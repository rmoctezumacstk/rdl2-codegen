package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentServiceImplGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/mx/com/aforebanamex/plata/service/impl/" + e.name.toLowerCase.toFirstUpper + "ServiceImpl.java", e.genJavaServiceImpl(m))
			}
		}
	}
	
	def CharSequence genJavaServiceImpl(Entity e, Module m) '''
	package mx.com.aforebanamex.plata.service.impl;
	
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	
	import mx.com.aforebanamex.plata.helper.PaginadoHelper«e.name.toLowerCase.toFirstUpper»;
	import mx.com.aforebanamex.plata.integration.«e.name.toLowerCase.toFirstUpper»Repository;
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»;
	import mx.com.aforebanamex.plata.service.«e.name.toLowerCase.toFirstUpper»Service;
	
	@Service
	public class «e.name.toLowerCase.toFirstUpper»ServiceImpl implements «e.name.toLowerCase.toFirstUpper»Service {
		
		@Autowired
		private «e.name.toLowerCase.toFirstUpper»Repository «e.name.toLowerCase»Repository;
	
		@Override
		public «e.name.toLowerCase.toFirstUpper» obtener«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
			return «e.name.toLowerCase»Repository.obtener«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase»);
		}
	
		@Override
		public int eliminar«e.name.toLowerCase.toFirstUpper»(int id) {
			return «e.name.toLowerCase»Repository.eliminar«e.name.toLowerCase.toFirstUpper»(id);
		}
	
		@Override
		public int agregar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
			return «e.name.toLowerCase»Repository.agregar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase»);
		}
	
		@Override
		public int actualizar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
			return «e.name.toLowerCase»Repository.actualizar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase»);
		}
		
		@Override
		public PaginadoHelper«e.name.toLowerCase.toFirstUpper» obtener«e.name.toLowerCase.toFirstUpper»s(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase», Integer page, Integer rows){
			PaginadoHelper«e.name.toLowerCase.toFirstUpper» paginadoHelper = «e.name.toLowerCase»Repository.obtener«e.name.toLowerCase.toFirstUpper»s(«e.name.toLowerCase», (page - 1) * rows, (page) * rows);
			paginadoHelper.setPaginaActual(page);
			paginadoHelper.setTotalPaginas(paginadoHelper.getTotalRegistros()/rows+((paginadoHelper.getTotalRegistros()%rows)==0?0:1));
			return paginadoHelper;
		}
	
	}

	'''
	
}