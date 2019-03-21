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
				fsa.generateFile("banamex/configuracion/src/main/java/com/aforebanamex/plata/configuracion/repository/mn/impl/" + e.name.toLowerCase.toFirstUpper + "RestRepositoryImpl.java", e.genJavaRepositoryImpl(m))
			}
		}
	}
	
	def CharSequence genJavaRepositoryImpl(Entity e, Module m) '''
	package com.aforebanamex.plata.configuracion.repository.mn.impl;
	
	import org.springframework.core.ParameterizedTypeReference;
	import org.springframework.http.HttpEntity;
	import org.springframework.http.HttpHeaders;
	import org.springframework.http.HttpMethod;
	import org.springframework.http.ResponseEntity;
	import org.springframework.stereotype.Repository;
	import org.springframework.web.client.RestTemplate;
	
	import com.aforebanamex.plata.base.model.RequestPlata;
	import com.aforebanamex.plata.base.model.ResponsePlata;
	import com.aforebanamex.plata.base.restClient.BaseRestCliente;
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;
	import com.aforebanamex.plata.configuracion.repository.mn.«e.name.toLowerCase.toFirstUpper»RestRepository;
	
	@Repository
	public class «e.name.toLowerCase.toFirstUpper»RestRepositoryImpl extends BaseRestCliente implements «e.name.toLowerCase.toFirstUpper»RestRepository {
	
		
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtener(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data) {
			logger.info("Se recibio en el repository obtener: {}", data.toString());
			RestTemplate rt = new RestTemplate();
			String uri = super.retrieveUri("services.url.mn");
			HttpHeaders headers = new HttpHeaders();
	        HttpEntity<RequestPlata<«e.name.toLowerCase.toFirstUpper»>> requestEntity = new HttpEntity<RequestPlata<«e.name.toLowerCase.toFirstUpper»>>(data, headers);
			ResponseEntity<ResponsePlata<«e.name.toLowerCase.toFirstUpper»>> response =  rt.exchange(uri+"obtener«e.name.toLowerCase.toFirstUpper»", HttpMethod.PUT,requestEntity, new ParameterizedTypeReference<ResponsePlata<«e.name.toLowerCase.toFirstUpper»>>(){});
			return response.getBody();
		}
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> obtenerTodos(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data, «e.name.toLowerCase.toFirstUpper» historical) {
			logger.info("Se recibio en el repository obtenerTodos: {}", data.toString());
			RestTemplate rt = new RestTemplate();
			String uri = super.retrieveUri("services.url.mn");
			HttpHeaders headers = new HttpHeaders();
	        HttpEntity<RequestPlata<«e.name.toLowerCase.toFirstUpper»>> requestEntity = new HttpEntity<RequestPlata<«e.name.toLowerCase.toFirstUpper»>>(data, headers);
			ResponseEntity<ResponsePlata<«e.name.toLowerCase.toFirstUpper»>> response =  rt.exchange(uri+"obtener«e.name.toLowerCase.toFirstUpper»s", HttpMethod.PUT,requestEntity, new ParameterizedTypeReference<ResponsePlata<«e.name.toLowerCase.toFirstUpper»>>(){});
			return response.getBody();
		}
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> agregar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data, «e.name.toLowerCase.toFirstUpper» historical) {
			logger.info("Se recibio en el repository agregar: {}", data.toString());
			RestTemplate rt = new RestTemplate();
			String uri = super.retrieveUri("services.url.mn");
			HttpHeaders headers = new HttpHeaders();
	        HttpEntity<RequestPlata<«e.name.toLowerCase.toFirstUpper»>> requestEntity = new HttpEntity<RequestPlata<«e.name.toLowerCase.toFirstUpper»>>(data, headers);
			ResponseEntity<ResponsePlata<«e.name.toLowerCase.toFirstUpper»>> response =  rt.exchange(uri+"agregar«e.name.toLowerCase.toFirstUpper»", HttpMethod.PUT,requestEntity, new ParameterizedTypeReference<ResponsePlata<«e.name.toLowerCase.toFirstUpper»>>(){});
			return response.getBody();
		}
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> actualizar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data, «e.name.toLowerCase.toFirstUpper» historical) {
			logger.info("Se recibio en el repository actualizar: {}", data.toString());
			RestTemplate rt = new RestTemplate();
			String uri = super.retrieveUri("services.url.mn");
			HttpHeaders headers = new HttpHeaders();
	        HttpEntity<RequestPlata<«e.name.toLowerCase.toFirstUpper»>> requestEntity = new HttpEntity<RequestPlata<«e.name.toLowerCase.toFirstUpper»>>(data, headers);
			ResponseEntity<ResponsePlata<«e.name.toLowerCase.toFirstUpper»>> response =  rt.exchange(uri+"actualizar«e.name.toLowerCase.toFirstUpper»", HttpMethod.PUT,requestEntity, new ParameterizedTypeReference<ResponsePlata<«e.name.toLowerCase.toFirstUpper»>>(){});
			return response.getBody();
		}
	
		@Override
		public ResponsePlata<«e.name.toLowerCase.toFirstUpper»> eliminar(RequestPlata<«e.name.toLowerCase.toFirstUpper»> data, «e.name.toLowerCase.toFirstUpper» historical) {
			logger.info("Se recibio en el repository eliminar: {}", data.toString());
			RestTemplate rt = new RestTemplate();
			String uri = super.retrieveUri("services.url.mn");
			HttpHeaders headers = new HttpHeaders();
	        HttpEntity<RequestPlata<«e.name.toLowerCase.toFirstUpper»>> requestEntity = new HttpEntity<RequestPlata<«e.name.toLowerCase.toFirstUpper»>>(data, headers);
			ResponseEntity<ResponsePlata<«e.name.toLowerCase.toFirstUpper»>> response =  rt.exchange(uri+"eliminar«e.name.toLowerCase.toFirstUpper»", HttpMethod.PUT,requestEntity, new ParameterizedTypeReference<ResponsePlata<«e.name.toLowerCase.toFirstUpper»>>(){});
			return response.getBody();
		}
	
	}
	'''
	
}

