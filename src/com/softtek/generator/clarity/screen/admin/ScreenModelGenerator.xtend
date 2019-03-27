package com.softtek.generator.clarity.screen.admin

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity
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
import com.softtek.rdl2.Enum import com.softtek.rdl2.EntityDateTimeField
import com.softtek.rdl2.EntityTimeField
import com.softtek.rdl2.EntityBooleanField

class ScreenModelGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(Entity)) {
				fsa.generateFile("clarity/src/app/admin/"+ m.name.toLowerCase + "/" + e.name.toLowerCase +".psg.model.ts", e.generateModelScreen(m))
			}
		}
	}
	
	def CharSequence generateModelScreen(Entity entity, Module module) '''
	export class «entity.name.toLowerCase.toFirstUpper» {
		«FOR f : entity.entity_fields»
			«f.getAttributes(module, entity)»
		«ENDFOR»	
	}
	'''

	/****************/	
	/*  Attributes  */			
	def dispatch getAttributes(EntityTextField      f, Module m, Entity t)'''«f.name.toLowerCase»: string  = null;'''
	def dispatch getAttributes(EntityLongTextField  f, Module m, Entity t)'''«f.name.toLowerCase»: string = null;'''
	def dispatch getAttributes(EntityDateField      f, Module m, Entity t)'''
	«f.name.toLowerCase»: number = null;
	«f.name.toLowerCase»Aux: Date = new Date();
	'''
	def dispatch getAttributes(EntityDateTimeField      f, Module m, Entity t)'''
	«f.name.toLowerCase»: number = null;
	«f.name.toLowerCase»Aux: DateTime = new DateTime();
	'''
	def dispatch getAttributes(EntityTimeField      f, Module m, Entity t)'''
	«f.name.toLowerCase»: number = null;
	«f.name.toLowerCase»Aux: DateTime = new DateTime();
	'''
	def dispatch getAttributes(EntityImageField     f, Module m, Entity t)'''«f.name.toLowerCase»: string = null;'''
	def dispatch getAttributes(EntityFileField      f, Module m, Entity t)'''«f.name.toLowerCase»: string = null;'''
	def dispatch getAttributes(EntityEmailField     f, Module m, Entity t)'''«f.name.toLowerCase»: string = null;'''
	def dispatch getAttributes(EntityDecimalField   f, Module m, Entity t)'''«f.name.toLowerCase»: number = null;'''
	def dispatch getAttributes(EntityIntegerField   f, Module m, Entity t)'''«f.name.toLowerCase»: number = null;'''
	def dispatch getAttributes(EntityCurrencyField  f, Module m, Entity t)'''«f.name.toLowerCase»: number = null;'''
	def dispatch getAttributes(EntityBooleanField  f, Module m, Entity t)'''«f.name.toLowerCase»: boolean = false;'''
	def dispatch getAttributes(EntityReferenceField f, Module m, Entity t)'''
	«IF !f.upperBound.equals('*')»
		«f.superType.getAttributesRef(m,t, f.name)»
	«ENDIF»
	'''
	
	def dispatch getAttributesRef(Enum  e, Module m, Entity t, String name)'''
	«e.name.toLowerCase»: string = null;
	«e.name.toLowerCase»Item: string = null;
	'''
	def dispatch getAttributesRef(Entity  e, Module m, Entity t, String name)'''
	«name.toLowerCase»Id: string = null;
	«name.toLowerCase»Item: string = null;
	'''	
	
}