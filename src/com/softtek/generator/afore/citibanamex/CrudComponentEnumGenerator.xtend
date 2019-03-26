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
import com.softtek.rdl2.EnumLiteral

class CrudComponentEnumGenerator {
	
	var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	var count = 0;
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Enum))) {
				fsa.generateFile("banamex/common/src/main/java/com/aforebanamex/plata/comunes/model/cg/" + e.name.toLowerCase.toFirstUpper + "Enum.java", e.genEnumModel(m))
			}
		}
	}
	
	def CharSequence genEnumModel(Enum e, Module m) '''
	package com.aforebanamex.plata.comunes.model.cg;
	
	public enum «e.name.toLowerCase.toFirstUpper»Enum {
	«FOR l : e.enum_literals SEPARATOR ","»«l.key.toLowerCase»(«genCount(l)»,"«l.value.toLowerCase»")«ENDFOR»;
	
	private int cve«e.name.toLowerCase.toFirstUpper»;
	private String descripcion;
	
	private «e.name.toLowerCase.toFirstUpper»Enum(int cve«e.name.toLowerCase.toFirstUpper», String descripcion) {
		this.cve«e.name.toLowerCase.toFirstUpper» = cve«e.name.toLowerCase.toFirstUpper»;
		this.descripcion = descripcion;
	}
	
	public int getcve«e.name.toLowerCase.toFirstUpper»() {
		return cve«e.name.toLowerCase.toFirstUpper»;
	}

	public void setcve«e.name.toLowerCase.toFirstUpper»(int cve«e.name.toLowerCase.toFirstUpper») {
		this.cve«e.name.toLowerCase.toFirstUpper» = cve«e.name.toLowerCase.toFirstUpper»;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public static Integer getCveDescripcion(String descripcion) {
        for («e.name.toLowerCase.toFirstUpper»Enum «e.name.toLowerCase.toFirstUpper»Enum : «e.name.toLowerCase.toFirstUpper»Enum.values()) {
            if («e.name.toLowerCase.toFirstUpper»Enum.getDescripcion().equals(descripcion)) {
                return «e.name.toLowerCase.toFirstUpper»Enum.getcve«e.name.toLowerCase.toFirstUpper»();
            }
        }
        return null;
    }
	
	public static String getDescripcionCve(int cve«e.name.toLowerCase.toFirstUpper») {
        for («e.name.toLowerCase.toFirstUpper»Enum «e.name.toLowerCase.toFirstUpper»Enum : «e.name.toLowerCase.toFirstUpper»Enum.values()) {
            if («e.name.toLowerCase.toFirstUpper»Enum.getcve«e.name.toLowerCase.toFirstUpper»() == cve«e.name.toLowerCase.toFirstUpper») {
                return «e.name.toLowerCase.toFirstUpper»Enum.getDescripcion();
            }
        }
        return null;
    }
    
    }
	
	'''
	
	def dispatch genCount(EnumLiteral e){
		count += 1;
		
		return count;
	}
	
}