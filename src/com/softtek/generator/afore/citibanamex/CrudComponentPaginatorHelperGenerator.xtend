package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentPaginatorHelperGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/mx/com/aforebanamex/plata/helper/PaginadoHelper" + e.name.toLowerCase.toFirstUpper + ".java", e.genJavaHelper(m))
			}
		}
	}
	
	def CharSequence genJavaHelper(Entity e, Module m) '''
	package mx.com.aforebanamex.plata.helper;
	
	import java.util.List;
	
	import mx.com.aforebanamex.plata.base.helper.BaseHelper;
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»;
	
	public class PaginadoHelper«e.name.toLowerCase.toFirstUpper» extends BaseHelper {
	
		/*
		 * Campos necesarios del paginador para llevar a cabo las consultas por pagina
		 */
		private int paginaActual;
	
		private int totalPaginas;
	
		private int totalRegistros;
	
		private List<«e.name.toLowerCase.toFirstUpper»> payload;
	
		public PaginadoHelper«e.name.toLowerCase.toFirstUpper»() {
		}
	
		/**
		 * Constructor de la clase.
		 * 
		 * @param paginaActual
		 *            Pagina actual del componente jqgrid que muestra la informacion de
		 *            la consulta.
		 * @param totalPaginas
		 *            Total de paginas de la consulta.
		 * @param totalPaginas
		 *            Total de registros de la consulta.
		 * @param listaRegistros
		 *            Coleccion de objetos de la consulta.
		 */
		public PaginadoHelper«e.name.toLowerCase.toFirstUpper»(int paginaActual, int totalPaginas, int totalRegistros, List<«e.name.toLowerCase.toFirstUpper»> payload) {
			super();
			this.paginaActual = paginaActual;
			this.totalPaginas = totalPaginas;
			this.totalRegistros = totalRegistros;
			this.payload = payload;
		}
	
		public int getPaginaActual() {
			return paginaActual;
		}
	
		public void setPaginaActual(int paginaActual) {
			this.paginaActual = paginaActual;
		}
	
		public int getTotalPaginas() {
			return totalPaginas;
		}
	
		public void setTotalPaginas(int totalPaginas) {
			this.totalPaginas = totalPaginas;
		}
	
		public int getTotalRegistros() {
			return totalRegistros;
		}
	
		public void setTotalRegistros(int totalRegistros) {
			this.totalRegistros = totalRegistros;
		}
	
		public List<«e.name.toLowerCase.toFirstUpper»> getPayload() {
			return payload;
		}
	
		public void setPayload(List<«e.name.toLowerCase.toFirstUpper»> payload) {
			this.payload = payload;
		}
	
		@Override
		public String toString() {
			return "JqgridResponse [paginaActual=" + paginaActual + ", totalPaginas=" + totalPaginas + ", totalRegistros="
					+ totalRegistros + ", listaRegistros=" + payload + "]";
		}
	'''
	
}