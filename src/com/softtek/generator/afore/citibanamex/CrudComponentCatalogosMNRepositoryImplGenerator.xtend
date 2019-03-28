package com.softtek.generator.afore.citibanamex

import org.eclipse.xtext.generator.IFileSystemAccess2
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
import com.softtek.rdl2.EntityBooleanField
import com.softtek.rdl2.EntityTimeField
import com.softtek.rdl2.EntityDateTimeField
import com.softtek.rdl2.Enum

class CrudComponentCatalogosMNRepositoryImplGenerator {
	
	def doGenerate(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) {
		fsa.generateFile("banamex/configuracion/src/main/java/com/aforebanamex/plata/configuracion/repository/mn/impl/CatalogosMNRepositoryImpl.java", genCatalogoMNRepositoryImpl(s, fsa))	
	}
	
	def CharSequence genCatalogoMNRepositoryImpl(com.softtek.rdl2.System s, IFileSystemAccess2 fsa) '''
	package com.aforebanamex.plata.configuracion.repository.mn.impl;
	
	import java.util.List;
	import org.springframework.core.ParameterizedTypeReference;
	import org.springframework.http.HttpEntity;
	import org.springframework.http.HttpHeaders;
	import org.springframework.http.HttpMethod;
	import org.springframework.http.ResponseEntity;
	import org.springframework.stereotype.Repository;
	import org.springframework.web.client.RestTemplate;
	import com.aforebanamex.plata.base.restClient.BaseRestCliente;
	import com.aforebanamex.plata.configuracion.repository.mn.CatalogosMNRepository;
	
	«FOR m : s.modules_ref»
		«FOR e : m.module_ref.elements.filter(Entity)»
			«FOR f: e.entity_fields»
				«f.genImportField(e)»
			«ENDFOR»
		«ENDFOR»
	«ENDFOR»	
	
	@Repository
	public class CatalogosMNRepositoryImpl extends BaseRestCliente implements CatalogosMNRepository {
		
		«FOR m : s.modules_ref»
			«FOR e : m.module_ref.elements.filter(Entity)»
				«FOR f: e.entity_fields»
				«f.getEntityField()»
				«ENDFOR»
			«ENDFOR»
		«ENDFOR»		
		
	}
	'''
	
	/* Get Import */
	def dispatch genImportField(EntityTextField f, Entity t)''''''
	def dispatch genImportField(EntityLongTextField f, Entity t)''''''
	def dispatch genImportField(EntityDateField f, Entity t)''''''
	def dispatch genImportField(EntityImageField f, Entity t)''''''
	def dispatch genImportField(EntityFileField f, Entity t)''''''
	def dispatch genImportField(EntityEmailField f, Entity t)''''''
	def dispatch genImportField(EntityDecimalField f, Entity t)''''''
	def dispatch genImportField(EntityIntegerField f, Entity t)''''''
	def dispatch genImportField(EntityCurrencyField f, Entity t)''''''
	def dispatch genImportField(EntityBooleanField f, Entity t)''''''
	def dispatch genImportField(EntityTimeField f, Entity t)''''''
	def dispatch genImportField(EntityDateTimeField f, Entity t)''''''
	
	def dispatch genImportField(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
	«f.superType.genRelationImport(t, f.name)»		
	«ENDIF»
	'''	
	def dispatch genRelationImport(Enum e, Entity t, String name) ''' 
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;
	'''
	def dispatch genRelationImport(Entity e, Entity t, String name) ''' 
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;
	'''		

	/* Get Field */
	def dispatch getEntityField(EntityTextField f)''''''
	def dispatch getEntityField(EntityLongTextField f)''''''
	def dispatch getEntityField(EntityDateField f)''''''
	def dispatch getEntityField(EntityImageField f)''''''
	def dispatch getEntityField(EntityFileField f)''''''
	def dispatch getEntityField(EntityEmailField f)''''''
	def dispatch getEntityField(EntityDecimalField f)''''''
	def dispatch getEntityField(EntityIntegerField f)''''''
	def dispatch getEntityField(EntityCurrencyField f)''''''
	def dispatch getEntityField(EntityBooleanField f)''''''
	def dispatch getEntityField(EntityTimeField f)''''''
	def dispatch getEntityField(EntityDateTimeField f)''''''
	
	def dispatch getEntityField(EntityReferenceField f)'''
	«IF  f !== null && !f.upperBound.equals('*')»
	«f.superType.getEntityFieldRel(f.name)»
	«ENDIF»
	'''	
	def dispatch getEntityFieldRel(Enum e, String name) '''
		@Override
		public List<«e.name.toLowerCase.toFirstUpper»> obtenerCatalogo«name.toLowerCase.toFirstUpper»() {
			logger.info("Se recibio en el repository obtener catalogo «name.toLowerCase.toFirstUpper»");
			RestTemplate rt = new RestTemplate();
			String uri = super.retrieveUri("services.url.mn");
			HttpHeaders headers = new HttpHeaders();    
			HttpEntity<«e.name.toLowerCase.toFirstUpper»> requestEntity = new HttpEntity<«e.name.toLowerCase.toFirstUpper»>(new «e.name.toLowerCase.toFirstUpper»(), headers);
			ResponseEntity<List<«e.name.toLowerCase.toFirstUpper»>> response =  rt.exchange(uri+"obtenerCatalogo«name.toLowerCase.toFirstUpper»", HttpMethod.PUT,requestEntity, new ParameterizedTypeReference<List<«e.name.toLowerCase.toFirstUpper»>>(){});
			return response.getBody();
		}
	'''
	def dispatch getEntityFieldRel(Entity e, String name) ''' 
		@Override
		public List<«e.name.toLowerCase.toFirstUpper»> obtenerCatalogo«name.toLowerCase.toFirstUpper»() {
			logger.info("Se recibio en el repository obtener catalogo «name.toLowerCase.toFirstUpper»");
			RestTemplate rt = new RestTemplate();
			String uri = super.retrieveUri("services.url.mn");
			HttpHeaders headers = new HttpHeaders();    
			HttpEntity<«e.name.toLowerCase.toFirstUpper»> requestEntity = new HttpEntity<«e.name.toLowerCase.toFirstUpper»>(new «e.name.toLowerCase.toFirstUpper»(), headers);
			ResponseEntity<List<«e.name.toLowerCase.toFirstUpper»>> response =  rt.exchange(uri+"obtenerCatalogo«name.toLowerCase.toFirstUpper»", HttpMethod.PUT,requestEntity, new ParameterizedTypeReference<List<«e.name.toLowerCase.toFirstUpper»>>(){});
			return response.getBody();
		}
	'''	
	
}