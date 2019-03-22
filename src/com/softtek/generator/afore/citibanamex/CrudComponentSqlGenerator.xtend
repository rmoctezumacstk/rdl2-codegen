package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

import com.softtek.generator.utils.EntityUtils
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.generator.utils.UIFlowUtils
import com.softtek.rdl2.EntityTextField
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.Enum
import java.util.ArrayList

class CrudComponentSqlGenerator {
	
	var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/resources/querys/data" + e.name.toLowerCase + ".sql", e.genJavaSql(m))
			}
		}
	}
	
	def CharSequence genJavaSql(Entity e, Module m) '''
	«var ArrayList<String> lstReferencesEntity = this.getReferencesEntities(e)»
	«««//----------------------------------------- Creacion de tablas -----------------------------------------
	«FOR enm : m.elements.filter(typeof(Enum))»
		«FOR erName : lstReferencesEntity»
			«IF enm.name.equals(erName)»
				create table CGG_«erName.toUpperCase»(
				«FOR attr : enm.enum_literals»
					«attr.key.toUpperCase» varchar(100) not null,
				«ENDFOR»
				CVE_«erName.toUpperCase» int(2) auto_increment,
				primary key(CVE_«erName.toUpperCase»)
				);
			«ENDIF»
		« ENDFOR»
	«ENDFOR»
	«FOR entity : m.elements.filter(typeof(Entity))»
		«FOR erName : lstReferencesEntity»
			«IF entity.name.equals(erName)»
				create table CGG_«erName.toUpperCase»(
				«FOR f : entity.entity_fields»
					«f.getAttribute(entity)»
				«ENDFOR» 
				ENABLED boolean not null,
				CVE_«erName.toUpperCase» int(2) auto_increment,
				primary key(CVE_«erName.toUpperCase»)
				);
			«ENDIF»
		«ENDFOR»
	«ENDFOR»
	
	create table CGT_«e.name.toUpperCase» (
	«FOR f : e.entity_fields»
	«f.getAttribute(e)»
	«ENDFOR» 
	ENABLED boolean not null,
	ID_«e.name.toUpperCase» bigint auto_increment,
	primary key(ID_«e.name.toUpperCase»)
	);
	«««//------------------------------------------------------------------------------------------------------

	
	«««//-------------------------------------------- Creacion de registros -----------------------------------------
	«FOR enm : m.elements.filter(typeof(Enum))»
		«FOR erName : lstReferencesEntity»
			«IF enm.name.equals(erName)»
				«FOR i:0..2»
					insert into CGG_«erName.toUpperCase» (
					«FOR attr : enm.enum_literals SEPARATOR ","»
					"«attr.key.toString.toUpperCase»"
					«ENDFOR»
					) values(
					«FOR attr : enm.enum_literals SEPARATOR ","»
					'«attr.value.toString»'
					«ENDFOR»	
					);
				«ENDFOR»	
			«ENDIF»
		« ENDFOR»
	«ENDFOR»
	«FOR entity : m.elements.filter(typeof(Entity))»
		«FOR erName : lstReferencesEntity»
			«IF entity.name.equals(erName)»
				«FOR i:0..2»
					insert into CGG_«erName.toUpperCase» (
					«FOR f : entity.entity_fields SEPARATOR ","»
					«f.getAttributeColumn(entity).toString»
					«ENDFOR»
					, "ENABLED") values(
					«FOR f : entity.entity_fields SEPARATOR ","»
					«f.getAttributeData(entity).toString»
					«ENDFOR»	
					, true);
				«ENDFOR»	
			«ENDIF»
		«ENDFOR»
	«ENDFOR»

	«FOR i:0..2»
		insert into CGT_«e.name.toUpperCase» (
		«FOR f : e.entity_fields SEPARATOR ","»
		«f.getAttributeColumn(e).toString»
		«ENDFOR»
		, "ENABLED") values(
		«FOR f : e.entity_fields SEPARATOR ","»
		«f.getAttributeData(e).toString»
		«ENDFOR»	
		, true);
	«ENDFOR»		
<<<<<<< HEAD
	«««//------------------------------------------------------------------------------------------------------------
=======
	«««//------------------------------------------------------------------------------------------------------------«»
>>>>>>> bde0f9cf8d8c3229dde215afed96a5903acf9df6
	'''
	
	def dispatch getReferencesEntities(Entity e){
		var ArrayList<String> lstReferencesEntity = new ArrayList();
		
		for(f : e.entity_fields.filter(EntityReferenceField)){
			if( f.eCrossReferences.head.eClass.name.equals("Entity") ){ 	
				var entity = f.eCrossReferences.head as Entity;
				lstReferencesEntity.add(entity.name);	
			}else{
				var enum = f.eCrossReferences.head as Enum;
				lstReferencesEntity.add(enum.name);
			}
		}
		
		return lstReferencesEntity;
	}
	
	/* Get Attribute */
	def dispatch getAttribute(EntityTextField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null,
	'''
	def dispatch getAttribute(EntityLongTextField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null,
	'''
	def dispatch getAttribute(EntityDateField f, Entity t)'''
	«f.name.toUpperCase» date(100) not null,
	'''
	def dispatch getAttribute(EntityImageField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null,
	'''
	def dispatch getAttribute(EntityFileField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null,
	'''
	def dispatch getAttribute(EntityEmailField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null,
	'''
	def dispatch getAttribute(EntityDecimalField f, Entity t)'''
	«f.name.toUpperCase» double not null,
	'''
	def dispatch getAttribute(EntityIntegerField f, Entity t)'''
	«f.name.toUpperCase» int not null,
	'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t)'''
	«f.name.toUpperCase» decimal(20,2) not null,
	'''	
	
	def dispatch getAttribute(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationship(t, f.name)»
	«ENDIF»
	'''	
	
	def dispatch genRelationship(Enum e, Entity t, String name) '''
	CVE_«e.name.toUpperCase» int(2),
	foreign key (CVE_«e.name.toUpperCase») references CGG_«e.name.toUpperCase»(CVE_«e.name.toUpperCase»),
	'''
	
	def dispatch genRelationship(Entity e, Entity t, String name) '''
	CVE_«e.name.toUpperCase» int(2),
>>>>>>> bde0f9cf8d8c3229dde215afed96a5903acf9df6
	foreign key (CVE_«e.name.toUpperCase») references CGG_«e.name.toUpperCase»(CVE_«e.name.toUpperCase»),
	'''
	
	/* Get Attribute Column*/
	def dispatch getAttributeColumn(EntityTextField f, Entity t)'''
	"«f.name.toUpperCase»"
	'''
	def dispatch getAttributeColumn(EntityLongTextField f, Entity t)'''
	"«f.name.toUpperCase»"
	'''
	def dispatch getAttributeColumn(EntityDateField f, Entity t)'''
	"«f.name.toUpperCase»"
	'''
	def dispatch getAttributeColumn(EntityImageField f, Entity t)'''
	"«f.name.toUpperCase»"
	'''
	def dispatch getAttributeColumn(EntityFileField f, Entity t)'''
	"«f.name.toUpperCase»"
	'''
	def dispatch getAttributeColumn(EntityEmailField f, Entity t)'''
	"«f.name.toUpperCase»"
	'''
	def dispatch getAttributeColumn(EntityDecimalField f, Entity t)'''
	"«f.name.toUpperCase»"
	'''
	def dispatch getAttributeColumn(EntityIntegerField f, Entity t)'''
	"«f.name.toUpperCase»"
	'''
	def dispatch getAttributeColumn(EntityCurrencyField f, Entity t)'''
	"«f.name.toUpperCase»"
	'''	
	
	def dispatch getAttributeColumn(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipColumn(t, f.name)»
	«ENDIF»
	'''	
	
	def dispatch genRelationshipColumn(Enum e, Entity t, String name) ''' 
	"CVE_«e.name.toUpperCase»"
	'''
	
	def dispatch genRelationshipColumn(Entity e, Entity t, String name) ''' 
	"CVE_«e.name.toUpperCase»"
	'''	
	/* Get Attribute Data*/
	def dispatch getAttributeData(EntityTextField f, Entity t)'''
	'«entityFieldUtils.fakerDomainData(f)»'
	'''
	def dispatch getAttributeData(EntityLongTextField f, Entity t)'''
	'«entityFieldUtils.fakerDomainData(f)»'
	'''
	def dispatch getAttributeData(EntityDateField f, Entity t)'''
	'«entityFieldUtils.fakerDomainData(f)»'
	'''
	def dispatch getAttributeData(EntityImageField f, Entity t)'''
	'«entityFieldUtils.fakerDomainData(f)»'
	'''
	def dispatch getAttributeData(EntityFileField f, Entity t)'''
	'«entityFieldUtils.fakerDomainData(f)»'
	'''
	def dispatch getAttributeData(EntityEmailField f, Entity t)'''
	'«entityFieldUtils.fakerDomainData(f)»'
	'''
	def dispatch getAttributeData(EntityDecimalField f, Entity t)'''
	«entityFieldUtils.fakerDomainData(f)»
	'''
	def dispatch getAttributeData(EntityIntegerField f, Entity t)'''
	«entityFieldUtils.fakerDomainData(f)»
	'''
	def dispatch getAttributeData(EntityCurrencyField f, Entity t)'''
	«entityFieldUtils.fakerDomainData(f)»
	'''	
	
	def dispatch getAttributeData(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
	«entityFieldUtils.fakerDomainData(f)»
«««		«f.superType.genRelationshipData(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipData(Enum e, Entity t, String name) ''' 
«««	«entityFieldUtils.fakerDomainData(e)»
	'''
	
	def dispatch genRelationshipData(Entity e, Entity t, String name) ''' 
«««	«entityFieldUtils.fakerDomainData(f)»
	'''	
	
}