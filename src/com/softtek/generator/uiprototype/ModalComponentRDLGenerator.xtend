package com.softtek.generator.uiprototype

import com.github.javafaker.Faker
import com.softtek.rdl2.AbstractElement
import com.softtek.rdl2.Entity
import com.softtek.rdl2.EntityAttr
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityDateFieldAttr
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityLongTextFieldAttr
import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.EntityReferenceFieldAttr
import com.softtek.rdl2.EntityTextField
import com.softtek.rdl2.EntityTextFieldAttr
import com.softtek.rdl2.Enum
import com.softtek.rdl2.Model
import com.softtek.rdl2.WidgetDisplayResult
import java.text.SimpleDateFormat
import java.util.Locale
import java.util.concurrent.TimeUnit
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.common.util.UniqueEList
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.Task

class ModalComponentRDLGenerator {
	
	Faker faker = new Faker(new Locale("es-MX"))
	SimpleDateFormat formatter = formatter = new SimpleDateFormat("yyyy-MMM-dd", new Locale("es-MX"))
	
	def doGeneratorModal(Resource resource, IFileSystemAccess2 fsa) {
		var model  = resource.contents.head as Model
		if (model.module!==null)
		for (AbstractElement a : model.module.elements){
			a.genAbstractElement(model,fsa)			
		}
	}
	
	def dispatch genAbstractElement(Entity t, Model model, IFileSystemAccess2 fsa) '''
	«fsa.generateFile('''prototipo/src/tabledata/modal«t.name.toLowerCase».json''', t.genApiModal(model))»
	'''
	
	def dispatch genAbstractElement(Enum t, Model model, IFileSystemAccess2 fsa) '''Enum'''
	
	def dispatch genAbstractElement(PageContainer t, Model model, IFileSystemAccess2 fsa) '''PageContainer'''
	
	def dispatch genAbstractElement(Task t, Model model, IFileSystemAccess2 fsa) '''Task'''
	
	def dispatch genApiModal(Entity t, Model model) '''
		«var EList<EntityField> visibleEntityFields = filterVisibleEntityFields(t)»
	
		{
			"ids":[
				{
					"id": "«t.name.toLowerCase»-results",
					"headers": [
					«FOR EntityField e : visibleEntityFields SEPARATOR ','»
						«var glossaryName = e.getGlossaryEntityField()»
						«IF glossaryName !== null && !glossaryName.toString.trim.isEmpty»	
							{ "label": "«glossaryName.toString.trim»" }
						«ELSE»
							{ "label": "«e.name.toFirstUpper»" }
						«ENDIF»
					«ENDFOR»
					],
					"rows": [
						«FOR i : 1..10 SEPARATOR ','»
						{
							"id": "«i»",
							"data": [
								«FOR EntityField e : visibleEntityFields SEPARATOR ','»
									«e.fakerDomainData(t)»
								«ENDFOR»
							]
						}
						«ENDFOR»
					]
					«t.genRelationshipOneToMany»
				}
			]
		}
	'''
	
	/*
	 * Get total count of OneToMany relationships to another Entities.
	 */
	def int countOneToManyRelationships(Entity entity) {
		var count = 0
		
		for (r : entity.entity_fields.filter(typeof(EntityReferenceField))) {
			if (r.upperBound != '1') {
				count++
			}
		}
		
		return count
	}
	
	/*
	 * Shows a Button in Search Results for each OneToMany relationship to another Entity.
	 */
	def CharSequence genRelationshipOneToMany(Entity entity) '''
		«IF countOneToManyRelationships(entity) > 0»
		    ,
			"actions": [
				{
				"group": "Relaciones",
				"actions": [
				«var int numEntityReferenceField = this.getNumEntityReferenceField(entity)»
				«var state = new State(1)»
				
				«FOR r : entity.entity_fields.filter(typeof(EntityReferenceField))»
					«IF r.upperBound != '1' »
						{ "label": "«r.getGlossaryEntityField().toString.trim»", "link": "/«r.superType.getEntityNameFromRelationship.toString.toLowerCase»-admin/" }«IF state.getCounter() < numEntityReferenceField »,«ENDIF»
						
						«state.setCounter(state.counter+1)»
					«ENDIF»
				«ENDFOR»
				]
				}
			]
		«ENDIF»
	'''
	/**
	 * Obtiene el numero de atributos de la entidad de tipo EntityReferenceField
	 * 
	 * return int.
	 */
	def getNumEntityReferenceField(Entity entity){
		var int counter = 0;
		
		for(r : entity.entity_fields.filter(typeof(EntityReferenceField))){
			if( r.upperBound != '1' ){
				counter++;
			}
		}
		
		return counter;
	}
	
	def dispatch getEntityNameFromRelationship(Enum e) {
		return e.name
	}
	
	def dispatch getEntityNameFromRelationship(Entity e) {
		return e.name
	}
	
	
	
	def filterVisibleEntityFields(Entity t){
		var EList<EntityField> visibleEntityFields = new UniqueEList
		
		for(EntityField e : t.entity_fields){
			if(e.isVisibleEntityField() !== null && !e.isVisibleEntityField().toString.trim.empty && e.isVisibleEntityField().toString.trim.equals("true")){
				visibleEntityFields.add(e)
			}
		}
		
		return visibleEntityFields
	}
	
//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/	
	def dispatch isVisibleEntityField(EntityReferenceField f)'''
		«FOR EntityReferenceFieldAttr a : f.attrs»
			«IF a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty »
				«a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result»
			«ENDIF»
		«ENDFOR»
	'''
		
	def dispatch isVisibleEntityField(EntityTextField f)'''
		«FOR EntityTextFieldAttr a : f.attrs»
			«IF a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty »
				«a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result»
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch isVisibleEntityField(EntityLongTextField f)'''
		«FOR EntityLongTextFieldAttr a : f.attrs»
			«IF a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty »
				«a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result»
			«ENDIF»
		«ENDFOR»
	'''
		
	def dispatch isVisibleEntityField(EntityDateField f)'''
		«FOR EntityDateFieldAttr a : f.attrs»
			«IF a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty »
				«a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result»
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch isVisibleEntityField(EntityImageField f)'''
		«FOR EntityAttr a : f.attrs»
			«IF a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty »
				«a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result»
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch isVisibleEntityField(EntityFileField f)'''
		«FOR EntityAttr a : f.attrs»
			«IF a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty »
				«a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result»
			«ENDIF»
		«ENDFOR»
	'''
	
	def dispatch isVisibleEntityField(EntityEmailField f)'''
		«FOR EntityAttr a : f.attrs»
			«IF a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty »
				«a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result»
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch isVisibleEntityField(EntityDecimalField f)'''
		«FOR EntityAttr a : f.attrs»
			«IF a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty »
				«a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result»
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch isVisibleEntityField(EntityIntegerField f)'''
		«FOR EntityAttr a : f.attrs»
			«IF a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty »
				«a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result»
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch isVisibleEntityField(EntityCurrencyField f)'''
		«FOR EntityAttr a : f.attrs»
			«IF a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty »
				«a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result»
			«ENDIF»
		«ENDFOR»
	'''
	
//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
	def dispatch getGlossaryEntityField(EntityReferenceField f)'''
		«FOR EntityReferenceFieldAttr a : f.attrs»
			«IF a.glossary !== null && !a.glossary.toString.trim.isEmpty»
				«a.glossary.glossary_name.label»
			«ENDIF»
		«ENDFOR»
	'''
		
	def dispatch getGlossaryEntityField(EntityTextField f)'''
		«FOR EntityTextFieldAttr a : f.attrs»
			«IF a.glossary !== null && !a.glossary.toString.trim.isEmpty»
				«a.glossary.glossary_name.label»
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch getGlossaryEntityField(EntityLongTextField f)'''
		«FOR EntityLongTextFieldAttr a : f.attrs»
			«IF a.glossary !== null && !a.glossary.toString.trim.isEmpty»
				«a.glossary.glossary_name.label»
			«ENDIF»
		«ENDFOR»
	'''
		
	def dispatch getGlossaryEntityField(EntityDateField f)'''
		«FOR EntityDateFieldAttr a : f.attrs»
			«IF a.glossary !== null && !a.glossary.toString.trim.isEmpty»
				«a.glossary.glossary_name.label»
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch getGlossaryEntityField(EntityImageField f)'''
		«FOR EntityAttr a : f.attrs»
			«IF a.glossary !== null && !a.glossary.toString.trim.isEmpty»
				«a.glossary.glossary_name.label»
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch getGlossaryEntityField(EntityFileField f)'''
		«FOR EntityAttr a : f.attrs»
			«IF a.glossary !== null && !a.glossary.toString.trim.isEmpty»
				«a.glossary.glossary_name.label»
			«ENDIF»
		«ENDFOR»
	'''
	
	def dispatch getGlossaryEntityField(EntityEmailField f)'''
		«FOR EntityAttr a : f.attrs»
			«IF a.glossary !== null && !a.glossary.toString.trim.isEmpty»
				«a.glossary.glossary_name.label»
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch getGlossaryEntityField(EntityDecimalField f)'''
		«FOR EntityAttr a : f.attrs»
			«IF a.glossary !== null && !a.glossary.toString.trim.isEmpty»
				«a.glossary.glossary_name.label»
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch getGlossaryEntityField(EntityIntegerField f)'''
		«FOR EntityAttr a : f.attrs»
			«IF a.glossary !== null && !a.glossary.toString.trim.isEmpty»
				«a.glossary.glossary_name.label»
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch getGlossaryEntityField(EntityCurrencyField f)'''
		«FOR EntityAttr a : f.attrs»
			«IF a.glossary !== null && !a.glossary.toString.trim.isEmpty»
				«a.glossary.glossary_name.label»
			«ENDIF»
		«ENDFOR»
	'''
//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
	
	def dispatch genApiModal(Enum t, Model model) '''
	'''
	
	def dispatch genApiModal(PageContainer t, Model model) '''
	'''
	
	def dispatch genApiModal(Task t, Model model) '''
	'''
	
	// Field Description DOM
	def dispatch fakerDomainData(EntityReferenceField field, Entity e) '''
		«field.superType.fakerRelationship(e, field)»
	'''
	def dispatch fakerRelationship(Enum toEnum, Entity fromEntity, EntityReferenceField fromField) '''
		"XXXXXXXX"
	'''
	
	def dispatch fakerRelationship(Entity toEntity, Entity fromEntity, EntityReferenceField fromField) '''
		"YYYYYYYY"
	'''
	def dispatch fakerDomainData(EntityTextField field, Entity e) '''
		"«field.fieldTextDomainData»"
	'''
	
	def dispatch fakerDomainData(EntityLongTextField field, Entity e) '''
		"«faker.lorem().paragraph»"
	'''
	def dispatch fakerDomainData(EntityDateField field, Entity e) '''
		"«formatter.format(faker.date().past(800, TimeUnit.DAYS))»"
	'''
	
	def dispatch fakerDomainData(EntityImageField field, Entity e) '''
		"«faker.internet().avatar»"
	'''
	
	def dispatch fakerDomainData(EntityFileField field, Entity e) '''
		""
	'''
	def dispatch fakerDomainData(EntityEmailField field, Entity e) '''
		"«faker.internet().emailAddress»"
	'''
	
	def dispatch fakerDomainData(EntityDecimalField field, Entity e) '''
		"«faker.number().randomNumber»"
	'''
	
	def dispatch fakerDomainData(EntityIntegerField field, Entity e) '''
		"«faker.number().numberBetween(1, 1000000)»"
	'''
	
	def dispatch fakerDomainData(EntityCurrencyField field, Entity e) '''
		"«"$"+faker.number().randomNumber»"
	'''
	def CharSequence fieldTextDomainData(EntityTextField field) {
		var fieldData = faker.lorem().sentence
		for (attr : field.attrs) {
			if (attr.data_domain !== null) {
				if (attr.data_domain.domain.toString=="Lorem::code5") {
					fieldData = faker.lorem().characters(5).toUpperCase
				}
				if (attr.data_domain.domain.toString=="Lorem::paragraph") {
					fieldData = faker.lorem().paragraph
				}
				if (attr.data_domain.domain.toString=="Lorem::longParagraph") {
					fieldData = faker.lorem().paragraph(10)
				}
				if (attr.data_domain.domain.toString=="App::name") {
					fieldData = faker.app().name
				}
				if (attr.data_domain.domain.toString=="Name::fullName") {
					fieldData = faker.name().fullName
				}
				if (attr.data_domain.domain.toString=="Name::firstName") {
					fieldData = faker.name().firstName
				}
				if (attr.data_domain.domain.toString=="Name::lastName") {
					fieldData = faker.name().lastName
				}
				if (attr.data_domain.domain.toString=="Bank::accountNumber") {
					fieldData = faker.code().isbn10
				}
				if (attr.data_domain.domain.toString=="Business::creditCardNumber") {
					fieldData = faker.business().creditCardNumber
				}
				if (attr.data_domain.domain.toString=="Internet::password") {
					fieldData = faker.internet().password
				}
				if (attr.data_domain.domain.toString=="Phone::phoneNumber") {
					fieldData = faker.phoneNumber().phoneNumber
				}
				if (attr.data_domain.domain.toString=="Address::country") {
					fieldData = faker.address().country
				}
				if (attr.data_domain.domain.toString=="Address::state") {
					fieldData = faker.address().state
				}
				if (attr.data_domain.domain.toString=="Address::city") {
					fieldData = faker.address().city
				}
				if (attr.data_domain.domain.toString=="Address::streetAddress") {
					fieldData = faker.address().streetAddress
				}
				if (attr.data_domain.domain.toString=="Address::zipCode") {
					fieldData = faker.address().zipCode
				}
			}
		}
		return fieldData
	}
	
	def static toUpperCase(String it){
	  toUpperCase
	}
	
	def static toLowerCase(String it){
	  toLowerCase
	}
}

/**
 * Clase para generar funcionalidad de un contador y evitar que los incrementos del contador se pinten como parte del contenido de los .json
 */
class State {
	@Accessors
	var int counter;
	
	new(int counter){
		this.counter = counter;
	}
}