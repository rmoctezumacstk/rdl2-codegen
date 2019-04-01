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
import com.softtek.generator.utils.EntityUtils

class CrudComponentJDBCRepositoryImplGenerator {
	var entityUtils = new EntityUtils
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/"+m.name.toLowerCase+"/src/main/java/com/aforebanamex/plata/cg/"+m.name.toLowerCase+"/repository/impl/"+e.name.toLowerCase.toFirstUpper+"JDBCRepositoryImpl.java", e.genJavaJDBCRepositoryImpl(m))
			}
		}
	}
	
	def CharSequence genJavaJDBCRepositoryImpl(Entity e, Module m) '''
		package com.aforebanamex.plata.cg.«e.name.toLowerCase».repository.impl;
		
		import java.util.HashMap;
		import java.util.List;
		import java.util.Map;
		
		import org.springframework.dao.DataAccessException;
		import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
		import org.springframework.jdbc.support.GeneratedKeyHolder;
		import org.springframework.jdbc.support.KeyHolder;
		import org.springframework.stereotype.Repository;
		
		import com.aforebanamex.plata.base.model.Message;
		import com.aforebanamex.plata.base.model.Paginado;
		import com.aforebanamex.plata.base.model.RequestPlata;
		import com.aforebanamex.plata.base.model.ResponsePlata;
		import com.aforebanamex.plata.base.repository.BaseDefinitionRepository;
		import com.aforebanamex.plata.cg.«e.name.toLowerCase».helper.ComponentesGeneralesConstantsHelper;
		import com.aforebanamex.plata.cg.«e.name.toLowerCase».repository.«e.name.toLowerCase.toFirstUpper»JDBCRepository;
		import com.aforebanamex.plata.comunes.helper.ValidarCadenas;
		import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;	
		//import com.aforebanamex.plata.comunes.model.ValorSemaforo;
		
		
		@Repository
		public class «e.name.toLowerCase.toFirstUpper»JDBCRepositoryImpl extends BaseDefinitionRepository<RequestPlata<«e.name.toLowerCase.toFirstUpper»>, «e.name.toLowerCase.toFirstUpper», ResponsePlata<«e.name.toLowerCase.toFirstUpper»>> implements «e.name.toLowerCase.toFirstUpper»JDBCRepository {
		
			@Override
			public «e.name.toLowerCase.toFirstUpper» obtener(int id) {
					logger.info("Se recibio en el repository obtener: {}", id);
					MapSqlParameterSource params = new MapSqlParameterSource();
					params.addValue("id", id);
					«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»Response = namedParameterJdbcTemplate
							.queryForObject(retrieveSentence("«m.name.toLowerCase».consulta.«e.name.toLowerCase».id"), params, new «e.name.toLowerCase.toFirstUpper»Mapper());
					//List<ValorSemaforo> valorSemaforos = jdbcTemplate.query(retrieveSentence("«m.name.toLowerCase».consulta.«e.name.toLowerCase».id"),
					//		new Object[] { id }, new ValorSemaforoMapper());
					//«e.name.toLowerCase»Response.setValoresSemaforo(valorSemaforos);
			
					return «e.name.toLowerCase»Response;
		   }
		   
		   @Override
		   public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtenerTodos(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
		   		logger.info("Se recibio en el repository obtener todos: {}", data);
		   		Paginado paginado = data.getPaginado();
		   		«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = data.getPayload();
		   		
		   		if(ValidarCadenas.comprobar(«e.name.toLowerCase».getNombre()).length()>0){
		   			logger.info("Caracteres incorrectos");
		   			return new ResponsePlata<>(new Message(ComponentesGeneralesConstantsHelper.CODIGO_ERROR, ComponentesGeneralesConstantsHelper.ERROR_CARACTERES_NO_VALIDOS));
		   		}
		   
		   		String condicion = "";
		   		if (!«e.name.toLowerCase».getNombre().equals("")) {
		   			condicion += ComponentesGeneralesConstantsHelper.«e.name.toUpperCase»_NOMBRE + «e.name.toLowerCase».getNombre()
		   					+ ComponentesGeneralesConstantsHelper.«e.name.toUpperCase.toFirstUpper»_NOMBRE_CIERRE;
		   		}
		   		/*if (!semaforo.getEstadoIndicador().getCveEdoIndicador().equals(0L)) {
		   			condicion += ComponentesGeneralesConstantsHelper.SEMAFORO_ESTADO_INDICADOR
		   					+ semaforo.getEstadoIndicador().getCveEdoIndicador();
		   		}
		   		if (!semaforo.getTipoMedida().getCveTipoMedida().equals(0L)) {
		   			condicion += ComponentesGeneralesConstantsHelper.SEMAFORO_TIPO_MEDIDA
		   					+ semaforo.getTipoMedida().getCveTipoMedida();
		   		}
		        */
		   		int total = jdbcTemplate.queryForObject(retrieveSentence("«m.name.toLowerCase».consulta.«e.name.toLowerCase».registros.count") + condicion + ComponentesGeneralesConstantsHelper.NO_ELIMINADO,
		   				new Object[] {}, (rs, rowNum) -> rs.getInt(1));
		   
		   		List<«e.name.toLowerCase.toFirstUpper»> «e.name.toLowerCase»s = jdbcTemplate.query(
		   				retrieveSentence("«m.name.toLowerCase».consulta.«e.name.toLowerCase».registros") + condicion 
		   						+ ComponentesGeneralesConstantsHelper.NO_ELIMINADO
		   						+ ComponentesGeneralesConstantsHelper.LIMIT + paginado.getValorMinimo()
		   						+ ComponentesGeneralesConstantsHelper.COMA + paginado.getValorMaximo(),
		   				new Object[] {}, new «e.name.toLowerCase.toFirstUpper»Mapper());
		   		for («e.name.toLowerCase.toFirstUpper» sem : «e.name.toLowerCase»s) {
		   			//List<ValorSemaforo> valorSemaforos = jdbcTemplate.query(retrieveSentence("mn.consulta.valor.semaforo.id"),
		   			//		new Object[] { sem.getIdSemaforo() }, new ValorSemaforoMapper());
		   			//sem.setValoresSemaforo(valorSemaforos);
		   		}
		   
		   		for («e.name.toLowerCase.toFirstUpper» s : «e.name.toLowerCase.toFirstUpper»s) {
		   			//s.setValorVerde(s.getValoresSemaforo().get(0).getValorMinimo() + "-"
		   			//		+ s.getValoresSemaforo().get(0).getValorMaximo());
		   			//s.setValorAmarillo(s.getValoresSemaforo().get(1).getValorMinimo() + "-"
		   			//		+ s.getValoresSemaforo().get(1).getValorMaximo());
		   			//s.setValorRojo(s.getValoresSemaforo().get(2).getValorMinimo() + "-"
		   			//		+ s.getValoresSemaforo().get(2).getValorMaximo());
		   		}
		   
		   		paginado.setTotalRegistros(total);
		   		paginado.setTotalPaginas(paginado.getTotalRegistros() / paginado.getRegistrosMostrados()
		   				+ ((paginado.getTotalRegistros() % paginado.getRegistrosMostrados()) == 0 ? 0 : 1));
		   
		   		return new ResponsePlata<>(paginado, «e.name.toLowerCase»s, new Message(ComponentesGeneralesConstantsHelper.CODIGO_EXITO, null));
		   	}
		   
		   «IF entityUtils.isAddInScaffolding(e)»
		   @Override
		   public Message agregar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data, «e.name.toLowerCase.toFirstUpper» historical) {
		   		logger.info("Se recibio en el repository agregar: {}", data);
		   		«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = data.getPayload();
		   		KeyHolder keyHolder = new GeneratedKeyHolder();
		   
		   		try {
		   			«e.name.toLowerCase.toFirstUpper» val = obtener«e.name.toLowerCase.toFirstUpper»Constraint(«e.name.toLowerCase»);
		   			if(val != null) {
		   				if(val.getEstadoIndicador().getDescripcion().equals("Eliminado")) {
		   					return new Message(ComponentesGeneralesConstantsHelper.CODIGO_ERROR, ComponentesGeneralesConstantsHelper.ERROR_ELIMINADO_REGISTRO);
		   				}else {
		   					return new Message(ComponentesGeneralesConstantsHelper.CODIGO_ERROR, ComponentesGeneralesConstantsHelper.ERROR_REGISTRO_DUPLICADO);
		   				}
		   			}else {
		   				
		   				if((ValidarCadenas.comprobar(«e.name.toLowerCase».getNombre())).length()>0 
		   						|| (ValidarCadenas.comprobar(«e.name.toLowerCase».getDescripcion())).length()>0){
		   					return new Message(ComponentesGeneralesConstantsHelper.CODIGO_ERROR, ComponentesGeneralesConstantsHelper.ERROR_CARACTERES_NO_VALIDOS);
		   				}
		   				
		   				MapSqlParameterSource params = new MapSqlParameterSource();
		   				params.addValue("snombre", «e.name.toLowerCase».getNombre());
		   				params.addValue("descripcion", «e.name.toLowerCase».getDescripcion());
		   				params.addValue("desempenio", «e.name.toLowerCase».getDesempenio());
		   				params.addValue("estadoIndicador", «e.name.toLowerCase».getEstadoindicador().getCveedoindicador());
		   				params.addValue("tipoMedida", «e.name.toLowerCase».getTipomedida().getCveTipomedida());
		   		
		   				String[] columnNames = new String[] { "ID_«e.name.toUpperCase»" };
		   		
		   				this.namedParameterJdbcTemplate.update(retrieveSentence("«m.name.toLowerCase».inserta.«e.name.toLowerCase»"), params, keyHolder, columnNames);
		   				
		   				Long key = (long) keyHolder.getKey();
		   				//Valor semaforo?
		   				//for (ValorSemaforo valorSemaforo : semaforo.getValoresSemaforo()) {
		   				//	MapSqlParameterSource paramsVal = new MapSqlParameterSource();
		   				//	paramsVal.addValue("id", key);
		   				//	paramsVal.addValue("color", valorSemaforo.getCveColorSemaforo());
		   				//	paramsVal.addValue("minimo", valorSemaforo.getValorMinimo());
		   				//	paramsVal.addValue("maximo", valorSemaforo.getValorMaximo());
		   				//	this.namedParameterJdbcTemplate.update(retrieveSentence("mn.inserta.valor"),paramsVal);
		   				//}
		   				«e.name.toLowerCase».setId«e.name.toLowerCase»(key.intValue());
		   			}
		   		}catch (DataAccessException e) {
		   			logger.info("ERROR BD: {}", e.getMessage());
		   			return new Message(ComponentesGeneralesConstantsHelper.CODIGO_ERROR, ComponentesGeneralesConstantsHelper.ERROR_REGISTRO_DUPLICADO);
		   		}
		   		
		   		return new Message(ComponentesGeneralesConstantsHelper.CODIGO_EXITO, ComponentesGeneralesConstantsHelper.EXITO_REGISTRO);
		   	}
		   	«ENDIF»
		   	
		   	«IF entityUtils.isEditInScaffolding(e)»
		   	@Override
		   	public Message actualizar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data, «e.name.toLowerCase.toFirstUpper» historical) {
		   			«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = data.getPayload();
		   			try {
		   				«e.name.toLowerCase.toFirstUpper» val = obtener«e.name.toLowerCase.toFirstUpper»Constraint(«e.name.toLowerCase»);
		   				if(val != null) {
		   					if(val.getEstadoIndicador().getDescripcion().equals("Eliminado")) {
		   						return new Message(ComponentesGeneralesConstantsHelper.CODIGO_ERROR, ComponentesGeneralesConstantsHelper.ERROR_ELIMINADO_REGISTRO);
		   					}else {
		   						return new Message(ComponentesGeneralesConstantsHelper.CODIGO_ERROR, ComponentesGeneralesConstantsHelper.ERROR_REGISTRO_DUPLICADO);
		   					}
		   				}else {
		   					
		   					if((ValidarCadenas.comprobar(«e.name.toLowerCase».getNombre())).length()>0 
		   							|| (ValidarCadenas.comprobar(«e.name.toLowerCase».getDescripcion())).length()>0){
		   						return new Message(ComponentesGeneralesConstantsHelper.CODIGO_ERROR, ComponentesGeneralesConstantsHelper.ERROR_CARACTERES_NO_VALIDOS);
		   					}
		   					
		   					MapSqlParameterSource params = new MapSqlParameterSource();
		   					params.addValue("nombre", «e.name.toLowerCase».getNombre());
		   					params.addValue("descripcion", «e.name.toLowerCase».getDescripcion());
		   					params.addValue("desempenio", «e.name.toLowerCase».getDesempenio());
		   					params.addValue("estadoIndicador", «e.name.toLowerCase».getEstadoindicador().getCveedoindicador());
		   					params.addValue("tipoMedida", «e.name.toLowerCase».getTipomedida().getCveTipomedida());
		   					params.addValue("id", «e.name.toLowerCase».getId«e.name.toLowerCase»());
		   	
		   					super.namedParameterJdbcTemplate.update(retrieveSentence("«m.name.toLowerCase».actualizar.«e.name.toLowerCase»"), params);
		   			
		   					//actualizarValor«e.name.toLowerCase»(«e.name.toLowerCase»);
		   				}
		   			}catch (DataAccessException e) {
		   				return new Message(ComponentesGeneralesConstantsHelper.CODIGO_ERROR, ComponentesGeneralesConstantsHelper.ERROR_REGISTRO_DUPLICADO);
		   			}
		   			return new Message(ComponentesGeneralesConstantsHelper.CODIGO_EXITO, ComponentesGeneralesConstantsHelper.EXITO_ACTUALIZA_REGISTRO);
		   	}
		    «ENDIF»
		    
		    «IF entityUtils.isDeleteInScaffolding(e)»
		    @Override
		    public Message eliminar(int id, «e.name.toLowerCase.toFirstUpper» historical) {
		    		logger.info("Se recibio en el repository eliminar: {}", id);
		    		
		    		Map<String, Object> params = new HashMap<>();
		    		params.put("id«e.name.toLowerCase.toFirstUpper»", id);
		    
		    		logger.info("Params: {}", params);
		    
		    		super.namedParameterJdbcTemplate.update(retrieveSentence("«m.name.toLowerCase».eliminar.«e.name.toLowerCase»"), params);
		    
		    		return new Message(ComponentesGeneralesConstantsHelper.CODIGO_EXITO, ComponentesGeneralesConstantsHelper.EXITO_ACTUALIZA_REGISTRO);
		    	}
		    «ENDIF»
		    
		    «IF entityUtils.isSearchInScaffolding(e)»
		    @Override
		    public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> consultar«e.name.toLowerCase.toFirstUpper»Autocomplete(String nombre) {
		    		logger.info("Se recibio en el repository consultar«e.name.toLowerCase.toFirstUpper»Autocomplete: {}", nombre);
		    		List<«e.name.toLowerCase.toFirstUpper»> lista«e.name.toLowerCase.toFirstUpper»s = null;
		    		ResponsePlata<«e.name.toLowerCase.toFirstUpper»> response = new ResponsePlata<>();
		    		MapSqlParameterSource mapaParametros = new MapSqlParameterSource();
		    		mapaParametros.addValue("nombre", nombre);
		    		lista«e.name.toLowerCase.toFirstUpper»s = namedParameterJdbcTemplate.query(retrieveSentence("«m.name.toLowerCase».autocompletar.«e.name.toLowerCase».nombre"),
		    				mapaParametros, new «e.name.toLowerCase.toFirstUpper»Mapper());
		    		response.setPayloades(lista«e.name.toLowerCase.toFirstUpper»s);
		    		return response;
		    }
		    «ENDIF»
		

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