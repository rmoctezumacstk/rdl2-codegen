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
	create table CGT_«e.name.toUpperCase» (
	«FOR f : e.entity_fields»
	«f.getAttribute(e)»
	«ENDFOR» 
	ID_«e.name.toUpperCase» bigint auto_increment
	);
	
	insert into CGT_«e.name.toUpperCase» (
	«FOR f : e.entity_fields SEPARATOR ","»
	«f.getAttributeColumn(e)»
	«ENDFOR»
	) values(
	«FOR f : e.entity_fields SEPARATOR ","»
	«f.getAttributeData(e)»
	«ENDFOR»	
	);
	
	insert into CGT_«e.name.toUpperCase» (
	«FOR f : e.entity_fields SEPARATOR ","»
	«f.getAttributeColumn(e)»
	«ENDFOR»
	) values(
	«FOR f : e.entity_fields SEPARATOR ","»
	«f.getAttributeData(e)»
	«ENDFOR»	
	);
	
	insert into CGT_«e.name.toUpperCase» (
	«FOR f : e.entity_fields SEPARATOR ","»
	«f.getAttributeColumn(e)»
	«ENDFOR»
	) values(
	«FOR f : e.entity_fields SEPARATOR ","»
	«f.getAttributeData(e)»
	«ENDFOR»	
	);		
	'''

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
	«name.toUpperCase» int not null,
	'''
	
	def dispatch genRelationship(Entity e, Entity t, String name) ''' 
	«name.toUpperCase» int not null,
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
	"«e.name.toUpperCase»"
	'''
	
	def dispatch genRelationshipColumn(Entity e, Entity t, String name) ''' 
	"«e.name.toUpperCase»"
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
	«entityFieldUtils.fakerDomainData(f)»
«««	«IF  f !== null && !f.upperBound.equals('*')»
«««		«f.superType.genRelationshipData(t, f.name)»		
«««	«ENDIF»
	'''	
	
	def dispatch genRelationshipData(Enum e, Entity t, String name) ''' 
«««	«entityFieldUtils.fakerDomainData(e)»
	'''
	
	def dispatch genRelationshipData(Entity e, Entity t, String name) ''' 
«««	«entityFieldUtils.fakerDomainData(f)»
	'''	
	
}