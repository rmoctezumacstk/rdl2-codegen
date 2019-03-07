package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentRepositoryGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/mx/com/aforebanamex/plata/integration/" + e.name.toLowerCase.toFirstUpper + "Repository.java", e.genJavaRepository(m))
			}
		}
	}
	
	def CharSequence genJavaRepository(Entity e, Module m) '''
	package mx.com.aforebanamex.plata.integration;
	
	import mx.com.aforebanamex.plata.helper.PaginadoHelper«e.name.toLowerCase.toFirstUpper»;
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»;
	
	public interface «e.name.toLowerCase.toFirstUpper»Repository {
		«e.name.toLowerCase.toFirstUpper» obtener«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»);
		int eliminar«e.name.toLowerCase.toFirstUpper»(int id);
		int agregar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»);
		int actualizar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»);
		PaginadoHelper«e.name.toLowerCase.toFirstUpper» obtener«e.name.toLowerCase.toFirstUpper»s(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase», Integer valorMinimo, Integer valorMaximo);
	}
	
	'''
	
}

