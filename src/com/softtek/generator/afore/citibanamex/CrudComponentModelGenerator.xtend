package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentModelGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/mx/com/aforebanamex/plata/model/" + e.name.toLowerCase.toFirstUpper + ".java", e.genJavaModel(m))
			}
		}
	}
	
	def CharSequence genJavaModel(Entity e, Module m) '''
	package mx.com.aforebanamex.plata.model;
	
	import java.io.Serializable;
	import java.util.List;
	
	import javax.validation.Valid;
	import javax.validation.constraints.Digits;
	import javax.validation.constraints.Size;
	
	public class «e.name.toLowerCase.toFirstUpper» implements Serializable{
		
		private static final long serialVersionUID = 1L;
		@Digits(integer=16, fraction=0, message="El id«e.name.toLowerCase.toFirstUpper» es incorrecto.")
		private Integer id«e.name.toLowerCase.toFirstUpper»;
		@Size(min=0,max=99, message="El nombre es incorrecto.")
		private String nombre;
		@Size(min=0,max=99, message="El descripcion es incorrecto.")
		private String descripcion;
		@Size(min=0,max=1, message="El desempenio es incorrecto.")
		private String desempenio;
		@Size(min=0,max=99, message="El descripcionEdoIndicador es incorrecto.")
		private String descripcionEdoIndicador;
		@Size(min=0,max=99, message="El descripcionTipoMedida es incorrecto.")
		private String descripcionTipoMedida;
		@Valid
		private List<Valor«e.name.toLowerCase.toFirstUpper»> valores«e.name.toLowerCase.toFirstUpper»;
		private String valorVerde;
		private String valorAmarillo;
		private String valorRojo;
		
		public «e.name.toLowerCase.toFirstUpper»(){}
		
		public «e.name.toLowerCase.toFirstUpper»(Integer id«e.name.toLowerCase.toFirstUpper», String nombre, String descripcion, String desempenio, String descripcionEdoIndicador,
				String descripcionTipoMedida, List<Valor«e.name.toLowerCase.toFirstUpper»> valor«e.name.toLowerCase.toFirstUpper») {
			super();
			this.id«e.name.toLowerCase.toFirstUpper» = id«e.name.toLowerCase.toFirstUpper»;
			this.nombre = nombre;
			this.descripcion = descripcion;
			this.desempenio = desempenio;
			this.descripcionEdoIndicador = descripcionEdoIndicador;
			this.descripcionTipoMedida = descripcionTipoMedida;
			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
		}
		
		public Integer getId«e.name.toLowerCase.toFirstUpper»() {
			return id«e.name.toLowerCase.toFirstUpper»;
		}
		public void setId«e.name.toLowerCase.toFirstUpper»(Integer id«e.name.toLowerCase.toFirstUpper») {
			this.id«e.name.toLowerCase.toFirstUpper» = id«e.name.toLowerCase.toFirstUpper»;
		}
		public String getNombre() {
			return nombre;
		}
		public void setNombre(String nombre) {
			this.nombre = nombre;
		}
		public String getDescripcion() {
			return descripcion;
		}
		public void setDescripcion(String descripcion) {
			this.descripcion = descripcion;
		}
		public String getDesempenio() {
			return desempenio;
		}
		public void setDesempenio(String desempenio) {
			this.desempenio = desempenio;
		}
		public String getDescripcionEdoIndicador() {
			return descripcionEdoIndicador;
		}
		public void setDescripcionEdoIndicador(String descripcionEdoIndicador) {
			this.descripcionEdoIndicador = descripcionEdoIndicador;
		}
		public String getDescripcionTipoMedida() {
			return descripcionTipoMedida;
		}
		public void setDescripcionTipoMedida(String descripcionTipoMedida) {
			this.descripcionTipoMedida = descripcionTipoMedida;
		}
	
		public List<Valor«e.name.toLowerCase.toFirstUpper»> getValor«e.name.toLowerCase.toFirstUpper»() {
			return valores«e.name.toLowerCase.toFirstUpper»;
		}
	
		public void setValor«e.name.toLowerCase.toFirstUpper»(List<Valor«e.name.toLowerCase.toFirstUpper»> valores«e.name.toLowerCase.toFirstUpper») {
			this.valores«e.name.toLowerCase.toFirstUpper» = valores«e.name.toLowerCase.toFirstUpper»;
		}
	
		public List<Valor«e.name.toLowerCase.toFirstUpper»> getValores«e.name.toLowerCase.toFirstUpper»() {
			return valores«e.name.toLowerCase.toFirstUpper»;
		}
	
		public void setValores«e.name.toLowerCase.toFirstUpper»(List<Valor«e.name.toLowerCase.toFirstUpper»> valores«e.name.toLowerCase.toFirstUpper») {
			this.valores«e.name.toLowerCase.toFirstUpper» = valores«e.name.toLowerCase.toFirstUpper»;
		}
	
		public String getValorVerde() {
			return valorVerde;
		}
	
		public void setValorVerde(String valorVerde) {
			this.valorVerde = valorVerde;
		}
	
		public String getValorAmarillo() {
			return valorAmarillo;
		}
	
		public void setValorAmarillo(String valorAmarillo) {
			this.valorAmarillo = valorAmarillo;
		}
	
		public String getValorRojo() {
			return valorRojo;
		}
	
		public void setValorRojo(String valorRojo) {
			this.valorRojo = valorRojo;
		}
		
	}
	'''
	
}