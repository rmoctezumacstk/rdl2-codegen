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

class CrudComponentMNConstantsHelperGenerator {
	
	var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def doGenerate(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) {
		fsa.generateFile("banamex/configuracion/src/main/java/com/aforebanamex/plata/configuracion/helper/mn/MNConstantesHelper.java", generateHelper(s, fsa))	
	}
	
	
	def CharSequence generateHelper(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) '''	
	package com.aforebanamex.plata.configuracion.helper.mn;
	
	public class MNConstantesHelper {
		public MNConstantesHelper() {}
		
		«FOR m : s.modules_ref»
			«FOR e : m.module_ref.elements.filter(Entity)»
		«e.genEntity(m.module_ref)»
			«ENDFOR»
		«ENDFOR»

		
	}
	
	'''
	
	def dispatch genEntity(Entity e, Module m) '''
		public static final String PAGINA_«e.name.toUpperCase» 		= "mn/«e.name.toLowerCase»";
		public static final String URL_PAGINA_«e.name.toUpperCase» 	= "/s«e.name.toLowerCase»";
	'''	
	
	
}