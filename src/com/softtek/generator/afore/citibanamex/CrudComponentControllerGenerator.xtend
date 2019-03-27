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
import com.softtek.generator.utils.EntityUtils
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.generator.utils.UIFlowUtils

class CrudComponentControllerGenerator {
	
	var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/configuracion/src/main/java/com/aforebanamex/plata/configuracion/controller/myn/" + e.name.toLowerCase.toFirstUpper + "Controller.java", e.generateController(m))


			}
		}
	}
	
	
	def CharSequence generateController(Entity e, Module m) '''
	package com.aforebanamex.plata.configuracion.controller.myn;
	
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.RequestBody;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.ResponseBody;
	import com.aforebanamex.plata.base.controller.BaseController;
	import com.aforebanamex.plata.base.model.RequestPlata;
	import com.aforebanamex.plata.base.model.ResponsePlata;
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;
	import com.aforebanamex.plata.configuracion.helper.mn.MNConstantesHelper;
	import com.aforebanamex.plata.configuracion.service.mn.CatalogosMNService;
	import com.aforebanamex.plata.configuracion.service.mn.«e.name.toLowerCase.toFirstUpper»Service;
	
	«FOR f : e.entity_fields.filter(EntityReferenceField)»
	«f.getAttributeImport(e,f.name)»
	«ENDFOR»	
	
	@Controller
	public class «e.name.toLowerCase.toFirstUpper»Controller extends BaseController<«e.name.toLowerCase.toFirstUpper», «e.name.toLowerCase.toFirstUpper»> {
		
		@Autowired
		private «e.name.toLowerCase.toFirstUpper»Service «e.name.toLowerCase»Service;
		
		@Autowired
		private CatalogoService catalogoService;
		
		@GetMapping(value = "/«e.name.toLowerCase»")
		public String «e.name.toLowerCase»(Model model) {
			logger.debug("Se ingresa a la pantalla de «e.name.toLowerCase»");
			model.addAttribute("tipoMedidas", catalogoService.obtenerTipoMedida());
			model.addAttribute("edo«e.name.toLowerCase.toFirstUpper»s", catalogoService.obtenerEstadoIndicador());
			Paginador paginador = new Paginador();
			paginador.setFilas(10);
			paginador.setPagina(1);
			«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = new «e.name.toLowerCase.toFirstUpper»();
			«e.name.toLowerCase».setNombre("");
			EstadoIndicador estadoIndicador = new EstadoIndicador();
			estadoIndicador.setCveEdoIndicador(0L);
			«e.name.toLowerCase».setEstadoIndicador(estadoIndicador);
			TipoMedida tipoMedida = new TipoMedida();
			tipoMedida.setCveTipoMedida(0L);
			«e.name.toLowerCase».setTipoMedida(tipoMedida);
			paginador.setPayload(«e.name.toLowerCase»);
			model.addAttribute("lista«e.name.toLowerCase.toFirstUpper»", obtener«e.name.toLowerCase.toFirstUpper»s(model,paginador));
			return ComponentesGeneralesConstantsHelper.RUTA_«e.name.toUpperCase»;
		}
	
		@RequestMapping(value="/obtener«e.name.toLowerCase.toFirstUpper»")
		public @ResponseBody «e.name.toLowerCase.toFirstUpper» obtener«e.name.toLowerCase.toFirstUpper»(@RequestBody «e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»){
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
		public @ResponseBody PaginadoHelper obtener«e.name.toLowerCase.toFirstUpper»s(Model model, @RequestBody Paginador paginador){
			logger.debug("Se solicita obtener los «e.name.toLowerCase»s: nombre={}, estado={}, medida:{}",paginador.getPayload().getNombre(),paginador.getPayload().getEstadoIndicador().getCveEdoIndicador(),paginador.getPayload().getTipoMedida().getCveTipoMedida());
			return «e.name.toLowerCase»Service.obtener«e.name.toLowerCase.toFirstUpper»s(paginador.getPayload(),paginador.getPagina(),paginador.getFilas());
		}
	}
		
	'''

	
	/* Get Attribute Import*/
	def dispatch getAttributeImport(EntityReferenceField f, Entity t, String name) ''' 
	«IF  f !== null && !f.upperBound.equals('*')»
	«f.superType.genRelationshipImport(t, f.name)»		
	«ENDIF»
	'''
	def dispatch genRelationshipImport(Entity e, Entity t, String name) ''' 
	import com.aforebanamex.plata.comunes.model.cg.«name.toLowerCase.toFirstUpper»;
	'''
	def dispatch genRelationshipImport(Enum e, Entity t, String name) ''''''	
	
	/* Get Attribute Catalog*/
	def dispatch getAttributeCatalog(EntityReferenceField f, Entity t, String name) ''' 
	«IF  f !== null && !f.upperBound.equals('*')»
	«f.superType.getAttributeCatalogRel(t, f.name)»
	«ENDIF»
	'''
	def dispatch getAttributeCatalogRel(Enum e, Entity t, String name) ''' 
	model.addAttribute("«name.toLowerCase»", catalogosMNService.obtenerCatalogo«name.toLowerCase.toFirstUpper»());
	'''
	def dispatch getAttributeCatalogRel(Entity e, Entity t, String name) ''' 
	model.addAttribute("«name.toLowerCase»", catalogosMNService.obtenerCatalogo«name.toLowerCase.toFirstUpper»());
	'''	
	/* Get Attribute Column*/
	def dispatch getAttributeColumn(EntityTextField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
	def dispatch getAttributeColumn(EntityLongTextField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
	def dispatch getAttributeColumn(EntityDateField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
	def dispatch getAttributeColumn(EntityImageField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
	def dispatch getAttributeColumn(EntityFileField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
	def dispatch getAttributeColumn(EntityEmailField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
	def dispatch getAttributeColumn(EntityDecimalField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
	def dispatch getAttributeColumn(EntityIntegerField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
	def dispatch getAttributeColumn(EntityCurrencyField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''	
	def dispatch getAttributeColumn(EntityReferenceField f, Entity t)'''«IF  f !== null && !f.upperBound.equals('*')»«entityFieldUtils.getFieldGlossaryName(f)»«ENDIF»'''	
	def dispatch getAttributeRelColumn(Enum e, Entity t, String name) ''' «name»'''
	def dispatch getAttributeRelColumn(Entity e, Entity t, String name) '''«name» '''
	
	/* Get Attribute Data*/
	def dispatch getAttributeData(EntityTextField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityLongTextField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityDateField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityImageField f, Entity t)'''«f.name.toLowerCase»	'''
	def dispatch getAttributeData(EntityFileField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityEmailField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityDecimalField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityIntegerField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityCurrencyField f, Entity t)'''«f.name.toLowerCase»'''	
	def dispatch getAttributeData(EntityReferenceField f, Entity t)'''«IF  f !== null && !f.upperBound.equals('*')»«f.name.toLowerCase»«ENDIF»'''	

}