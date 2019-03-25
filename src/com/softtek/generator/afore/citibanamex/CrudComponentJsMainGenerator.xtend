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
		var paginado = info.paginado;
		
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
	    
	    $("#«e.name.toLowerCase»_info").html("Mostrando "+(paginado.valorMinimo+1)+" a "+(paginado.valorMaximo>paginado.totalRegistros?paginado.totalRegistros:paginado.valorMaximo)+" de "+paginado.totalRegistros+" registros");
	
	    generarPaginado(paginado);
		
		$(".page-item").click(function(){
			console.log("Valor enlace" + $(this).children("a:not(.inactivo)").data("value"));
			if(!$(this).children("a").hasClass("inactivo")){
				paginarTabla($(this).children("a").data("value"));
			}
		});
	}	
	
	
	function generarPaginado(data){
	    
	    var paginado = '<nav aria-label="..."><ul class="pagination">';
	    	if(data.pagina==1){
	    		paginado += '<li class="page-item disabled"><a class="page-link inactivo" href="#" tabindex="-1">Anterior</a></li>';
	    	}else{
	    		paginado += '<li class="page-item"><a class="page-link" href="#" tabindex="-1" data-value="'+(data.pagina-1)+'">Anterior</a></li>';
	    	}
	    	
	    	console.log(data.totalPaginas);
	    	for(i = 1; i<=data.totalPaginas;i++){
	    		if(i==data.pagina){
	    			paginado += '<li class="page-item active"><a class="page-link" href="#" data-value="'+i+'">'+i+' <span class="sr-only">(current)</span></a></li>';
	    		}else{
	    			paginado += '<li class="page-item"><a class="page-link" href="#" data-value="'+i+'">'+i+'</a></li>';
	    		}
	    	}
	    	
	    	if(data.pagina==data.totalPaginas){
	    		paginado += '<li class="page-item disabled"><a class="page-link inactivo" href="#" tabindex="-1">Siguiente</a></li>';
	    	}else{
	    		paginado += '<li class="page-item"><a class="page-link" href="#" data-value="'+(data.pagina+1)+'">Siguiente</a></li>';
	    	}
	    	
	    	paginado += '</ul></nav>';
	
	    $("#«e.name.toLowerCase»_paginate").empty().append(paginado);
	}	
	'''
	
}