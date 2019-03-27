package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentDaoImplGenerator {
	def doGenerate(Resource resource, IFileSystemAccess2 fsa){
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/mx/com/aforebanamex/plata/dao/impl/" + e.name.toLowerCase + "DAOImpl.java", e.generateDAOImpl(m));
			}
		}
	}

	def CharSequence generateDAOImpl(Entity e, Module m) '''
	package mx.com.aforebanamex.plata.dao.impl;
	
	import java.util.List;
	import mx.com.aforebanamex.plata.exception.ComponenteGeneralException;
	
	import mx.com.aforebanamex.plata.model.Da«e.name.toLowerCase.toFirstUpper»Archivo;
	import mx.com.aforebanamex.plata.model.DependenciaModel;
	import mx.com.aforebanamex.plata.model.Lista«e.name.toLowerCase.toFirstUpper»sModel;
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»Model;
	
	@Repository
	public class «e.name.toLowerCase.toFirstUpper»DAOImpl extends BaseDAO implements «e.name.toLowerCase.toFirstUpper»DAO {
		//Aqui debe ir el contenido de los DAOImpl...
	
	}
	'''
}