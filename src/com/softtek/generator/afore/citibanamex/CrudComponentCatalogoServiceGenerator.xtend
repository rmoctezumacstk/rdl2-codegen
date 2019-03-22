package com.softtek.generator.afore.citibanamex

import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentCatalogoServiceGenerator {
	
	def doGenerate(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) {
		fsa.generateFile("banamex/src/main/java/com/aforebanamex/plata/service/CatalogoService.java", genCatalogoService(s, fsa))	
	}
	
	def CharSequence genCatalogoService(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) '''
	package mx.com.aforebanamex.plata.service;
	
	import java.util.List;
	
	import mx.com.aforebanamex.plata.model.EstadoIndicador;
	import mx.com.aforebanamex.plata.model.TipoMedida;
	
	«FOR m : s.modules_ref»
		«FOR e : m.module_ref.elements.filter(Entity)»
		«e.genEntityImport(m.module_ref)»
		«ENDFOR»
	«ENDFOR»
	
	public interface CatalogoService {
		List<TipoMedida> obtenerTipoMedida();
		List<EstadoIndicador> obtenerEstadoIndicador();
		«FOR m : s.modules_ref»
			«FOR e : m.module_ref.elements.filter(Entity)»
			«e.genEntity(m.module_ref)»
			«ENDFOR»
		«ENDFOR»
	}
	'''
	
	def dispatch genEntity(Entity e, Module m) '''
	List<«e.name.toLowerCase.toFirstUpper»> obtener«e.name.toLowerCase.toFirstUpper»();
	'''
	
	def dispatch genEntityImport(Entity e, Module m) '''
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»;
	'''
}