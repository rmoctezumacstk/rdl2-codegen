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

class CrudComponentMensajesESGenerator {
	
	var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def doGenerate(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) {
		fsa.generateFile("banamex/configuracion/src/main/resources/messages/mensajes-mn.properties", generateMessages(s, fsa))	
	}
	
	
	def CharSequence generateMessages(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) '''	
	
	«FOR m : s.modules_ref»
		«FOR e : m.module_ref.elements.filter(Entity)»
	mn.«e.name.toLowerCase».titulo=«e.name.toLowerCase.toFirstUpper»s
	mn.«e.name.toLowerCase».consulta.titulo=Consultar «e.name.toLowerCase.toFirstUpper»
	mn.«e.name.toLowerCase».tabla.titulo=Resultado de la busqueda
	mn.«e.name.toLowerCase».modal.agregar.titulo=Registrar «e.name.toLowerCase.toFirstUpper»
	mn.«e.name.toLowerCase».minimo=M\u00ednimo
	mn.«e.name.toLowerCase».maximo=M\u00e1ximo
	mn.«e.name.toLowerCase».modal.actualizar.titulo=Actualizar «e.name.toLowerCase.toFirstUpper»
	mn.«e.name.toLowerCase».modal.eliminar.titulo=Eliminar «e.name.toLowerCase.toFirstUpper»
	mn.«e.name.toLowerCase».modal.eliminar=Desea eliminar «e.name.toLowerCase.toFirstUpper»?
	«FOR f : e.entity_fields»
	«f.getAttribute(e)»
	«ENDFOR»	
		
	cg.«e.name.toLowerCase».titulo=«e.name.toLowerCase.toFirstUpper»s
	cg.«e.name.toLowerCase».consulta.titulo=Consultar «e.name.toLowerCase.toFirstUpper»
	cg.«e.name.toLowerCase».modal.agregar.titulo=Registrar «e.name.toLowerCase.toFirstUpper»
	cg.«e.name.toLowerCase».minimo=M\u00ednimo
	cg.«e.name.toLowerCase».maximo=M\u00e1ximo
	cg.«e.name.toLowerCase».modal.actualizar.titulo=Actualizar «e.name.toLowerCase.toFirstUpper»
	cg.«e.name.toLowerCase».modal.eliminar.titulo=Eliminar «e.name.toLowerCase.toFirstUpper»
	cg.«e.name.toLowerCase».modal.eliminar=Desea eliminar el «e.name.toLowerCase.toFirstUpper»?
	
	«FOR f : e.entity_fields»
	«f.getAttributeCg(e)»
	«ENDFOR»	
	
	label.«e.name.toLowerCase».busqueda.modulo = Modulo
	label.«e.name.toLowerCase».busqueda.procesos = Proceso
	label.«e.name.toLowerCase».busqueda.subproceso = Subproceso
	
		«ENDFOR»
	«ENDFOR»
	
	
	label.busqueda.seleccionar = Seleccionar
	label.busqueda.limpiar = Limpiar
	label.busqueda.buscar = Buscar
	
	cg.cerrar = Cerrar
	cg.guardar = Guardar
	cg.aceptar = Aceptar
	
	'''
	
	/* Get Attribute */
	def dispatch getAttribute(EntityTextField f, Entity t)'''
	mn.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttribute(EntityLongTextField f, Entity t)'''
	mn.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttribute(EntityDateField f, Entity t)'''
	mn.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttribute(EntityImageField f, Entity t)'''
	mn.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttribute(EntityFileField f, Entity t)'''
	mn.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttribute(EntityEmailField f, Entity t)'''
	mn.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttribute(EntityDecimalField f, Entity t)'''
	mn.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttribute(EntityIntegerField f, Entity t)'''
	mn.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t)'''
	mn.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''	
	def dispatch getAttribute(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
	mn.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	«ENDIF»
	'''	
	
	/* Get Attribute */
	def dispatch getAttributeCg(EntityTextField f, Entity t)'''
	cg.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttributeCg(EntityLongTextField f, Entity t)'''
	cg.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttributeCg(EntityDateField f, Entity t)'''
	cg.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttributeCg(EntityImageField f, Entity t)'''
	cg.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttributeCg(EntityFileField f, Entity t)'''
	cg.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttributeCg(EntityEmailField f, Entity t)'''
	cg.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttributeCg(EntityDecimalField f, Entity t)'''
	cg.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttributeCg(EntityIntegerField f, Entity t)'''
	cg.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''
	def dispatch getAttributeCg(EntityCurrencyField f, Entity t)'''
	cg.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	'''	
	def dispatch getAttributeCg(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
	cg.«t.name.toLowerCase».«f.name.toLowerCase»=«entityFieldUtils.getFieldGlossaryName(f)»
	«ENDIF»
	'''	
}