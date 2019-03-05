package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity
import com.softtek.generator.utils.EntityUtils
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.generator.utils.UIFlowUtils

class CrudComponentIntegrationGenerator {
	
	var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/mx/com/aforebanamex/plata/integration/" + e.name.toLowerCase.toFirstUpper + "Repository.java", e.genAppHtml(m))
			}
		}
	}
	
	def CharSequence genAppHtml(Entity e, Module m) '''
	package mx.com.aforebanamex.plata.integration;
	
	import java.util.List;
	
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»;
	
	public interface «e.name.toLowerCase.toFirstUpper»Repository {
		«e.name.toLowerCase.toFirstUpper» findById(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»);
		List<«e.name.toLowerCase.toFirstUpper»> findAll(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»);
		int delete(int id);
		int add(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»);
		int update(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase.toFirstUpper»);
		List<«e.name.toLowerCase.toFirstUpper»> findAllPagination(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase», Integer valorMinimo, Integer valorMaximo);
	}
	
	'''
	
}

