package com.softtek.generator.afore.citibanamex

import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity

class CrudComponentCatalogoRepositoryImplGenerator {
		
	def doGenerate(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) {
		fsa.generateFile("banamex/src/main/java/com/aforebanamex/plata/integration/CatalogoRepositoryImpl.java", genCatalogoRepositoryImpl(s, fsa))	
	}
	
	def CharSequence genCatalogoRepositoryImpl(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) '''
	package mx.com.aforebanamex.plata.integration.impl;
	
	import java.util.List;
	
	import org.springframework.jdbc.core.BeanPropertyRowMapper;
	import org.springframework.stereotype.Repository;
	
	import mx.com.aforebanamex.plata.base.integration.BaseJdbcH2Repository;
	import mx.com.aforebanamex.plata.integration.CatalogoRepository;
	import mx.com.aforebanamex.plata.model.EstadoIndicador;
	import mx.com.aforebanamex.plata.model.TipoMedida;
	
	«FOR m : s.modules_ref»
		«FOR e : m.module_ref.elements.filter(Entity)»
		«e.genEntityImport(m.module_ref)»
		«ENDFOR»
	«ENDFOR»
	
@Repository
public class CatalogoRepositoryImpl extends BaseJdbcH2Repository implements CatalogoRepository {

	@Override
	public List<TipoMedida> obtenerTipoMedida() {
		return jdbcTemplate.query(obtenerConsulta("tipo.medida.catalogo"),
				new Object[] {}, new BeanPropertyRowMapper<TipoMedida>(TipoMedida.class));
	}

	@Override
	public List<EstadoIndicador> obtenerEstadoIndicador() {
		return jdbcTemplate.query(obtenerConsulta("estado.indicador.catalogo"),
				new Object[] {}, new BeanPropertyRowMapper<EstadoIndicador>(EstadoIndicador.class));
	}
	
		«FOR m : s.modules_ref»
			«FOR e : m.module_ref.elements.filter(Entity)»
			«e.genEntity(m.module_ref)»
			«ENDFOR»
		«ENDFOR»
	}
	'''
	
	def dispatch genEntity(Entity e, Module m) '''
	@Override
	public List<«e.name.toLowerCase.toFirstUpper»> obtener«e.name.toLowerCase.toFirstUpper»() {
		return jdbcTemplate.query(obtenerConsulta("«e.name.toLowerCase».catalogo"),
				new Object[] {}, new BeanPropertyRowMapper<«e.name.toLowerCase.toFirstUpper»>(«e.name.toLowerCase.toFirstUpper».class));
	}
	'''
	
	def dispatch genEntityImport(Entity e, Module m) '''
	import mx.com.aforebanamex.plata.model.«e.name.toLowerCase.toFirstUpper»;
	'''	
	
}