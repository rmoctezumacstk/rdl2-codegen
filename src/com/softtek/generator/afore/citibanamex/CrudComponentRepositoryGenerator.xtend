package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentRepositoryGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/configuracion/src/main/java/com/aforebanamex/plata/configuracion/repository/mn/" + e.name.toLowerCase.toFirstUpper + "RestRepository.java", e.genJavaRepository(m))
			}
		}
	}
	
	def CharSequence genJavaRepository(Entity e, Module m) '''
	package com.aforebanamex.plata.configuracion.repository.mn;
	
	import com.aforebanamex.plata.base.model.RequestPlata;
	import com.aforebanamex.plata.base.model.ResponsePlata;
	import com.aforebanamex.plata.base.repository.BaseRepository;
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;
	
	public interface «e.name.toLowerCase.toFirstUpper»RestRepository extends BaseRepository<RequestPlata<«e.name.toLowerCase.toFirstUpper»>, «e.name.toLowerCase.toFirstUpper», ResponsePlata<«e.name.toLowerCase.toFirstUpper»>> {
	
	}
	
	'''
	
}

