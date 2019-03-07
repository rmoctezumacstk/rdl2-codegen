package com.softtek.generator.afore.citibanamex

import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentConstantsGenerator {
	
	def doGenerate(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) {
		fsa.generateFile("banamex/src/main/java/mx/com/aforebanamex/plata/helper/ComponentesGeneralesConstantsHelper.java", genJavaConstants(s, fsa))	
	}
	
	def CharSequence genJavaConstants(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) '''
	/* 
	 * Nombre de la Clase: ComponentesGeneralesConstantsHelper
	 * Numero de version: 1.0
	 * Fecha: 26/12/2018
	 * Copyright:  
	 * 
	 */
	
	package mx.com.aforebanamex.plata.helper;
	
	import mx.com.aforebanamex.plata.model.StatusTypeEnum;
	
	/** Constantes de rutas jsp. */
	public class ComponentesGeneralesConstantsHelper {
	
		private ComponentesGeneralesConstantsHelper() {
	
		}
	
		// Constantes de las rutas de las pantallas del portal.
		public static final String RUTA_HOME = "pages/home";
		public static final String RUTA_SEMAFORO = "pages/semaforo";
		«FOR m : s.modules_ref»
			«FOR e : m.module_ref.elements.filter(Entity)»
		«e.genEntityPages(m.module_ref)»
			«ENDFOR»
		«ENDFOR»
		public static final String RUTA_BUSQUEDA_PROCESOS_ARCHIVOS = "pages/busquedaProcesosArchivos";
		public static final String RUTA_REENVIO_ARCHIVOS = "pages/reenvioArchivos";
		public static final String RUTA_GESTION_ARCHIVOS_RECEPCION = "pages/gestionArchivosRecepcion";
		public static final String RUTA_GESTION_ARCHIVOS_GENERACION = "pages/gestionArchivosGeneracion";
		public static final String RUTA_GESTION_CONTENEDORES = "pages/registroContenedor";
		public static final String RUTA_GESTION_PROCESOS = "pages/registroProceso";
		public static final String RUTA_GESTION_ENV_ARCHIVOS = "pages/envioArchivo";
		public static final String RUTA_GESTION_ARCHIVOS = "pages/registroArchivo";
		public static final String RUTA_NO_AUTORIZADO = "pages/noAutorizado";
		public static final String EXCEL_HELPER = "ExcelHelper";
		public static final String PDF_HELPER = "PdfHelper";
		public static final String DATA_LIST = "dataList";
	
		/* Constantes que envuelven a todas las consultas por paginacion */
		public static final String STR_QUERY = "strQuery";
		public static final String STR_PAGINACION_HDR = "SELECT * FROM (SELECT ROWNUM rn, a.* FROM ( ";
		public static final String STR_PAGINACION_FTR = " ) a WHERE ROWNUM <= ";
		public static final String STR_PAGINACION_PGR = " ) WHERE rn >= ";
	
		/* Constantes de campos de consulta */
		public static final String CAMPO_CUENTA = "CUENTA";
		public static final String CAMPO_ID_ARCHIVO = "idArchivo";
		public static final String CAMPO_ID_SISTEMA = "idSistema";
		public static final String CAMPO_ID_BATCH = "idBatch";
	
		/* Constantes de formato de fecha */
		public static final String FECHA_ANTERIOR = "dd/MM/yyyy";
		public static final String FECHA_NUEVA = "dd/MM/yy";
	
		/* Ruta de archivo properties de consulta */
		public static final String CONSULTAS_PROPERTIES = "classpath:/querys/consultas.properties";
	
		public static final int CONTENEDOR_NOEXISTE = 0;
		public static final int CONTENEDOR_EXISTE = 1;
		public static final int CONTENEDOR_HORA_INICIO_CERCANA = 2;
		
		public static final String IS_ERROR = "isError";
		public static final String MS_OPERACION = "MsgOperacion"; 
		
		public static final int  LONGITUD_CONTENEDOR = 35;
		public static final int  LONGITUD_ARCHIVO_DESCRIPCION = 80;
		public static final int  LONGITUD_SISTEMA = 20;
		
		public static final String SEMAFORO_NOMBRE = " and NOMBRE Like '%";
		public static final String SEMAFORO_NOMBRE_CIERRE = "%'";
		public static final String SEMAFORO_ESTADO_INDICADOR = " and CVE_EDO_INDICADOR = ";
		public static final String SEMAFORO_TIPO_MEDIDA = " and CVE_TIPO_MEDIDA = ";
		public static final String LIMIT = " LIMIT ";
		public static final String COMA = ",";
		«FOR m : s.modules_ref»
			«FOR e : m.module_ref.elements.filter(Entity)»
		«e.genEntity(m.module_ref)»
			«ENDFOR»
		«ENDFOR»
		
		public static String getStatusEspanol (String estatus) {
			
			return estatus.equals(StatusTypeEnum.ACTIVO.getDescription()) ? StatusTypeEnum.ACTIVO.getDescripcion()
					: StatusTypeEnum.INACTIVO.getDescripcion(); 
			
		}
	}

	'''

	def dispatch genEntityPages(Entity e, Module m) '''
		public static final String RUTA_«e.name.toUpperCase» = "pages/«e.name.toLowerCase»";
	'''	
	
	def dispatch genEntity(Entity e, Module m) '''
		public static final String «e.name.toUpperCase»_NOMBRE = " and NOMBRE Like '%";
		public static final String «e.name.toUpperCase»_NOMBRE_CIERRE = "%'";	
	'''	
	
}