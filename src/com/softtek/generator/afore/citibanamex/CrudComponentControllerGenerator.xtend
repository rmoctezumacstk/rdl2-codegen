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
				fsa.generateFile("banamex/src/main/java/mx/com/aforebanamex/plata/controller/" + e.name.toLowerCase.toFirstUpper + "Controller.java", e.generateController(m))
			}
		}
	}
	
	
	def CharSequence generateController(Entity e, Module m) '''
	package mx.com.aforebanamex.plata.controller;
	
	import javax.validation.Valid;
	
	import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.validation.Errors;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestBody;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.ResponseBody;

	import mx.com.aforebanamex.plata.base.controller.BaseController;
	import mx.com.aforebanamex.plata.helper.ComponentesGeneralesConstantsHelper;
	import mx.com.aforebanamex.plata.helper.PaginadoHelper«e.name.toLowerCase.toFirstUpper»;
	import mx.com.aforebanamex.plata.model.EstadoIndicador;
	import mx.com.aforebanamex.plata.model.Paginador«e.name.toLowerCase.toFirstUpper»;
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»;
	import mx.com.aforebanamex.plata.model.TipoMedida;
	import mx.com.aforebanamex.plata.service.CatalogoService;
	import mx.com.aforebanamex.plata.service.«e.name.toLowerCase.toFirstUpper»Service;
	
	«FOR f : e.entity_fields»
	«f.getAttributeImport(e)»
	«ENDFOR»	
	
		
	@Controller
	public class «e.name.toLowerCase.toFirstUpper»Controller extends BaseController {
		
		@Autowired
		private «e.name.toLowerCase.toFirstUpper»Service «e.name.toLowerCase»Service;
		
		@Autowired
		private CatalogoService catalogoService;
		
		@GetMapping(value = "/«e.name.toLowerCase»")
		public String «e.name.toLowerCase»(Model model) {
			logger.debug("Se ingresa a la pantalla de «e.name.toLowerCase»");
			«FOR f : e.entity_fields»
			«f.getAttribute(e)»
			«ENDFOR»
			Paginador«e.name.toLowerCase.toFirstUpper» paginador = new Paginador«e.name.toLowerCase.toFirstUpper»();
			paginador.setFilas(10);
			paginador.setPagina(1);
			«e.name.toLowerCase.toFirstUpper» sem = new «e.name.toLowerCase.toFirstUpper»();
			«FOR f : e.entity_fields»
			«f.getAttributeSet(e)»
			«ENDFOR»			
			paginador.setPayload(sem);
			model.addAttribute("lista«e.name.toLowerCase.toFirstUpper»", obtener«e.name.toLowerCase.toFirstUpper»s(model,paginador));
			return ComponentesGeneralesConstantsHelper.RUTA_«e.name.toUpperCase»;
		}
	
		@RequestMapping(value="/obtener«e.name.toLowerCase.toFirstUpper»s")
		public @ResponseBody «e.name.toLowerCase.toFirstUpper» obtener«e.name.toLowerCase.toFirstUpper»s(@RequestBody «e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»){
			logger.debug("Se solicita obtener un «e.name.toLowerCase» con el id: {}",«e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»());
			return «e.name.toLowerCase»Service.obtener«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase»);
		}
	
		@PostMapping(value="/agregar«e.name.toLowerCase.toFirstUpper»", produces = "application/json", consumes = "application/json")
		public @ResponseBody «e.name.toLowerCase.toFirstUpper» agregar«e.name.toLowerCase.toFirstUpper»(@RequestBody @Valid «e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase», 
				Errors errors){
			logger.debug("Se solicita agregar el «e.name.toLowerCase»: {}",ReflectionToStringBuilder.toString(«e.name.toLowerCase»));
			if(errors.hasErrors()) {
				return new «e.name.toLowerCase.toFirstUpper»();
			}
			«e.name.toLowerCase».setId«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase»Service.agregar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase»));
			return «e.name.toLowerCase»Service.obtener«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase»);
		}
	
		@PostMapping(value="/eliminar«e.name.toLowerCase.toFirstUpper»", produces = "application/json")
		public @ResponseBody int eliminar«e.name.toLowerCase.toFirstUpper»(@RequestBody «e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»){
			logger.debug("Se solicita eliminar un «e.name.toLowerCase» con el id: {}",«e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»());
			return «e.name.toLowerCase»Service.eliminar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»());
		}
	
		@PostMapping(value="/actualizar«e.name.toLowerCase.toFirstUpper»", produces = "application/json", consumes = "application/json")
		public @ResponseBody int actualizar«e.name.toLowerCase.toFirstUpper»(@RequestBody @Valid «e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase», 
				Errors errors){
				logger.debug("Se solicita actualizar el «e.name.toLowerCase»: {}",ReflectionToStringBuilder.toString(«e.name.toLowerCase»));
			if(errors.hasErrors()) {
				return 0;
			}
			return «e.name.toLowerCase»Service.actualizar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase»);
		}
		
		/*Obtenemos los «e.name.toLowerCase» filtrando por nombre, tipoMedia y Estado Indicador*/
		@RequestMapping(value="/obtener«e.name.toLowerCase.toFirstUpper»s", produces = "application/json", consumes = "application/json")
		public @ResponseBody PaginadoHelper«e.name.toLowerCase.toFirstUpper» obtener«e.name.toLowerCase.toFirstUpper»s(Model model, @RequestBody Paginador«e.name.toLowerCase.toFirstUpper» paginador){
«««			logger.debug("Se solicita obtener los «e.name.toLowerCase»s: nombre={}, estado={}, medida:{}",paginador.getPayload().getNombre(),paginador.getPayload().getEstadoIndicador().getCveEdoIndicador(),paginador.getPayload().getTipoMedida().getCveTipoMedida());
			return «e.name.toLowerCase»Service.obtener«e.name.toLowerCase.toFirstUpper»s(paginador.getPayload(),paginador.getPagina(),paginador.getFilas());
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
	import mx.com.aforebanamex.plata.model.«name.toLowerCase.toFirstUpper»;
	'''
}