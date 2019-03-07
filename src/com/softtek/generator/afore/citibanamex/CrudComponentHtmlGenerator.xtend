package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity
import com.softtek.generator.utils.EntityUtils
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.generator.utils.UIFlowUtils

class CrudComponentHtmlGenerator {
	
	var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/src/main/webapp/WEB-INF/views/pages/" + e.name.toLowerCase+ ".html", e.genAppHtml(m))
			}
		}
	}
	
	def CharSequence genAppHtml(Entity e, Module m) '''
	<!DOCTYPE html>
	<html th:fragment="layout (title, body)"
		xmlns:th="http://www.thymeleaf.org">
	<head>
	<meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="Cache-control" content="no-cache">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Expires" content="-1">
	<title>«e.name.toLowerCase.toFirstUpper»</title>
	<link rel="stylesheet" href=".../../resources/css/bootstrap.min.css">
	<link rel="stylesheet" href=".../../resources/css/inicio.css">
	<link rel="stylesheet" href=".../../resources/css/modelo.css">
	<link rel="stylesheet" href=".../../resources/css/jquery-ui.css"> 
	<link rel="stylesheet" href=".../../resources/css/ui.jqgrid.css"> 
	<link rel="stylesheet" href=".../../resources/css/bootstrapvalidation.min.css">
	<link rel="stylesheet" type="text/css" href=".../../resources/css/datatables.min.css"/>
	<script type="text/javascript" src=".../../resources/js/jquery-3.3.1.min.js"></script>
	<script type="text/javascript" src=".../../resources/js/bootstrap.bundle.js"></script>
	<script type="text/javascript" src=".../../resources/js/jquery-ui.js"></script>
	<script type="text/javascript" src=".../../resources/js/jquery.jqgrid.src.js"></script>
	<script type="text/javascript" src=".../../resources/js/grid.locale-es.js"></script>
	<script type="text/javascript" src=".../../resources/js/bootstrapvalidator.js"></script>
	<script type="text/javascript" src=".../../resources/js/main.js"></script>
	<script type="text/javascript" src=".../../resources/js/modelo.js"></script>
	<script type="text/javascript" src=".../../resources/js/datatables.js"></script>
	</head>
	<body>
		<div th:fragment="header" class="afobnmx_header">
			<div class="container">
				<a class="afobnmx_txt_leng"> <span>| Ver. 1.0.9.10 al
						28/01/2019 |</span>
				</a>
			</div>
	
			<div class="container">
				<div class="afobnmx_headerLogo">
					<img src=".../../resources/img/logoCiti.png" alt="citibanamex">
				</div>
			</div>
		</div>
		<br>
		<div class="container">
			<div id="alertSuccess"></div>
			<div id="alertWarning"></div>
			<div id="alertDanger"></div>
	
			<div class="formTop">
				<span class="titleStaticForm">Consultar «e.name.toLowerCase»</span>
				<hr>
				<form id="formBusquedar«e.name.toLowerCase.toFirstUpper»">
					
				</form>
			</div>
			<span class="tituloTabla" th:text="#{span.titulo.tabla}"></span>

			<div class="row float-right mx-0 btnList">
				<button type="button" class="btn-style-citi" id="eliminar«e.name.toLowerCase.toFirstUpper»" th:text="#{boton.«e.name.toLowerCase».eliminar}"></button>
				<button type="button" class="btn-style-citi"
					name="actualizar«e.name.toLowerCase.toFirstUpper»" id="actualizar«e.name.toLowerCase.toFirstUpper»" th:text="#{boton.«e.name.toLowerCase».actualizar}"></button>
				<button type="button" class="btn-style-citi" data-toggle="modal"
					data-target=".modalNew«e.name.toLowerCase.toFirstUpper»" th:text="#{boton.«e.name.toLowerCase».agregar}"></button>
			</div>
		</div>
	
		<!-- The Modal New -->
		<div class="modal fade modalNew«e.name.toLowerCase.toFirstUpper»" tabindex="-1" role="dialog"
			aria-labelledby="modalNuevo«e.name.toLowerCase.toFirstUpper»" aria-hidden="true"
			id="modalNew«e.name.toLowerCase.toFirstUpper»" style="display: none;">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title" id="modalNuevo«e.name.toLowerCase.toFirstUpper»" th:text="#{title.modal.new}"></h4>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					
				</div>
			</div>
		</div>
	
		<!-- The Modal Edit -->
		<div class="modal fade modal«e.name.toLowerCase.toFirstUpper»Editar" tabindex="-1" role="dialog"
			aria-labelledby="modal«e.name.toLowerCase.toFirstUpper»Editar" aria-hidden="true"
			style="display: none;">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					
				</div>
			</div>
		</div>
		<!-- Modal -->
		<div class="modal fade eliminar«e.name.toLowerCase.toFirstUpper»Modal" id="eliminar«e.name.toLowerCase.toFirstUpper»Modal"
			tabindex="-1" role="dialog" aria-labelledby="modalEliminarTitle"
			aria-hidden="true">
			<div class="modal-dialog modal-sm modal-dialog-centered"
				role="document">
				<div class="modal-content">
					
				</div>
			</div>
		</div>
	
	</body>
	</html>
	'''
}