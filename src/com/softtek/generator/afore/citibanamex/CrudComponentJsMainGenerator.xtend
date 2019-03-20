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

class CrudComponentJsMainGenerator {
	
	@Inject EntityFieldUtils entityFieldUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/configuracion/src/main/webapp/resources/js/main" + e.name.toLowerCase.toFirstUpper + ".js", e.genJavaJs(m))
			}
		}
	}
	
	/* Archivo Principal */
	def CharSequence genJavaJs(Entity e, Module m) '''
	var MENSAJE_ERROR_OPEN_ACTUALIZAR = "No se ha seleccionado un Registro...!";
	var MENSAJE_GUARDADO_EXITOSO = "Registro guardado Correctamente...!";
	var MENSAJE_ELIMINADO_EXITOSO = "Registro eliminado Correctamente...!";
	var MENSAJE_ACTUALIZADO_EXITOSO = "Registro actualizado Correctamente...!";
	
	function mostrarAlertSuccess(mensaje){
		$("#alertSuccess").after('<div class="alert alert-success alert-dismissible fade show fixed-top" id="eventoAlertSuccess">'
		+'<strong>Advertencia!</strong>' + mensaje
		+'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'
		+'<span aria-hidden="true">&times;</span>'
		+'</button>'
		+'</div>');
		$('#eventoAlertSuccess').delay(2000).fadeOut();
	}
	
	function mostrarAlertWarning(mensaje){
		$("#alertWarning").after('<div class="alert alert-warning alert-dismissible fade show fixed-top" id="eventoAlertWarning">'
		+'<strong>Advertencia!</strong>' + mensaje
		+'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'
		+'<span aria-hidden="true">&times;</span>'
		+'</button>'
		+'</div>');
		$('#eventoAlertWarning').delay(2000).fadeOut();
	}
	
	function mostrarAlertDanger(mensaje){
		$("#alertDanger").after('<div class="alert alert-danger alert-dismissible fade show fixed-top" id="eventoAlertWarning">'
		+'<strong>Advertencia!</strong>' + mensaje
		+'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'
		+'<span aria-hidden="true">&times;</span>'
		+'</button>'
		+'</div>');
		$('#eventoAlertWarning').delay(2000).fadeOut();
	}
	
	//Función que recibe un trozo de html del back y actualiza el front
	function actualizarAjaxHTML(url,modelo,actualiza){
		$.ajax({
				url:url,
				data: modelo,
				type: "post",
				success:function(data){
					$(actualiza).empty().append(data);
				},
				error: function(){
					console.log("Ocurrio un error");
					
				}
		});
	}
	
	//Función que recibe un json del back
	function jsonAjax(url,model,callback){
		$.ajax({
				url:url,
				headers: { 
			        'Accept': 'application/json',
			        'Content-Type': 'application/json' 
			    },
				data: JSON.stringify(model),
				dataType: "json",
				type: "post",
				success:function(data){
					callback(data);
				},
				error: function(){
					console.log("Ocurrio un error");
				}
		});
	}
	
	function crearCabeceras(){
		var cabeceras = titulos.split(",");
		var cabecerasHtml = document.createElement('tr');
		for(i in cabeceras){
			thElement = document.createElement('th');
			thElement.textContent = cabeceras[i];
			thElement.setAttribute("scope","col");
			cabecerasHtml.appendChild(thElement);
		}
		$(".bg-info").append(cabecerasHtml);
	}
	
	function columnas(data) {
		var origenDatos = datosOrigen.split(",");
		var params = [];
		params.push({
	        data:   origenDatos[0],
	        render: function ( data, type, row ) {
	            if ( type === 'display' ) {
	                return '<input type="radio" name="radioIndex" class="editor-active" value="'+data+'">';
	            }
	            return data;
	        },
	        className: "dt-body-center"});
		origenDatos.shift();
		origenDatos.forEach(function (column, index) {
			var propiedad = {data: column.split(":")[0],name: "",searchable: true,orderable: true, search:{regex: "", value: false}, className: column.split(":").length>1? "dt-body-center":""};
			params.push(propiedad);
		});
		return params;
	}
	
	function inicioDatos(info){
		console.log(info);
		var data = info.payloades;
		
	    var tabla = $('#datostabla').dataTable( {
	        data : data,
	        destroy:true,
	        columns: columnas(data),
	        "searching": false,
	        language: {
	            "decimal": "",
	            "emptyTable": "No hay informaci\u00F3n",
	            "info": "Mostrando 23 a _END_ de _TOTAL_ registros",
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
	    
	    $("#«e.name.toLowerCase»_info").html("Mostrando 1 a 10 de "+info.totalRegistros+" registros");
	
	    for(i = 2; i<=info.totalPaginas;i++){
	    	$("#«e.name.toLowerCase»_paginate .next").before('<span><a class="paginate_button current" aria-controls="«e.name.toLowerCase»" data-dt-idx="'+i+'" tabindex="0">'+i+'</a></span>');
	    }
		
		$(".paginate_button").click(function(){
			console.log($(this).data("dt-idx"));
			paginarTabla($(this).data("dt-idx"));
		});
	}	
	
	'''
	
}