package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity
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
import java.util.ArrayList

class CrudComponentOracleGenerator {
	
	var acctables = new ArrayList<String>()
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			acctables.add("-----------------------------------------\n")
			acctables.add("-- Tables generated from module "+m.name +"\n")
			acctables.add("-----------------------------------------\n")
			for (e : m.elements.filter(typeof(Entity))) {
				acctables.add(e.genJavaSql(m).toString())
			}
		}
		var tables=""
		for(t:acctables){
		  tables=tables+t
		}
		fsa.generateFile("banamex/src/main/resources/oraclequeries/script.sql", tables)
	}
	

	def CharSequence genJavaSql(Entity e, Module m) '''
	
	CREATE TABLE cgt_«e.name.toLowerCase»(
	«FOR f : e.entity_fields»
		«f.getAttribute(e)»
	«ENDFOR» 
	cve_«e.name.toLowerCase»_id NUMBER(10) NOT NULL,
	CONSTRAINT cgt_«e.name.toLowerCase»_pk PRIMARY KEY (cve_«e.name.toLowerCase»_id)
	);
				
	'''
	
	/* Get Attribute */
	def dispatch getAttribute(EntityTextField f, Entity t)'''
	«f.name.toLowerCase» VARCHAR2(100) NOT NULL,
	'''
	def dispatch getAttribute(EntityLongTextField f, Entity t)'''
	«f.name.toLowerCase» VARCHAR2(100) NOT NULL,
	'''
	def dispatch getAttribute(EntityDateField f, Entity t)'''
	«f.name.toLowerCase» DATE NOT NULL,
	'''
	def dispatch getAttribute(EntityImageField f, Entity t)'''
	«f.name.toLowerCase» VARCHAR2(100) NOT NULL,
	'''
	def dispatch getAttribute(EntityFileField f, Entity t)'''
	«f.name.toLowerCase» VARCHAR2(100) NOT NULL,
	'''
	def dispatch getAttribute(EntityEmailField f, Entity t)'''
	«f.name.toLowerCase» VARCHAR2(100) NOT NULL,
	'''
	def dispatch getAttribute(EntityDecimalField f, Entity t)'''
	«f.name.toLowerCase» NUMBER(20,2) NOT NULL,
	'''
	def dispatch getAttribute(EntityIntegerField f, Entity t)'''
	«f.name.toLowerCase» NUMBER(20) NOT NULL,
	'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t)'''
	«f.name.toLowerCase» NUMBER(20,2) NOT NULL,
	'''	
	
	def dispatch getAttribute(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('1')»
		«f.superType.genRelationship(t, f.name)»
	«ENDIF»
	'''	
	
	def dispatch genRelationship(Enum e, Entity t, String name) '''
	CONSTRAINT fk_cve_«e.name.toLowerCase»
	FOREIGN KEY (cve_«e.name.toLowerCase»_id) 
	REFERENCES cgt_«e.name.toLowerCase»(cve_«e.name.toLowerCase»_id)
	'''
	
	def dispatch genRelationship(Entity e, Entity t, String name) '''
	CONSTRAINT fk_cve_«e.name.toLowerCase»
	FOREIGN KEY (cve_«e.name.toLowerCase»_id) 
	REFERENCES cgt_«e.name.toLowerCase»(cve_«e.name.toLowerCase»_id)
	'''
	
}