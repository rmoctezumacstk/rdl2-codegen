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

class CrudComponentModelEnumGenerator {
	
	var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Enum))) {
				fsa.generateFile("banamex/common/src/main/java/com/aforebanamex/plata/comunes/model/cg/" + e.name.toLowerCase.toFirstUpper + ".java", e.genEnumModel(m))
			}
		}
	}
	
	def CharSequence genEnumModel(Enum e, Module m) '''
	package com.aforebanamex.plata.comunes.model.cg;
	
	import javax.validation.constraints.Digits;
	import javax.validation.constraints.Size;
	
	import com.aforebanamex.plata.base.model.BaseSerizalizableModel;
	
	public class «e.name.toLowerCase.toFirstUpper» extends BaseSerizalizableModel{
	
		private static final long serialVersionUID = 1L;
		
		@Digits(integer=2, fraction=0, message="El cve«e.name.toLowerCase.toFirstUpper» es incorrecto.")
		private Long cve«e.name.toLowerCase.toFirstUpper»;
		@Size(min=0,max=99, message="El descripcion es incorrecto.")
		private String descripcion;
		
		public «e.name.toLowerCase.toFirstUpper»(){}
		
		public «e.name.toLowerCase.toFirstUpper»(Long cve«e.name.toLowerCase.toFirstUpper», String descripcion) {
			super();
			this.cve«e.name.toLowerCase.toFirstUpper» = cve«e.name.toLowerCase.toFirstUpper»;
			this.descripcion = descripcion;
		}
	
		public Long getCve«e.name.toLowerCase.toFirstUpper»() {
			return cve«e.name.toLowerCase.toFirstUpper»;
		}
	
		public void setCve«e.name.toLowerCase.toFirstUpper»(Long cve«e.name.toLowerCase.toFirstUpper») {
			this.cve«e.name.toLowerCase.toFirstUpper» = cve«e.name.toLowerCase.toFirstUpper»;
		}
	
		public String getDescripcion() {
			return descripcion;
		}
	
		public void setDescripcion(String descripcion) {
			this.descripcion = descripcion;
		}
	}	
	
	'''
	
}