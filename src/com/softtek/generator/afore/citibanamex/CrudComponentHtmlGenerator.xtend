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
import com.softtek.rdl2.EntityTimeField
import com.softtek.rdl2.EntityBooleanField
import com.softtek.rdl2.EntityDateTimeField

class CrudComponentHtmlGenerator {
	
	var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/configuracion/src/main/webapp/WEB-INF/views/mn/" + e.name.toLowerCase+ ".html", e.genAppHtml(m))
			}
		}
	}
	
	/* Archivo Principal */
	def CharSequence genAppHtml(Entity e, Module m) '''
	<!DOCTYPE html>
	<html xmlns:th="http://www.thymeleaf.org">
	<head th:replace="templates/layout :: head(~{this :: title}, ~{this :: .custom-link}, ~{this :: .custom-script}, ~{this :: .custom-body})">
	
	<title th:text="#{mn.«e.name.toLowerCase».titulo}"></title>
	
	<!--/* Links de su pagina */-->
	<link class="custom-link" rel="stylesheet" media="screen"  th:href="@{/resources/css/mn/main-mn.css}" />
	
	<!--/* Scripts de su pagina */-->
	<script class="custom-script" th:src="@{/resources/js/mn/«e.name.toLowerCase».js}"></script>
	</head>
	<body>
		<header th:insert="templates/header :: header">
		</header>
		<br>
		<div class="container custom-body">
			<div id="alertSuccess"></div>
			<div id="alertWarning"></div>
			<div id="alertDanger"></div>
	
			<div class="formTop">
				<span class="titleStaticForm" th:text="#{mn.«e.name.toLowerCase».consulta.titulo}"></span>
				<hr>
				<form id="formBusquedar«e.name.toLowerCase.toFirstUpper»">

					<!--  Codigo Adicional -->
					<!--
					<div class="row">
						<div class="col-md-4">
							<label for="modulosSemaf" class="col-form-label" th:text="#{label.«e.name.toLowerCase».busqueda.modulo}"></label>
							<select name="Modulo" id="moduloSemaf" class="form-control" required>
								<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
								<option th:each="modulo : ${modulo}"  th:value="${modulo.idModulo}" th:utext="${modulo.descripcion}"/>
							</select>
						</div>		
						<div class="col-md-4">
							<label for="procesosSemaf" class="col-form-label" th:text="#{label.«e.name.toLowerCase».busqueda.procesos}"></label>
							<select name="Proceso padre" id="procesosSemaf" class="form-control" required>
								<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
								<option th:each="procesos : ${procesos}" th:value="${procesos.idProcesos}" th:utext="${procesos.descripcion}"/>
							</select>
						</div>
						<div class="col-md-4">
							<label for="subprocesoSemaf" class="col-form-label" th:text="#{label.«e.name.toLowerCase».busqueda.subproceso}"></label>
							<select name="Subproceso padre"
								id="subprocesoSemaf" class="form-control" required>
								<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
								<option th:each="subproceso : ${subproceso}" th:value="${subproceso.idSubproceso}" th:utext="${subproceso.descripcion}"/>
							</select>
						</div>
					</div>
					-->
					<!--  ./Codigo Adicional -->
					
					<div class="row">
						«FOR f : e.entity_fields»
						«f.getAttributeSearch(e)»
						«ENDFOR»						
					</div>
					<div class="row">
						<div class="col-md-6"></div>
						<div class="col-md-6">
							<button name="buscar" id="buscar" type="button"
								class="btn-style-citi float-right mx-0" th:text="#{label.button.buscar}"></button>
							<button name="limpiar" id="limpiar" type="button"
								class="btn-style-citi float-right mx-2" th:text="#{label.button.limpiar}"></button>
						</div>
					</div>
				</form>
			</div>
			<span class="tituloTabla" th:text="#{mn.«e.name.toLowerCase».tabla.titulo}"></span>
			<div class="table-responsive">
				<table class="table table-bordered" id="datostabla">
					<thead class="bg-info">
					</thead>
				</table>
			</div>
			<!-- </div> -->
			<div class="row float-right mx-0 btnList">
				<button type="button" class="btn-style-citi" id="eliminar«e.name.toLowerCase.toFirstUpper»" th:text="#{label.button.eliminar}"></button>
				<button type="button" class="btn-style-citi"
					name="actualizar«e.name.toLowerCase.toFirstUpper»" id="actualizar«e.name.toLowerCase.toFirstUpper»" th:text="#{label.button.actualizar}"></button>
				<button type="button" class="btn-style-citi" data-toggle="modal"
					data-target=".modalNew«e.name.toLowerCase.toFirstUpper»" th:text="#{label.button.agregar}"></button>
			</div>
	
		<!-- The Modal New -->
		<div class="modal fade modalNew«e.name.toLowerCase.toFirstUpper»" tabindex="-1" role="dialog"
			aria-labelledby="modalNuevo«e.name.toLowerCase.toFirstUpper»" aria-hidden="true"
			id="modalNew«e.name.toLowerCase.toFirstUpper»" style="display: none;">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title" id="modalNuevo«e.name.toLowerCase.toFirstUpper»" th:text="#{mn.«e.name.toLowerCase».modal.agregar.titulo}"></h4>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="container-body">
						<form class="needs-validation mt-1" id="formularioNew«e.name.toLowerCase.toFirstUpper»"
							novalidate>
							<!--  Codigo Adicional -->
							<!--
							<div class="row">	
								<div class="col-lg-6 form-group">
									<div class="col-lg-12 text-left">
									<label for="modulo" class="col-form-label" th:text="#{label.«e.name.toLowerCase».busqueda.modulo}"></label> 
									</div>
									<div class="col-lg-12">
									<select name="Modulo padre"
										id="moduloNew" class="form-control" required>
										<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
										<option th:each="modulo : ${modulo}" th:value="${modulo.idModulo}" th:utext="${modulo.descripcion}"/>
									</select>
									</div>
								</div>						
								<div class="col-lg-6 form-group">
									<div class="col-lg-12 text-left">
									<label for="proceso" class="col-form-label" th:text="#{label.«e.name.toLowerCase».busqueda.proceso}"></label> 
									</div>
									<div class="col-lg-12">
									<select name="Proceso padre"
										id="procesoNew" class="form-control" required>
										<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
										<option th:each="procesos : ${procesos}" th:value="${procesos.idProcesos}" th:utext="${procesos.descripcion}"/>
									</select>
									</div>
								</div>						
								<div class="col-lg-6 form-group">
									<div class="col-lg-12 text-left">
									<label for="subproceso" class="col-form-label" th:text="#{label.«e.name.toLowerCase».busqueda.subproceso}"></label> 
									</div>
									<div class="col-lg-12">
									<select name="Subproceso padre"
										id="SubprocesoNew" class="form-control" required>
										<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
										<option th:each="subproceso : ${subproceso}" th:value="${subproceso.idSubproceso}" th:utext="${subproceso.descripcion}"/>
									</select>
									</div>
								</div>
							</div>	
							-->
							<!--  ./Codigo Adicional -->
							
							<div class="row">
								«FOR f : e.entity_fields»
								«f.getAttribute(e)»
								«ENDFOR»
							</div>
							<div class="modal-footer ">
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
						<h4 class="modal-title" id="modal«e.name.toLowerCase.toFirstUpper»Editar" th:text="#{mn.«e.name.toLowerCase».modal.actualizar.titulo}"></h4>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="container-body">
						<form class="needs-validation mt-1" id="formularioEdit«e.name.toLowerCase.toFirstUpper»" novalidate>
						
							<!--  Codigo Adicional -->
							<!--
							<div class="row">
								<div class="col-lg-6 form-group">
									<div class="col-lg-12 text-left">
									<label for="modulo" class="col-form-label" th:text="#{label.«e.name.toLowerCase».busqueda.modulo}"></label> 
									</div>
									<div class="col-lg-12">
									<select name="Modulo padre"
										id="moduloEdit" class="form-control" required>
										<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
										<option th:each="modulo : ${modulo}" th:value="${modulo.idModulo}" th:utext="${modulo.descripcion}"/>
									</select>
									</div>
								</div>
								<div class="col-lg-6 form-group">
									<div class="col-lg-12 text-left">
									<label for="proceso" class="col-form-label" th:text="#{label.«e.name.toLowerCase».busqueda.proceso}"></label> 
									</div>
									<div class="col-lg-12">
									<select name="Proceso padre"
										id="procesoEdit" class="form-control" required>
										<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
										<option th:each="procesos : ${procesos}" th:value="${procesos.idProcesos}" th:utext="${procesos.descripcion}"/>
									</select>
									</div>
								</div>
								<div class="col-lg-6 form-group">
									<div class="col-lg-12 text-left">
									<label for="subproceso" class="col-form-label" th:text="#{label.«e.name.toLowerCase».busqueda.subproceso}"></label> 
									</div>
									<div class="col-lg-12">
									<select name="Subproceso padre"
										id="subprocesoEdit" class="form-control" required>
										<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
										<option th:each="subproceso : ${subproceso}" th:value="${subproceso.idSubproceso}" th:utext="${subproceso.descripcion}"/>
									</select>
									</div>
								</div>												
							</div>
							-->
							<!--  ./Codigo Adicional -->						

							<div class="row">
								«FOR f : e.entity_fields»
								«f.getAttributeEdit(e)»
								«ENDFOR»
							</div>
							<div class="modal-footer">
								<button type="button" class="btn-style-citi" data-dismiss="modal" th:text="#{cg.cerrar}"></button>
								<button type="submit" class="btn-style-citi"
									name="editar«e.name.toLowerCase.toFirstUpper»" id="editar«e.name.toLowerCase.toFirstUpper»" th:text="#{cg.guardar}"></button>
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
						<h5 class="modal-title" id="modalEliminarTitle"  th:text="#{mn.«e.name.toLowerCase».modal.eliminar.titulo}"></h5>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="text-center">
							<p th:text="#{mn.«e.name.toLowerCase».modal.eliminar}"></p>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn-style-citi" data-dismiss="modal" th:text="#{cg.cerrar}"></button>
						<button type="button" class="btn-style-citi"
							id="eliminar«e.name.toLowerCase.toFirstUpper»Confirm" th:text="#{cg.aceptar}"></button>
					</div>
				</div>
			</div>
		</div>
		</div>
		
		<footer th:replace="templates/footer :: footer">
		</footer>
	</body>
	</html>
	'''
	/* ./Archivo Principal */
	
	
	/* Get Attribute Field */
	def dispatch getAttribute(EntityTextField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»New"
				name="«f.name.toLowerCase»New" maxlength="100" required>
			<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>	
	'''
	def dispatch getAttribute(EntityLongTextField f, Entity t)'''
	<div class="col-lg-12 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»New" class="col-form-label"  th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<textarea class="form-control" id="«f.name.toLowerCase»New"  name="«f.name.toLowerCase»New" maxlength="100" rows="3"></textarea>
			<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>
	'''
	def dispatch getAttribute(EntityDateField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»New"
				name="«f.name.toLowerCase»New" maxlength="100" required>
			<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>	
	'''
	
	def dispatch getAttribute(EntityDateTimeField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»New"
				name="«f.name.toLowerCase»New" maxlength="100" required>
			<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>	
	'''
	
	def dispatch getAttribute(EntityTimeField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»New"
				name="«f.name.toLowerCase»New" maxlength="100" required>
			<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>	
	'''
	
	def dispatch getAttribute(EntityBooleanField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»New"
				name="«f.name.toLowerCase»New" maxlength="100" required>
			<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>	
	'''
	def dispatch getAttribute(EntityImageField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»New"
				name="«f.name.toLowerCase»New" maxlength="100" required>
			<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>	
	'''
	def dispatch getAttribute(EntityFileField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»New"
				name="«f.name.toLowerCase»New" maxlength="100" required>
			<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>	
	'''
	def dispatch getAttribute(EntityEmailField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»New"
				name="«f.name.toLowerCase»New" maxlength="100" required>
			<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>	
	'''
	def dispatch getAttribute(EntityDecimalField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»New"
				name="«f.name.toLowerCase»New" maxlength="100" required>
			<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>	
	'''
	def dispatch getAttribute(EntityIntegerField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»New"
				name="«f.name.toLowerCase»New" maxlength="100" required>
			<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>	
	'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»New" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»New"
				name="«f.name.toLowerCase»New" maxlength="100" required>
			<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>
	'''	
	
	def dispatch getAttribute(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationship(t, f.name, entityFieldUtils.getFieldGlossaryName(f))»
	«ENDIF»
	'''	
	
	def dispatch genRelationship(Enum e, Entity t, String name, String glossaryName) '''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
		<label for="«name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«e.name.toLowerCase»}"></label> 
		</div>
		<div class="col-lg-12">
		<select name="«glossaryName»"
			id="«name.toLowerCase»New" class="form-control" required>
			<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
			<option th:each="«name.toLowerCase» : ${«name.toLowerCase»}" th:value="${«name.toLowerCase».cve«name.toLowerCase.toFirstUpper»}" th:utext="${«name.toLowerCase».descripcion}"/>
		</select>
		</div>
	</div>
	'''
	
	def dispatch genRelationship(Entity e, Entity t, String name, String glossaryName) ''' 
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
		<label for="«name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«e.name.toLowerCase»}"></label> 
		</div>
		<div class="col-lg-12">
		<select name="«glossaryName»"
			id="«name.toLowerCase»New" class="form-control" required>
			<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
			<option th:each="«name.toLowerCase» : ${«name.toLowerCase»}" th:value="${«name.toLowerCase».clave}" th:utext="${«name.toLowerCase».descripcion}"/>
		</select>
		</div>
	</div>
	'''
	
	/* Get Attribute Field */
	def dispatch getAttributeEdit(EntityTextField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»Edit"
				name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityLongTextField f, Entity t)'''
	<div class="col-lg-12 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»Edit" class="col-form-label"  th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<textarea class="form-control" id="«f.name.toLowerCase»Edit"  name="«f.name.toLowerCase»Edit" maxlength="100" rows="3"></textarea>
			<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>	
	'''
	def dispatch getAttributeEdit(EntityDateField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»Edit"
				name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityDateTimeField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»Edit"
				name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityTimeField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»Edit"
				name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityBooleanField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»Edit"
				name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityImageField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»Edit"
				name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityFileField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»Edit"
				name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityEmailField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»Edit"
				name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityDecimalField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»Edit"
				name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityIntegerField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»Edit"
				name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>
	'''
	def dispatch getAttributeEdit(EntityCurrencyField f, Entity t)'''
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
			<label for="«f.name.toLowerCase»Edit" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}"></label>
		</div>
		<div class="col-lg-12">
			<input type="text" class="form-control" id="«f.name.toLowerCase»Edit"
				name="«f.name.toLowerCase»Edit" maxlength="100" required>
				<div class="invalid-feedback" th:text="#{cg.error.requerido}"></div>
		</div>
	</div>
	'''	
	
	def dispatch getAttributeEdit(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipEdit(t, f.name, entityFieldUtils.getFieldGlossaryName(f))»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipEdit(Enum e, Entity t, String name, String glossaryName) ''' 
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
		<label for="«name.toLowerCase»" class="col-form-label" th:text="#{cg.«t.name.toLowerCase».«e.name.toLowerCase»}"></label> 
		</div>
		<div class="col-lg-12">
		<select name="«glossaryName»"
			id="descripcion«name.toLowerCase.toFirstUpper»" class="form-control" required>
			<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
			<option th:each="«name.toLowerCase» : ${«name.toLowerCase»}" th:value="${«name.toLowerCase».cve«name.toLowerCase.toFirstUpper»}" th:utext="${«name.toLowerCase».descripcion}"/>
		</select>
		</div>
	</div>
	'''
	
	def dispatch genRelationshipEdit(Entity e, Entity t, String name, String glossaryName) ''' 
	<div class="col-lg-6 form-group">
		<div class="col-lg-12 text-left">
		<label for="«name.toLowerCase»" class="col-form-label" th:text="#{cg.«t.name.toLowerCase».«e.name.toLowerCase»}"></label> 
		</div>
		<div class="col-lg-12">
		<select name="«glossaryName»"
			id="«name.toLowerCase»Edit" class="form-control" required>
			<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
			<option th:each="«name.toLowerCase» : ${«name.toLowerCase»}" th:value="${«name.toLowerCase».clave}" th:utext="${«name.toLowerCase».descripcion}"/>
		</select>
		</div>
	</div>
	'''	
	
	/* Get Attribute Field */
	def dispatch getAttributeTitle(EntityTextField f, Entity t)'''
	<th scope="col">«entityFieldUtils.getFieldGlossaryName(f)»</th>
	'''
	def dispatch getAttributeTitle(EntityLongTextField f, Entity t)'''
	<th scope="col">«entityFieldUtils.getFieldGlossaryName(f)»</th>
	'''
	def dispatch getAttributeTitle(EntityDateField f, Entity t)'''
	<th scope="col">«entityFieldUtils.getFieldGlossaryName(f)»</th>
	'''
	def dispatch getAttributeTitle(EntityDateTimeField f, Entity t)'''
	<th scope="col">«entityFieldUtils.getFieldGlossaryName(f)»</th>
	'''
	def dispatch getAttributeTitle(EntityTimeField f, Entity t)'''
	<th scope="col">«entityFieldUtils.getFieldGlossaryName(f)»</th>
	'''
	def dispatch getAttributeTitle(EntityBooleanField f, Entity t)'''
	<th scope="col">«entityFieldUtils.getFieldGlossaryName(f)»</th>
	'''
	def dispatch getAttributeTitle(EntityImageField f, Entity t)'''
	<th scope="col">«entityFieldUtils.getFieldGlossaryName(f)»</th>
	'''
	def dispatch getAttributeTitle(EntityFileField f, Entity t)'''
	<th scope="col">«entityFieldUtils.getFieldGlossaryName(f)»</th>
	'''
	def dispatch getAttributeTitle(EntityEmailField f, Entity t)'''
	<th scope="col">«entityFieldUtils.getFieldGlossaryName(f)»</th>
	'''
	def dispatch getAttributeTitle(EntityDecimalField f, Entity t)'''
	<th scope="col">«entityFieldUtils.getFieldGlossaryName(f)»</th>
	'''
	def dispatch getAttributeTitle(EntityIntegerField f, Entity t)'''
	<th scope="col">«entityFieldUtils.getFieldGlossaryName(f)»</th>
	'''
	def dispatch getAttributeTitle(EntityCurrencyField f, Entity t)'''
	<th scope="col">«entityFieldUtils.getFieldGlossaryName(f)»</th>
	'''	
	def dispatch getAttributeTitle(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
	<th scope="col">«entityFieldUtils.getFieldGlossaryName(f)»</th>
	«ENDIF»
	'''	
	
	/* Get Attribute Search */
	def dispatch getAttributeSearch(EntityTextField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityLongTextField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityDateField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityDateTimeField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityTimeField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityBooleanField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityImageField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityFileField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityEmailField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityDecimalField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityIntegerField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''
	def dispatch getAttributeSearch(EntityCurrencyField f, Entity t)'''
	<div class="col-md-4">
		<label for="«f.name.toLowerCase»" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«f.name.toLowerCase»}">
		</label> <input name="«f.name.toLowerCase»Semaf" type="text"
			class="form-control" id="«f.name.toLowerCase»Semaf" required>
	</div>
	'''	
	
	def dispatch getAttributeSearch(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipSearch(t, f.name, entityFieldUtils.getFieldGlossaryName(f))»
	«ENDIF»
	'''	
	
	def dispatch genRelationshipSearch(Enum e, Entity t, String name, String glossaryName) ''' 
	<div class="col-md-4">
		<label for="«name.toLowerCase»Semaf" class="col-form-label" th:text="#{mn.«t.name.toLowerCase».«e.name.toLowerCase»}"></label>
		<select name="«glossaryName»"
			id="«name.toLowerCase»Semaf" class="form-control" required>
			<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
			<option th:each="«name.toLowerCase» : ${«name.toLowerCase»}" th:value="${«name.toLowerCase».clave}" th:utext="${«name.toLowerCase».descripcion}"/>
		</select>
	</div>
	'''
	
	def dispatch genRelationshipSearch(Entity e, Entity t, String name, String glossaryName) ''' 
	<div class="col-md-4">
		<label for="«name.toLowerCase»Semaf" class="col-form-label" th:text="#{cg.«t.name.toLowerCase».«e.name.toLowerCase»}"></label>
		<select name="«glossaryName»"
			id="«name.toLowerCase»Semaf" class="form-control" required>
			<option value="0" th:text="#{label.busqueda.seleccionar}" selected></option>
			<option th:each="«name.toLowerCase» : ${«name.toLowerCase»}" th:value="${«name.toLowerCase».clave}" th:utext="${«name.toLowerCase».descripcion}"/>
		</select>
	</div>
	'''	
	
}