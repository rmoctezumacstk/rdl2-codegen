package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

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
	
	@Repository
	public class «e.name.toLowerCase.toFirstUpper»RepositoryImpl extends BaseJdbcH2Repository implements «e.name.toLowerCase.toFirstUpper»Repository {
	
		public «e.name.toLowerCase.toFirstUpper» obtener«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("id", «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»());
			«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase»Response = namedParameterJdbcTemplate.queryForObject(
					obtenerConsulta("«e.name.toLowerCase».consulta.id"), params,
					new «e.name.toLowerCase.toFirstUpper»Mapper());
	//		List<Valor«e.name.toLowerCase.toFirstUpper»> valor«e.name.toLowerCase.toFirstUpper»s = jdbcTemplate.query(obtenerConsulta("«e.name.toLowerCase».valor.consulta.id"),
	//				new Object[] { «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»() }, new Valor«e.name.toLowerCase.toFirstUpper»Mapper());
	//		«e.name.toLowerCase»Response.setValor«e.name.toLowerCase.toFirstUpper»(valor«e.name.toLowerCase.toFirstUpper»s);
			return «e.name.toLowerCase»Response;
	
		}
	
		public int agregar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
			KeyHolder keyHolder = new GeneratedKeyHolder();
	
			jdbcTemplate.update(connection -> {
				PreparedStatement ps = connection.prepareStatement(
						obtenerConsulta("«e.name.toLowerCase».insertar"));
	//			ps.setString(1, «e.name.toLowerCase».getNombre());
	//			ps.setString(2, «e.name.toLowerCase».getDescripcion());
	//			ps.setString(3, «e.name.toLowerCase».getDesempenio());
	//			ps.setLong(4, «e.name.toLowerCase».getEstadoIndicador().getCveEdoIndicador());
	//			ps.setLong(5, «e.name.toLowerCase».getTipoMedida().getCveTipoMedida());
				return ps;
			}, keyHolder);
			Long key = (long) keyHolder.getKey();
	//		for (Valor«e.name.toLowerCase.toFirstUpper» valor«e.name.toLowerCase.toFirstUpper» : «e.name.toLowerCase».getValor«e.name.toLowerCase.toFirstUpper»()) {
	//			jdbcTemplate.update(
	//					obtenerConsulta("«e.name.toLowerCase».valor.insert"),
	//					new Object[] { key, valor«e.name.toLowerCase.toFirstUpper».getCveColor«e.name.toLowerCase.toFirstUpper»(), valor«e.name.toLowerCase.toFirstUpper».getValorMaximo(),
	//							valor«e.name.toLowerCase.toFirstUpper».getValorMinimo() });
	//		}
			logger.info("RESGISTRO INSERTADO: " + key.intValue());
			return key.intValue();
		}
	
		public int eliminar«e.name.toLowerCase.toFirstUpper»(int id) {
			jdbcTemplate.update(obtenerConsulta("«e.name.toLowerCase».valor.eliminar"), new Object[] { id });
			return jdbcTemplate.update(obtenerConsulta("«e.name.toLowerCase».eiminar"), new Object[] { id });
		}
	
		@Override
		public int actualizar«e.name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase») {
			KeyHolder keyHolder = new GeneratedKeyHolder();
			jdbcTemplate.update(connection -> {
				PreparedStatement ps = connection.prepareStatement(
						obtenerConsulta("«e.name.toLowerCase».actualizar"));
	//			ps.setString(1, «e.name.toLowerCase».getNombre());
	//			ps.setString(2, «e.name.toLowerCase».getDescripcion());
	//			ps.setString(3, «e.name.toLowerCase».getDesempenio());
	//			ps.setLong(4, «e.name.toLowerCase».getEstadoIndicador().getCveEdoIndicador());
	//			ps.setLong(5, «e.name.toLowerCase».getTipoMedida().getCveTipoMedida());
				ps.setInt(6, «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»());
				return ps;
			}, keyHolder);
	//		for (Valor«e.name.toLowerCase.toFirstUpper» valor«e.name.toLowerCase.toFirstUpper» : «e.name.toLowerCase».getValor«e.name.toLowerCase.toFirstUpper»()) {
	//			jdbcTemplate.update(
	//					obtenerConsulta("«e.name.toLowerCase».valor.actualizar"),
	//					new Object[] { valor«e.name.toLowerCase.toFirstUpper».getValorMaximo(), valor«e.name.toLowerCase.toFirstUpper».getValorMinimo(),
	//							«e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»(), valor«e.name.toLowerCase.toFirstUpper».getCveColor«e.name.toLowerCase.toFirstUpper»() });
	//		}
			return «e.name.toLowerCase».getId«e.name.toLowerCase.toFirstUpper»();
		}
		
		public PaginadoHelper«e.name.toLowerCase.toFirstUpper» obtener«e.name.toLowerCase.toFirstUpper»s(«e.name.toLowerCase.toFirstUpper» «e.name.toLowerCase», Integer valorMinimo, Integer valorMaximo) {
			
			PaginadoHelper«e.name.toLowerCase.toFirstUpper» paginadoHelper«e.name.toLowerCase.toFirstUpper» = new PaginadoHelper«e.name.toLowerCase.toFirstUpper»();
			
			String condicion = "";
			
			int total = jdbcTemplate.queryForObject(obtenerConsulta("«e.name.toLowerCase».consulta.registros") + condicion, new Object[]{}, (rs, rowNum) -> rs.getInt(1));
	
	
			List<«e.name.toLowerCase.toFirstUpper»> «e.name.toLowerCase»s = jdbcTemplate.query(obtenerConsulta("«e.name.toLowerCase».consulta.todos") + condicion + ComponentesGeneralesConstantsHelper.LIMIT + valorMinimo + ComponentesGeneralesConstantsHelper.COMA + valorMaximo,
					new Object[] {}, new «e.name.toLowerCase.toFirstUpper»Mapper());
			
			paginadoHelper«e.name.toLowerCase.toFirstUpper».setTotalRegistros(total);
			paginadoHelper«e.name.toLowerCase.toFirstUpper».setPayload(«e.name.toLowerCase»s);;
			
			return paginadoHelper«e.name.toLowerCase.toFirstUpper»;
		}
	}
	'''
	
}

