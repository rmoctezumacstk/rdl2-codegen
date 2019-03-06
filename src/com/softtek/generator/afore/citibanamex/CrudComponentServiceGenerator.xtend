package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentServiceGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/mx/com/aforebanamex/plata/service/" + e.name.toLowerCase.toFirstUpper + "Service.java", e.genJavaService(m))
			}
		}
	}
	
	def CharSequence genJavaService(Entity e, Module m) '''
	package mx.com.aforebanamex.plata.service;
	
	import java.util.List;
	
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»;
	
	public interface «e.name.toLowerCase.toFirstUpper»Service {
		«e.name.toLowerCase.toFirstUpper» findById(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»);
		List<«e.name.toLowerCase.toFirstUpper»> findAll(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»);
		int delete(int id);
		int add(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»);
		int update(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»);
		List<«e.name.toLowerCase.toFirstUpper»> findAllPagination(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase», Integer page, Integer rows);
	}
	'''
	
}