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
import com.softtek.rdl2.EntityDateTimeField
import com.softtek.rdl2.EntityTimeField
import com.softtek.rdl2.EntityBooleanField

class CrudComponentMapperGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/mn/src/main/java/com/aforebanamex/plata/cg/mn/repository/impl/" + e.name.toLowerCase.toFirstUpper + "Mapper.java", e.genJavaMapperImpl(m))
			}
		}
	}
	
	def CharSequence genJavaMapperImpl(Entity e, Module m) '''
	package com.aforebanamex.plata.cg.mn.repository.impl;
	
	import java.sql.ResultSet;
	import java.sql.SQLException;
	
	import org.springframework.jdbc.core.RowMapper;
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;
	«FOR f : e.entity_fields»
	«f.getAttributeImport(e)»
	«ENDFOR» 
	
	public class «e.name.toLowerCase.toFirstUpper»Mapper implements RowMapper< «e.name.toLowerCase.toFirstUpper» > {
	
	        @Override
	        public «e.name.toLowerCase.toFirstUpper» mapRow(ResultSet rs, int rowNum) throws SQLException {
	
	            «e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = new «e.name.toLowerCase.toFirstUpper»();
	            «e.name.toLowerCase».setId«e.name.toLowerCase.toFirstUpper»(rs.getInt("ID_«e.name.toUpperCase»"));
        		«FOR f : e.entity_fields»
        		«f.getAttribute(e)»
        		«ENDFOR» 
        		«e.name.toLowerCase».setEstadoLogico(rs.getBoolean("ESTADO_LOGICO"));
	            return «e.name.toLowerCase»;
	
	        }
	}
	'''	
	
	def dispatch getAttribute(EntityTextField f, Entity t)'''«t.name.toLowerCase».set«f.name.toLowerCase.toFirstUpper»(rs.getString("«f.name.toUpperCase»"));'''
	def dispatch getAttribute(EntityLongTextField f, Entity t)'''«t.name.toLowerCase».set«f.name.toLowerCase.toFirstUpper»(rs.getString("«f.name.toUpperCase»"));'''
	def dispatch getAttribute(EntityDateField f, Entity t)'''«t.name.toLowerCase».set«f.name.toLowerCase.toFirstUpper»(rs.getDate("«f.name.toUpperCase»"));'''
	def dispatch getAttribute(EntityDateTimeField f, Entity t)'''«t.name.toLowerCase».set«f.name.toLowerCase.toFirstUpper»(rs.getDate("«f.name.toUpperCase»"));'''
	def dispatch getAttribute(EntityTimeField f, Entity t)'''«t.name.toLowerCase».set«f.name.toLowerCase.toFirstUpper»(rs.getDate("«f.name.toUpperCase»"));'''
	def dispatch getAttribute(EntityBooleanField f, Entity t)'''«t.name.toLowerCase».set«f.name.toLowerCase.toFirstUpper»(rs.getBoolean("«f.name.toUpperCase»"));'''
	def dispatch getAttribute(EntityImageField f, Entity t)'''«t.name.toLowerCase».set«f.name.toLowerCase.toFirstUpper»(rs.getString("«f.name.toUpperCase»"));'''
	def dispatch getAttribute(EntityFileField f, Entity t)'''«t.name.toLowerCase».set«f.name.toLowerCase.toFirstUpper»(rs.getString("«f.name.toUpperCase»"));'''
	def dispatch getAttribute(EntityEmailField f, Entity t)'''«t.name.toLowerCase».set«f.name.toLowerCase.toFirstUpper»(rs.getString("«f.name.toUpperCase»"));'''
	def dispatch getAttribute(EntityDecimalField f, Entity t)'''«t.name.toLowerCase».set«f.name.toLowerCase.toFirstUpper»(rs.getDouble("«f.name.toUpperCase»"));'''
	def dispatch getAttribute(EntityIntegerField f, Entity t)'''«t.name.toLowerCase».set«f.name.toLowerCase.toFirstUpper»(rs.getInt("«f.name.toUpperCase»"));'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t)'''«t.name.toLowerCase».set«f.name.toLowerCase.toFirstUpper»(rs.getDouble("«f.name.toUpperCase»"));'''	
	
	def dispatch getAttribute(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipFieldGetSetOne(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipFieldGetSetOne(Enum e, Entity t, String name) ''' 
    «e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = new «e.name.toLowerCase.toFirstUpper»();
    «e.name.toLowerCase».setCve«e.name.toLowerCase.toFirstUpper»(rs.getLong("CVE_«e.name.toUpperCase»"));
    «e.name.toLowerCase».setDescripcion(«e.name.toLowerCase.toFirstUpper»Enum.getDescripcionCve(rs.getInt("CVE_«e.name.toUpperCase»")));
    «t.name.toLowerCase».set«name.toLowerCase.toFirstUpper»(«e.name.toLowerCase»);
	'''
	
	def dispatch genRelationshipFieldGetSetOne(Entity e, Entity t, String name) ''' 
	«e.name.toLowerCase.toFirstUpper» «name.toLowerCase» = new «e.name.toLowerCase.toFirstUpper»();
	«name.toLowerCase».setId«e.name.toLowerCase.toFirstUpper»(rs.getInt("ID_«e.name.toUpperCase»"));
	«t.name.toLowerCase».set«name.toLowerCase.toFirstUpper»(«name.toLowerCase»);
	'''
	
	def dispatch getAttributeImport(EntityTextField f, Entity t)''''''
	def dispatch getAttributeImport(EntityLongTextField f, Entity t)''''''
	def dispatch getAttributeImport(EntityDateField f, Entity t)''''''
	def dispatch getAttributeImport(EntityDateTimeField f, Entity t)''''''
	def dispatch getAttributeImport(EntityTimeField f, Entity t)''''''
	def dispatch getAttributeImport(EntityBooleanField f, Entity t)''''''
	def dispatch getAttributeImport(EntityImageField f, Entity t)''''''
	def dispatch getAttributeImport(EntityFileField f, Entity t)''''''
	def dispatch getAttributeImport(EntityEmailField f, Entity t)''''''
	def dispatch getAttributeImport(EntityDecimalField f, Entity t)''''''
	def dispatch getAttributeImport(EntityIntegerField f, Entity t)''''''
	def dispatch getAttributeImport(EntityCurrencyField f, Entity t)''''''	
	
	def dispatch getAttributeImport(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipFieldGetSetOneImport(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipFieldGetSetOneImport(Enum e, Entity t, String name) ''' 	
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»Enum;
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;
	'''
	
	def dispatch genRelationshipFieldGetSetOneImport(Entity e, Entity t, String name) ''' 
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;
	'''
	
}