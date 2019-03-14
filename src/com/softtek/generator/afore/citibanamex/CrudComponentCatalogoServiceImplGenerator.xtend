package com.softtek.generator.afore.citibanamex

import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentCatalogoServiceImplGenerator {
	
	def doGenerate(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) {
		fsa.generateFile("banamex/src/main/java/com/aforebanamex/plata/service/CatalogoServiceImpl.java", genCatalogoServiceImpl(s, fsa))	
	}
	
	def CharSequence genCatalogoServiceImpl(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) '''
	package mx.com.aforebanamex.plata.service.impl;
	
	import java.util.List;
	
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	
	import mx.com.aforebanamex.plata.integration.CatalogoRepository;
	import mx.com.aforebanamex.plata.model.EstadoIndicador;
	import mx.com.aforebanamex.plata.model.TipoMedida;
	import mx.com.aforebanamex.plata.service.CatalogoService;
	
	«FOR m : s.modules_ref»
		«FOR e : m.module_ref.elements.filter(Entity)»
		«e.genEntityImport(m.module_ref)»
		«ENDFOR»
	«ENDFOR»
	
	@Service
	public class CatalogoServiceImpl implements CatalogoService {
		
		@Autowired
		private CatalogoRepository catalogoRepository;
	
		@Override
		public List<TipoMedida> obtenerTipoMedida() {
			return catalogoRepository.obtenerTipoMedida();
		}
	
		@Override
		public List<EstadoIndicador> obtenerEstadoIndicador() {
			return catalogoRepository.obtenerEstadoIndicador();
		}
		
		«FOR m : s.modules_ref»
			«FOR e : m.module_ref.elements.filter(Entity)»
			«e.genEntity(m.module_ref)»
			«ENDFOR»
		«ENDFOR»
	}
	'''
	
	def dispatch genEntity(Entity e, Module m) '''
	@Override
	public List<«e.name.toLowerCase.toFirstUpper»> obtener«e.name.toLowerCase.toFirstUpper»() {
		return catalogoRepository.obtener«e.name.toLowerCase.toFirstUpper»();
	}
	'''
	
	def dispatch genEntityImport(Entity e, Module m) '''
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»;
	'''
}