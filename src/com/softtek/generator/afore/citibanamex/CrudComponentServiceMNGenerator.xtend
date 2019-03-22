package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentServiceMNGenerator {

	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/mn/src/main/java/com/aforebanamex/plata/cg/mn/service/" + e.name.toLowerCase.toFirstUpper + "Service.java", e.genServiceMNService(m))
			}
		}
	}
	
	def CharSequence genServiceMNService(Entity e, Module m) '''
	package com.aforebanamex.plata.cg.mn.service;
	
	import com.aforebanamex.plata.base.model.RequestPlata;
	import com.aforebanamex.plata.base.model.ResponsePlata;
	import com.aforebanamex.plata.base.service.BaseService;
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;
	
	public interface «e.name.toLowerCase.toFirstUpper»Service extends BaseService<RequestPlata<«e.name.toLowerCase.toFirstUpper»>, ResponsePlata<«e.name.toLowerCase.toFirstUpper»>>{
		
	}	
	'''
	
}