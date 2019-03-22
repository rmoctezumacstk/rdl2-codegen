package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentControllerMNGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/mn/src/main/java/com/aforebanamex/plata/cg/mn/controller/" + e.name.toLowerCase.toFirstUpper + "Controller.java", e.genServiceMNController(m))
			}
		}
	}
	
	def CharSequence genServiceMNController(Entity e, Module m) '''
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
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;
	
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
	
}