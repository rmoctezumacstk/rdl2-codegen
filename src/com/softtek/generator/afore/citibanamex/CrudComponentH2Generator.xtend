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

class CrudComponentH2Generator {
	
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
		fsa.generateFile("banamex/src/main/resources/h2querys/script.sql", tables)
	}
	

	def CharSequence genJavaSql(Entity e, Module m) '''
	
	create table CGT_«e.name.toUpperCase»(
	«FOR f : e.entity_fields»
		«f.getAttribute(e)»
	«ENDFOR» 
	ENABLED boolean not null,
	CVE_«e.name.toUpperCase» int(2) auto_increment,
	primary key(CVE_«e.name.toUpperCase»)
	);
				
	'''
	
	/* Get Attribute */
	def dispatch getAttribute(EntityTextField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null,
	'''
	def dispatch getAttribute(EntityLongTextField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null,
	'''
	def dispatch getAttribute(EntityDateField f, Entity t)'''
	«f.name.toUpperCase» date(100) not null,
	'''
	def dispatch getAttribute(EntityImageField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null,
	'''
	def dispatch getAttribute(EntityFileField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null,
	'''
	def dispatch getAttribute(EntityEmailField f, Entity t)'''
	«f.name.toUpperCase» varchar(100) not null,
	'''
	def dispatch getAttribute(EntityDecimalField f, Entity t)'''
	«f.name.toUpperCase» double not null,
	'''
	def dispatch getAttribute(EntityIntegerField f, Entity t)'''
	«f.name.toUpperCase» int not null,
	'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t)'''
	«f.name.toUpperCase» decimal(20,2) not null,
	'''	
	
	def dispatch getAttribute(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('1')»
		«f.superType.genRelationship(t, f.name)»
	«ENDIF»
	'''	
	
	def dispatch genRelationship(Enum e, Entity t, String name) '''
	CVE_«e.name.toUpperCase» int(2),
	foreign key (CVE_«e.name.toUpperCase») references CGT_«e.name.toUpperCase»(CVE_«e.name.toUpperCase»),
	'''
	
	def dispatch genRelationship(Entity e, Entity t, String name) '''
	CVE_«e.name.toUpperCase» int(2),
	foreign key (CVE_«e.name.toUpperCase») references CGT_«e.name.toUpperCase»(CVE_«e.name.toUpperCase»),
	'''
	
}