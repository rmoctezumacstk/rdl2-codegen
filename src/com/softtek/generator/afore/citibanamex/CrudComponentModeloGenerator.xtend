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

class CrudComponentModeloGenerator {
	
	@Inject EntityFieldUtils entityFieldUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/webapp/resources/js/modelo" + e.name.toLowerCase.toFirstUpper + ".js", e.genJavaJs(m))
			}
		}
	}
	
	def CharSequence genJavaJs(Entity e, Module m) '''
	/* 
	 * Numero de version: 1.0
	 * Fecha: 22/02/2019
	 * Copyright:  
	 * 
	 */
	
	//Componentes Genéricos 5.5
	
	(function() {
		'use strict';
		window.addEventListener('load', function() {
			var forms = document.getElementsByClassName('needs-validation');
			Array.prototype.filter.call(forms, function(form) {
				form.addEventListener('submit', function(event) {
					if (form.checkValidity() === false) {
						event.preventDefault();
						event.stopPropagation();
					}
					form.classList.add('was-validated');
				}, false);
			});
		}, false);
	})();
	
	function enableButton(name, status){
		$("#"+name).prop("disabled", status);
	}
	
	function cleanForm(name){
		document.getElementById(name).reset();
		$("#"+name).removeClass("was-validated");
	}
	
	function tableClean(id){
		$('#'+id).remove();  
	}
	
	function methodGenericPost(path, model){
		jQuery.post(path, model, "json").done(function(data) {
			location.reload();
		});
	}
	
	$(window).on("resize", function () {
	    var $grid = $("#grid");
	    var newWidth = $grid.closest(".ui-jqgrid").parent().width();
	    $grid.jqGrid("setGridWidth", newWidth, true);
	});
	
	
	$(document).ready(function() {
		
		$('#«e.name.toLowerCase»').DataTable({
	        "searching": false,
	        language: {
	            "decimal": "",
	            "emptyTable": "No hay información",
	            "info": "Mostrando _START_ a _END_ de _TOTAL_ registros",
	            "infoEmpty": "Mostrando 0 to 0 of 0 registros",
	            "infoFiltered": "(Filtrado de _MAX_ total registros)",
	            "infoPostFix": "",
	            "thousands": ",",
	            "lengthMenu": "Mostrar _MENU_ registros",
	            "loadingRecords": "Cargando...",
	            "processing": "Procesando...",
	            "search": "Buscar:",
	            "zeroRecords": "Sin resultados encontrados",
	            "paginate": {
	                "first": "Primero",
	                "last": "Ultimo",
	                "next": "Siguiente",
	                "previous": "Anterior"
	            }
	        }
	    });
	
		jsonAjax("/componentesGenerales/obtener«e.name.toLowerCase.toFirstUpper»ss",{"pagina":1,"filas":10,"payload":{"nombre" : "","estadoIndicador" : {"cveEdoIndicador": 0},"tipoMedida" : {"cveTipoMedida": 0}}},inicioDatos);
	
		//Guardar un «e.name.toLowerCase»
		$("#agregar«e.name.toLowerCase.toFirstUpper»").click(function () {
			var validate = false;
			var id«e.name.toLowerCase.toFirstUpper» = Number($('input:radio[name=«e.name.toLowerCase»Radios]:checked').val());
			
			«FOR f : e.entity_fields»
				«f.getAttributeEntityJQuery(e)»
			«ENDFOR»

			var modelo = {"id«e.name.toLowerCase.toFirstUpper»": id«e.name.toLowerCase.toFirstUpper», 
				«FOR f : e.entity_fields»
					«f.getAttributeEntityLabelValue(e)»
				«ENDFOR»
			};

		    if(«getIfRequiredAttrbutes(e)»){
				$( "#formularioNew«e.name.toLowerCase.toFirstUpper»").last().addClass("was-validated");
			}else if(validate == false){
				jsonAjax("/componentesGenerales/agregar«e.name.toLowerCase.toFirstUpper»",modelo,inicioDatos);
				mostrarAlertSuccess(MENSAJE_GUARDADO_EXITOSO);
				$("#formularioNew«e.name.toLowerCase.toFirstUpper»").reset();
				$(".modalNew«e.name.toLowerCase.toFirstUpper»").modal('hide');
			}
			
		});
		
		//Seleccionar «e.name.toLowerCase» por id
		$("#actualizar«e.name.toLowerCase.toFirstUpper»").click(function() {
			
			if($("input[name='radio«e.name.toLowerCase.toFirstUpper»s']:radio").is(':checked')){
				var id = $('input:radio[name=radio«e.name.toLowerCase.toFirstUpper»s]:checked').val();
				var modelo = {
						"id«e.name.toLowerCase.toFirstUpper»": Number(id)
				};
				jsonAjax("/componentesGenerales/obtener«e.name.toLowerCase.toFirstUpper»",modelo,actualizar«e.name.toLowerCase.toFirstUpper»);
			}else{
				mostrarAlertWarning(MENSAJE_ERROR_OPEN_ACTUALIZAR);
			}
		});
		
		//Seleccionar «e.name.toLowerCase» por id
		$("#eliminar«e.name.toLowerCase.toFirstUpper»").click(function() {
			
			if($("input[name='radio«e.name.toLowerCase.toFirstUpper»s']:radio").is(':checked')){
				$("#eliminar«e.name.toLowerCase.toFirstUpper»Modal").modal('show');
			}else{
				mostrarAlertWarning(MENSAJE_ERROR_OPEN_ACTUALIZAR);
			}
		});
	
		
		$("#buscar").click(function(){
			var modelo = {
					"pagina":1,
					"filas":10,
					"payload":{
					«FOR f : e.entity_fields SEPARATOR ","»
						«f.getAttributeEntitySearch(e)»
					«ENDFOR»	
					}
			};
			
	
			
			
			
			jsonAjax("/componentesGenerales/obtener«e.name.toLowerCase.toFirstUpper»s",modelo,inicioDatos);
		});
		
		
		$("#limpiar").click(function() {
			cleanForm("formBusquedar«e.name.toLowerCase.toFirstUpper»");
			var modelo = {
					"pagina":1,
					"filas":10,
					"payload":{
						«FOR f : e.entity_fields SEPARATOR ","»
							«f.getAttributeEntitySearch(e)»
						«ENDFOR»	
						}
			};
			
			var modelo0 = {
					"pagina":1,
					"filas":10,
					"payload":{
						«FOR f : e.entity_fields SEPARATOR ","»
							«f.getAttributeEntitySearch(e)»
						«ENDFOR»	
						}
					};
			
			jsonAjax("/componentesGenerales/obtener«e.name.toLowerCase.toFirstUpper»s",modelo,inicioDatos);
		});
		
		
		$("#editar«e.name.toLowerCase.toFirstUpper»").click(function() {
			var validate = false;
			var id«e.name.toLowerCase.toFirstUpper» = $('input:radio[name=radio«e.name.toLowerCase.toFirstUpper»s]:checked').val();

			«FOR f : e.entity_fields»
				«f.getAttributeEntityJQuery(e)»
			«ENDFOR»
			
			var modelo = {"id«e.name.toLowerCase.toFirstUpper»": id«e.name.toLowerCase.toFirstUpper», 
						«FOR f : e.entity_fields»
							«f.getAttributeEntityLabelValue(e)»
						«ENDFOR»
					};
	
				if(«getIfRequiredAttrbutes(e)»){
					$( "#formularioEdit«e.name.toLowerCase.toFirstUpper»").last().addClass("was-validated");
				}else if(validate == false){
					jsonAjax("/componentesGenerales/actualizar«e.name.toLowerCase.toFirstUpper»",modelo,inicioDatos);
					mostrarAlertSuccess(MENSAJE_ACTUALIZADO_EXITOSO);
					$("#formularioEdit«e.name.toLowerCase.toFirstUpper»").reset();
					$(".modal«e.name.toLowerCase.toFirstUpper»Editar").modal('hide');
				}
		});
		
		$("#eliminar«e.name.toLowerCase.toFirstUpper»Confirm").click(function(){
			var modelo = {
						"id«e.name.toLowerCase.toFirstUpper»": Number($('input:radio[name=radio«e.name.toLowerCase.toFirstUpper»s]:checked').val())
				};
			
			jsonAjax("/componentesGenerales/eliminar«e.name.toLowerCase.toFirstUpper»",modelo,iniciarTabla);
			mostrarAlertSuccess(MENSAJE_ELIMINADO_EXITOSO);
			iniciarTabla();
			$(".eliminar«e.name.toLowerCase.toFirstUpper»Modal").modal('hide');
		});
	});
	
	function iniciarTabla(){
		var modelo = {
				"pagina":1,
				"filas":10,
				"payload":{
					"nombre": "",
					"estadoIndicador" : {
						"cveEdoIndicador": 0
						},
					"tipoMedida" : {
						"cveTipoMedida": 0
						}
				}
			};
		jsonAjax("/componentesGenerales/obtener«e.name.toLowerCase.toFirstUpper»s",modelo,inicioDatos);
	}
	
	function paginarTabla(pagina){
		var modelo = {
				"pagina":pagina,
				"filas":$("#«e.name.toLowerCase»_length select").val(),
				"payload":{
					"nombre": $("#nombreSemaf").val(),
					"estadoIndicador" : {
						"cveEdoIndicador": Number($("#descripcionEdoIndicador").val())
						},
					"tipoMedida" : {
						"cveTipoMedida": Number($("#descripcionTipoMedida").val())
						}
				}
			};
		jsonAjax("/componentesGenerales/obtener«e.name.toLowerCase.toFirstUpper»s",modelo,inicioDatos);
	}
	
	//function inicioDatos(data){
	//	getTable(data);
	//}
	
	function inicioDatos(info){
		var data = info.payload;
	    $('#«e.name.toLowerCase»').dataTable( {
	        data : data,
	        destroy:true,
	        columns: [{
	            data:   "id«e.name.toLowerCase.toFirstUpper»",
	            render: function ( data, type, row ) {
	                if ( type === 'display' ) {
	                    return '<input type="radio" name="radio«e.name.toLowerCase.toFirstUpper»s" class="editor-active" value="'+data+'">';
	                }
	                return data;
	            },
	            className: "dt-body-center"
	        },
	            {"data" : "nombre"},
	            {"data" : "estadoIndicador.descripcion", className: "dt-body-center"},
	            {"data" : "descripcion"},
	            {"data" : "tipoMedida.descripcion", className: "dt-body-center"},
	            {"data" : "valorVerde", className: "dt-body-center"} ,
	            {"data" : "valorAmarillo", className: "dt-body-center"},
	            {"data" : "valorRojo", className: "dt-body-center"} 
	        ],
	        "searching": false,
	        language: {
	            "decimal": "",
	            "emptyTable": "No hay información",
	            "info": "Mostrando _START_ a _END_ de _TOTAL_ registros",
	            "infoEmpty": "Mostrando 0 to 0 of 0 registros",
	            "infoFiltered": "(Filtrado de _MAX_ total registros)",
	            "infoPostFix": "",
	            "thousands": ",",
	            "lengthMenu": "Mostrar _MENU_ registros",
	            "loadingRecords": "Cargando...",
	            "processing": "Procesando...",
	            "search": "Buscar:",
	            "zeroRecords": "Sin resultados encontrados",
	            "paginate": {
	                "first": "Primero",
	                "last": "Ultimo",
	                "next": "Siguiente",
	                "previous": "Anterior"
	            }
	        }
	    });
	    
	    $("#«e.name.toLowerCase»_info").html("Mostrando "+(((info.paginaActual-1)*$("#«e.name.toLowerCase»_length select").val())+1)+" a "+((info.totalPaginas==info.paginaActual)?info.totalRegistros:(info.paginaActual*$("#«e.name.toLowerCase»_length select").val()))+" de "+info.totalRegistros+" registros");
	
	    for(i = 2; i<=info.totalPaginas;i++){
	    	$("#«e.name.toLowerCase»_paginate .next").before('<span><a class="paginate_button current" aria-controls="«e.name.toLowerCase»" data-dt-idx="'+i+'" tabindex="0">'+i+'</a></span>');
	    }
	    
	
		
		$(".paginate_button").click(function(){
			paginarTabla($(this).data("dt-idx"));
		});
	}
	
	function buscarDatos(data){
		$("#grid").clearGridData();
		$("#grid").jqGrid('setGridParam', {data:data});
		$("#grid").trigger("reloadGrid");
	}
	
	
	function actualizar«e.name.toLowerCase.toFirstUpper»(data){
		$("#nombreEdit").val(data.nombre);
		$("#medidaEdit option[value="+ data.tipoMedida.cveTipoMedida +"]").attr("selected",true);
		$("#descripcionEdit").val(data.descripcion);
		$("#minimoGreenEdit").val(data.valores«e.name.toLowerCase.toFirstUpper»[0].valorMinimo);
		$("#maximoGreenEdit").val(data.valores«e.name.toLowerCase.toFirstUpper»[0].valorMaximo);
		$("#minimoYellowEdit").val(data.valores«e.name.toLowerCase.toFirstUpper»[1].valorMinimo);
		$("#maximoYellowEdit").val(data.valores«e.name.toLowerCase.toFirstUpper»[1].valorMaximo);
		$("#minimoRedEdit").val(data.valores«e.name.toLowerCase.toFirstUpper»[2].valorMinimo);
		$("#maximoRedEdit").val(data.valores«e.name.toLowerCase.toFirstUpper»[2].valorMaximo);
		$('.modal«e.name.toLowerCase.toFirstUpper»Editar').modal('show');
	}
	
	function vacio(){}
	
	function getTable(results){ 
		$("#grid").clearGridData();
		$("#grid").jqGrid({
			datatype: "local",
			data: results,
		    colNames:['Seleccionar','Nombre','Estado','Descripción','Medida','Semáforo verde','Semáforo amarillo','Semáforo rojo'],
		    colModel :[ 
		    	{ name: 'id«e.name.toLowerCase.toFirstUpper»', label: 'id«e.name.toLowerCase.toFirstUpper»', width: 50, align:'center',
		            formatter: function radio(cellValue, option) {
		                return '<input type="radio" name="radio«e.name.toLowerCase.toFirstUpper»s" value="'+cellValue+'"/>';
		            } 
		        },
		      {name:'nombre', index:'nombre', width:90}, 
		      {name:'descripcionEdoIndicador', index:'descripcionEdoIndicador', width:40, align:'center'}, 
		      {name:'descripcion', index:'descripcion', width:150, align:'left'}, 
		      {name:'descripcionTipoMedida', index:'descripcionTipoMedida', width:40, align:'center'},
		      {name:'valorVerde', index:'valorVerde', width:60, align:'center'}, 
		      {name:'valorAmarillo', index:'valorAmarillo', width:60, align:'center'}, 
		      {name:'valorRojo', index:'valorRojo', width:60, sortable:false, align:'center'} 
		    ],
		    search:true,
		    pagination:true,
		    pager: '#pager',
		    loadonce: true,
		    rowNum:10,
		   	rowList:[10,20,50,100],
		   	height: 250,
		   	scrollOffset:0,
		   	autowidth: true,
		   	shrinkToFit: true,
		    pginput: true,
		    pgbuttons: true,
		    viewrecords: true,
			rownumbers: false,
	  }); 
		$("#grid").trigger("reloadGrid");
	}	
	'''
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
	//--------------------------------- CODIGO PARA GENERAR EVENTOS JQUERY ------------------------------
	//---------------------------------------------------------------------------------------------------
	def dispatch getAttributeEntityRefJQuery(Entity tr, EntityReferenceField f, Entity t, String name)'''
		var «name.toLowerCase» = $('#«name.toLowerCase»New').val();
	'''
 	def dispatch getAttributeEntityRefJQuery(Enum tr, EntityReferenceField f, Entity t, String name)'''
		var «tr.name.toLowerCase» = $('#«tr.name.toLowerCase»New').val();
	'''
	
	def dispatch getAttributeEntityJQuery(EntityReferenceField f, Entity t)'''
		«IF  f !== null && !f.upperBound.equals('*')»
			«f.superType.getAttributeEntityRefJQuery(f, t, f.name)»
		«ENDIF»
	'''
	
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
	
	//----------------------------------------------------------------------------------------------------
	//--------------------------------- CODIGO PARA GENERAR LABELS - VALUES ------------------------------
	//----------------------------------------------------------------------------------------------------
	def dispatch getAttributeEntityRefLabelValue(Entity tr, EntityReferenceField f, Entity t, String name)'''
		"«name.toLowerCase»" : «name.toLowerCase»,
	'''
 	def dispatch getAttributeEntityRefLabelValue(Enum tr, EntityReferenceField f, Entity t, String name)'''
		"«tr.name.toLowerCase»" : «tr.name.toLowerCase»,
	'''
	
	def dispatch getAttributeEntityLabelValue(EntityReferenceField f, Entity t)'''
		«IF  f !== null && !f.upperBound.equals('*')»
			«f.superType.getAttributeEntityRefLabelValue(f, t, f.name)»
		«ENDIF»
	'''
	
	def dispatch getAttributeEntityLabelValue(EntityTextField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»,
	'''
	
	def dispatch getAttributeEntityLabelValue(EntityLongTextField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»,
	'''
	def dispatch getAttributeEntityLabelValue(EntityDateField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»,
	'''
	def dispatch getAttributeEntityLabelValue(EntityImageField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»,
	'''
	def dispatch getAttributeEntityLabelValue(EntityFileField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»,
	'''
	def dispatch getAttributeEntityLabelValue(EntityEmailField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»,
	'''
	def dispatch getAttributeEntityLabelValue(EntityDecimalField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»,
	'''
	def dispatch getAttributeEntityLabelValue(EntityIntegerField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»,
	'''
	def dispatch getAttributeEntityLabelValue(EntityCurrencyField f, Entity t)'''
		"«f.name.toLowerCase»" : «f.name.toLowerCase»,
	'''
	

	def dispatch getAttributeEntityRefLabelValueSearch(Entity tr, EntityReferenceField f, Entity t, String name)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()		
	'''
 	def dispatch getAttributeEntityRefLabelValueSearch(Enum tr, EntityReferenceField f, Entity t, String name)'''
	"«f.name.toLowerCase»": $("#«f.name.toLowerCase»Semaf").val()		
	'''
	
	def dispatch getAttributeEntitySearch(EntityReferenceField f, Entity t)'''
		«IF  f !== null && !f.upperBound.equals('*')»
			«f.superType.getAttributeEntityRefLabelValueSearch(f, t, f.name)»
		«ENDIF»
	'''
	
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
	
	
}