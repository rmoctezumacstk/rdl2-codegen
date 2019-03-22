package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentServiceImplGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/configuracion/src/main/java/com/aforebanamex/plata/configuracion/service/mn/impl/" + e.name.toLowerCase.toFirstUpper + "ServiceImpl.java", e.genJavaServiceImpl(m))
			}
		}
	}
	
	def CharSequence genJavaServiceImpl(Entity e, Module m) '''
	package com.aforebanamex.plata.configuracion.service.mn.impl;
	
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	
	import com.aforebanamex.plata.base.model.RequestPlata;
	import com.aforebanamex.plata.base.model.ResponsePlata;
	import com.aforebanamex.plata.base.service.BaseBusinessService;
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;
	import com.aforebanamex.plata.configuracion.repository.mn.«e.name.toLowerCase.toFirstUpper»RestRepository;
	import com.aforebanamex.plata.configuracion.service.mn.«e.name.toLowerCase.toFirstUpper»Service;
	
	@Service
	public class «e.name.toLowerCase.toFirstUpper»ServiceImpl extends BaseBusinessService<RequestPlata<«e.name.toLowerCase.toFirstUpper»>, ResponsePlata<«e.name.toLowerCase.toFirstUpper»>> implements «e.name.toLowerCase.toFirstUpper»Service {
	
		@Autowired
		private «e.name.toLowerCase.toFirstUpper»RestRepository «e.name.toLowerCase»RestRepository;
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtener(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio en el repository obtener: {}", data.toString());
			return «e.name.toLowerCase»RestRepository.obtener(data);
		}
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtenerTodos(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio en el repository obtenerTodos: {}", data.toString());
			return «e.name.toLowerCase»RestRepository.obtenerTodos(data, data.getPayload());
		}
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> agregar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio en el repository agregar: {}", data.toString());
			return «e.name.toLowerCase»RestRepository.agregar(data, data.getPayload());
		}
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> actualizar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio en el repository actualizar: {}", data.toString());
			return «e.name.toLowerCase»RestRepository.actualizar(data, data.getPayload());
		}
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> eliminar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio en el repository eliminar: {}", data.toString());
			return «e.name.toLowerCase»RestRepository.eliminar(data, data.getPayload());
		}
	}
	'''
	
}