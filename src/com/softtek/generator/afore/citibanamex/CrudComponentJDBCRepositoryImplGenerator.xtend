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
import com.softtek.rdl2.EntityTimeField
import com.softtek.rdl2.EntityDateTimeField
import com.softtek.rdl2.EntityBooleanField

class CrudComponentJDBCRepositoryImplGenerator {
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/mn/src/main/java/com/aforebanamex/plata/cg/mn/repository/impl/"+e.name.toLowerCase.toFirstUpper+"JDBCRepositoryImpl.java", e.genJavaJDBCRepositoryImpl(m))
			}
		}
	}
	
	def CharSequence genJavaJDBCRepositoryImpl(Entity e, Module m) '''
		package com.aforebanamex.plata.cg.mn.repository.impl;
		
		import java.sql.PreparedStatement;
		import java.util.HashMap;
		import java.util.List;
		import java.util.Map;
		
		import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
		import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
		import org.springframework.jdbc.core.namedparam.SqlParameterSource;
		import org.springframework.jdbc.support.GeneratedKeyHolder;
		import org.springframework.jdbc.support.KeyHolder;
		import org.springframework.stereotype.Repository;
		
		import com.aforebanamex.plata.base.model.Paginado;
		import com.aforebanamex.plata.base.model.RequestPlata;
		import com.aforebanamex.plata.base.model.ResponsePlata;
		import com.aforebanamex.plata.base.repository.BaseDefinitionRepository;
		import com.aforebanamex.plata.cg.mn.helper.ComponentesGeneralesConstantsHelper;
		import com.aforebanamex.plata.cg.mn.repository.«e.name.toLowerCase.toFirstUpper»JDBCRepository;
		import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;	
		
		@Repository
		public class «e.name.toLowerCase.toFirstUpper»JDBCRepositoryImpl extends BaseDefinitionRepository<RequestPlata<«e.name.toLowerCase.toFirstUpper»>, «e.name.toLowerCase.toFirstUpper», ResponsePlata<«e.name.toLowerCase.toFirstUpper»>> implements «e.name.toLowerCase.toFirstUpper»JDBCRepository {
		
			@Override
			public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtener(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
				logger.info("Se recibio en el repository obtener: {}", data.toString());
				«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = data.getPayload();
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("id", «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»());
				«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»Response = namedParameterJdbcTemplate.queryForObject(
				retrieveSentence("mn.consulta.«e.name.toLowerCase».id"), params, new «e.name.toLowerCase.toFirstUpper»Mapper());
		
				return new ResponsePlata<«e.name.toLowerCase.toFirstUpper»>(«e.name.toLowerCase»Response);
			}
		
			@Override
			public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtenerTodos(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data, «e.name.toLowerCase.toFirstUpper» historical) {
				logger.info("Se recibio en el repository obtener todos: {}", data.toString());
				Paginado paginado = data.getPaginado();
				«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = data.getPayload();
				
				String condicion = "";
				
				«FOR f : e.entity_fields»
				«f.getAttributeCondicion(e)»
				«ENDFOR»
				
				int total = jdbcTemplate.queryForObject(retrieveSentence("mn.consulta.«e.name.toLowerCase».registros.count") + condicion, new Object[]{}, (rs, rowNum) -> rs.getInt(1));
		
				List<«e.name.toLowerCase.toFirstUpper»> «e.name.toLowerCase»s = jdbcTemplate.query(retrieveSentence("mn.consulta.«e.name.toLowerCase».registros") + condicion + ComponentesGeneralesConstantsHelper.LIMIT + paginado.getValorMinimo() + ComponentesGeneralesConstantsHelper.COMA + paginado.getValorMaximo(),
						new Object[] {}, new «e.name.toLowerCase.toFirstUpper»Mapper());
				
				logger.info("Los «e.name.toLowerCase»s son: " + «e.name.toLowerCase»s.size());
				
				//for («e.name.toLowerCase.toFirstUpper» mod : «e.name.toLowerCase»s) {
				//	List<Subproceso> subprocesos = jdbcTemplate.query(
				//		retrieveSentence("«e.name.toLowerCase».subproceso.consulta.id"), new Object[] {id},
				//		new SubprocesoMapper());
				//      mod.setSubproceso(subproceso.get(0));	
				//}
				
				//for («e.name.toLowerCase.toFirstUpper» mod : «e.name.toLowerCase»s) {
				//	List<Procesos> procesos = jdbcTemplate.query(
				//		retrieveSentence("«e.name.toLowerCase».procesos.consulta.id"), new Object[] {id},
				//		new ProcesosMapper());	
				// 		subproceso.get(0).setProcesos(procesos.get(0));
				//      mod.setSubproceso(subproceso.get(0));	
				//}	
				
				//for («e.name.toLowerCase.toFirstUpper» mod : «e.name.toLowerCase»s) {
				//	List<Modulo> modulos = jdbcTemplate.query(
				//		retrieveSentence("«e.name.toLowerCase».odulo.consulta.id"), new Object[] {id},
				//		new ModuloMapper());	
	 			// 		mod.setSubproceso(subproceso.get(0));
				//}				
				
				paginado.setTotalRegistros(total);
				paginado.setTotalPaginas(paginado.getTotalRegistros()/paginado.getRegistrosMostrados()+((paginado.getTotalRegistros()%paginado.getRegistrosMostrados())==0?0:1));
				
				return new ResponsePlata<«e.name.toLowerCase.toFirstUpper»>(paginado, «e.name.toLowerCase»s);
			}
		
			@Override
			public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> agregar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data, «e.name.toLowerCase.toFirstUpper» historical) {
				logger.info("Se recibio en el repository agregar: {}", data.toString());
				«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = data.getPayload();
				KeyHolder keyHolder = new GeneratedKeyHolder();
				
				MapSqlParameterSource params = new MapSqlParameterSource();
				
				«FOR f : e.entity_fields»
				«f.getAttributeValue(e)»
				«ENDFOR»
				params.addValue("estadoLogico", true);
				
				String[] columnNames = new String[] {"ID_«e.name.toUpperCase»"};
				
				this.namedParameterJdbcTemplate.update(retrieveSentence("mn.inserta.«e.name.toLowerCase»"), params, keyHolder, columnNames);
		        Map<String,Object> keys = keyHolder.getKeys();
		        
		        logger.info("Key: {}", ReflectionToStringBuilder.toString(keys));
		        
				Long key = (long) keyHolder.getKey();

				«e.name.toLowerCase».setId«e.name.toLowerCase.toFirstUpper»(key.intValue());
				
				return new ResponsePlata<«e.name.toLowerCase.toFirstUpper»>(«e.name.toLowerCase»);
			}
		
			@Override
			public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> actualizar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data, «e.name.toLowerCase.toFirstUpper» historical) {
				«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = data.getPayload();
				
				Map<String, Object> params = new HashMap<>();
				«FOR f : e.entity_fields»
				«f.getAttributePut(e)»
				«ENDFOR»
				params.put("estadoLogico", true);
				params.put("id«e.name.toLowerCase.toFirstUpper»", «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»());
				
				logger.info("Sentence: ", retrieveSentence("mn.actualizar.«e.name.toLowerCase»"));
				logger.info("Params: ", params);
				
				super.namedParameterJdbcTemplate.update(retrieveSentence("mn.actualizar.«e.name.toLowerCase»"), params);
				
				return new ResponsePlata<«e.name.toLowerCase.toFirstUpper»>(«e.name.toLowerCase»);
			}
		
			@Override
			public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> eliminar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data, «e.name.toLowerCase.toFirstUpper» historical) {
				logger.info("Se recibio en el repository eliminar: {}", data.toString());
				«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = data.getPayload();
				jdbcTemplate.update(retrieveSentence("mn.eliminar.«e.name.toLowerCase»"), new Object[] { false,«e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»() });
				
				return new ResponsePlata<«e.name.toLowerCase.toFirstUpper»>(«e.name.toLowerCase»);
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
	def dispatch getAttributeImport(EntityDateTimeField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityTimeField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityBooleanField f, Entity t)'''
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
	import com.aforebanamex.plata.base.model.«e.name.toLowerCase.toFirstUpper»Enum;
	import com.aforebanamex.plata.base.model.«e.name.toLowerCase.toFirstUpper»;
	'''
	
	def dispatch getAttributeRefImport(Entity e, Entity t, String name) ''' 
	import com.aforebanamex.plata.base.model.«name.toLowerCase.toFirstUpper»;
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
	def dispatch getAttributeCondicion(EntityDateTimeField f, Entity t)'''
	if (!«t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»().equals("")) {
		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase» + «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE;
	}	
	'''
	
	def dispatch getAttributeCondicion(EntityTimeField f, Entity t)'''
	if (!«t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»().equals("")) {
		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase» + «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«f.name.toUpperCase»_CIERRE;
	}	
	'''
	
	def dispatch getAttributeCondicion(EntityBooleanField f, Entity t)'''
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
«««	if (!«t.name.toLowerCase».get«name.toLowerCase.toFirstUpper»().getId«e.name.toLowerCase.toFirstUpper»().equals(0)) {
«««		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«e.name.toUpperCase» + «t.name.toLowerCase».get«name.toLowerCase.toFirstUpper»().getId«e.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«e.name.toUpperCase»_CIERRE;
«««	}	
	'''
	
	def dispatch genRelationshipSearchCondicion(Entity e, Entity t, String name) ''' 
	if (!«t.name.toLowerCase».get«name.toLowerCase.toFirstUpper»().getId«e.name.toLowerCase.toFirstUpper»().equals(0)) {
		condicion += ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«e.name.toUpperCase» + «t.name.toLowerCase».get«name.toLowerCase.toFirstUpper»().getId«e.name.toLowerCase.toFirstUpper»() + ComponentesGeneralesConstantsHelper.«t.name.toUpperCase»_«e.name.toUpperCase»_CIERRE;
	}	
	'''	

	/* getAttributeColumn */
	def dispatch getAttributeColumn(EntityTextField f, Entity t)'''

	'''
	def dispatch getAttributeColumn(EntityLongTextField f, Entity t)'''
	
	'''
	def dispatch getAttributeColumn(EntityDateField f, Entity t)'''
	
	'''
	def dispatch getAttributeColumn(EntityDateTimeField f, Entity t)'''
	
	'''
	def dispatch getAttributeColumn(EntityTimeField f, Entity t)'''
	
	'''
	def dispatch getAttributeColumn(EntityBooleanField f, Entity t)'''
	
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
	
	/* getAttributeValue */
	def dispatch getAttributeValue(EntityTextField f, Entity t)'''
	params.addValue("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());
	'''
	def dispatch getAttributeValue(EntityLongTextField f, Entity t)'''
	params.addValue("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributeValue(EntityDateField f, Entity t)'''
	params.addValue("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributeValue(EntityDateTimeField f, Entity t)'''
	params.addValue("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributeValue(EntityTimeField f, Entity t)'''
	params.addValue("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributeValue(EntityBooleanField f, Entity t)'''
	params.addValue("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributeValue(EntityImageField f, Entity t)'''
	params.addValue("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributeValue(EntityFileField f, Entity t)'''
	params.addValue("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributeValue(EntityEmailField f, Entity t)'''
	params.addValue("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributeValue(EntityDecimalField f, Entity t)'''
	params.addValue("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributeValue(EntityIntegerField f, Entity t)'''
	params.addValue("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributeValue(EntityCurrencyField f, Entity t)'''
	params.addValue("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''	
	
	def dispatch getAttributeValue(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeRefValue(t, f.name)»
	«ENDIF»
	'''	
	
	def dispatch getAttributeRefValue(Enum e, Entity t, String name) ''' 
	params.addValue("«e.name.toLowerCase»", «t.name.toLowerCase».get«name.toLowerCase.toFirstUpper»().getCve«e.name.toLowerCase.toFirstUpper»());
	'''
	
	def dispatch getAttributeRefValue(Entity e, Entity t, String name) ''' 
	params.addValue("id«e.name.toLowerCase.toFirstUpper»", «t.name.toLowerCase».get«name.toLowerCase.toFirstUpper»().getId«e.name.toLowerCase.toFirstUpper»());
	'''
	
	/* getAttributeValue */
	def dispatch getAttributePut(EntityTextField f, Entity t)'''
	params.put("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());
	'''
	def dispatch getAttributePut(EntityLongTextField f, Entity t)'''
	params.put("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributePut(EntityDateField f, Entity t)'''
	params.put("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributePut(EntityDateTimeField f, Entity t)'''
	params.put("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributePut(EntityTimeField f, Entity t)'''
	params.put("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributePut(EntityBooleanField f, Entity t)'''
	params.put("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributePut(EntityImageField f, Entity t)'''
	params.put("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributePut(EntityFileField f, Entity t)'''
	params.put("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributePut(EntityEmailField f, Entity t)'''
	params.put("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributePut(EntityDecimalField f, Entity t)'''
	params.put("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributePut(EntityIntegerField f, Entity t)'''
	params.put("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''
	def dispatch getAttributePut(EntityCurrencyField f, Entity t)'''
	params.put("«f.name.toLowerCase»", «t.name.toLowerCase».get«f.name.toLowerCase.toFirstUpper»());	
	'''	
	
	def dispatch getAttributePut(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeRefPut(t, f.name)»
	«ENDIF»
	'''	
	
	def dispatch getAttributeRefPut(Enum e, Entity t, String name) ''' 
	params.put("«e.name.toLowerCase»", «t.name.toLowerCase».get«name.toLowerCase.toFirstUpper»().getCve«e.name.toLowerCase.toFirstUpper»());
	'''
	
	def dispatch getAttributeRefPut(Entity e, Entity t, String name) ''' 
	params.put("id«e.name.toLowerCase.toFirstUpper»", «t.name.toLowerCase».get«name.toLowerCase.toFirstUpper»().getId«e.name.toLowerCase.toFirstUpper»());
	'''	
			
	
			
	
}