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
	var MENSAJE_ERROR_OPEN_ACTUALIZAR = "No se ha seleccionado un registro";
	var MENSAJE_GUARDADO_EXITOSO = "Registro guardado correctamente";
	var MENSAJE_ELIMINADO_EXITOSO = "Registro eliminado correctamente";
	var MENSAJE_ACTUALIZADO_EXITOSO = "Registro actualizado correctamente";
	var MENSAJE_CAMPO_OBLIGATORIO = "El campo es obligatorio";
	var MENSAJE_CAMPOS_OBLIGATORIOS = " Proporcionar un criterio de b\u00fasqueda";
	var paginacion;	
	
	function mostrarAlertSuccess(mensaje){
		$("#alertSuccess").after('<div class="alert alert-success alert-dismissible fade show fixed-top" style="z-index:100;" id="eventoAlertSuccess">'
		+'<strong></strong>' + mensaje
		+'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'
		+'<span aria-hidden="true">&times;</span>'
		+'</button>'
		+'</div>');
		$('#eventoAlertSuccess').delay(2000).fadeOut();
	}
	
	function mostrarAlertWarning(mensaje){
		$("#alertWarning").after('<div class="alert alert-warning alert-dismissible fade show fixed-top" id="eventoAlertWarning">'
		+'<strong></strong>' + mensaje
		+'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'
		+'<span aria-hidden="true">&times;</span>'
		+'</button>'
		+'</div>');
		$('#eventoAlertWarning').delay(2000).fadeOut();
	}
	
	function mostrarAlertDanger(mensaje, alert){
		$("#"+alert).after('<div class="alert alert-danger alert-dismissible fade show fixed-top" id="eventoAlertWarning">'
		+'<strong></strong>' + mensaje
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
			thElement.setAttribute("class","ordenar");
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
	                return '<label class="containerradio"><input type="radio" style="align:center;" name="radio" value="'+data+'"><span class="checkmark"></span></label>';
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

	function inicioDatos(info,origen){
		console.log(info);
	
		var data = info.payloades;
		var paginado = info.paginado;
		
		if(data == 'undefined'){
			data = info;
		}
		console.log(data);
		
	    var tabla = $('#datostabla').dataTable( {
	        data : data,
	        destroy:true,
	        columns: columnas(data),
	        "pageLength": paginado.registrosMostrados,
	        "searching": false,
	        language: {
	            "decimal": "",
	            "emptyTable": "No hay informaci\u00F3n",
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
	    
	    if(origen){
	    	$("#datostabla .dataTables_empty").empty();
	    }
	    
	    
	    generarPaginado(paginado);
	    
	    $("#datostabla_length select").val(paginado.registrosMostrados);
	    
	    paginacion = paginado;
	    
	    $("#datostabla_length select").change(function(){
	    	if($("#datostabla").children("tbody").children('tr').children('td').hasClass("dataTables_empty")){
	    		tablaVacia();
	    	}else{
	    		iniciarTabla();
	    	}
		});
	    
	    $(".ordenar").click(function(){
			generarPaginado(paginacion);
		});
	}
	
	function generarPaginado(data){
	    
	    var paginado = '<nav aria-label="..."><ul class="pagination">';
	    	if(data.pagina==1 || data.totalRegistros==0){
	    		paginado += '<li class="page-item disabled"><a class="page-link inactivo" href="#" tabindex="-1"><span aria-hidden="true">&laquo;</span><span class="sr-only">Primera</span></a></li>';
	    		paginado += '<li class="page-item disabled"><a class="page-link inactivo" href="#" data-value="'+(data.pagina-1)+'">\<</a></li>';
	    	}else{
	    		paginado += '<li class="page-item"><a class="page-link" href="#" tabindex="-1" data-value="'+1+'"><span aria-hidden="true">&laquo;</span><span class="sr-only">Primera</span></a></li>';
	    		paginado += '<li class="page-item"><a class="page-link" href="#" data-value="'+(data.pagina-1)+'">\<</a></li>';
	    	}
	    	
	    	if(data.totalPaginas>0){
				paginado += '<li><p style="margin:5px 10px 0 10px;">P&aacute;gina <input type="text" size="2" style="z-index: 99;" id="pagina-actual" value="'+data.pagina+'"> de '+data.totalPaginas+'</p></li>';
			}
	    	
	    	if(data.pagina==data.totalPaginas || $("#datostabla").children("tbody").children('tr').children('td').hasClass("dataTables_empty")){
	    		paginado += '<li class="page-item disabled"><a class="page-link inactivo" href="#" data-value="'+(data.pagina+1)+'">\></a></li>';
	    		paginado += '<li class="page-item disabled"><a class="page-link inactivo" id="ultima-pagina" href="#" data-value="'+(data.totalPaginas)+'" tabindex="-1"><span aria-hidden="true">&raquo;</span><span class="sr-only">Ultima</span></a></li>';
	    	}else{
	    		paginado += '<li class="page-item"><a class="page-link" href="#" data-value="'+(data.pagina+1)+'">\></a></li>';
	    		paginado += '<li class="page-item"><a class="page-link" href="#" id="ultima-pagina" data-value="'+(data.totalPaginas)+'"><span aria-hidden="true">&raquo;</span><span class="sr-only">Ultima</span></a></li>';
	    	}

	    	paginado += '</ul></nav>';
	
	    $("#datostabla_paginate").empty().append(paginado);
	    
	    $("#datostabla_info").html("Mostrando "+(data.totalRegistros==0?0:(data.valorMinimo+1))+" a "+(data.valorMaximo>data.totalRegistros?data.totalRegistros:data.valorMaximo)+" de "+data.totalRegistros+" registros");
		
		$(".page-item").click(function(){
			console.log("Valor enlace" + $(this).children("a:not(.inactivo)").data("value"));
			if(!$(this).children("a").hasClass("inactivo")){
				paginarTabla($(this).children("a").data("value"));
			}
		});
		
		$("#pagina-actual").change(function(){
			console.log("pagina ingresada: " + $("#pagina-actual").val() + " pagina ultima: " + $("#ultima-pagina").data("value"));
			if($("#pagina-actual").val()>0 && $("#pagina-actual").val()<=$("#ultima-pagina").data("value")){
				paginarTabla($("#pagina-actual").val());
			}
		});
	}
-----------------------------------------------------------------------------------
	/*Creación de Arboles.*/
	function dibujarArbol(lista){
		var modulo = document.createElement("ul");
		modulo.setAttribute("class", "tree");
		var moduloLi = document.createElement("li");
		crearUl(moduloLi, lista.idCtrlProceso, lista.cveTipoNivel, lista.modulo);
		var proceso = document.createElement("ul");
		proceso.setAttribute("class", "interior");
		for(i in lista.proceso){
			var procesoLi = document.createElement("li");
			crearUl(procesoLi, lista.proceso[i].idCtrlProceso, lista.proceso[i].cveTipoNivel, lista.proceso[i].texto);
			agregarSubProcesos(procesoLi, lista.proceso[i]);
			proceso.appendChild(procesoLi);
		}
		moduloLi.appendChild(proceso);
		modulo.appendChild(moduloLi);
		$("#list_view").append(modulo);
	}

	function agregarSubProcesos(procesoLi, lista){
		var subproceso = document.createElement("ul");
		subproceso.setAttribute("class", "interior");
		for(j in lista.subproceso){
			var subprocesoLi = document.createElement("li");
			crearUl(subprocesoLi, lista.subproceso[j].idCtrlProceso, lista.subproceso[j].cveTipoNivel, lista.subproceso[j].texto);
			agregarTareas(subprocesoLi, lista.subproceso[j]);
			subproceso.appendChild(subprocesoLi);
		}
		procesoLi.appendChild(subproceso);
	}

	function agregarTareas(subprocesoLi, listatarea){
		var tarea = document.createElement("ul");
		tarea.setAttribute("class", "interior");
		for(k in listatarea.tarea){
			var tareaLi = document.createElement("li");
			tarea.appendChild(tareaLi);
			tareaLi.textContent=listatarea.tarea[k].texto;
		}
		subprocesoLi.appendChild(tarea);
	}

	function crearUl(moduloLi, idCtrlProceso, cveTipoNivel, texto){
		var UID = Math.floor(Math.random() * 99999);
		var check = document.createElement("input");
		check.setAttribute("type", "checkbox");
		check.setAttribute("name", "list");
		check.setAttribute("id", "id_"+UID);
		check.setAttribute("value", idCtrlProceso);
		
		var modulospan = document.createElement("label");
		modulospan.setAttribute("class", "tree_label");
		modulospan.setAttribute("for", "id_"+UID);
		modulospan.setAttribute("id", "span"+UID);
		modulospan.setAttribute("onclick", "migas(id_"+UID+", "+ cveTipoNivel +", '"+texto+"')");
		moduloLi.appendChild(check);
		moduloLi.appendChild(modulospan);
		modulospan.textContent=texto;
	} 

	function tablaVacia(){
		inicioDatos({"paginado":{"pagina":0,"registrosMostrados":10,"totalRegistros":0,"totalPaginas":0,"valorMinimo":0, "valorMaximo":0},"payloades":{}},true);
	}

	function onlyText(e){
		var tecla = (document.all) ? e.keyCode : e.which;
		   if (tecla==8 || tecla==13){
			    event.preventDefault();
			    return false;
		    }
		var regex = /^[^\'\"\*\(\)\&\|\/\\]*$/;
		var tecla_final = String.fromCharCode(tecla);
	    return regex.test(tecla_final);
	};

	$.datepicker.regional['es'] = {
			 closeText: 'Cerrar',
			 prevText: '< Ant',
			 nextText: 'Sig >',
			 currentText: 'Hoy',
			 monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
			 monthNamesShort: ['Ene','Feb','Mar','Abr', 'May','Jun','Jul','Ago','Sep', 'Oct','Nov','Dic'],
			 dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
			 dayNamesShort: ['Dom','Lun','Mar','Mié','Juv','Vie','Sáb'],
			 dayNamesMin: ['Do','Lu','Ma','Mi','Ju','Vi','Sa'],
			 weekHeader: 'Sm',
			 dateFormat: 'dd/mm/yy',
			 firstDay: 1,
			 isRTL: false,
			 showMonthAfterYear: false,
			 yearSuffix: ''
			 };
			 $.datepicker.setDefaults($.datepicker.regional['es']);	
	
	'''
	
}