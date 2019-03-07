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
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/resources/querys/data" + e.name.toLowerCase + ".sql", e.genJavaSql(m))
			}
		}
	}
	
	def CharSequence genJavaSql(Entity e, Module m) '''
	create table CGT_«e.name.toUpperCase» (
	ID_«e.name.toUpperCase» bigint auto_increment,
	«FOR f : e.entity_fields SEPARATOR ','»
	«f.getAttribute(e)»
	«ENDFOR» 
	);
	'''

	/* Get Attribute */
	def dispatch getAttribute(EntityTextField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null
	'''
	def dispatch getAttribute(EntityLongTextField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null
	'''
	def dispatch getAttribute(EntityDateField f, Entity t)'''
	«f.name.toUpperCase» date(100) not null
	'''
	def dispatch getAttribute(EntityImageField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null
	'''
	def dispatch getAttribute(EntityFileField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null
	'''
	def dispatch getAttribute(EntityEmailField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null
	'''
	def dispatch getAttribute(EntityDecimalField f, Entity t)'''
	«f.name.toUpperCase» double not null
	'''
	def dispatch getAttribute(EntityIntegerField f, Entity t)'''
	«f.name.toUpperCase» int not null
	'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t)'''
	«f.name.toUpperCase» decimal(20,2) not null
	'''	
	
	def dispatch getAttribute(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationship(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationship(Enum e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''
	
	def dispatch genRelationship(Entity e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''
	
}