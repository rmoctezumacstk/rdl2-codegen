package com.softtek.generator.afore.citibanamex

import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity
import com.softtek.rdl2.Enum
import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.EntityTextField
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.generator.utils.EntityUtils
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.generator.utils.UIFlowUtils
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity
import com.softtek.rdl2.EntityDateTimeField
import com.softtek.rdl2.EntityTimeField
import com.softtek.rdl2.EntityBooleanField

class CrudComponentQuerysGenerator {
		
		var entityUtils = new EntityUtils
		var entityFieldUtils = new EntityFieldUtils
		var uiFlowUtils = new UIFlowUtils
		
		def doGenerate(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) {
			fsa.generateFile("banamex/mn/src/main/resorces/sentences/salidaInformacion-mn.xml", generateHelper(s, fsa))	
		}
		
		
		def CharSequence generateHelper(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) '''	
		
	
	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
	
	<properties>
	
		<!-- Consultas  -->
		<entry key="procesos.modulo.consulta.id">
			<![CDATA[
				select ID_MODULO,CLAVE,DESCRIPCION,ESTADO_LOGICO from CGT_MODULO where ID_MODULO=? and ESTADO_LOGICO = 'true'
			]]>
		</entry>
		<entry key="subproceso.procesos.consulta.id">
			<![CDATA[
				select 
				ID_PROCESOS,CLAVE,DESCRIPCION,RUTA,ID_MODULO,ESTADO_LOGICO 
				from 
				CGT_PROCESOS 
				where ID_PROCESOS=? and ESTADO_LOGICO = 'true'
			]]>
		</entry>
		<entry key="subproceso.modulo.consulta.id">
			<![CDATA[
				select ID_MODULO,CLAVE,DESCRIPCION,ESTADO_LOGICO from CGT_MODULO where ID_MODULO=? and ESTADO_LOGICO = 'true'
			]]>
		</entry>
		
		<entry key="tarea.subproceso.consulta.id	">
			<![CDATA[
				select ID_SUBPROCESO,CLAVE,DESCRIPCION,RUTA,ESTADO_LOGICO from CGT_SUBPROCESO where ID_SUBPROCESO=? and ESTADO_LOGICO = 'true'
			]]>
		</entry>
		<entry key="tarea.procesos.consulta.id	">
			<![CDATA[
				select 
				ID_PROCESOS,CLAVE,DESCRIPCION,RUTA,ID_MODULO,ESTADO_LOGICO 
				from 
				CGT_PROCESOS 
				where ID_PROCESOS=? and ESTADO_LOGICO = 'true'
			]]>
		</entry>
		<entry key="tarea.modulo.consulta.id	">
			<![CDATA[
				select ID_MODULO,CLAVE,DESCRIPCION,ESTADO_LOGICO from CGT_MODULO where ID_MODULO=? and ESTADO_LOGICO = 'true'
			]]>
		</entry>	
	
		
	<!-- Semaforo -->	
		<entry key="mn.consulta.semaforo.id">
			<![CDATA[
				select 
				ID_SEMAFORO,NOMBRE,DESCRIPCION,DESEMPENIO,CVE_EDO_INDICADOR,CVE_TIPO_MEDIDA 
				from 
				CGT_SEMAFORO 
				where ID_SEMAFORO=:id
			]]>
		</entry>
		<entry key="mn.consulta.valor.semaforo.id">
			<![CDATA[
				select 
				ID_VALOR_SEMAFORO,CVE_COLOR_SEMAFORO,VALOR_MAXIMO,VALOR_MINIMO 
				from 
				CGT_VALOR_SEMAFORO 
				where ID_SEMAFORO=?
			]]>
		</entry>
		<entry key="mn.consulta.semaforo.registros">
			<![CDATA[
				select 
				ID_SEMAFORO,NOMBRE,DESCRIPCION,DESEMPENIO,CVE_EDO_INDICADOR,CVE_TIPO_MEDIDA 
				from 
				CGT_SEMAFORO 
				where 1=1
			]]>
		</entry>
		<entry key="mn.consulta.semaforo.registros.count">
			<![CDATA[
				select 
				count(1) 
				from CGT_SEMAFORO 
				where 1=1
			]]>
		</entry>
		<entry key="mn.inserta.semaforo.db">
			<![CDATA[
				insert into 
				CGT_SEMAFORO 
				(NOMBRE,DESCRIPCION,DESEMPENIO,CVE_EDO_INDICADOR,CVE_TIPO_MEDIDA) 
				values(:nombre,:descripcion,:desempenio,:estadoIndicador,:tipoMedida)
			]]>
		</entry>
		<entry key="mn.inserta.valor.db">
			<![CDATA[
				insert into 
				CGT_VALOR_SEMAFORO 
				(ID_SEMAFORO,CVE_COLOR_SEMAFORO,VALOR_MAXIMO,VALOR_MINIMO) 
				values(?,?,?,?)
			]]>
		</entry>
		<entry key="mn.actualizar.semaforo">
			<![CDATA[
				update 
				CGT_SEMAFORO 
				set NOMBRE=:nombre, DESCRIPCION=:descripcion, DESEMPENIO=:desempenio, CVE_EDO_INDICADOR=:estadoIndicador, CVE_TIPO_MEDIDA=:tipoMedida 
				where ID_SEMAFORO=:idSemaforo
			]]>
		</entry>
		<entry key="mn.actualizar.valor">
			<![CDATA[
				update 
				CGT_VALOR_SEMAFORO 
				set VALOR_MAXIMO=:valorMaximo,VALOR_MINIMO=:valorMinimo 
				where ID_SEMAFORO=:idSemaforo and CVE_COLOR_SEMAFORO=:colorSemaforo
			]]>
		</entry>
		<entry key="mn.eliminar.semaforo">
			<![CDATA[
				delete 
				from CGT_SEMAFORO 
				where ID_SEMAFORO=?
			]]>
		</entry>
		<entry key="mn.eliminar.valor">
			<![CDATA[
				delete 
				from CGT_VALOR_SEMAFORO 
				where ID_SEMAFORO= ?
			]]>
		</entry>
		<entry key="mn.tipo.medida">
			<![CDATA[
				select 
				CVE_TIPO_MEDIDA,DESCRIPCION 
				from CGG_TIPO_MEDIDA
			]]>
		</entry>
		<entry key="mn.estatus.indicador">
			<![CDATA[
				select 
				CVE_EDO_INDICADOR,DESCRIPCION 
				from CGG_EDO_INDICADOR
			]]>
		</entry>
		<entry key="mn.catalogo.tiposalida">
			<![CDATA[
				select 
				CVE_TIPOSALIDA,DESCRIPCION 
				from CGT_TIPOSALIDA
			]]>
		</entry>
		<entry key="mn.catalogo.clasificacionsalidainfo">
			<![CDATA[
				select 
				CVE_CLASIFICACIONSALIDAINFO,DESCRIPCION 
				from CGT_CLASIFICACIONSALIDAINFO
			]]>
		</entry>	
		<entry key="mn.catalogo.estatussalidainfo">
			<![CDATA[
				select 
				CVE_ESTATUSSALIDAINFO,DESCRIPCION 
				from CGT_ESTATUSSALIDAINFO
			]]>
		</entry>
		<entry key="mn.catalogo.estatustareareglanegocio">
			<![CDATA[
				select 
				CVE_CGT_ESTATUSTAREAREGLANEGOCIO,DESCRIPCION 
				from CGT_ESTATUSTAREAREGLANEGOCIO
			]]>
		</entry>
		
		<entry key="mn.inserta.semaforo">
			<![CDATA[
				insert into 
				CGT_SEMAFORO 
				(NOMBRE,DESCRIPCION,DESEMPENIO,CVE_EDO_INDICADOR,CVE_TIPO_MEDIDA) 
				values(:snombre,:descripcion,:desempenio,:estadoIndicador,:tipoMedida)
			]]>
		</entry>
		<entry key="mn.inserta.valor">
			<![CDATA[
				insert into 
				CGT_VALOR_SEMAFORO 
				(ID_SEMAFORO,CVE_COLOR_SEMAFORO,VALOR_MAXIMO,VALOR_MINIMO) 
				values(?,?,?,?)
			]]>
		</entry>
		
	<!-- Catalogos -->
		<entry key="mn.catalogo.modulo">
			<![CDATA[
				select 
				ID_MODULO, CLAVE, DESCRIPCION 
				from CGT_MODULO 
				where ESTADO_LOGICO = 'true'
			]]>
		</entry>
		<entry key="mn.catalogo.procesos">
			<![CDATA[
				select 
				ID_PROCESOS, CLAVE, DESCRIPCION 
				from CGT_PROCESOS 
				where ESTADO_LOGICO = 'true'
			]]>
		</entry>
		<entry key="mn.catalogo.subproceso">
			<![CDATA[
				select 
				ID_SUBPROCESO, CLAVE, DESCRIPCION 
				from CGT_SUBPROCESO 
				where ESTADO_LOGICO = 'true'
			]]>
		</entry>
		<entry key="mn.catalogo.tarea">
			<![CDATA[
				select 
				ID_TAREA, CLAVE, DESCRIPCION 
				from CGT_TAREA 
				where ESTADO_LOGICO = 'true'
			]]>
		</entry>	
		<entry key="mn.catalogo.reglanegocio">
			<![CDATA[
				select 
				ID_REGLANEGOCIO, CLAVE, DESCRIPCION 
				from CGT_REGLANEGOCIO 
				where ESTADO_LOGICO = 'true'
			]]>
		</entry>
		<entry key="mn.catalogo.asociaciontareareglanegocio">
			<![CDATA[
				select 
				ID_ASOCIACIONTAREAREGLANEGOCIO, ID_TAREA, ID_REGLANEGOCIO,CVE_ESTATUSTAREAREGLANEGOCIO 
				from CGT_ASOCIACIONTAREAREGLANEGOCIO 
				where ESTADO_LOGICO = 'true'
			]]>
		</entry>	
		<entry key="mn.catalogo.salidainfo">
			<![CDATA[
				select 
				ID_SALIDAINFO, CLAVE, DESCRIPCION 
				from CGT_SALIDAINFO 
				where ESTADO_LOGICO = 'true'
			]]>
		</entry>		
		«FOR m : s.modules_ref»
			«FOR e : m.module_ref.elements.filter(Entity)»
		<!-- «e.name.toLowerCase.toFirstUpper» -->	
		<entry key="mn.consulta.«e.name.toLowerCase».id">
			<![CDATA[
				select 
				
				ID_«e.name.toUpperCase»,
				«FOR f : e.entity_fields»
				«f.getAttribute(e)»
				«ENDFOR»
				ESTADO_LOGICO 
				from 
				CGT_«e.name.toUpperCase» 
				where ID_«e.name.toUpperCase»=:id and ESTADO_LOGICO = 'true'
			]]>
		</entry>
		<entry key="mn.consulta.«e.name.toLowerCase».registros">
			<![CDATA[
				select 
				ID_«e.name.toUpperCase»,
				«FOR f : e.entity_fields»
				«f.getAttribute(e)»
				«ENDFOR»
				ESTADO_LOGICO 
				from 
				CGT_«e.name.toUpperCase»
				where 1=1 and ESTADO_LOGICO = 'true'
			]]>
		</entry>
		<entry key="mn.consulta.«e.name.toLowerCase».registros.count">
			<![CDATA[
				select 
				count(1) 
				from CGT_«e.name.toUpperCase»
				where 1=1 and ESTADO_LOGICO = 'true'
			]]>
		</entry>
		<entry key="mn.inserta.«e.name.toLowerCase».db">
			<![CDATA[
				insert into 
				CGT_«e.name.toUpperCase»
				(CLAVE,DESCRIPCION,ESTADO_LOGICO ) 
				values(:clave,:descripcion,:estadoLogico)
			]]>
		</entry>
		<entry key="mn.actualizar.«e.name.toLowerCase»">
			<![CDATA[
				update 
				CGT_«e.name.toUpperCase»
				set 
				«FOR f : e.entity_fields»
				«f.getAttributeUpdate(e)»
				«ENDFOR»
				ESTADO_LOGICO=:estadoLogico 
				where ID_«e.name.toUpperCase»=:id«e.name.toLowerCase.toFirstUpper»
			]]>
		</entry>
		<entry key="mn.eliminar.«e.name.toLowerCase»">
			<![CDATA[
				update 
				CGT_«e.name.toUpperCase»
				set ESTADO_LOGICO=?
				where ID_«e.name.toUpperCase»=?
			]]>
		</entry>
		<entry key="mn.inserta.«e.name.toLowerCase»">
			<![CDATA[
				insert into 
				CGT_«e.name.toUpperCase»
				(
				«FOR f : e.entity_fields»
				«f.getAttribute(e)»
				«ENDFOR»
				ESTADO_LOGICO ) 
				values(
				«FOR f : e.entity_fields»
				«f.getAttributeValues(e)»
				«ENDFOR»
				:estadoLogico)
			]]>
		</entry>		
		<!-- ./«e.name.toLowerCase.toFirstUpper» -->	
			«ENDFOR»
		«ENDFOR»
	
	</properties>
	'''
	
	/* Get Attribute */	
	def dispatch getAttribute(EntityTextField f, Entity t)'''
	«f.name.toUpperCase»,
	'''
	def dispatch getAttribute(EntityLongTextField f, Entity t)'''
    «f.name.toUpperCase»,
	'''
	def dispatch getAttribute(EntityDateField f, Entity t)'''
    «f.name.toUpperCase»,
	'''
	def dispatch getAttribute(EntityDateTimeField f, Entity t)'''
    «f.name.toUpperCase»,
	'''
	def dispatch getAttribute(EntityTimeField f, Entity t)'''
    «f.name.toUpperCase»,
	'''
	def dispatch getAttribute(EntityBooleanField f, Entity t)'''
    «f.name.toUpperCase»,
	'''
	def dispatch getAttribute(EntityImageField f, Entity t)'''
    «f.name.toUpperCase»,
	'''
	def dispatch getAttribute(EntityFileField f, Entity t)'''
    «f.name.toUpperCase»,
	'''
	def dispatch getAttribute(EntityEmailField f, Entity t)'''
    «f.name.toUpperCase»,
	'''
	def dispatch getAttribute(EntityDecimalField f, Entity t)'''
    «f.name.toUpperCase»,
	'''
	def dispatch getAttribute(EntityIntegerField f, Entity t)'''
    «f.name.toUpperCase»,
	'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t)'''
    «f.name.toUpperCase»,
	'''	
	
	def dispatch getAttribute(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipFieldGetSetOne(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipFieldGetSetOne(Enum e, Entity t, String name) ''' 
«name.toUpperCase»,
	'''
	
	def dispatch genRelationshipFieldGetSetOne(Entity e, Entity t, String name) ''' 
«name.toUpperCase»,
	'''	
	
	/* Get Attribute Update*/	
	def dispatch getAttributeUpdate(EntityTextField f, Entity t)'''
	«f.name.toUpperCase»=:«f.name.toLowerCase»,
	'''
	def dispatch getAttributeUpdate(EntityLongTextField f, Entity t)'''
    «f.name.toUpperCase»=:«f.name.toLowerCase»,
	'''
	def dispatch getAttributeUpdate(EntityDateField f, Entity t)'''
    «f.name.toUpperCase»=:«f.name.toLowerCase»,
	'''
	def dispatch getAttributeUpdate(EntityDateTimeField f, Entity t)'''
    «f.name.toUpperCase»=:«f.name.toLowerCase»,
	'''
	def dispatch getAttributeUpdate(EntityTimeField f, Entity t)'''
    «f.name.toUpperCase»=:«f.name.toLowerCase»,
	'''
	def dispatch getAttributeUpdate(EntityBooleanField f, Entity t)'''
    «f.name.toUpperCase»=:«f.name.toLowerCase»,
	'''
	def dispatch getAttributeUpdate(EntityImageField f, Entity t)'''
    «f.name.toUpperCase»=:«f.name.toLowerCase»,
	'''
	def dispatch getAttributeUpdate(EntityFileField f, Entity t)'''
    «f.name.toUpperCase»=:«f.name.toLowerCase»,
	'''
	def dispatch getAttributeUpdate(EntityEmailField f, Entity t)'''
    «f.name.toUpperCase»=:«f.name.toLowerCase»,
	'''
	def dispatch getAttributeUpdate(EntityDecimalField f, Entity t)'''
    «f.name.toUpperCase»=:«f.name.toLowerCase»,
	'''
	def dispatch getAttributeUpdate(EntityIntegerField f, Entity t)'''
    «f.name.toUpperCase»=:«f.name.toLowerCase»,
	'''
	def dispatch getAttributeUpdate(EntityCurrencyField f, Entity t)'''
    «f.name.toUpperCase»=:«f.name.toLowerCase»,
	'''	
	
	def dispatch getAttributeUpdate(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipUpdate(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipUpdate(Enum e, Entity t, String name) '''
	«name.toUpperCase»=:«name.toLowerCase», 
	'''
	
	def dispatch genRelationshipUpdate(Entity e, Entity t, String name) ''' 
«name.toUpperCase»=:«name.toLowerCase», 
	'''	

	/* Get Attribute Values*/	
	def dispatch getAttributeValues(EntityTextField f, Entity t)'''
	:«f.name.toLowerCase»,
	'''
	def dispatch getAttributeValues(EntityLongTextField f, Entity t)'''
    :«f.name.toLowerCase»,
	'''
	def dispatch getAttributeValues(EntityDateField f, Entity t)'''
    :«f.name.toLowerCase»,
	'''
	def dispatch getAttributeValues(EntityDateTimeField f, Entity t)'''
    :«f.name.toLowerCase»,
	'''
	def dispatch getAttributeValues(EntityTimeField f, Entity t)'''
    :«f.name.toLowerCase»,
	'''
	def dispatch getAttributeValues(EntityBooleanField f, Entity t)'''
    :«f.name.toLowerCase»,
	'''
	def dispatch getAttributeValues(EntityImageField f, Entity t)'''
    :«f.name.toLowerCase»,
	'''
	def dispatch getAttributeValues(EntityFileField f, Entity t)'''
    :«f.name.toLowerCase»,
	'''
	def dispatch getAttributeValues(EntityEmailField f, Entity t)'''
    :«f.name.toLowerCase»,
	'''
	def dispatch getAttributeValues(EntityDecimalField f, Entity t)'''
    :«f.name.toLowerCase»,
	'''
	def dispatch getAttributeValues(EntityIntegerField f, Entity t)'''
    :«f.name.toLowerCase»,
	'''
	def dispatch getAttributeValues(EntityCurrencyField f, Entity t)'''
    :«f.name.toLowerCase»,
	'''	
	
	def dispatch getAttributeValues(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipValues(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipValues(Enum e, Entity t, String name) '''
:«name.toLowerCase»,
	'''
	
	def dispatch genRelationshipValues(Entity e, Entity t, String name) ''' 
:«name.toLowerCase»,
	'''		
	
}