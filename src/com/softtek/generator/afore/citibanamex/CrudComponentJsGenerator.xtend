package com.softtek.generator.afore.citibanamex

import javax.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity
import com.softtek.rdl2.Enum
import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.EntityTextField
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.generator.utils.EntityFieldUtils

class CrudComponentJsGenerator {
	
	@Inject EntityFieldUtils entityFieldUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/configuracion/src/main/webapp/resources/js/mn/" + e.name.toLowerCase + ".js", e.genJavaJs(m))
			}
		}
	}
	
	/* Archivo Principal */
	def CharSequence genJavaJs(Entity e, Module m) '''
	$(document).ready(function() {
		
		crearCabeceras();
			
		jsonAjax("/configuracion/obtener«e.name.toLowerCase.toFirstUpper»s",{"paginado":{"pagina":1,"registrosMostrados":10},"payload":{
			«FOR f : e.entity_fields»
				«f.getAttributeValue(e)»
			«ENDFOR»
		}},inicioDatos);
		
		urlGlobal = "/configuracion/obtener«e.name.toLowerCase.toFirstUpper»s";
		
		$("#agregar«e.name.toLowerCase.toFirstUpper»").click(function () {
			var validate = false;
			var id«e.name.toLowerCase.toFirstUpper» = Number($('input:radio[name=«e.name.toLowerCase.toFirstUpper»Radios]:checked').val());

			«FOR f : e.entity_fields»
				«f.getAttributeEntityJQueryAgregar(e)»
			«ENDFOR»
			
			var modelo = {
					"paginado":{
						"pagina":1,
						"registrosMostrados":10
					},
					"payload":{
						"id«e.name.toLowerCase.toFirstUpper»": id«e.name.toLowerCase.toFirstUpper», 
						«FOR f : e.entity_fields»
							«f.getAttributeEntityLabelValue(e)»
						«ENDFOR»
					}
			};
		
		    if(«getIfRequiredAttrbutes(e)»){
				$( "#formularioNew«e.name.toLowerCase.toFirstUpper»").last().addClass("was-validated");
			}else if(validate == false){
				jsonAjax("/configuracion/agregar«e.name.toLowerCase.toFirstUpper»",modelo,inicioDatos);
				mostrarAlertSuccess(MENSAJE_GUARDADO_EXITOSO);
				$("#formularioNew«e.name.toLowerCase.toFirstUpper»").reset();
				$(".modalNew«e.name.toLowerCase.toFirstUpper»").modal('hide');
			}

			
		});
		
		//Seleccionar «e.name.toLowerCase.toFirstUpper» por id
		$("#actualizar«e.name.toLowerCase.toFirstUpper»").click(function() {
			
			if($("input[name='radioIndex']:radio").is(':checked')){
				var id = $('input:radio[name=radioIndex]:checked').val();
				var modelo = {
						"payload":{
						"id«e.name.toLowerCase.toFirstUpper»": Number(id)
						}
				};
				jsonAjax("/configuracion/obtener«e.name.toLowerCase.toFirstUpper»",modelo,actualizar«e.name.toLowerCase.toFirstUpper»);
			}else{
				mostrarAlertWarning(MENSAJE_ERROR_OPEN_ACTUALIZAR);
			}
		});
		
		//Seleccionar «e.name.toLowerCase.toFirstUpper» por id
		$("#eliminar«e.name.toLowerCase.toFirstUpper»").click(function() {
			
			if($("input[name='radioIndex']:radio").is(':checked')){
				$("#eliminar«e.name.toLowerCase.toFirstUpper»Modal").modal('show');
			}else{
				mostrarAlertWarning(MENSAJE_ERROR_OPEN_ACTUALIZAR);
			}
		});
	
		
		$("#buscar").click(function(){
			
		«FOR f : e.entity_fields»
			«f.getAttributeSearch(e)»
		«ENDFOR»	
	
			var modelo = {
					"paginado":{
						"pagina":1,
						"registrosMostrados":10
					},
					"payload":{
					«FOR f : e.entity_fields SEPARATOR ","»
						«f.getAttributeEntitySearch(e)»
					«ENDFOR»						
					}
			};
			
			jsonAjax(urlGlobal,modelo,inicioDatos);
		});
		
		
		$("#limpiar").click(function() {
			cleanForm("formBusquedar«e.name.toLowerCase.toFirstUpper»");
			
			«FOR f : e.entity_fields»
				«f.getAttributeSearch(e)»
			«ENDFOR»	
			
			var modelo = {
					"paginado":{
						"pagina":1,
						"registrosMostrados":10
					},
					"payload":{
						«FOR f : e.entity_fields SEPARATOR ","»
							«f.getAttributeEntitySearch(e)»
						«ENDFOR»
					}									
			};
			
			jsonAjax(urlGlobal,modelo,inicioDatos);
		});
		
		
		$("#editar«e.name.toLowerCase.toFirstUpper»").click(function() {
			var validate = false;
			var id«e.name.toLowerCase.toFirstUpper» = $('input:radio[name=radioIndex]:checked').val();
			«FOR f : e.entity_fields»
				«f.getAttributeEntityJQueryEdit(e)»
			«ENDFOR»
			
			var modelo = {
					"payload":{
						"id«e.name.toLowerCase.toFirstUpper»": id«e.name.toLowerCase.toFirstUpper», 
						«FOR f : e.entity_fields SEPARATOR ","»
							«f.getAttributeEntityLabelValue(e)»
						«ENDFOR»
					}
				};
	
				if(«getIfRequiredAttrbutes(e)»){
					$( "#formularioEdit«e.name.toLowerCase.toFirstUpper»").last().addClass("was-validated");
				}else if(validate == false){
					jsonAjax("/configuracion/actualizar«e.name.toLowerCase.toFirstUpper»",modelo,inicioDatos);
					mostrarAlertSuccess(MENSAJE_ACTUALIZADO_EXITOSO);
					$("#formularioEdit«e.name.toLowerCase.toFirstUpper»").reset();
					$(".modal«e.name.toLowerCase.toFirstUpper»Editar").modal('hide');
				}
		});
		
		$("#eliminar«e.name.toLowerCase.toFirstUpper»Confirm").click(function(){
			var modelo = {
					"payload":{
						"id«e.name.toLowerCase.toFirstUpper»": Number($('input:radio[name=radioIndex]:checked').val())
					}
				};
			
			jsonAjax("/configuracion/eliminar«e.name.toLowerCase.toFirstUpper»",modelo,iniciarTabla);
			mostrarAlertSuccess(MENSAJE_ELIMINADO_EXITOSO);
			iniciarTabla();
			$(".eliminar«e.name.toLowerCase.toFirstUpper»Modal").modal('hide');
		});
	});
	
	function obtenerModelo(){
		var modelo = {
				«FOR f : e.entity_fields SEPARATOR ","»
					«f.getAttributeEntitySearch(e)»
				«ENDFOR»
			}
		console.log
		return modelo;
	}
	
	function cleanForm(name){
		document.getElementById(name).reset();
		$("#"+name).removeClass("was-validated");
	}
	
	function iniciarTabla(){
		var modelo = {
				"paginado":{
				"pagina":1,
				"registrosMostrados":10
			},
			"payload":{
				«FOR f : e.entity_fields SEPARATOR ","»
					«f.getAttributeValue(e)»
				«ENDFOR»				
				}
			};
		jsonAjax(urlGlobal,modelo,inicioDatos);
	}
	
	function actualizar«e.name.toLowerCase.toFirstUpper»(info){
		var data = info.payload;
		«FOR f : e.entity_fields»
			«f.getAttributeUpdate(e)»
		«ENDFOR»
		$('.modal«e.name.toLowerCase.toFirstUpper»Editar').modal('show');
	}
	
	function paginarTabla(pagina){
		var modelo = {
				"paginado":{
					"pagina":pagina,
					"registrosMostrados":Number($("#datostabla_length select").val())
				},
				"payload":{
					«FOR f : e.entity_fields SEPARATOR ","»
					«f.getAttributePaginarTabla(e)»
					«ENDFOR»
				}
			};
		console.log(modelo);
		jsonAjax("/configuracion/obtener«e.name.toLowerCase.toFirstUpper»s",modelo,inicioDatos);
	}	
	
	'''
	/* ./Archivo Principal */
	
	
	def dispatch getIfRequiredAttrbutes(Entity e){
		var isFirst = true
		var ifValidation = ""
		
		for( f : e.entity_fields ){
			var operator = " || "
			
			if( isFirst ){
				operator = ""
				isFirst = false
			}
		
			if( entityFieldUtils.isFieldRequired(f) ){
				ifValidation += operator + f.name.toLowerCase + "== \"\""
			}
		}
		
		return ifValidation
	}
	
	//---------------------------------------------------------------------------------------------------
	//--------------------------------- CODIGO PARA GENERAR EVENTOS JQUERY NEW ------------------------------
	//---------------------------------------------------------------------------------------------------
	
	def dispatch getAttributeEntityJQuery(EntityTextField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	
	def dispatch getAttributeEntityJQuery(EntityLongTextField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQuery(EntityDateField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQuery(EntityImageField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQuery(EntityFileField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQuery(EntityEmailField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQuery(EntityDecimalField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();		
	'''
	def dispatch getAttributeEntityJQuery(EntityIntegerField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQuery(EntityCurrencyField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''	
	def dispatch getAttributeEntityRefJQuery(Entity tr, EntityReferenceField f, Entity t, String name)'''
		var «name.toLowerCase» = Number($("#«name.toLowerCase»New").val());
	'''
 	def dispatch getAttributeEntityRefJQuery(Enum tr, EntityReferenceField f, Entity t, String name)'''
		var «tr.name.toLowerCase» = $('#«tr.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQuery(EntityReferenceField f, Entity t)'''
		«IF  f !== null && !f.upperBound.equals('*')»
			«f.superType.getAttributeEntityRefJQuery(f, t, f.name)»
		«ENDIF»
	'''	
	//---------------------------------------------------------------------------------------------------
	//--------------------------------- CODIGO PARA GENERAR EVENTOS JQUERY EDIT------------------------------
	//---------------------------------------------------------------------------------------------------

	
	def dispatch getAttributeEntityJQueryEdit(EntityTextField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»Edit').val();
	'''
	
	def dispatch getAttributeEntityJQueryEdit(EntityLongTextField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»Edit').val();
	'''
	def dispatch getAttributeEntityJQueryEdit(EntityDateField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»Edit').val();
	'''
	def dispatch getAttributeEntityJQueryEdit(EntityImageField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»Edit').val();
	'''
	def dispatch getAttributeEntityJQueryEdit(EntityFileField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»Edit').val();
	'''
	def dispatch getAttributeEntityJQueryEdit(EntityEmailField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»Edit').val();
	'''
	def dispatch getAttributeEntityJQueryEdit(EntityDecimalField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»Edit').val();		
	'''
	def dispatch getAttributeEntityJQueryEdit(EntityIntegerField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»Edit').val();
	'''
	def dispatch getAttributeEntityJQueryEdit(EntityCurrencyField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»Edit').val();
	'''		
	def dispatch getAttributeEntityRefJQueryEdit(Entity tr, EntityReferenceField f, Entity t, String name)'''
		var «tr.name.toLowerCase» = Number($("#«tr.name.toLowerCase»Edit").val());
	'''
 	def dispatch getAttributeEntityRefJQueryEdit(Enum tr, EntityReferenceField f, Entity t, String name)'''
		var «tr.name.toLowerCase» = $('#«tr.name.toLowerCase»Edit').val();
	'''
	def dispatch getAttributeEntityJQueryEdit(EntityReferenceField f, Entity t)'''
		«IF  f !== null && !f.upperBound.equals('*')»
			«f.superType.getAttributeEntityRefJQueryEdit(f, t, f.name)»
		«ENDIF»
	'''
	
	//----------------------------------------------------------------------------------------------------
	//--------------------------------- CODIGO PARA GENERAR LABELS - VALUES ------------------------------
	//----------------------------------------------------------------------------------------------------
	
	def dispatch getAttributeEntityLabelValue(EntityTextField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»
	'''
	def dispatch getAttributeEntityLabelValue(EntityLongTextField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»
	'''
	def dispatch getAttributeEntityLabelValue(EntityDateField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»
	'''
	def dispatch getAttributeEntityLabelValue(EntityImageField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»
	'''
	def dispatch getAttributeEntityLabelValue(EntityFileField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»
	'''
	def dispatch getAttributeEntityLabelValue(EntityEmailField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»
	'''
	def dispatch getAttributeEntityLabelValue(EntityDecimalField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»
	'''
	def dispatch getAttributeEntityLabelValue(EntityIntegerField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»
	'''
	def dispatch getAttributeEntityLabelValue(EntityCurrencyField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»
	'''
	def dispatch getAttributeEntityRefLabelValue(Entity tr, EntityReferenceField f, Entity t, String name)'''
		"«name.toLowerCase»":  {
			"id«name.toLowerCase.toFirstUpper»": «name.toLowerCase»
		}
	'''
 	def dispatch getAttributeEntityRefLabelValue(Enum tr, EntityReferenceField f, Entity t, String name)'''
		"«tr.name.toLowerCase»" : «tr.name.toLowerCase»
	'''
	def dispatch getAttributeEntityLabelValue(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeEntityRefLabelValue(f, t, f.name)»
	«ENDIF»
	'''	

	/* getAttributeEntitySearch */
	def dispatch getAttributeEntitySearch(EntityTextField f, Entity t)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()	
	'''
	def dispatch getAttributeEntitySearch(EntityLongTextField f, Entity t)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()		
	'''
	def dispatch getAttributeEntitySearch(EntityDateField f, Entity t)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()		
	'''
	def dispatch getAttributeEntitySearch(EntityImageField f, Entity t)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()		
	'''
	def dispatch getAttributeEntitySearch(EntityFileField f, Entity t)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()		
	'''
	def dispatch getAttributeEntitySearch(EntityEmailField f, Entity t)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()		
	'''
	def dispatch getAttributeEntitySearch(EntityDecimalField f, Entity t)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()		
	'''
	def dispatch getAttributeEntitySearch(EntityIntegerField f, Entity t)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()		
	'''
	def dispatch getAttributeEntitySearch(EntityCurrencyField f, Entity t)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()		
	'''	
	def dispatch getAttributeEntityRefLabelValueSearch(Entity tr, EntityReferenceField f, Entity t, String name)'''
	"«tr.name.toLowerCase»" : {"id«tr.name.toLowerCase.toFirstUpper»": «tr.name.toLowerCase»}	
	'''
 	def dispatch getAttributeEntityRefLabelValueSearch(Enum tr, EntityReferenceField f, Entity t, String name)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()		
	'''
	
	def dispatch getAttributeEntitySearch(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeEntityRefLabelValueSearch(f, t, f.name)»
	«ENDIF»	
	'''
	
	/* getAttributeValue */
	def dispatch getAttributeValue(EntityTextField f, Entity t)'''
	"«f.name.toLowerCase»" : "",
	'''
	def dispatch getAttributeValue(EntityLongTextField f, Entity t)'''
	"«f.name.toLowerCase»" : "",
	'''
	def dispatch getAttributeValue(EntityDateField f, Entity t)'''
	"«f.name.toLowerCase»" : "",	
	'''
	def dispatch getAttributeValue(EntityImageField f, Entity t)'''
	"«f.name.toLowerCase»" : "",	
	'''
	def dispatch getAttributeValue(EntityFileField f, Entity t)'''
	"«f.name.toLowerCase»" : "",
	'''
	def dispatch getAttributeValue(EntityEmailField f, Entity t)'''
	"«f.name.toLowerCase»" : "",	
	'''
	def dispatch getAttributeValue(EntityDecimalField f, Entity t)'''
	"«f.name.toLowerCase»" : "",
	'''
	def dispatch getAttributeValue(EntityIntegerField f, Entity t)'''
	"«f.name.toLowerCase»" : 0,	
	'''
	def dispatch getAttributeValue(EntityCurrencyField f, Entity t)'''
	"«f.name.toLowerCase»" : "",	
	'''	
	def dispatch getAttributeValue(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeEntityRefValue(f, t, f.name)»
	«ENDIF»
	'''
	def dispatch getAttributeEntityRefValue(Entity tr, EntityReferenceField f, Entity t, String name)'''
	"«tr.name.toLowerCase»" : {"id«tr.name.toLowerCase.toFirstUpper»": 0},
	'''
 	def dispatch getAttributeEntityRefValue(Enum tr, EntityReferenceField f, Entity t, String name)'''
	"«tr.name.toLowerCase»" : {"cve«tr.name.toLowerCase.toFirstUpper»": 0},
	'''
	
	/* getAttributeEntityClean */
	def dispatch getAttributeEntityClean(EntityTextField f, Entity t)'''
	"«f.name.toLowerCase»": ""
	'''
	def dispatch getAttributeEntityClean(EntityLongTextField f, Entity t)'''
	"«f.name.toLowerCase»": ""
	'''
	def dispatch getAttributeEntityClean(EntityDateField f, Entity t)'''
	"«f.name.toLowerCase»": ""
	'''
	def dispatch getAttributeEntityClean(EntityImageField f, Entity t)'''
	"«f.name.toLowerCase»": ""
	'''
	def dispatch getAttributeEntityClean(EntityFileField f, Entity t)'''
	"«f.name.toLowerCase»": ""
	'''
	def dispatch getAttributeEntityClean(EntityEmailField f, Entity t)'''
	"«f.name.toLowerCase»": ""
	'''
	def dispatch getAttributeEntityClean(EntityDecimalField f, Entity t)'''
	"«f.name.toLowerCase»": ""
	'''
	def dispatch getAttributeEntityClean(EntityIntegerField f, Entity t)'''
	"«f.name.toLowerCase»": ""
	'''
	def dispatch getAttributeEntityClean(EntityCurrencyField f, Entity t)'''
	"«f.name.toLowerCase»": ""
	'''	
	def dispatch getAttributeEntityClean(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeEntityRefClean(f, t, f.name)»
	«ENDIF»
	'''	

	def dispatch getAttributeEntityRefClean(Entity tr, EntityReferenceField f, Entity t, String name)'''
	"«f.name.toLowerCase»" : {"id«f.name.toLowerCase.toFirstUpper»": 0}
	'''
 	def dispatch getAttributeEntityRefClean(Enum tr, EntityReferenceField f, Entity t, String name)'''
	"«name.toLowerCase»" : {"id«name.toLowerCase.toFirstUpper»": 0}
	'''	
	
	/* getAttributeUpdate */
	def dispatch getAttributeUpdate(EntityTextField f, Entity t)'''
	$("#«f.name.toLowerCase»Edit").val(data.«f.name.toLowerCase»);
	'''
	def dispatch getAttributeUpdate(EntityLongTextField f, Entity t)'''
	$("#«f.name.toLowerCase»Edit").val(data.«f.name.toLowerCase»);
	'''
	def dispatch getAttributeUpdate(EntityDateField f, Entity t)'''
	$("#«f.name.toLowerCase»Edit").val(data.«f.name.toLowerCase»);
	'''
	def dispatch getAttributeUpdate(EntityImageField f, Entity t)'''
	$("#«f.name.toLowerCase»Edit").val(data.«f.name.toLowerCase»);
	'''
	def dispatch getAttributeUpdate(EntityFileField f, Entity t)'''
	$("#«f.name.toLowerCase»Edit").val(data.«f.name.toLowerCase»);
	'''
	def dispatch getAttributeUpdate(EntityEmailField f, Entity t)'''
	$("#«f.name.toLowerCase»Edit").val(data.«f.name.toLowerCase»);
	'''
	def dispatch getAttributeUpdate(EntityDecimalField f, Entity t)'''
	$("#«f.name.toLowerCase»Edit").val(data.«f.name.toLowerCase»);
	'''
	def dispatch getAttributeUpdate(EntityIntegerField f, Entity t)'''
	$("#«f.name.toLowerCase»Edit").val(data.«f.name.toLowerCase»);
	'''
	def dispatch getAttributeUpdate(EntityCurrencyField f, Entity t)'''
	$("#«f.name.toLowerCase»Edit").val(data.«f.name.toLowerCase»);
	'''	
	
	def dispatch getAttributeRefUpdate(Entity tr, EntityReferenceField f, Entity t, String name)'''
	$("#«tr.name.toLowerCase»Edit").val(data.«f.name.toLowerCase»);
	'''
 	def dispatch getAttributeRefUpdate(Enum tr, EntityReferenceField f, Entity t, String name)'''
	$("#«tr.name.toLowerCase»Edit").val(data.«f.name.toLowerCase»);
	'''
	
	def dispatch getAttributeUpdate(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeRefUpdate(f, t, f.name)»
	«ENDIF»	
	'''
	
	/* getAttributeSearch */
	def dispatch getAttributeSearch(EntityTextField f, Entity t)''''''
	def dispatch getAttributeSearch(EntityLongTextField f, Entity t)''''''
	def dispatch getAttributeSearch(EntityDateField f, Entity t)''''''
	def dispatch getAttributeSearch(EntityImageField f, Entity t)''''''
	def dispatch getAttributeSearch(EntityFileField f, Entity t)''''''
	def dispatch getAttributeSearch(EntityEmailField f, Entity t)''''''
	def dispatch getAttributeSearch(EntityDecimalField f, Entity t)''''''
	def dispatch getAttributeSearch(EntityIntegerField f, Entity t)''''''
	def dispatch getAttributeSearch(EntityCurrencyField f, Entity t)''''''
	
	def dispatch getAttributeRefSearch(Entity tr, EntityReferenceField f, Entity t, String name)'''
	var «tr.name.toLowerCase» = Number($("#«tr.name.toLowerCase»Semaf").val());
	'''
 	def dispatch getAttributeRefSearch(Enum tr, EntityReferenceField f, Entity t, String name)'''
	
	'''
	def dispatch getAttributeSearch(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeRefSearch(f, t, f.name)»
	«ENDIF»	
	'''
	
	/* getAttributePaginarTabla */
	def dispatch getAttributePaginarTabla(EntityTextField f, Entity t)'''"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()'''
	def dispatch getAttributePaginarTabla(EntityLongTextField f, Entity t)'''"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()'''
	def dispatch getAttributePaginarTabla(EntityDateField f, Entity t)'''"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()'''
	def dispatch getAttributePaginarTabla(EntityImageField f, Entity t)'''"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()'''
	def dispatch getAttributePaginarTabla(EntityFileField f, Entity t)'''"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()'''
	def dispatch getAttributePaginarTabla(EntityEmailField f, Entity t)'''"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()'''
	def dispatch getAttributePaginarTabla(EntityDecimalField f, Entity t)'''"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()'''
	def dispatch getAttributePaginarTabla(EntityIntegerField f, Entity t)'''"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()'''
	def dispatch getAttributePaginarTabla(EntityCurrencyField f, Entity t)'''"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()'''
	
	def dispatch getAttributeRefPaginarTabla(Entity tr, EntityReferenceField f, Entity t, String name)'''
	"«tr.name.toLowerCase»" : {"id«tr.name.toLowerCase.toFirstUpper»": $("#«tr.name.toLowerCase»Semaf").val()}	
	'''
 	def dispatch getAttributeRefPaginarTabla(Enum tr, EntityReferenceField f, Entity t, String name)'''
	
	'''
	def dispatch getAttributePaginarTabla(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeRefPaginarTabla(f, t, f.name)»
	«ENDIF»	
	'''	
	
	/* getAttributeInicioDatos */
	def dispatch getAttributeInicioDatos(EntityTextField f, Entity t)'''{"data" : "«f.name.toLowerCase»", className: "dt-body-center"}'''
	def dispatch getAttributeInicioDatos(EntityLongTextField f, Entity t)'''{"data" : "«f.name.toLowerCase»", className: "dt-body-center"}'''
	def dispatch getAttributeInicioDatos(EntityDateField f, Entity t)'''{"data" : "«f.name.toLowerCase»", className: "dt-body-center"}'''
	def dispatch getAttributeInicioDatos(EntityImageField f, Entity t)'''{"data" : "«f.name.toLowerCase»", className: "dt-body-center"}'''
	def dispatch getAttributeInicioDatos(EntityFileField f, Entity t)'''{"data" : "«f.name.toLowerCase»", className: "dt-body-center"}'''
	def dispatch getAttributeInicioDatos(EntityEmailField f, Entity t)'''{"data" : "«f.name.toLowerCase»", className: "dt-body-center"}'''
	def dispatch getAttributeInicioDatos(EntityDecimalField f, Entity t)'''{"data" : "«f.name.toLowerCase»", className: "dt-body-center"}'''
	def dispatch getAttributeInicioDatos(EntityIntegerField f, Entity t)'''{"data" : "«f.name.toLowerCase»", className: "dt-body-center"}'''
	def dispatch getAttributeInicioDatos(EntityCurrencyField f, Entity t)'''{"data" : "«f.name.toLowerCase»", className: "dt-body-center"}'''
	
	def dispatch getAttributeRefInicioDatos(Entity tr, EntityReferenceField f, Entity t, String name)
	'''{"data" : "«f.name.toLowerCase».descripcion", className: "dt-body-center"}'''
	
 	def dispatch getAttributeRefInicioDatos(Enum tr, EntityReferenceField f, Entity t, String name)'''
	'''
	def dispatch getAttributeInicioDatos(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeRefInicioDatos(f, t, f.name)»
	«ENDIF»	
	'''	
	
	/* getAttributeGetTable */
	def dispatch getAttributeGetTable(EntityTextField f, Entity t)'''{name:'«f.name.toLowerCase»', index:'«f.name.toLowerCase»', align:'center'}'''
	def dispatch getAttributeGetTable(EntityLongTextField f, Entity t)'''{name:'«f.name.toLowerCase»', index:'«f.name.toLowerCase»', align:'center'}'''
	def dispatch getAttributeGetTable(EntityDateField f, Entity t)'''{name:'«f.name.toLowerCase»', index:'«f.name.toLowerCase»', align:'center'}'''
	def dispatch getAttributeGetTable(EntityImageField f, Entity t)'''{name:'«f.name.toLowerCase»', index:'«f.name.toLowerCase»', align:'center'}'''
	def dispatch getAttributeGetTable(EntityFileField f, Entity t)'''{name:'«f.name.toLowerCase»', index:'«f.name.toLowerCase»', align:'center'}'''
	def dispatch getAttributeGetTable(EntityEmailField f, Entity t)'''{name:'«f.name.toLowerCase»', index:'«f.name.toLowerCase»', align:'center'}'''
	def dispatch getAttributeGetTable(EntityDecimalField f, Entity t)'''{name:'«f.name.toLowerCase»', index:'«f.name.toLowerCase»', align:'center'}'''
	def dispatch getAttributeGetTable(EntityIntegerField f, Entity t)'''{name:'«f.name.toLowerCase»', index:'«f.name.toLowerCase»', align:'center'}'''
	def dispatch getAttributeGetTable(EntityCurrencyField f, Entity t)'''{name:'«f.name.toLowerCase»', index:'«f.name.toLowerCase»', align:'center'}'''
	
	def dispatch getAttributeRefGetTable(Entity tr, EntityReferenceField f, Entity t, String name)
	'''{name:'«tr.name.toLowerCase»', index:'«tr.name.toLowerCase»', align:'center'}'''
	
 	def dispatch getAttributeRefGetTable(Enum tr, EntityReferenceField f, Entity t, String name)'''
	'''
	def dispatch getAttributeGetTable(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeRefGetTable(f, t, f.name)»
	«ENDIF»	
	'''	
	
	/* Get Attribute Field */
	def dispatch getAttributeTitle(EntityTextField f, Entity t)'''
	'«entityFieldUtils.getFieldGlossaryName(f)»'
	'''
	def dispatch getAttributeTitle(EntityLongTextField f, Entity t)'''
	'«entityFieldUtils.getFieldGlossaryName(f)»'
	'''
	def dispatch getAttributeTitle(EntityDateField f, Entity t)'''
	'«entityFieldUtils.getFieldGlossaryName(f)»'
	'''
	def dispatch getAttributeTitle(EntityImageField f, Entity t)'''
	'«entityFieldUtils.getFieldGlossaryName(f)»'
	'''
	def dispatch getAttributeTitle(EntityFileField f, Entity t)'''
	'«entityFieldUtils.getFieldGlossaryName(f)»'
	'''
	def dispatch getAttributeTitle(EntityEmailField f, Entity t)'''
	'«entityFieldUtils.getFieldGlossaryName(f)»'
	'''
	def dispatch getAttributeTitle(EntityDecimalField f, Entity t)'''
	'«entityFieldUtils.getFieldGlossaryName(f)»'
	'''
	def dispatch getAttributeTitle(EntityIntegerField f, Entity t)'''
	'«entityFieldUtils.getFieldGlossaryName(f)»'
	'''
	def dispatch getAttributeTitle(EntityCurrencyField f, Entity t)'''
	'«entityFieldUtils.getFieldGlossaryName(f)»'
	'''	
	def dispatch getAttributeTitle(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
	'«entityFieldUtils.getFieldGlossaryName(f)»'
	«ENDIF»
	'''	
	
	/* getAttributeEntityJQueryAgregar */
	def dispatch getAttributeEntityJQueryAgregar(EntityTextField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQueryAgregar(EntityLongTextField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQueryAgregar(EntityDateField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQueryAgregar(EntityImageField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQueryAgregar(EntityFileField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQueryAgregar(EntityEmailField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQueryAgregar(EntityDecimalField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();		
	'''
	def dispatch getAttributeEntityJQueryAgregar(EntityIntegerField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQueryAgregar(EntityCurrencyField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''	
	def dispatch getAttributeEntityRefJQueryAgregar(Entity tr, EntityReferenceField f, Entity t, String name)'''
		var «name.toLowerCase» = Number($("#«name.toLowerCase»New").val());
	'''
 	def dispatch getAttributeEntityRefJQueryAgregar(Enum tr, EntityReferenceField f, Entity t, String name)'''
		var «tr.name.toLowerCase» = Number($('#«tr.name.toLowerCase»New').val());
	'''
	def dispatch getAttributeEntityJQueryAgregar(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeEntityRefJQueryAgregar(f, t, f.name)»
	«ENDIF»	
	'''	
	
}