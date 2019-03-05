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
	<script type="text/javascript" src=".../../resources/js/jquery-3.3.1.min.js"></script>
	<script type="text/javascript" src=".../../resources/js/bootstrap.bundle.js"></script>
	<script type="text/javascript" src=".../../resources/js/jquery.jqgrid.src.js"></script>
	<script type="text/javascript" src=".../../resources/js/grid.locale-es.js"></script>
	<script type="text/javascript" src=".../../resources/js/bootstrapvalidator.js"></script>
	<script type="text/javascript" src=".../../resources/js/main.js"></script>
	<script type="text/javascript" src=".../../resources/js/modelo.js"></script>
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
		
		<!-- Body -->
		<div class="container">
			<div id="alertSuccess"></div>
			<div id="alertWarning"></div>
			<div id="alertDanger"></div>
	
			<div class="formTop">
				<span class="titleStaticForm">«e.name»</span>
				<form id="formBusquedar«e.name.toFirstUpper»">
				
				
«««					<div class="row">
«««						<div class="col-md-4">
«««							<label for="nombre" class="col-form-label" th:text="#{label.busqueda.nombre}">
«««							</label> <input name="nombreSemaf" type="text"
«««								class="form-control" id="nombreSemaf" required>
«««						</div>
«««						<div class="col-md-4">
«««							<label for="descripcionTipoMedida" class="col-form-label" th:text="#{label.busqueda.medida}"></label> 
«««							<select name="descripcionTipoMedida"
«««								id="descripcionTipoMedida" class="form-control" required>
«««								<option value="" th:text="#{label.busqueda.seleccionar}" selected></option>
«««								<option th:each="tipoMedida : ${tipoMedidas}" th:value="${tipoMedida.descripcion}" th:utext="${tipoMedida.descripcion}"/>
«««							</select>
«««						</div>
«««						<div class="col-md-4">
«««							<label for="descripcionEdoIndicador" class="col-form-label" th:text="#{label.busqueda.estado}"></label> 
«««							<select name="descripcionEdoIndicador"
«««								id="descripcionEdoIndicador" class="form-control" required>
«««								<option value="" th:text="#{label.busqueda.seleccionar}" selected></option>
«««								<option th:each="edo«e.name.toLowerCase.toFirstUpper» : ${edo«e.name.toLowerCase.toFirstUpper»s}" th:value="${edo«e.name.toLowerCase.toFirstUpper».descripcion}" th:utext="${edo«e.name.toLowerCase.toFirstUpper».descripcion}"/>
«««							</select>
«««						</div>
«««					</div>
«««					<div class="row">
«««						<div class="col-md-6"></div>
«««						<div class="col-md-6">
«««							<button name="buscar" id="buscar" type="button"
«««								class="btn-style-citi float-right mx-0" th:text="#{label.busqueda.buscar}"></button>
«««							<button name="limpiar" id="limpiar" type="button"
«««								class="btn-style-citi float-right mx-2" th:text="#{label.busqueda.limpiar}"></button>
«««						</div>
«««					</div>
					
					
				</form>
			</div>
			<span class="tituloTabla" th:text="#{span.titulo.tabla}"></span>
			<!-- <div class="container"> -->
«««				<div id='divjqgrid'>
«««					<table id='grid'></table>
«««					<div id='pager'></div>
«««				</div>
			<!-- </div> -->
			<div class="row float-right mx-0 btnList">
				<button type="button" class="btn-style-citi" id="eliminar«e.name.toLowerCase.toFirstUpper»" th:text="#{boton.«e.name.toLowerCase».eliminar}"></button>
				<button type="button" class="btn-style-citi" name="actualizar«e.name.toLowerCase.toFirstUpper»" id="actualizar«e.name.toLowerCase.toFirstUpper»" th:text="#{boton.«e.name.toLowerCase».actualizar}"></button>
				<button type="button" class="btn-style-citi" data-toggle="modal" data-target=".modalNew«e.name.toLowerCase.toFirstUpper»" th:text="#{boton.«e.name.toLowerCase».agregar}"></button>
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
					<div class="container body">
						<form class="needs-validation mt-1" id="formularioNew«e.name.toLowerCase.toFirstUpper»"
							novalidate>
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right">
									<label for="nombreNew" class="col-form-label" th:text="#{label.busqueda.nombre}"></label>
								</div>
								<div class="col-lg-7">
									<input type="text" class="form-control" id="nombreNew"
										name="nombreNew" maxlength="100" required>
									<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
								</div>
							</div>
	
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right">
									<label for="medidaNew" class="col-form-label" th:text="#{label.busqueda.medida}"></label>
								</div>
								<div class="col-lg-7">
									<select id="medidaNew" class="form-control" name="medidaNew"
										required>
										<option value="">-- Seleccionar --</option>
										<option th:each="tipoMedida : ${tipoMedidas}" th:value="${tipoMedida.descripcion}" th:utext="${tipoMedida.descripcion}"/>
									</select>
									<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
								</div>
							</div>
	
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right">
									<label for="descripcionNew" class="col-form-label"  th:text="#{label.modal.descripcion}"></label>
								</div>
								<div class="col-lg-7">
									<textarea class="form-control" id="descripcionNew"  maxlength="100" rows="3"></textarea>
								</div>
							</div>
	
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right"></div>
								<div class="col-lg-7">
									<div class="row justify-content-start">
										<div class="col-4"></div>
										<div class="col-4 text-center" th:text="#{label.modal.minimo}"></div>
										<div class="col-4 text-center" th:text="#{label.modal.maximo}"></div>
									</div>
								</div>
							</div>
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right"></div>
								<div class="col-lg-7">
									<div class="row justify-content-start">
										<div class="col-4 text-center">
											<div class="greenCircle"></div>
										</div>
										<div class="col-4">
											<select id="minimoGreenNew" class="form-control" required>
												<option value="" selected>0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
											</select>
											<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
										</div>
										<div class="col-4">
											<select id="maximoGreenNew" class="form-control" required>
												<option value="" selected>0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
											</select>
											<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
										</div>
									</div>
								</div>
							</div>
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right"></div>
								<div class="col-lg-7">
									<div class="row justify-content-start">
										<div class="col-4 text-center">
											<div class="yellowCircle justify-content-center"></div>
										</div>
										<div class="col-4">
											<select id="minimoYellowNew" class="form-control" required>
												<option value="" selected>0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
											</select>
											<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
										</div>
										<div class="col-4">
											<select id="maximoYellowNew" class="form-control" required>
												<option value="" selected>0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
											</select>
											<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
										</div>
									</div>
								</div>
							</div>
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right"></div>
								<div class="col-lg-7">
									<div class="row justify-content-start">
										<div class="col-4 text-center">
											<div class="redCircle"></div>
										</div>
										<div class="col-4">
											<select id="minimoRedNew" class="form-control" required>
												<option value="" selected>0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
											</select>
											<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
										</div>
										<div class="col-4">
											<select id="maximoRedNew" class="form-control" required>
												<option value="" selected>0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
											</select>
											<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
										</div>
									</div>
								</div>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn-style-citi" data-dismiss="modal">Cerrar</button>
								<button type="submit" class="btn-style-citi" id="agregar«e.name.toLowerCase.toFirstUpper»">Guardar</button>
							</div>
						</form>
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
	
					<div class="modal-header">
						<h4 class="modal-title" id="modal«e.name.toLowerCase.toFirstUpper»Editar" th:text="#{title.modal.edit}"></h4>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="container body">
						<form class="needs-validation mt-1" id="formularioEdit«e.name.toLowerCase.toFirstUpper»" novalidate>
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right">
									<label for="nombreEdit" class="col-form-label" th:text="#{label.busqueda.nombre}"></label>
								</div>
								<div class="col-lg-7">
									<input type="text" class="form-control" id="nombreEdit"
										name="nombreEdit" maxlength="100" required>
										<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
								</div>
							</div>
	
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right">
									<label for="medidaEdit" class="col-form-label" th:text="#{label.busqueda.medida}"></label>
								</div>
								<div class="col-lg-7">
									<select id="medidaEdit" class="form-control" name="medidaEdit" required>
										<option value="" selected>-- Seleccionar --</option>
										<option th:each="tipoMedida : ${tipoMedidas}" th:value="${tipoMedida.descripcion}" th:utext="${tipoMedida.descripcion}"/>
									</select>
									<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
								</div>
							</div>
	
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right">
									<label for="descripcionEdit" class="col-form-label" th:text="#{label.modal.descripcion}"></label>
								</div>
								<div class="col-lg-7">
									<textarea class="form-control" id="descripcionEdit" maxlength="100" rows="3"></textarea>
								</div>
							</div>
	
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right"></div>
								<div class="col-lg-7">
									<div class="row justify-content-start">
										<div class="col-4"></div>
										<div class="col-4 text-center" th:text="#{label.modal.minimo}"></div>
										<div class="col-4 text-center" th:text="#{label.modal.maximo}"></div>
									</div>
								</div>
							</div>
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right"></div>
								<div class="col-lg-7">
									<div class="row justify-content-start">
										<div class="col-4 text-center">
											<div class="greenCircle"></div>
										</div>
										<div class="col-4">
											<select id="minimoGreenEdit" class="form-control" required>
												<option value="">0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
											</select>
											<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
										</div>
										<div class="col-4">
											<select id="maximoGreenEdit" class="form-control" required>
												<option value="">0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
											</select>
											<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
										</div>
									</div>
								</div>
							</div>
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right"></div>
								<div class="col-lg-7">
									<div class="row justify-content-start">
										<div class="col-4 text-center">
											<div class="yellowCircle justify-content-center"></div>
										</div>
										<div class="col-4">
											<select id="minimoYellowEdit" class="form-control" required>
												<option value="">0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
											</select>
											<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
										</div>
										<div class="col-4">
											<select id="maximoYellowEdit" class="form-control" required>
												<option value="">0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
											</select>
											<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
										</div>
									</div>
								</div>
							</div>
							<div class="row mx-3 form-group">
								<div class="col-lg-4 text-right"></div>
								<div class="col-lg-7">
									<div class="row justify-content-start">
										<div class="col-4 text-center">
											<div class="redCircle"></div>
										</div>
										<div class="col-4">
											<select id="minimoRedEdit" class="form-control" required>
												<option value="">0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
											</select>
											<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
										</div>
										<div class="col-4">
											<select id="maximoRedEdit" class="form-control" required>
												<option value="">0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn-style-citi" data-dismiss="modal">Cerrar</button>
								<button type="submit" class="btn-style-citi" name="editar«e.name.toLowerCase.toFirstUpper»" id="editar«e.name.toLowerCase.toFirstUpper»">Guardar</button>
							</div>
						</form>
					</div>
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
					<div class="modal-header">
						<h5 class="modal-title" id="modalEliminarTitle"  th:text="#{title.modal.delete}"></h5>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="text-center">
							<p th:text="#{label.modal.delete.message}"></p>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn-style-citi" data-dismiss="modal">Cerrar</button>
						<button type="button" class="btn-style-citi" id="eliminar«e.name.toLowerCase.toFirstUpper»Confirm">Aceptar</button>
					</div>
				</div>
			</div>
		</div>
	
	</body>
	</html>
	'''
}