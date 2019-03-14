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

class CrudComponentRepositoryImplGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/mx/com/aforebanamex/plata/integration/impl/" + e.name.toLowerCase.toFirstUpper + "RepositoryImpl.java", e.genJavaRepositoryImpl(m))
			}
		}
	}
	
	def CharSequence genJavaRepositoryImpl(Entity e, Module m) '''
	package mx.com.aforebanamex.plata.integration.impl;
	
	import java.sql.PreparedStatement;
	import java.util.HashMap;
	import java.util.List;
	import java.util.Map;
	
	import org.springframework.jdbc.support.GeneratedKeyHolder;
	import org.springframework.jdbc.support.KeyHolder;
	import org.springframework.stereotype.Repository;
	
	import mx.com.aforebanamex.plata.base.integration.BaseJdbcH2Repository;
	import mx.com.aforebanamex.plata.helper.ComponentesGeneralesConstantsHelper;
	import mx.com.aforebanamex.plata.helper.PaginadoHelper«e.name.toLowerCase.toFirstUpper»;
	import mx.com.aforebanamex.plata.integration.«e.name.toLowerCase.toFirstUpper»Repository;
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»;
	//import mx.com.aforebanamex.plata.model.Valor«e.name.toLowerCase.toFirstUpper»;
	
	«FOR f : e.entity_fields»
		«f.getAttributeImport(e)»
	«ENDFOR»	
	
	@Repository
	public class «e.name.toLowerCase.toFirstUpper»RepositoryImpl extends BaseJdbcH2Repository implements «e.name.toLowerCase.toFirstUpper»Repository {
	
		public «e.name.toLowerCase.toFirstUpper» obtener«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("id", «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»());
			«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»Response = namedParameterJdbcTemplate.queryForObject(
					obtenerConsulta("«e.name.toLowerCase».consulta.id"), params,
					new «e.name.toLowerCase.toFirstUpper»Mapper());
			// TODO Dependencias				
			return «e.name.toLowerCase»Response;
	
		}
	
		public int agregar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
			KeyHolder keyHolder = new GeneratedKeyHolder();
	
			jdbcTemplate.update(connection -> {
				PreparedStatement ps = connection.prepareStatement(
						obtenerConsulta("«e.name.toLowerCase».insertar"));
						
				«e.name.toLowerCase».setEstadoLogico(true);
						
				«FOR f : e.entity_fields»
					«f.getAttribute(e, 0)»
				«ENDFOR»
				ps.setBoolean(0, «e.name.toLowerCase».getEstadoLogico());		
				return ps;
			}, keyHolder);
			Long key = (long) keyHolder.getKey();
			// TODO Dependencias
			logger.info("RESGISTRO INSERTADO: " + key.intValue());
			return key.intValue();
		}
	
		public int eliminar«e.name.toLowerCase.toFirstUpper»(int id) {
			//jdbcTemplate.update(obtenerConsulta("«e.name.toLowerCase».valor.eliminar"), new Object[] { id });
			return jdbcTemplate.update(obtenerConsulta("«e.name.toLowerCase».eiminar"), new Object[] { id });
		}
	
		@Override
		public int actualizar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
			KeyHolder keyHolder = new GeneratedKeyHolder();
			jdbcTemplate.update(connection -> {
				PreparedStatement ps = connection.prepareStatement(
						obtenerConsulta("«e.name.toLowerCase».actualizar"));
				
				«e.name.toLowerCase».setEstadoLogico(true);					
				«FOR f : e.entity_fields»
				«f.getAttribute(e, 0)»
				«ENDFOR»
				ps.setBoolean(0, «e.name.toLowerCase».getEstadoLogico());	
				ps.setInt(1, «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»());
				// TODO dependencias
				return ps;
			}, keyHolder);
			return «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»();
		}
		
		public PaginadoHelper«e.name.toLowerCase.toFirstUpper» obtener«e.name.toLowerCase.toFirstUpper»s(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase», Integer valorMinimo, Integer valorMaximo) {
			
			PaginadoHelper«e.name.toLowerCase.toFirstUpper» paginadoHelper«e.name.toLowerCase.toFirstUpper» = new PaginadoHelper«e.name.toLowerCase.toFirstUpper»();
			String condicion = "";
			
			«FOR f : e.entity_fields»
			«f.getAttributeCondicion(e)»
			«ENDFOR»			
			
			int total = jdbcTemplate.queryForObject(obtenerConsulta("«e.name.toLowerCase».consulta.registros") + condicion, new Object[]{}, (rs, rowNum) -> rs.getInt(1));
			
			List<«e.name.toLowerCase.toFirstUpper»> «e.name.toLowerCase»s = jdbcTemplate.query(obtenerConsulta("«e.name.toLowerCase».consulta.todos") + condicion + ComponentesGeneralesConstantsHelper.LIMIT + valorMinimo + ComponentesGeneralesConstantsHelper.COMA + valorMaximo,
					new Object[] {}, new «e.name.toLowerCase.toFirstUpper»Mapper());
					
			«FOR f : e.entity_fields»
			«f.getAttributeColumn(e)»
			«ENDFOR»					
							
			paginadoHelper«e.name.toLowerCase.toFirstUpper».setTotalRegistros(total);
			paginadoHelper«e.name.toLowerCase.toFirstUpper».setPayload(«e.name.toLowerCase»s);;
			
			return paginadoHelper«e.name.toLowerCase.toFirstUpper»;
		}
	}
	'''
	
	/* Get Attribute */
	def dispatch getAttribute(EntityTextField f, Entity t, int counter)'''
	ps.setString(«counter», «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());
	'''
	def dispatch getAttribute(EntityLongTextField f, Entity t, int counter)'''
	ps.setString(«counter», «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());
	'''
	def dispatch getAttribute(EntityDateField f, Entity t, int counter)'''
	ps.setDate(«counter», «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());
	'''
	def dispatch getAttribute(EntityImageField f, Entity t, int counter)'''
	ps.setString(«counter», «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());
	'''
	def dispatch getAttribute(EntityFileField f, Entity t, int counter)'''
	ps.setString(«counter», «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());
	'''
	def dispatch getAttribute(EntityEmailField f, Entity t, int counter)'''
	ps.setString(«counter», «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());
	'''
	def dispatch getAttribute(EntityDecimalField f, Entity t, int counter)'''
	ps.setDouble(«counter», «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());
	'''
	def dispatch getAttribute(EntityIntegerField f, Entity t, int counter)'''
	ps.setInt(«counter», «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());
	'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t, int counter)'''
	ps.setDouble(«counter», «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());
	'''	
	
	def dispatch getAttribute(EntityReferenceField f, Entity t, int counter)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipSearch(t, f.name)»
	«ENDIF»
	'''	
	
	def dispatch genRelationshipSearch(Enum e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''
	
	def dispatch genRelationshipSearch(Entity e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''		
	
	/* Get Attribute Condicion */
	def dispatch getAttributeCondicion(EntityTextField f, Entity t)'''
	if (!«t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»().equals("")) {
		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase» + «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE;
	}	
	'''
	def dispatch getAttributeCondicion(EntityLongTextField f, Entity t)'''
	if (!«t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»().equals("")) {
		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase» + «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE;
	}	
	'''
	def dispatch getAttributeCondicion(EntityDateField f, Entity t)'''
	if (!«t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»().equals("")) {
		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase» + «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE;
	}	
	'''
	def dispatch getAttributeCondicion(EntityImageField f, Entity t)'''
	if (!«t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»().equals("")) {
		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase» + «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE;
	}	
	'''
	def dispatch getAttributeCondicion(EntityFileField f, Entity t)'''
	if (!«t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»().equals("")) {
		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase» + «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE;
	}	
	'''
	def dispatch getAttributeCondicion(EntityEmailField f, Entity t)'''
	if (!«t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»().equals("")) {
		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase» + «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE;
	}	
	'''
	def dispatch getAttributeCondicion(EntityDecimalField f, Entity t)'''
	if (!«t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»().equals("")) {
		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase» + «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE;
	}	
	'''
	def dispatch getAttributeCondicion(EntityIntegerField f, Entity t)'''
	if (!«t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»().equals("")) {
		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase» + «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE;
	}	
	'''
	def dispatch getAttributeCondicion(EntityCurrencyField f, Entity t)'''
	if (!«t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»().equals("")) {
		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase» + «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE;
	}	
	'''	
	
	def dispatch getAttributeCondicion(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipSearchCondicion(t, f.name)»
	«ENDIF»
	'''	
	
	def dispatch genRelationshipSearchCondicion(Enum e, Entity t, String name) ''' 

	'''
	
	def dispatch genRelationshipSearchCondicion(Entity e, Entity t, String name) ''' 
	if (!«t.name.toLowerCase».get«e.name.toLowerCase.toFirstUpper»().getId«e.name.toLowerCase.toFirstUpper»().equals(0)) {
		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«e.name.toUpperCase» + «t.name.toLowerCase».get«e.name.toLowerCase.toFirstUpper»().getId«e.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«e.name.toUpperCase»_CIERRE;
	}	
	'''	
	
	/* getAttributeColumn */
	def dispatch getAttributeColumn(EntityTextField f, Entity t)'''

	'''
	def dispatch getAttributeColumn(EntityLongTextField f, Entity t)'''
	
	'''
	def dispatch getAttributeColumn(EntityDateField f, Entity t)'''
	
	'''
	def dispatch getAttributeColumn(EntityImageField f, Entity t)'''
	
	'''
	def dispatch getAttributeColumn(EntityFileField f, Entity t)'''
	
	'''
	def dispatch getAttributeColumn(EntityEmailField f, Entity t)'''
	
	'''
	def dispatch getAttributeColumn(EntityDecimalField f, Entity t)'''
	
	'''
	def dispatch getAttributeColumn(EntityIntegerField f, Entity t)'''
	
	'''
	def dispatch getAttributeColumn(EntityCurrencyField f, Entity t)'''
	
	'''	
	
	def dispatch getAttributeColumn(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeRefColumn(t, f.name)»
	«ENDIF»
	'''	
	
	def dispatch getAttributeRefColumn(Enum e, Entity t, String name) ''' 

	'''
	
	def dispatch getAttributeRefColumn(Entity e, Entity t, String name) ''' 
	if («t.name.toLowerCase»s.size() > 0) {
		for («t.name.toLowerCase.toFirstUpper» mod : «t.name.toLowerCase»s) {
			
			int id =  mod.get«name.toLowerCase.toFirstUpper»().getId«name.toLowerCase.toFirstUpper»();
			
			List<«name.toLowerCase.toFirstUpper»> «name.toLowerCase»s = jdbcTemplate.query(
					obtenerConsulta("«t.name.toLowerCase».«name.toLowerCase».consulta.id"), new Object[] {id},
					new «name.toLowerCase.toFirstUpper»Mapper());
			
			mod.set«name.toLowerCase.toFirstUpper»(«name.toLowerCase»s.get(0));
		}
	}	
	'''	
	
	/* getAttributeImport */
	def dispatch getAttributeImport(EntityTextField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityLongTextField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityDateField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityImageField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityFileField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityEmailField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityDecimalField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityIntegerField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityCurrencyField f, Entity t)'''
	'''	
	
	def dispatch getAttributeImport(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeRefImport(t, f.name)»
	«ENDIF»
	'''	
	
	def dispatch getAttributeRefImport(Enum e, Entity t, String name) ''' 
	'''
	
	def dispatch getAttributeRefImport(Entity e, Entity t, String name) ''' 
	import mx.com.aforebanamex.plata.model.«name.toLowerCase.toFirstUpper»;
	'''		
	
}

