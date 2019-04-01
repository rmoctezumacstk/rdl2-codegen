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
import com.softtek.rdl2.EntityDateTimeField
import com.softtek.rdl2.EntityTimeField
import com.softtek.rdl2.EntityBooleanField
import org.eclipse.xtend.lib.annotations.Accessors

class CrudComponentJsGenerator {
	
	@Inject EntityFieldUtils entityFieldUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/configuracion/src/main/webapp/resources/js/"+m.name.toLowerCase+"/" + e.name.toLowerCase + ".js", e.genJavaJs(m))
			}
		}
	}
	
	/* Archivo Principal */
	def CharSequence genJavaJs(Entity e, Module m) '''
	var urlGlobal = "/configuracion/obtener«e.name.toLowerCase.toFirstUpper»s";
	«var state = new State(1)»
	
	$(document).ready(function() {
		
		crearCabeceras();
			
		$( function() {
		    $( "#dateExample" ).datepicker({ dateFormat: 'dd/mm/yy' });
		  } );
	
		tablaVacia();
		
		$('#mn-inp-nombre-«e.name.toLowerCase»').autocomplete({
			source : function(request, response) {
				$.ajax({
							url : "/configuracion/consultar«e.name.toLowerCase.toFirstUpper»Nombre",
							dataType : "json",
							type : 'POST',
							data : {
								term : request.term
							},
							success : function(data) {
								console.log(data);
								response(data);
							}
				});
			},
			minLength : 3
		});
		
		$('#cg-mod-agregar').on('shown.bs.modal', function () {
			cleanForm("formularioNew«e.name.toLowerCase.toFirstUpper»");
			$('#formularioNew«e.name.toLowerCase.toFirstUpper»').bootstrapValidator().data('bootstrapValidator').destroy();
		});
			
		$("#cg-but-agregar-guardar").click(function () {		
			$('#formularioNew«e.name.toLowerCase.toFirstUpper»').bootstrapValidator({
				onError: function(e) {
		            console.log('error al guardar «e.name.toLowerCase»');
		        }
	        }).on('success.form.bv', function(e) {
	            e.preventDefault();
	            var $form = $(e.target);
	            
	    		var id«e.name.toLowerCase.toFirstUpper» = Number($('input:radio[name=«e.name.toLowerCase»Radios]:checked').val());
	    		«FOR f : e.entity_fields»
					«f.getAttributeEntityJQuery(e)»
				«ENDFOR»
				
	    			
	    		var modelo = {
	    				"paginado":{
	    					"pagina":1,
	    					"registrosMostrados":10
	    				},
	    				"payload":{
					«state = new State(1)»
					
					"id«e.name.toLowerCase.toFirstUpper»": id«e.name.toLowerCase.toFirstUpper»,
					«FOR f : e.entity_fields»
					«IF f !== null && entityFieldUtils.isFieldRequired(f) && ( !(f instanceof EntityReferenceField) || (f instanceof EntityReferenceField && !(f as EntityReferenceField).upperBound.equals('*') ) ) »
						«IF state.getCounter() <= 1 »
						«f.getAttributeEntityLabelValue(e)»
						«ELSE»
						, «f.getAttributeEntityLabelValue(e)»
						«ENDIF»
					«ENDIF»
					«state.setCounter(state.getCounter()+1)»
					«ENDFOR»
					
	    					}
	    		};
	    		jsonAjax("/configuracion/agregar«e.name.toLowerCase.toFirstUpper»",modelo,validarRespuesta);
	    		$form.bootstrapValidator().data('bootstrapValidator').destroy();
	        });
			
			$('#dateExample').on('change', function (e) {
	            $('#formularioNew«e.name.toLowerCase.toFirstUpper»').bootstrapValidator('revalidateField', 'dateExample');
	        });
	
		});
		
		//Seleccionar «e.name.toLowerCase» por id
		$("#cg-but-actualizar").click(function() {
			cleanForm("formularioEdit«e.name.toLowerCase.toFirstUpper»");
			$('#formularioEdit«e.name.toLowerCase.toFirstUpper»').bootstrapValidator().data('bootstrapValidator').destroy();
			if($("input[name='radio']:radio").is(':checked')){
				var id = $('input:radio[name=radio]:checked').val();
				var modelo = {};
				jsonAjax("/configuracion/obtener«e.name.toLowerCase.toFirstUpper»/"+id,modelo,actualizar«e.name.toLowerCase.toFirstUpper»);
			}else{
				mostrarAlertWarning(MENSAJE_ERROR_OPEN_ACTUALIZAR);
			}
		});
		
		//Seleccionar «e.name.toLowerCase» por id
		$("#cg-but-eliminar").click(function() {
			
			if($("input[name='radio']:radio").is(':checked')){
				$("#cg-mensaje-eliminar").empty().append("&iquest;Desea eliminar el «e.name.toLowerCase» "+$('input:radio[name=radio]:checked').parents("tr").find("td").eq(1).html()+"?");
				$("#cg-mod-eliminar").modal('show');
			}else{
				mostrarAlertWarning(MENSAJE_ERROR_OPEN_ACTUALIZAR);
			}
		});
		
		$("#cg-but-buscar").click(function(e){
			var caracteres = " ' * \ / ( ) \" & ";
			var nombre = $("#mn-inp-nombre-«e.name.toLowerCase»").val();
			var indicador = $("#mn-sel-descripcion-estado-indicador").val();
			var medida = $("#mn-sel-descripcion-tipo-medida").val();		
			if(nombre != "" || indicador != 0 || medida !=0){
				$('#formBusquedar«e.name.toLowerCase.toFirstUpper»').bootstrapValidator({
					onError: function(e) {
			            console.log('error al guardar «e.name.toLowerCase»');
			        },
			        fields: {
			        	nombre«e.name.toLowerCase.toFirstUpper»: {
			                validators: {
			                    regexp: {
			                        regexp: /^[^\'\"\*\(\)\&\|\/\\]*$/,
			                        message: "No se permiten los caracteres:" + caracteres
			                    }
			                }
			            }
			        }
		        }).on('success.form.bv', function(e) {
		        	e.preventDefault();
		            var $form = $(e.target);
		        	var modelo = {
		    				"paginado":{
		    					"pagina":1,
		    					"registrosMostrados":Number($("#datostabla_length select").val())
		    				},
		    				"payload":{
							«state = new State(1)»
				    		«FOR f : e.entity_fields»
			    			«IF f !== null && entityFieldUtils.isFieldRequired(f) && ( !(f instanceof EntityReferenceField) || (f instanceof EntityReferenceField && !(f as EntityReferenceField).upperBound.equals('*') ) ) »
			    			«IF state.getCounter() <= 1 »
							«f.getAttributeEntitySearch(e)»
							«ELSE»
			    			, «f.getAttributeEntitySearch(e)»
							«ENDIF»
							«ENDIF»
							«state.setCounter(state.getCounter()+1)»
							«ENDFOR»
		    				}
		    		};
		        	jsonAjax(urlGlobal,modelo,validarRespuestaResponse);	
		        	$form.bootstrapValidator().data('bootstrapValidator').destroy();
		        })
				
			}else{
				e.preventDefault();
				mostrarAlertWarning(MENSAJE_CAMPOS_OBLIGATORIOS);
			}		
		});
		
		$("#cg-but-limpiar").click(function() {
			cleanForm("formBusquedar«e.name.toLowerCase.toFirstUpper»");
			$('#formBusquedar«e.name.toLowerCase.toFirstUpper»').bootstrapValidator().data('bootstrapValidator').destroy();
			tablaVacia();
		});
		
		$("#cg-editar-guardar").click(function() {
			$('#formularioEdit«e.name.toLowerCase.toFirstUpper»').bootstrapValidator({
				onError: function(e) {
		            console.log('error al guardar «e.name.toLowerCase»');
		        }
	        }).on('success.form.bv', function(e) {
	            e.preventDefault();
	            var $form = $(e.target);
		        var id«e.name.toLowerCase.toFirstUpper» = $('input:radio[name=radio]:checked').val();
	    		«FOR f : e.entity_fields»
					«f.getAttributeEntityJQuery(e)»
				«ENDFOR»
				
	    		var modelo = {
	    				"payload":{
					«state = new State(1)»
					
					"id«e.name.toLowerCase.toFirstUpper»": id«e.name.toLowerCase.toFirstUpper»,
					«FOR f : e.entity_fields»
					«IF f !== null && entityFieldUtils.isFieldRequired(f) && ( !(f instanceof EntityReferenceField) || (f instanceof EntityReferenceField && !(f as EntityReferenceField).upperBound.equals('*') ) ) »
						«IF state.getCounter() <= 1 »
						«f.getAttributeEntityLabelValue(e)»
						«ELSE»
						, «f.getAttributeEntityLabelValue(e)»
						«ENDIF»
					«ENDIF»
					«state.setCounter(state.getCounter()+1)»
					«ENDFOR»
	    				}
	    			};
				jsonAjax("/configuracion/actualizar«e.name.toLowerCase.toFirstUpper»",modelo,validarRespuestaActualizacion);
				$form.bootstrapValidator().data('bootstrapValidator').destroy();
	        });
		});
		
		
		$("#cg-eliminar-aceptar").click(function(){
			var id = Number($('input:radio[name=radio]:checked').val());
			var modelo = {};
			
			jsonAjax("/configuracion/eliminar«e.name.toLowerCase.toFirstUpper»/"+id,modelo,iniciarTabla);
			mostrarAlertSuccess(MENSAJE_ELIMINADO_EXITOSO);
			iniciarTabla();
			$(".cg-mod-eliminar").modal('hide');
		});
		
	});

	function validarRespuesta(data){
		if(data.codigoEstatus == 200){
			$("#formularioNew«e.name.toLowerCase.toFirstUpper»")[0].reset();
			$(".cg-mod-agregar").modal('hide');
			tablaVacia();
			mostrarAlertSuccess(MENSAJE_GUARDADO_EXITOSO);
		}else if(data.codigoEstatus == 415){
			mostrarAlertDanger(" "+ data.mensaje, 'alertDanger', "cg-but-agregar-guardar");
			bloquea("cg-but-agregar-guardar");
			return false;
		}
	}

	function validarRespuestaActualizacion(data){
		if(data.codigoEstatus == 200){
			$("#formularioNew«e.name.toLowerCase.toFirstUpper»")[0].reset();
			$(".cg-mod-editar").modal('hide');
			iniciarTabla();
			mostrarAlertSuccess(MENSAJE_ACTUALIZADO_EXITOSO);
		}else if(data.codigoEstatus == 415){
			console.log("BOTON: " + $("#cg-editar-guardar").is(":disabled"));
			mostrarAlertDanger(" "+ data.mensaje, 'alertDangerEdit');
			bloquea("cg-editar-guardar");
			return false;
		}
	}

	function validarRespuestaResponse(data){
		if(data.mensaje.codigoEstatus == 200){
			iniciarTabla(data);
		}else if(data.mensaje.codigoEstatus == 415){
			mostrarAlertDanger(" "+ data.mensaje.mensaje, 'alertDangerError');
		}
	}

	function bloquea(boton){
		if($("#"+boton).is(":disabled") == false){
		     boton.disabled = true; 
		     $("#"+boton).prop('disabled', true);
		     
		     setTimeout(function(){
		    	 $("#"+boton).prop('disabled', false);
		    }, 3000)
		}
	}

	function obtenerModelo(){
		var modelo = {
				«state = new State(1)»
	    		«FOR f : e.entity_fields»
	    			«IF state.getCounter() <= 1 »
					«f.getAttributeEntityJQuery(e)»
					«ELSE»
	    			, «f.getAttributeEntityJQuery(e)»
					«ENDIF»
					«state.setCounter(state.getCounter()+1)»
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
				"registrosMostrados":Number($("#datostabla_length select").val())
			},
			"payload":{
				«state = new State(1)»
	    		«FOR f : e.entity_fields»
	    			«IF state.getCounter() <= 1 »
					«f.getAttributeEntitySearch(e)»
					«ELSE»
	    			, «f.getAttributeEntitySearch(e)»
					«ENDIF»
					«state.setCounter(state.getCounter()+1)»
				«ENDFOR»
				}
			};
		jsonAjax(urlGlobal,modelo,inicioDatos);
	}

	function paginarTabla(pagina){
		var modelo = {
				"paginado":{
					"pagina":pagina,
					"registrosMostrados": Number($("#datostabla_length select").val())
				},
				"payload":{
					«state = new State(1)»
					«FOR f : e.entity_fields»
					«IF f !== null && entityFieldUtils.isFieldRequired(f) && ( !(f instanceof EntityReferenceField) || (f instanceof EntityReferenceField && !(f as EntityReferenceField).upperBound.equals('*') ) ) »
						«IF state.getCounter() <= 1 »
						«f.getAttributePaginarTabla(e)»
						«ELSE»
						, «f.getAttributePaginarTabla(e)»
						«ENDIF»
					«ENDIF»
					«state.setCounter(state.getCounter()+1)»
					«ENDFOR»
				}
			};
		console.log(modelo);
		jsonAjax("/configuracion/obtenerSemaforos",modelo,inicioDatos);
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
				if( f !== null && ( !(f instanceof EntityReferenceField) || (f instanceof EntityReferenceField && !(f as EntityReferenceField).upperBound.equals('*') ) ) ){
					ifValidation += operator + f.name.toLowerCase + "== \"\""	
				}
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
	def dispatch getAttributeEntityJQuery(EntityDateTimeField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQuery(EntityTimeField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQuery(EntityBooleanField f, Entity t)'''
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
	def dispatch getAttributeEntityJQueryEdit(EntityDateTimeField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»Edit').val();
	'''
	def dispatch getAttributeEntityJQueryEdit(EntityTimeField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»Edit').val();
	'''
	def dispatch getAttributeEntityJQueryEdit(EntityBooleanField f, Entity t)'''
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
	def dispatch getAttributeEntityLabelValue(EntityDateTimeField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»
	'''
	def dispatch getAttributeEntityLabelValue(EntityTimeField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»
	'''
	def dispatch getAttributeEntityLabelValue(EntityBooleanField f, Entity t)'''
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
	def dispatch getAttributeEntitySearch(EntityDateTimeField f, Entity t)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()		
	'''
	def dispatch getAttributeEntitySearch(EntityTimeField f, Entity t)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()		
	'''
	def dispatch getAttributeEntitySearch(EntityBooleanField f, Entity t)'''
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
	"«f.name.toLowerCase»" : ""
	'''
	def dispatch getAttributeValue(EntityLongTextField f, Entity t)'''
	"«f.name.toLowerCase»" : ""	
	'''
	def dispatch getAttributeValue(EntityDateField f, Entity t)'''
	"«f.name.toLowerCase»" : ""	
	'''
	def dispatch getAttributeValue(EntityDateTimeField f, Entity t)'''
	"«f.name.toLowerCase»" : ""	
	'''
	def dispatch getAttributeValue(EntityTimeField f, Entity t)'''
	"«f.name.toLowerCase»" : ""	
	'''
	def dispatch getAttributeValue(EntityBooleanField f, Entity t)'''
	"«f.name.toLowerCase»" : ""	
	'''
	def dispatch getAttributeValue(EntityImageField f, Entity t)'''
	"«f.name.toLowerCase»" : ""	
	'''
	def dispatch getAttributeValue(EntityFileField f, Entity t)'''
	"«f.name.toLowerCase»" : ""
	'''
	def dispatch getAttributeValue(EntityEmailField f, Entity t)'''
	"«f.name.toLowerCase»" : ""	
	'''
	def dispatch getAttributeValue(EntityDecimalField f, Entity t)'''
	"«f.name.toLowerCase»" : ""
	'''
	def dispatch getAttributeValue(EntityIntegerField f, Entity t)'''
	"«f.name.toLowerCase»" : 0	
	'''
	def dispatch getAttributeValue(EntityCurrencyField f, Entity t)'''
	"«f.name.toLowerCase»" : ""	
	'''	
	def dispatch getAttributeValue(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeEntityRefValue(f, t, f.name)»
	«ENDIF»
	'''
	def dispatch getAttributeEntityRefValue(Entity tr, EntityReferenceField f, Entity t, String name)'''
	"«tr.name.toLowerCase»" : {"id«tr.name.toLowerCase.toFirstUpper»": 0}
	'''
 	def dispatch getAttributeEntityRefValue(Enum tr, EntityReferenceField f, Entity t, String name)'''
	"«tr.name.toLowerCase»" : ""
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
	def dispatch getAttributeEntityClean(EntityDateTimeField f, Entity t)'''
	"«f.name.toLowerCase»": ""
	'''
	def dispatch getAttributeEntityClean(EntityTimeField f, Entity t)'''
	"«f.name.toLowerCase»": ""
	'''
	def dispatch getAttributeEntityClean(EntityBooleanField f, Entity t)'''
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
	"«f.name.toLowerCase»" : {"id«f.name.toLowerCase.toFirstUpper»": 0}
	«ENDIF»
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
	def dispatch getAttributeUpdate(EntityDateTimeField f, Entity t)'''
	$("#«f.name.toLowerCase»Edit").val(data.«f.name.toLowerCase»);
	'''
	def dispatch getAttributeUpdate(EntityTimeField f, Entity t)'''
	$("#«f.name.toLowerCase»Edit").val(data.«f.name.toLowerCase»);
	'''
	def dispatch getAttributeUpdate(EntityBooleanField f, Entity t)'''
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
	def dispatch getAttributeSearch(EntityDateTimeField f, Entity t)''''''
	def dispatch getAttributeSearch(EntityTimeField f, Entity t)''''''
	def dispatch getAttributeSearch(EntityBooleanField f, Entity t)''''''
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
	def dispatch getAttributePaginarTabla(EntityDateTimeField f, Entity t)'''"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()'''
	def dispatch getAttributePaginarTabla(EntityTimeField f, Entity t)'''"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()'''
	def dispatch getAttributePaginarTabla(EntityBooleanField f, Entity t)'''"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()'''
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
	"«tr.name.toLowerCase»" : {"id«tr.name.toLowerCase.toFirstUpper»": $("#«tr.name.toLowerCase»Semaf").val()}
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
	def dispatch getAttributeInicioDatos(EntityDateTimeField f, Entity t)'''{"data" : "«f.name.toLowerCase»", className: "dt-body-center"}'''
	def dispatch getAttributeInicioDatos(EntityTimeField f, Entity t)'''{"data" : "«f.name.toLowerCase»", className: "dt-body-center"}'''
	def dispatch getAttributeInicioDatos(EntityBooleanField f, Entity t)'''{"data" : "«f.name.toLowerCase»", className: "dt-body-center"}'''
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
	def dispatch getAttributeGetTable(EntityDateTimeField f, Entity t)'''{name:'«f.name.toLowerCase»', index:'«f.name.toLowerCase»', align:'center'}'''
	def dispatch getAttributeGetTable(EntityTimeField f, Entity t)'''{name:'«f.name.toLowerCase»', index:'«f.name.toLowerCase»', align:'center'}'''
	def dispatch getAttributeGetTable(EntityBooleanField f, Entity t)'''{name:'«f.name.toLowerCase»', index:'«f.name.toLowerCase»', align:'center'}'''
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
	def dispatch getAttributeTitle(EntityDateTimeField f, Entity t)'''
	'«entityFieldUtils.getFieldGlossaryName(f)»'
	'''
	def dispatch getAttributeTitle(EntityTimeField f, Entity t)'''
	'«entityFieldUtils.getFieldGlossaryName(f)»'
	'''
	def dispatch getAttributeTitle(EntityBooleanField f, Entity t)'''
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
	def dispatch getAttributeEntityJQueryAgregar(EntityDateTimeField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQueryAgregar(EntityTimeField f, Entity t)'''
		var «f.name.toLowerCase» = $('#«f.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQueryAgregar(EntityBooleanField f, Entity t)'''
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
		var «tr.name.toLowerCase» = $('#«tr.name.toLowerCase»New').val();
	'''
	def dispatch getAttributeEntityJQueryAgregar(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeEntityRefJQueryAgregar(f, t, f.name)»
	«ENDIF»	
	'''		
}

/**
 * Clase para generar funcionalidad de un contador y evitar que los incrementos del contador se pinten como parte de las plantillas.
 */
class State {
	@Accessors
	var int counter;
	
	new(int counter){
		this.counter = counter;
	}
}