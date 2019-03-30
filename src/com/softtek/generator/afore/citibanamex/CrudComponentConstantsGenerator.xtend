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
import com.softtek.rdl2.EntityDateTimeField
import com.softtek.rdl2.EntityTimeField
import com.softtek.rdl2.EntityBooleanField
import com.softtek.rdl2.ModuleRef
import com.softtek.generator.utils.EntityFieldUtils

class CrudComponentConstantsGenerator {
	
	var entityFieldUtils = new EntityFieldUtils
	
	def doGenerate(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) {
		for (m : s.modules_ref)
	      fsa.generateFile("banamex/"+m.module_ref.name.toLowerCase+"/src/main/java/com/aforebanamex/plata/cg/"+ m.module_ref.name.toLowerCase +"/helper/ComponentesGeneralesConstantsHelper.java", genJavaConstants(m, fsa))	
	    
	}
	
	 
	def CharSequence genJavaConstants(ModuleRef m, IFileSystemAccess2 fsa) '''
	/* 
	 * Nombre de la Clase: ComponentesGeneralesConstantsHelper
	 * Numero de version: 1.0
	 * Fecha: 26/12/2018
	 * Copyright:  
	 * 
	 */
	
	package com.aforebanamex.plata.cg.mn.helper; 
	
	/** Constantes de rutas jsp. */
	public class ComponentesGeneralesConstantsHelper {
	
		    private ComponentesGeneralesConstantsHelper() {
	 
	        }
	
			«FOR e : m.module_ref.elements.filter(Entity)»
			  «e.genEntity(m.module_ref)»
			«ENDFOR»
		
		    public static final String LIMIT = " LIMIT ";
		    public static final String COMA = ",";
			public static final String NO_ELIMINADO = " AND CVE_EDO_INDICADOR <> 4";	
			public static final int CODIGO_ERROR = 415;
			public static final int CODIGO_EXITO = 200;
			public static final String ERROR_REGISTRO_DUPLICADO = " Ya existe un registro con las mismas características.";
			public static final String EXITO_REGISTRO = " Se realizo el registro de forma correcta.";
			public static final String EXITO_ACTUALIZA_REGISTRO = " Se actalizo el registro de forma correcta.";
			public static final String EXITO_ELIMINADO_REGISTRO = " Se elimino el registro de forma correcta.";
			public static final String ERROR_ELIMINADO_REGISTRO ="Registro con las mismas características se encuentra con estado eliminado.";
			public static final String ERROR_CARACTERES_NO_VALIDOS ="No se permiten los caracteres [']";
			 	
	}
	'''
	
	def dispatch genEntity(Entity e, Module m) '''
		«FOR f : e.entity_fields»
			«f.getAttribute(e)»
		«ENDFOR»
	'''	
	
	/* getAttributeValue */
	def dispatch getAttribute(EntityTextField f, Entity t)'''
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» Like '%";
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE = "%'";
	'''
	def dispatch getAttribute(EntityLongTextField f, Entity t)'''
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» Like '%";
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE = "%'";	
	'''
	def dispatch getAttribute(EntityDateField f, Entity t)'''
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» Like '%";
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE = "%'";	
	'''
	def dispatch getAttribute(EntityDateTimeField f, Entity t)'''
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» Like '%";
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE = "%'";	
	'''
	def dispatch getAttribute(EntityTimeField f, Entity t)'''
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» Like '%";
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE = "%'";	
	'''
	def dispatch getAttribute(EntityBooleanField f, Entity t)'''
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» Like '%";
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE = "%'";	
	'''
	def dispatch getAttribute(EntityImageField f, Entity t)'''
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» Like '%";
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE = "%'";	
	'''
	def dispatch getAttribute(EntityFileField f, Entity t)'''
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» Like '%";
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE = "%'";	
	'''
	def dispatch getAttribute(EntityEmailField f, Entity t)'''
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» Like '%";
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE = "%'";	
	'''
	def dispatch getAttribute(EntityDecimalField f, Entity t)'''
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» Like '%";
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE = "%'";	
	'''
	def dispatch getAttribute(EntityIntegerField f, Entity t)'''
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» Like '%";
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE = "%'";	
	'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t)'''
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» Like '%";
	   public static final String «t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE = "%'";	
	'''	
	
	def dispatch getAttributeEntityRefValue(Entity tr, EntityReferenceField f, Entity t, String name)'''
	   public static final String «t.name.toUpperCase»_«tr.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» =";
	'''
 	def dispatch getAttributeEntityRefValue(Enum tr, EntityReferenceField f, Entity t, String name)'''
	   public static final String «t.name.toUpperCase»_«tr.name.toUpperCase» = " and «entityFieldUtils.getFieldDbMap(f).toUpperCase» =";
	'''
	def dispatch getAttribute(EntityReferenceField f, Entity t)'''
		«IF  f !== null && !f.upperBound.equals('*')»
			«f.superType.getAttributeEntityRefValue(f, t, f.name)»
		«ENDIF»
	'''	
	
}