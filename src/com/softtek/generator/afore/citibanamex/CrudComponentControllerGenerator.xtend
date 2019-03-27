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
import com.softtek.rdl2.EntityDateTimeField
import com.softtek.rdl2.EntityTimeField
import com.softtek.rdl2.EntityBooleanField

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
	
	«FOR f : e.entity_fields»
	«f.getAttributeImport(e)»
	«ENDFOR»	
	
		
	@Controller
	public class «e.name.toLowerCase.toFirstUpper»Controller extends BaseController<«e.name.toLowerCase.toFirstUpper», «e.name.toLowerCase.toFirstUpper»> {
		
		@Autowired
		private «e.name.toLowerCase.toFirstUpper»Service «e.name.toLowerCase»Service;
		
		@Autowired
		private CatalogosMNService catalogosMNService;
		
		
		@Override
		@GetMapping(value=MNConstantesHelper.URL_PAGINA_«e.name.toUpperCase»)
		public String pagina(Model model) {
			model.addAttribute("cabeceras", "Seleccione,«FOR f : e.entity_fields SEPARATOR ","»«f.getAttributeColumn(e)»«ENDFOR»");	
			model.addAttribute("origenDatos", "id«e.name.toLowerCase.toFirstUpper»,«FOR f : e.entity_fields SEPARATOR ","»«f.getAttributeData(e)»«ENDFOR»");
			return MNConstantesHelper.PAGINA_«e.name.toUpperCase»;
		}	
		
		@Override
		@RequestMapping(value="/obtener«e.name.toLowerCase.toFirstUpper»")
		public @ResponseBody ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtener(@RequestBody RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio la petición - consultar el «e.name.toLowerCase»: {}", data.toString());
			return «e.name.toLowerCase»Service.obtener(data);
		}
	
		@Override
		@RequestMapping(value="/obtener«e.name.toLowerCase.toFirstUpper»s")
		public @ResponseBody ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtenerTodos(@RequestBody RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio la petición - consultar todos los «e.name.toLowerCase»s: {}", data.toString());
			return «e.name.toLowerCase»Service.obtenerTodos(data);
		}
	
		@Override
		@RequestMapping(value="/agregar«e.name.toLowerCase.toFirstUpper»")
		public @ResponseBody ResponsePlata<«e.name.toLowerCase.toFirstUpper»> agregar(@RequestBody RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio la petición - agregar «e.name.toLowerCase»: {}", data.toString());
			return «e.name.toLowerCase»Service.agregar(data);
		}
	
		@Override
		@RequestMapping(value="/actualizar«e.name.toLowerCase.toFirstUpper»")
		public @ResponseBody ResponsePlata<«e.name.toLowerCase.toFirstUpper»> actualizar(@RequestBody RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio la petición - actualizar «e.name.toLowerCase»: {}", data.toString());
			return «e.name.toLowerCase»Service.actualizar(data);
		}
	
		@Override
		@RequestMapping(value="/eliminar«e.name.toLowerCase.toFirstUpper»")
		public @ResponseBody ResponsePlata<«e.name.toLowerCase.toFirstUpper»> eliminar(@RequestBody RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio la petición - eliminar «e.name.toLowerCase»: {}", data.toString());
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
	def dispatch getAttributeImport(EntityDateTimeField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityTimeField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityBooleanField f, Entity t)'''
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
	import com.aforebanamex.plata.comunes.model.cg.«name.toLowerCase.toFirstUpper»;
	'''
	
	/* Get Attribute Column*/
	def dispatch getAttributeColumn(EntityTextField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
	def dispatch getAttributeColumn(EntityLongTextField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
	def dispatch getAttributeColumn(EntityDateField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
	def dispatch getAttributeColumn(EntityDateTimeField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
	def dispatch getAttributeColumn(EntityTimeField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
	def dispatch getAttributeColumn(EntityBooleanField f, Entity t)'''«entityFieldUtils.getFieldGlossaryName(f)»'''
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
	def dispatch getAttributeData(EntityDateTimeField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityTimeField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityBooleanField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityImageField f, Entity t)'''«f.name.toLowerCase»	'''
	def dispatch getAttributeData(EntityFileField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityEmailField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityDecimalField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityIntegerField f, Entity t)'''«f.name.toLowerCase»'''
	def dispatch getAttributeData(EntityCurrencyField f, Entity t)'''«f.name.toLowerCase»'''	
	def dispatch getAttributeData(EntityReferenceField f, Entity t)'''«IF  f !== null && !f.upperBound.equals('*')»«f.name.toLowerCase»«ENDIF»'''	
}