package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity
import com.softtek.generator.utils.EntityUtils
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.generator.utils.UIFlowUtils
import com.softtek.rdl2.EntityTextField
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.Enum

class CrudComponentMessagesGenerator {
	
	def doGenerate(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) {
		fsa.generateFile("banamex/src/main/resources/messages_es"+ ".properties", genJavaConstants(s, fsa))	
	}
	
	def CharSequence genJavaConstants(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) '''
	#Pagina de logout
	page.path.logout = ../logout
	
	#Etiquetas jsp titulos paginas
	title.consulta.recepcion.envio.archivos = Consultar recepci\u00F3n y env\u00edo de archivos operativos.
	title.consulta.busqueda.archivos = B\u00fasqueda de archivos operativos para reenviar.
	title.gestion.busqueda.archivos = B\u00fasqueda de archivos de recepci\u00F3n.
	
	#Etiquetas jsp titulos formularios 
	label.busqueda.procesos.operativos= B\u00fasqueda de procesos operativos
	label.busqueda.reenvio.archivos= B\u00fasqueda de archivos a reenviar
	label.busqueda.gestion.archivos= B\u00fasqueda de archivos
	
	#Etiquetas jsp titulos tablas de informacion
	label.title.tabla.ejecucionesArchivo = Bit\u00e1cora de ejecuciones del archivo
	label.title.tabla.accionesEjecucion = Bit\u00e1cora de acciones de la ejecuci\u00F3n
	label.title.tabla.incidenciasAccion = Bit\u00e1cora de incidencias de la acci\u00F3n
	label.title.tabla.directorio = Directorio
	label.title.tabla.gestionArchivo = Configurar recepci\u00F3n de archivo
	label.title.tabla.gestionArchivoGen = Configurar generaci\u00F3n de archivo
	label.title.tabla.archivosRecepcion = Archivos de recepci\u00F3n
	label.title.tabla.archivosGeneracion = Archivos de generaci\u00F3n
	
	#Etiquetas jsp campos formularios 
	label.filtro.proceso = Proceso
	label.filtro.identificadorArchivo = Identificador del archivo
	label.filtro.tipoArchivo = Tipo de archivo
	label.filtro.entidadOrigen = Entidad origen
	label.filtro.entidadDestino = Entidad destino
	label.filtro.estadoEjecucion = Estado de ejecuci\u00F3n
	label.filtro.fechaInicioEjecucion = Fecha inicio ejecuci\u00F3n
	label.filtro.fechaFinEjecucion = Fecha fin ejecuci\u00F3n
	label.filtro.fechaLlegada = Fecha de llegada
	
	label.filtro.nombreArchivo = Nombre del archivo
	label.filtro.rutaOrigen = Ruta origen
	label.filtro.rutaDestino = Ruta destino
	label.filtro.validaLayout = Validar layout
	label.filtro.acuseRecibo = Acuse de recibo
	label.filtro.rechazoArchivo = Rechazo Archivo
	label.filtro.tipoTransmision = Tipo de transmisi\u00F3n
	label.filtro.transmisionTexto = Texto
	label.filtro.transmisionBinario = Binario
	
	
	#Etiquetas jsp columnas consulta procesos archivos
	label.tabla.identificadorProceso = Proceso
	label.tabla.identificadorArchivo = Identificador del archivo
	label.tabla.identificadorArchivoRelacionado = Identificador del archivo relacionado
	label.tabla.tipoArchivio = Tipo de archivo
	label.tabla.estadoEjecucion = Estado de ejecuci\u00F3n
	label.tabla.fechaLlegada = Fecha de llegada
	label.tabla.fechaProcesoRecepcion = Fecha proceso de recepci\u00F3n
	label.tabla.fechaInicioEjecucion = Fecha de ejecuci\u00F3n
	label.tabla.horaInicioEjecucion = Hora de ejecuci\u00F3n
	label.tabla.fechaFinEjecucion = Fecha fin ejecuci\u00F3n
	label.tabla.horaFinEjecucion = Hora fin ejecuci\u00F3n
	label.tabla.entidadOrigen = Entidad origen
	label.tabla.entidadDestino = Entidad destino
	label.tabla.totalRechazos = Total de rechazos
	label.tabla.totalIncidencias = Total de incidencias
	label.tabla.acuse = Acuse
	
	
	
	#Etiquetas jsp columnas consulta procesos 
	label.tabla.tipoAccion = Tipo de acci\u00F3n
	label.tabla.numeroRechazos = N\u00famero de rechazos
	label.tabla.numeroIncidencias = N\u00famero de incidencias
	label.tabla.fechaEjecucion = Fecha de ejecuci\u00F3n
	label.tabla.horaEjecucion = Hora de ejecuci\u00F3n
	label.tabla.estadoEjecucionAccion = Estado de ejecuci\u00F3n de la acci\u00F3n
	
	#Etiquetas jsp columnas consulta incidencias
	label.tabla.secuenciaRegistro = Secuencia del registro
	label.tabla.tipoRegistro = Tipo de registro
	label.tabla.valorRegistro = Valor identificador del registro
	label.tabla.secuenciaError = Secuencia del error 
	label.tabla.claveError = Clave del error
	label.tabla.descripcionError = Descripci\u00F3n del error
	label.tabla.datoError = Dato del error
	
	#Etiquetas jsp columnas consulta archivos a reenviar
	label.tabla.selccionar = Seleccionar archivo
	label.tabla.fechaProcesoRecepcion = Fecha de proceso de recepci\u00F3n
	label.tabla.tipoArchivo = Tipo de archivo
	label.tabla.estadoArchivo = Estado del archivo
	label.tabla.estadoReenvio = Estado del reenv\u00edo
	label.tabla.nombreFisicoArchivo = Nombre f\u00edsico del archivo de salida
	label.tabla.tipoRelacionArchivo = Tipo de relaci\u00F3n del archivo
	label.tabla.entidadDestino = Entidad destino
	
	#Etiquetas jsp errores controlados
	label.error.sinFiltros = Proporcionar un criterio de b\u00fasqueda
	label.error.sinResultados = No se encontraron resultados de b\u00fasqueda
	label.error.sinArchivo = Favor de seleccionar un archivo
	label.error.sinRegistros = Favor de seleccionar un registro
	
	#Etiquetas jsp mensaje respuesta
	label.info.archivoReenviado = Se ha actualizado el archivo para su posterior re-env\u00edo
	label.info.yaExisteContenedor = Ya existe este contenedor
	label.info.noExisteContenedor = No existe este contenedor
	label.info.yaExisteProceso = Ya existe este proceso
	label.info.noExisteProceso = No existe este proceso
	label.info.DidfMinutos = Ya existe otro contenedor con horario de inicio menor a 3 minutos de diferencia
	label.info.regExitoso = Registro exitoso
	label.info.actExitoso = Actualizaci\u00F3n Exitosa
	label.info.errBD = Error Inesperado, posiblemente en BD
	
	#Titulos paginas
	title.registro.contenedor = Registrar Contenedor
	title.actualiza.contenedor = Actualizar Contenedor
	#Titulo pantallas
	label.title.registoContenedor=Registrar configuraci&oacute;n de contenedor
	label.title.actualizaContenedor=Actualizar configuraci&oacute;n de contenedor
	
	#Titulo proceso
	title.registro.proceso = Registro proceso
	title.actualiza.proceso = Actualiza proceso
	label.title.registro.proceso = Registrar configuraci\u00F3n de proceso
	label.title.actualiza.proceso = Actualizar configuraci\u00F3n de proceso
	label.info.yaExisteProceso = Ya existe este proceso
	label.info.noExisteProceso = No existe este proceso
	
	#Titulo archivo
	label.info.yaExisteArchivo = Ya existe este archivo
	label.info.noExisteArchivo = No existe este archivo
	
	#Pantalla registro y actualizacion archivo
	title.registro.archivo = Registro archivo
	title.actualiza.archivo = Actualiza archivo
	label.title.registoArchivo = Registrar configuraci\u00F3n de archivo
	label.title.actualizaArchivo = Actualizar configuraci\u00F3n de archivo
	
	#Pantalla registro y actualizacion de envio de archivo
	title.registro.envioArchivo = Registro env\u00edo archivo
	title.actualiza.envioArchivo = Actualiza env\u00edo archivo
	label.title.registoEnvioArchivo = Registrar configuraci\u00F3n env\u00edo archivo
	label.title.actualizaEnvioArchivo = Actualizar configuraci\u00F3n env\u00edo archivo
	label.info.yaExisteEnvArchivo = Ya existe este env\u00edo de archivo
	
	
	#Configuración de la pantalla Semaforo
	label.busqueda.nombre: Nombre del sem\u00e1foro
	label.busqueda.medida: Medida del sem\u00e1foro
	label.busqueda.estado: Estado del sem\u00e1foro
	label.modal.descripcion: Descripci\u00F3n del sem\u00e1foro
	label.modal.minimo: M\u00ednimo
	label.modal.maximo: M\u00e1ximo
	label.busqueda.buscar: Buscar
	label.busqueda.limpiar: Limpiar
	label.form.campo.required: Campo requerido.
	
	label.busqueda.seleccionar: -- Seleccionar --
	span.titulo.tabla: Resultado de la busqueda
	
	boton.semaforo.agregar: Agregar
	boton.semaforo.actualizar: Actualizar
	boton.semaforo.eliminar: Eliminar
	
	title.modal.new: Registrar sem\u00e1foro
	title.modal.edit: Actualizar sem\u00e1foro
	title.modal.delete: Eliminar sem\u00e1foro
	
	label.modal.delete.message: Desea eliminar el Sem\u00e1foro?
	
	«FOR m : s.modules_ref»
		«FOR e : m.module_ref.elements.filter(Entity)»
		«e.genEntity(m.module_ref)»
		«ENDFOR»
	«ENDFOR»
		
	'''
	
	def dispatch genEntity(Entity e, Module m) '''
	
	#Configuración de la pantalla «e.name.toLowerCase.toFirstUpper»
	«FOR f : e.entity_fields»
	«f.getAttribute(e)»
	«ENDFOR» 
	
	label.«e.name.toLowerCase».modal.descripcion: Descripci\u00F3n del «e.name.toLowerCase»
	label.«e.name.toLowerCase».modal.minimo: M\u00ednimo
	label.«e.name.toLowerCase».modal.maximo: M\u00e1ximo
	label.«e.name.toLowerCase».busqueda.buscar: Buscar
	label.«e.name.toLowerCase».busqueda.limpiar: Limpiar
	label.«e.name.toLowerCase».form.campo.required: Campo requerido.
	
	boton.«e.name.toLowerCase».agregar: Agregar
	boton.«e.name.toLowerCase».actualizar: Actualizar
	boton.«e.name.toLowerCase».eliminar: Eliminar
	
	title.«e.name.toLowerCase».modal.new: Registrar «e.name.toLowerCase.toFirstUpper»
	title.«e.name.toLowerCase».modal.edit: Actualizar «e.name.toLowerCase.toFirstUpper»
	title.«e.name.toLowerCase».modal.delete: Eliminar «e.name.toLowerCase.toFirstUpper»
	
	label.«e.name.toLowerCase».modal.delete.message: Desea eliminar el «e.name.toLowerCase.toFirstUpper»
	'''	
	
	/* Attribute */
	def dispatch getAttribute(EntityTextField f, Entity t)'''
	label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»: «f.name.toLowerCase.toFirstUpper» del «t.name.toLowerCase»
	'''
	def dispatch getAttribute(EntityLongTextField f, Entity t)'''
	label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»: «f.name.toLowerCase.toFirstUpper» del «t.name.toLowerCase»
	'''
	def dispatch getAttribute(EntityDateField f, Entity t)'''
	label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»: «f.name.toLowerCase.toFirstUpper» del «t.name.toLowerCase»
	'''
	def dispatch getAttribute(EntityImageField f, Entity t)'''
	label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»: «f.name.toLowerCase.toFirstUpper» del «t.name.toLowerCase»
	'''
	def dispatch getAttribute(EntityFileField f, Entity t)'''
	label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»: «f.name.toLowerCase.toFirstUpper» del «t.name.toLowerCase»
	'''
	def dispatch getAttribute(EntityEmailField f, Entity t)'''
	label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»: «f.name.toLowerCase.toFirstUpper» del «t.name.toLowerCase»
	'''
	def dispatch getAttribute(EntityDecimalField f, Entity t)'''
	label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»: «f.name.toLowerCase.toFirstUpper» del «t.name.toLowerCase»
	'''
	def dispatch getAttribute(EntityIntegerField f, Entity t)'''
	label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»: «f.name.toLowerCase.toFirstUpper» del «t.name.toLowerCase»
	'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t)'''
	label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»: «f.name.toLowerCase.toFirstUpper» del «t.name.toLowerCase»
	'''	
	
	def dispatch getAttribute(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationship(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationship(Enum e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''
	
	def dispatch genRelationship(Entity e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''
}