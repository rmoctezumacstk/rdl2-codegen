package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity


class CrudComponentJDBCRepositoryGenerator {
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/com/aforebanamex/plata/cg/mn/repository/"+e.name.toLowerCase.toFirstUpper+"JDBCRepository.java", e.genJavaJDBCRepository(m))
			}
		}
	}
	
	def CharSequence genJavaJDBCRepository(Entity e, Module m) '''
		package com.aforebanamex.plata.cg.mn.repository;
		
		import com.aforebanamex.plata.base.model.RequestPlata;
		import com.aforebanamex.plata.base.model.ResponsePlata;
		import com.aforebanamex.plata.base.repository.BaseRepository;
		import com.aforebanamex.plata.comunes.model.mn.«e.name.toLowerCase.toFirstUpper»;
				
		public interface «e.name.toLowerCase.toFirstUpper»JDBCRepository extends BaseRepository<RequestPlata<«e.name.toLowerCase.toFirstUpper»>, «e.name.toLowerCase.toFirstUpper», ResponsePlata<«e.name.toLowerCase.toFirstUpper»>> {
		
		}
	'''	
	
}