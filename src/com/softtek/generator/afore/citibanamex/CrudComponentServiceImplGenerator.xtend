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
	
	import java.util.List;
	
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	
	import mx.com.aforebanamex.plata.integration.«e.name.toLowerCase.toFirstUpper»;
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»;
	import mx.com.aforebanamex.plata.service.«e.name.toLowerCase.toFirstUpper»Service;
	
	@Service
	public class «e.name.toLowerCase.toFirstUpper»ServiceImpl implements «e.name.toLowerCase.toFirstUpper»Service {
		
		@Autowired
		private «e.name.toLowerCase.toFirstUpper»Repository «e.name.toLowerCase»Repository;
	
		@Override
		public «e.name.toLowerCase.toFirstUpper» findById(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
			return «e.name.toLowerCase»Repository.findById(«e.name.toLowerCase»);
		}
	
		@Override
		public List<«e.name.toLowerCase.toFirstUpper»> findAll(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
			return «e.name.toLowerCase»Repository.findAll(«e.name.toLowerCase»);
		}
	
		@Override
		public int delete(int id) {
			return «e.name.toLowerCase»Repository.delete(id);
		}
	
		@Override
		public int add(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
			return «e.name.toLowerCase»Repository.add(«e.name.toLowerCase»);
		}
	
		@Override
		public int update(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
			return «e.name.toLowerCase»Repository.update(«e.name.toLowerCase»);
		}
		
		@Override
		public List<«e.name.toLowerCase.toFirstUpper»> findAllPagination(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase», Integer page, Integer rows){
			return «e.name.toLowerCase»Repository.findAllPagination(«e.name.toLowerCase», (page - 1) * rows, (page) * rows);
		}
	
	}
	'''
	
}