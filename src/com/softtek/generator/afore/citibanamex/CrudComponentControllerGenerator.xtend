package com.softtek.generator.afore.citibanamex

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
import com.softtek.rdl2.Enum

class CrudComponentControllerGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/com/aforebanamex/plata/cg/mn/controller/" + e.name.toLowerCase.toFirstUpper + "Controller.java", e.generateController(m))
			}
		}
	}
	
	
	def CharSequence generateController(Entity e, Module m) '''
	package com.aforebanamex.plata.cg.mn.controller;
	
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.aforebanamex.plata.base.controller.BaseController;
import com.aforebanamex.plata.base.model.RequestPlata;
import com.aforebanamex.plata.base.model.ResponsePlata;
import com.aforebanamex.plata.cg.mn.service.«e.name.toLowerCase.toFirstUpper»Service;
import com.aforebanamex.plata.comunes.model.mn.«e.name.toLowerCase.toFirstUpper»;
	
	«FOR f : e.entity_fields»
	«f.getAttributeImport(e)»
	«ENDFOR»	
	
		
	@Controller
	public class «e.name.toLowerCase.toFirstUpper»Controller extends BaseController<«e.name.toLowerCase.toFirstUpper», «e.name.toLowerCase.toFirstUpper»> {
		
		@Autowired
		private «e.name.toLowerCase.toFirstUpper»Service «e.name.toLowerCase»Service;
		
		@Override
		@RequestMapping(value="/obtener«e.name.toLowerCase.toFirstUpper»")
		public @ResponseBody ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtener(@RequestBody RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio la petición - consultar el «e.name.toLowerCase» en mn: {}", data.toString());
			return «e.name.toLowerCase»Service.obtener(data);
		}
	
		@Override
		@RequestMapping(value="/obtener«e.name.toLowerCase.toFirstUpper»s")
		public @ResponseBody ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtenerTodos(@RequestBody RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio la petición - consultar todos los «e.name.toLowerCase»s en mn: {}", data.toString());
			return «e.name.toLowerCase»Service.obtenerTodos(data);
		}
	
		@Override
		@RequestMapping(value="/agregar«e.name.toLowerCase.toFirstUpper»")
		public @ResponseBody ResponsePlata<«e.name.toLowerCase.toFirstUpper»> agregar(@RequestBody RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio la petición - agregar «e.name.toLowerCase» en mn: {}", data.toString());
			return «e.name.toLowerCase»Service.agregar(data);
		}
	
		@Override
		@RequestMapping(value="/actualizar«e.name.toLowerCase.toFirstUpper»")
		public @ResponseBody ResponsePlata<«e.name.toLowerCase.toFirstUpper»> actualizar(@RequestBody RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio la petición - actualizar «e.name.toLowerCase» en mn: {}", data.toString());
			return «e.name.toLowerCase»Service.actualizar(data);
		}
	
		@Override
		@RequestMapping(value="/eliminar«e.name.toLowerCase.toFirstUpper»")
		public @ResponseBody ResponsePlata<«e.name.toLowerCase.toFirstUpper»> eliminar(@RequestBody RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio la petición - eliminar «e.name.toLowerCase» en mn: {}", data.toString());
			return «e.name.toLowerCase»Service.eliminar(data);
		}
	}
		
	'''
	
	/* Get Attribute */
	def dispatch getAttribute(EntityTextField f, Entity t)'''
	'''
	def dispatch getAttribute(EntityLongTextField f, Entity t)'''
	'''
	def dispatch getAttribute(EntityDateField f, Entity t)'''
	'''
	def dispatch getAttribute(EntityImageField f, Entity t)'''
	'''
	def dispatch getAttribute(EntityFileField f, Entity t)'''
	'''
	def dispatch getAttribute(EntityEmailField f, Entity t)'''
	'''
	def dispatch getAttribute(EntityDecimalField f, Entity t)'''
	'''
	def dispatch getAttribute(EntityIntegerField f, Entity t)'''
	'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t)'''
	'''	
	def dispatch getAttribute(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
	«f.superType.genRelationship(t, f.name)»		
	«ENDIF»
	'''	
	def dispatch genRelationship(Enum e, Entity t, String name) ''' 
	'''
	def dispatch genRelationship(Entity e, Entity t, String name) ''' 
	model.addAttribute("«name.toLowerCase»", catalogoService.obtener«name.toLowerCase.toFirstUpper»());
	'''
	
	/* Get Attribute Set */
	def dispatch getAttributeSet(EntityTextField f, Entity t)'''
	sem.set«f.name.toLowerCase.toFirstUpper»("");
	'''
	def dispatch getAttributeSet(EntityLongTextField f, Entity t)'''
	sem.set«f.name.toLowerCase.toFirstUpper»("");
	'''
	def dispatch getAttributeSet(EntityDateField f, Entity t)'''
	sem.set«f.name.toLowerCase.toFirstUpper»("");
	'''
	def dispatch getAttributeSet(EntityImageField f, Entity t)'''
	sem.set«f.name.toLowerCase.toFirstUpper»("");
	'''
	def dispatch getAttributeSet(EntityFileField f, Entity t)'''
	sem.set«f.name.toLowerCase.toFirstUpper»("");
	'''
	def dispatch getAttributeSet(EntityEmailField f, Entity t)'''
	sem.set«f.name.toLowerCase.toFirstUpper»("");
	'''
	def dispatch getAttributeSet(EntityDecimalField f, Entity t)'''
	sem.set«f.name.toLowerCase.toFirstUpper»(0.0);
	'''
	def dispatch getAttributeSet(EntityIntegerField f, Entity t)'''
	sem.set«f.name.toLowerCase.toFirstUpper»(0);
	'''
	def dispatch getAttributeSet(EntityCurrencyField f, Entity t)'''
	sem.set«f.name.toLowerCase.toFirstUpper»(0.0);
	'''	
	def dispatch getAttributeSet(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
	«f.superType.genRelationshipSet(t, f.name)»		
	«ENDIF»
	'''	
	def dispatch genRelationshipSet(Enum e, Entity t, String name) ''' 
	'''
	def dispatch genRelationshipSet(Entity e, Entity t, String name) ''' 
	«name.toLowerCase.toFirstUpper» «name.toLowerCase» = new «name.toLowerCase.toFirstUpper»();
	«name.toLowerCase».setId«name.toLowerCase.toFirstUpper»(0);
	sem.set«name.toLowerCase.toFirstUpper»(«name.toLowerCase»);
	'''
	
	/* Get Attribute Import*/
	def dispatch getAttributeImport(EntityTextField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityLongTextField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityDateField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityImageField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityFileField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityEmailField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityDecimalField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityIntegerField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityCurrencyField f, Entity t)'''
	'''	
	def dispatch getAttributeImport(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
	«f.superType.genRelationshipImport(t, f.name)»
	«ENDIF»
	'''	
	def dispatch genRelationshipImport(Enum e, Entity t, String name) ''' 
	'''
	def dispatch genRelationshipImport(Entity e, Entity t, String name) ''' 
	import com.aforebanamex.plata.comunes.model.mn.«name.toLowerCase.toFirstUpper»;
	'''
}