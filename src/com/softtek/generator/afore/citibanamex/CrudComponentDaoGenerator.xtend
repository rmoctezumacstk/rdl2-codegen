package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentDaoGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa){
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/mx/com/aforebanamex/plata/dao/" + e.name.toLowerCase + "DAO.java", e.generateDAO(m));
			}
		}
	}
	
	def CharSequence generateDAO(Entity e, Module m) '''
	package mx.com.aforebanamex.plata.dao;
	
	import java.util.List;
	import mx.com.aforebanamex.plata.exception.ComponenteGeneralException;
	
	import mx.com.aforebanamex.plata.model.Da«e.name.toLowerCase.toFirstUpper»Archivo;
	import mx.com.aforebanamex.plata.model.DependenciaModel;
	import mx.com.aforebanamex.plata.model.Lista«e.name.toLowerCase.toFirstUpper»sModel;
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»Model;

	
	/**
	 * interface «e.name.toLowerCase.toFirstUpper»DAO.
	 * @author PSG.
	 *
	 */
	public interface «e.name.toLowerCase.toFirstUpper»DAO {
		public boolean verifica«e.name.toLowerCase.toFirstUpper»(String idSistema, String «e.name.toLowerCase») throws ComponenteGeneralException;
		
		public void crear«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper»Model «e.name.toLowerCase») throws ComponenteGeneralException;
		
		public List<Lista«e.name.toLowerCase.toFirstUpper»sModel> obtiene«e.name.toLowerCase.toFirstUpper»s(String idSistema, String contenedor) throws ComponenteGeneralException;
		
		public «e.name.toLowerCase.toFirstUpper»Model obtiene«e.name.toLowerCase.toFirstUpper»Info(String idSistema, String contenedor) throws ComponenteGeneralException;
		
		public void actualizar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper»Model «e.name.toLowerCase») throws ComponenteGeneralException;
		
		public List<Lista«e.name.toLowerCase.toFirstUpper»sModel> obtenerLista«e.name.toLowerCase.toFirstUpper»s(String idSitema, String[] listaExclusion) throws ComponenteGeneralException;
		
		public void agregarDependencia«e.name.toLowerCase.toFirstUpper»(DependenciaModel dependencia) throws ComponenteGeneralException ;
		
		public void quitarDependencia«e.name.toLowerCase.toFirstUpper»(String idSistema, String id«e.name.toLowerCase.toFirstUpper», String[] id«e.name.toLowerCase.toFirstUpper»Dependencia) throws ComponenteGeneralException ;
		
		public List<String> obtenerListaDependencias(String idSistema, String id«e.name.toLowerCase.toFirstUpper») throws ComponenteGeneralException;
		
		public  void agregar«e.name.toLowerCase.toFirstUpper»Archivo(Da«e.name.toLowerCase.toFirstUpper»Archivo «e.name.toLowerCase»Archivo) throws ComponenteGeneralException;
		
		public List<Lista«e.name.toLowerCase.toFirstUpper»sModel> obtenerLista«e.name.toLowerCase.toFirstUpper»sEnv(String idSistema) throws ComponenteGeneralException;
	}
	
	'''
}