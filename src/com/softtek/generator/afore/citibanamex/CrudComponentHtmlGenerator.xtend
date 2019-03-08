package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity
import com.softtek.generator.utils.EntityUtils
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.generator.utils.UIFlowUtils
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
	<script type="text/javascript" src=".../../resources/js/datatables.js"></script>
	<script type="text/javascript" src=".../../resources/js/main.js"></script>
	<script type="text/javascript" src=".../../resources/js/modelo«e.name.toLowerCase.toFirstUpper».js"></script>

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
				<span class="titleStaticForm">Consultar «entityUtils.getEntityName(e)»</span>
				<hr>
				<form id="formBusquedar«e.name.toLowerCase.toFirstUpper»">
					<div class="row">
					«FOR f : e.entity_fields»
					«f.getAttributeSearch(e)»
					«ENDFOR»
					</div>
					<div class="row">
						<div class="col-md-6"></div>
						<div class="col-md-6">
							<button name="buscar" id="buscar" type="button"
								class="btn-style-citi float-right mx-0" th:text="#{label.busqueda.buscar}"></button>
							<button name="limpiar" id="limpiar" type="button"
								class="btn-style-citi float-right mx-2" th:text="#{label.busqueda.limpiar}"></button>
						</div>
					</div>					
				</form>
			</div>
			<span class="tituloTabla" th:text="#{span.titulo.tabla}"></span>
			<div class="table-responsive">
				<table class="table table-bordered" id="«e.name.toLowerCase»">
					<thead class="bg-info">
						<tr>
							<th scope="col" style="width: 70px;">Seleccione</th>
							«FOR f : e.entity_fields»
							«f.getAttributeTitle(e)»
							«ENDFOR»
						</tr>
					</thead>
				</table>
			</div>

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
						<h4 class="modal-title" id="modalNuevo«e.name.toLowerCase.toFirstUpper»" th:text="#{title.«e.name.toLowerCase».modal.new}"></h4>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					
					<div class="container-body">
						<form class="needs-validation mt-1" id="formularioNew«e.name.toLowerCase.toFirstUpper»" novalidate>
							«FOR f : e.entity_fields»
							«f.getAttribute(e)»
							«ENDFOR» 
							<div class="modal-footer ">
								<button type="button" class="btn-style-citi" data-dismiss="modal">Cerrar</button>
								<button type="submit" class="btn-style-citi" id="agregarSemaforo">Guardar</button>
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
						<h4 class="modal-title" id="modal«e.name.toLowerCase.toFirstUpper»Editar" th:text="#{title.«e.name.toLowerCase».modal.edit}"></h4>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						
						<div class="container-body">
							<form class="needs-validation mt-1" id="formularioEdit«e.name.toLowerCase.toFirstUpper»" novalidate>
							«FOR f : e.entity_fields»
							«f.getAttributeEdit(e)»
							«ENDFOR»
							<div class="modal-footer">
								<button type="button" class="btn-style-citi" data-dismiss="modal">Cerrar</button>
								<button type="submit" class="btn-style-citi"
									name="editarSemaforo" id="editarSemaforo">Guardar</button>
							</div>
							</form>
						</div>
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
						<h5 class="modal-title" id="modalEliminarTitle"  th:text="#{title.«e.name.toLowerCase».modal.delete}"></h5>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="text-center">
							<p th:text="#{label.«e.name.toLowerCase».modal.delete.message}"></p>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn-style-citi" data-dismiss="modal">Cerrar</button>
						<button type="button" class="btn-style-citi"
							id="eliminar«e.name.toLowerCase.toFirstUpper»Confirm">Aceptar</button>
					</div>					
				</div>
			</div>
		</div>
	
	</body>
	</html>
	'''
	
	/* Get Attribute Field */
	def dispatch getAttribute(EntityTextField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»New" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttribute(EntityLongTextField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»New" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttribute(EntityDateField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»New" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttribute(EntityImageField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»New" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttribute(EntityFileField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»New" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttribute(EntityEmailField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»New" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttribute(EntityDecimalField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»New" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttribute(EntityIntegerField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»New" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»New" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''	
	
	def dispatch getAttribute(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationship(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationship(Enum e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''
	
	def dispatch genRelationship(Entity e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''
	
	/* Get Attribute Field */
	def dispatch getAttributeEdit(EntityTextField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityLongTextField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityDateField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityImageField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityFileField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityEmailField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityDecimalField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityIntegerField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityCurrencyField f, Entity t)'''
	<div class="row">
		<div class="col-lg-6 form-group">
			<div class="col-lg-12 text-left">
				<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}"></label>
			</div>
			<div class="col-lg-12">
				<input type="text" class="form-control" id="«f.name.toLowerCase»New"
					name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{label.form.campo.required}"></div>
			</div>
		</div>
	</div>
	'''	
	
	def dispatch getAttributeEdit(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipEdit(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipEdit(Enum e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''
	
	def dispatch genRelationshipEdit(Entity e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''	
	
	/* Get Attribute Field */
	def dispatch getAttributeTitle(EntityTextField f, Entity t)'''
	<th scope="col">«f.name.toLowerCase.toFirstUpper»</th>
	'''
	def dispatch getAttributeTitle(EntityLongTextField f, Entity t)'''
	<th scope="col">«f.name.toLowerCase.toFirstUpper»</th>
	'''
	def dispatch getAttributeTitle(EntityDateField f, Entity t)'''
	<th scope="col">«f.name.toLowerCase.toFirstUpper»</th>
	'''
	def dispatch getAttributeTitle(EntityImageField f, Entity t)'''
	<th scope="col">«f.name.toLowerCase.toFirstUpper»</th>
	'''
	def dispatch getAttributeTitle(EntityFileField f, Entity t)'''
	<th scope="col">«f.name.toLowerCase.toFirstUpper»</th>
	'''
	def dispatch getAttributeTitle(EntityEmailField f, Entity t)'''
	<th scope="col">«f.name.toLowerCase.toFirstUpper»</th>
	'''
	def dispatch getAttributeTitle(EntityDecimalField f, Entity t)'''
	<th scope="col">«f.name.toLowerCase.toFirstUpper»</th>
	'''
	def dispatch getAttributeTitle(EntityIntegerField f, Entity t)'''
	<th scope="col">«f.name.toLowerCase.toFirstUpper»</th>
	'''
	def dispatch getAttributeTitle(EntityCurrencyField f, Entity t)'''
	<th scope="col">«f.name.toLowerCase.toFirstUpper»</th>
	'''	
	
	def dispatch getAttributeTitle(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipTitle(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipTitle(Enum e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''
	
	def dispatch genRelationshipTitle(Entity e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''	
	
	/* Get Attribute Search */
	def dispatch getAttributeSearch(EntityTextField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityLongTextField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityDateField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityImageField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityFileField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityEmailField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityDecimalField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityIntegerField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityCurrencyField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{label.«t.name.toLowerCase».busqueda.«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''	
	
	def dispatch getAttributeSearch(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipSearch(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipSearch(Enum e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''
	
	def dispatch genRelationshipSearch(Entity e, Entity t, String name) ''' 
	«««			this.valores«e.name.toLowerCase.toFirstUpper» = valor«e.name.toLowerCase.toFirstUpper»;
	'''	
	
}