package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentPaginadorGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/mx/com/aforebanamex/plata/model/Paginador" + e.name.toLowerCase.toFirstUpper + ".java", e.genJavaPaginador(m))
			}
		}
	}
	
	def CharSequence genJavaPaginador(Entity e, Module m) '''
	package mx.com.aforebanamex.plata.model;
	
	public class Paginador«e.name.toLowerCase.toFirstUpper» {
	
		private int pagina;
		private int filas;
		private «e.name.toLowerCase.toFirstUpper» payload;
		
		public int getPagina() {
			return pagina;
		}
		public void setPagina(int pagina) {
			this.pagina = pagina;
		}
		public int getFilas() {
			return filas;
		}
		public void setFilas(int filas) {
			this.filas = filas;
		}
		public «e.name.toLowerCase.toFirstUpper» getPayload() {
			return payload;
		}
		public void setPayload(«e.name.toLowerCase.toFirstUpper» payload) {
			this.payload = payload;
		}	
		
	}	
	'''
}