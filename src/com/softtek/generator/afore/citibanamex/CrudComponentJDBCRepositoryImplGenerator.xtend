package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity


class CrudComponentJDBCRepositoryImplGenerator {
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/java/com/aforebanamex/plata/cg/mn/repository/impl/"+e.name.toLowerCase.toFirstUpper+"JDBCRepositoryImpl.java", e.genJavaJDBCRepositoryImpl(m))
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
		import com.aforebanamex.plata.comunes.model.mn.«e.name.toLowerCase.toFirstUpper»;
		import com.aforebanamex.plata.comunes.model.mn.Valor«e.name.toLowerCase.toFirstUpper»;
		
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
				List<Valor«e.name.toLowerCase.toFirstUpper»> valor«e.name.toLowerCase.toFirstUpper»s = jdbcTemplate.query(retrieveSentence("mn.consulta.valor.«e.name.toLowerCase».id"),
						new Object[] { «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»() }, new Valor«e.name.toLowerCase.toFirstUpper»Mapper());
				«e.name.toLowerCase»Response.setValor«e.name.toLowerCase.toFirstUpper»(valor«e.name.toLowerCase.toFirstUpper»s);
				
				return new ResponsePlata<«e.name.toLowerCase.toFirstUpper»>(«e.name.toLowerCase»Response);
			}

		
			@Override
			public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtenerTodos(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data, «e.name.toLowerCase.toFirstUpper» historical) {
				logger.info("Se recibio en el repository obtener todos: {}", data.toString());
				Paginado paginado = data.getPaginado();
				«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = data.getPayload();
				
				String condicion = "";
				if (!«e.name.toLowerCase».getNombre().equals("")) {
					condicion += ComponentesGeneralesConstantsHelper.«e.name.toUpperCase»_NOMBRE + «e.name.toLowerCase».getNombre() + ComponentesGeneralesConstantsHelper.«e.name.toUpperCase»_NOMBRE_CIERRE;
				}
				if (!«e.name.toLowerCase».getEstadoIndicador().getCveEdoIndicador().equals(0L)) {
					condicion += ComponentesGeneralesConstantsHelper.«e.name.toUpperCase»_ESTADO_INDICADOR + «e.name.toLowerCase».getEstadoIndicador().getCveEdoIndicador();
				}
				if (!«e.name.toLowerCase».getTipoMedida().getCveTipoMedida().equals(0L)) {
					condicion += ComponentesGeneralesConstantsHelper.«e.name.toUpperCase»_TIPO_MEDIDA + «e.name.toLowerCase».getTipoMedida().getCveTipoMedida();
				}
				
				int total = jdbcTemplate.queryForObject(retrieveSentence("mn.consulta.«e.name.toLowerCase».registros.count") + condicion, new Object[]{}, (rs, rowNum) -> rs.getInt(1));
		
		
				List<«e.name.toLowerCase.toFirstUpper»> «e.name.toLowerCase»s = jdbcTemplate.query(retrieveSentence("mn.consulta.«e.name.toLowerCase».registros") + condicion + ComponentesGeneralesConstantsHelper.LIMIT + paginado.getValorMinimo() + ComponentesGeneralesConstantsHelper.COMA + paginado.getValorMaximo(),
						new Object[] {}, new «e.name.toLowerCase.toFirstUpper»Mapper());
				for («e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»TMP : «e.name.toLowerCase»s) {
					List<Valor«e.name.toLowerCase.toFirstUpper»> valor«e.name.toLowerCase.toFirstUpper»s = jdbcTemplate.query(
							retrieveSentence("mn.consulta.valor.«e.name.toLowerCase».id"), new Object[] { «e.name.toLowerCase»TMP.getId«e.name.toLowerCase.toFirstUpper»() },
							new Valor«e.name.toLowerCase.toFirstUpper»Mapper());
					«e.name.toLowerCase»TMP.setValor«e.name.toLowerCase.toFirstUpper»(valor«e.name.toLowerCase.toFirstUpper»s);
				}

				«««				
				«««for («e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»TMP : «e.name.toLowerCase»s) {
					«««e.name.toLowerCase»TMP.setValorVerde(«e.name.toLowerCase»TMP.getValores«e.name.toLowerCase.toFirstUpper»().get(0).getValorMinimo() + "-" + «e.name.toLowerCase»TMP.getValores«e.name.toLowerCase.toFirstUpper»().get(0).getValorMaximo() );
					«««e.name.toLowerCase»TMP.setValorAmarillo(«e.name.toLowerCase»TMP.getValores«e.name.toLowerCase.toFirstUpper»().get(1).getValorMinimo() + "-" + «e.name.toLowerCase»TMP.getValores«e.name.toLowerCase.toFirstUpper»().get(1).getValorMaximo() );
					«««e.name.toLowerCase»TMP.setValorRojo(«e.name.toLowerCase»TMP.getValores«e.name.toLowerCase.toFirstUpper»().get(2).getValorMinimo() + "-" + «e.name.toLowerCase»TMP.getValores«e.name.toLowerCase.toFirstUpper»().get(2).getValorMaximo() );
				«««}
				
				logger.info("Los «e.name.toLowerCase»s son: " + «e.name.toLowerCase»s.size());
				
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
				params.addValue("snombre", «e.name.toLowerCase».getNombre());
				params.addValue("descripcion", «e.name.toLowerCase».getDescripcion());
				params.addValue("desempenio", «e.name.toLowerCase».getDesempenio());
				params.addValue("estadoIndicador", «e.name.toLowerCase».getEstadoIndicador().getCveEdoIndicador());
				params.addValue("tipoMedida", «e.name.toLowerCase».getTipoMedida().getCveTipoMedida());
				
				String[] columnNames = new String[] {"ID_«e.name.toUpperCase»"};
				
				this.namedParameterJdbcTemplate.update(retrieveSentence("mn.inserta.«e.name.toLowerCase»"), params, keyHolder, columnNames);
		        Map<String,Object> keys = keyHolder.getKeys();
		        
		        logger.info("Key: {}", ReflectionToStringBuilder.toString(keys));
		        
				Long key = (long) keyHolder.getKey();
				for (Valor«e.name.toLowerCase.toFirstUpper» valor«e.name.toLowerCase.toFirstUpper» : «e.name.toLowerCase».getValor«e.name.toLowerCase.toFirstUpper»()) {
					jdbcTemplate.update(
							retrieveSentence("mn.inserta.valor"),
							new Object[] { key, valor«e.name.toLowerCase.toFirstUpper».getCveColor«e.name.toLowerCase.toFirstUpper»(), valor«e.name.toLowerCase.toFirstUpper».getValorMaximo(),
									valor«e.name.toLowerCase.toFirstUpper».getValorMinimo() });
				}
				«e.name.toLowerCase».setId«e.name.toLowerCase.toFirstUpper»(key.intValue());
				
				return new ResponsePlata<«e.name.toLowerCase.toFirstUpper»>(«e.name.toLowerCase»);
			}
		
			@Override
			public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> actualizar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data, «e.name.toLowerCase.toFirstUpper» historical) {
				«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = data.getPayload();
				
				Map<String, Object> params = new HashMap<>();
				params.put("nombre", «e.name.toLowerCase».getNombre());
				params.put("descripcion", «e.name.toLowerCase».getDescripcion());
				params.put("desempenio", «e.name.toLowerCase».getDesempenio());
				params.put("estadoIndicador", «e.name.toLowerCase».getEstadoIndicador().getCveEdoIndicador());
				params.put("tipoMedida", «e.name.toLowerCase».getTipoMedida().getCveTipoMedida());
				params.put("idSemaforo", «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»());
				
				logger.info("Sentence: ", retrieveSentence("mn.actualizar.«e.name.toLowerCase»"));
				logger.info("Params: ", params);
				
				super.namedParameterJdbcTemplate.update(retrieveSentence("mn.actualizar.«e.name.toLowerCase»"), params);
				
				actualizarValor«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase»);
				
				return new ResponsePlata<«e.name.toLowerCase.toFirstUpper»>(«e.name.toLowerCase»);
			}
			
			private void actualizarValor«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
				for (Valor«e.name.toLowerCase.toFirstUpper» valor«e.name.toLowerCase.toFirstUpper» : «e.name.toLowerCase».getValores«e.name.toLowerCase.toFirstUpper»()) {
					Map<String, Object> params = new HashMap<>();
					params.put("valorMaximo", valor«e.name.toLowerCase.toFirstUpper».getValorMaximo());
					params.put("valorMinimo", valor«e.name.toLowerCase.toFirstUpper».getValorMinimo());
					params.put("color«e.name.toLowerCase.toFirstUpper»", valor«e.name.toLowerCase.toFirstUpper».getCveColor«e.name.toLowerCase.toFirstUpper»());
					params.put("id«e.name.toLowerCase.toFirstUpper»", «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»());
					
					logger.info("Sentence: ", retrieveSentence("mn.actualizar.valor"));
					logger.info("Params: ", params);
					
					super.namedParameterJdbcTemplate.update(retrieveSentence("mn.actualizar.valor"), params);
				}
			}
		
			@Override
			public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> eliminar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data, «e.name.toLowerCase.toFirstUpper» historical) {
				logger.info("Se recibio en el repository eliminar: {}", data.toString());
				«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase» = data.getPayload();
				jdbcTemplate.update(retrieveSentence("mn.eliminar.valor"), new Object[] { «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»() });
				jdbcTemplate.update(retrieveSentence("mn.eliminar.«e.name.toLowerCase.toFirstUpper»"), new Object[] { «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»() });
				
				return new ResponsePlata<«e.name.toLowerCase.toFirstUpper»>(«e.name.toLowerCase»);
			}
		
		}
		
	'''	
	
}