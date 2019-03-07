package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentControllerGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/mx/com/aforebanamex/plata/controller/" + e.name.toLowerCase.toFirstUpper + "Controller.java", e.generateController(m))
			}
		}
	}
	
	
	def CharSequence generateController(Entity e, Module m) '''
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
	import mx.com.aforebanamex.plata.helper.PaginadoHelper;
	import mx.com.aforebanamex.plata.model.EstadoIndicador;
	import mx.com.aforebanamex.plata.model.Paginador;
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»;
	import mx.com.aforebanamex.plata.model.TipoMedida;
	import mx.com.aforebanamex.plata.service.CatalogoService;
	import mx.com.aforebanamex.plata.service.«e.name.toLowerCase.toFirstUpper»Service;
		
	@Controller
	public class «e.name.toLowerCase.toFirstUpper»Controller extends BaseController {
		
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
}