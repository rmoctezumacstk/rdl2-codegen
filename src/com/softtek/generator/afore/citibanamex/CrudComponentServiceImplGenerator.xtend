package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentServiceImplGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/com/aforebanamex/plata/cg/mn/service/impl/" + e.name.toLowerCase.toFirstUpper + "ServiceImpl.java", e.genJavaServiceImpl(m))
			}
		}
	}
	
	def CharSequence genJavaServiceImpl(Entity e, Module m) '''
	package com.aforebanamex.plata.cg.mn.service.impl;
	
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	
	import com.aforebanamex.plata.base.model.RequestPlata;
	import com.aforebanamex.plata.base.model.ResponsePlata;
	import com.aforebanamex.plata.base.service.BaseBusinessService;
	import com.aforebanamex.plata.cg.mn.repository.«e.name.toLowerCase.toFirstUpper»JDBCRepository;
	import com.aforebanamex.plata.cg.mn.service.«e.name.toLowerCase.toFirstUpper»Service;
	import com.aforebanamex.plata.comunes.model.mn.«e.name.toLowerCase.toFirstUpper»;
	
	@Service
	public class «e.name.toLowerCase.toFirstUpper»ServiceImpl extends BaseBusinessService<RequestPlata<«e.name.toLowerCase.toFirstUpper»>, ResponsePlata<«e.name.toLowerCase.toFirstUpper»>> implements «e.name.toLowerCase.toFirstUpper»Service {
	
		@Autowired
		private «e.name.toLowerCase.toFirstUpper»JDBCRepository «e.name.toLowerCase»JDBCRepository;
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtener(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio en el repository obtener: {}", data.toString());
			return «e.name.toLowerCase»JDBCRepository.obtener(data);
		}
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtenerTodos(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio en el repository obtenerTodos: {}", data.toString());
			return «e.name.toLowerCase»JDBCRepository.obtenerTodos(data, data.getPayload());
		}
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> agregar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio en el repository agregar: {}", data.toString());
			return «e.name.toLowerCase»JDBCRepository.agregar(data, data.getPayload());
		}
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> actualizar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio en el repository actualizar: {}", data.toString());
			return «e.name.toLowerCase»JDBCRepository.actualizar(data, data.getPayload());
		}
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> eliminar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio en el repository eliminar: {}", data.toString());
			return «e.name.toLowerCase»JDBCRepository.eliminar(data, data.getPayload());
		}
	}
	'''
	
}