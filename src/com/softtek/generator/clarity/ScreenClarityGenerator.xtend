package com.softtek.generator.clarity

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.FormComponent
import com.softtek.rdl2.ListComponent
import com.softtek.rdl2.DetailComponent
import com.softtek.rdl2.MessageComponent
import com.softtek.rdl2.UIField
import com.softtek.rdl2.UIDisplay
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
import com.softtek.rdl2.Enum
import com.softtek.rdl2.Entity

import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.rdl2.UILinkFlow
import com.softtek.generator.utils.UIFlowUtils
import com.softtek.rdl2.UIFormRow
import com.softtek.rdl2.RowComponent
import com.softtek.rdl2.ColumnComponent
import org.eclipse.emf.common.util.EList
import com.softtek.rdl2.SizeOption
import com.softtek.rdl2.UIFormContainer
import com.softtek.rdl2.UIFormPanel
import com.softtek.rdl2.UIFormColumn
import com.softtek.rdl2.WidgetAttrEnumType
import com.softtek.rdl2.WidgetAttrEnumTypeSelect
import com.softtek.rdl2.WidgetDisplayResult
import com.softtek.rdl2.WidgetLabel
import com.softtek.rdl2.WidgetHelp
import com.softtek.rdl2.WidgetExposedFilter
import com.softtek.rdl2.WidgetType
import org.apache.commons.lang3.RandomStringUtils
import com.softtek.rdl2.UICommandFlow
import com.softtek.rdl2.UIQueryFlow
import com.softtek.rdl2.InlineFormComponent
import com.softtek.rdl2.UIComponent
import com.softtek.generator.utils.EntityUtils
import com.softtek.rdl2.UITextField
import com.softtek.rdl2.UILongTextField
import com.softtek.rdl2.UIDateField
import com.softtek.rdl2.UIImageField
import com.softtek.rdl2.UIFileField
import com.softtek.rdl2.UIEmailField
import com.softtek.rdl2.UIDecimalField
import com.softtek.rdl2.UIIntegerField
import com.softtek.rdl2.UICurrencyField
import com.softtek.rdl2.OffSetMD

class ScreenClarityGenerator {
	
	var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
		def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				if (p.screen_type === null) {
					fsa.generateFile("clarity/src/app/admin/" +m.name.toLowerCase+ "/" +p.name.toLowerCase+"/"+p.name.toLowerCase +".psg.html", p.generateTag(m))
				}
			}
		}
	}
	
	def CharSequence generateTag(PageContainer page, Module module) '''
		   <div class="card-block">
		   «FOR c : page.components»
		   		«c.genUIComponent(module, page)»
		   «ENDFOR»
		   </div>
		   <div class="ln_solid"></div>
		   <div class="card-block">
			   	<p>
	   			«FOR flow : page.links»
	   				«flow.genPageFlow»
	   			«ENDFOR»
	   			</p>
   			</div>	
	'''
	
	// Form
	def dispatch genUIComponent(FormComponent form, Module module, PageContainer page) '''	
		<!-- form -->
		<form class="form" [formGroup]="«form.name.toLowerCase»Form">
			«FOR field : form.form_elements»
				«field.genUIFormElement(form)»
			«ENDFOR»
			<div class="ln_solid"></div>
			«FOR flow : form.links»
				«flow.genFormFlow»
			«ENDFOR»
		</form>
		<!-- ./form -->	
	'''

	// InlineFormComponent
	def dispatch genUIComponent(InlineFormComponent form, Module module, PageContainer page) '''
	<!--	<simple-admin id="«form.name.toLowerCase»" maxrows="8"/>-->
	'''
	
	// ListComponent
	def dispatch genUIComponent(ListComponent l, Module module, PageContainer page) '''
	<!-- PSG Administrar «page.page_title» Html -->
	<div class="card-header">
	«page.page_title»
	</div>
	
	<div class="card-block">  
	    <clr-datagrid [clrDgLoading]="loading">
	        <clr-dg-placeholder>No se encontró información.</clr-dg-placeholder>
	        
	        «FOR h : l.list_elements»
				«h.genTableHeader»
			«ENDFOR»
			
	            <clr-dg-row *clrDgItems="let «page.name.toLowerCase» of «page.name.toLowerCase»Array" [clrDgItem]="«page.name.toLowerCase»">
	                <div hidden="true">
	                    <div>
	                        <button class="action-item" (click)="setClickedRowEdita«page.name.toLowerCase.toFirstUpper»(i, «page.name.toLowerCase»)">Editar</button> 
	                    </div>
	                    <div>
	                        <button class="action-item" (click)="setClickedRowElimina«page.name.toLowerCase.toFirstUpper»(i, «page.name.toLowerCase»)">Eliminar</button>
	                    </div>
	                </div>
	                <clr-dg-action-overflow>
	                    <button class="action-item" *ngIf="beneficiario_update" (click)="setClickedRowEdita«page.name.toLowerCase.toFirstUpper»(i, «page.name.toLowerCase»)">
	                        <clr-icon shape="note" ></clr-icon> Editar
	                    </button>
	                    <button class="action-item" *ngIf="beneficiario_delete" (click)="setClickedRowElimina«page.name.toLowerCase.toFirstUpper»(i, «page.name.toLowerCase»)">
	                        <clr-icon shape="trash"></clr-icon> Borrar
	                    </button>
	                </clr-dg-action-overflow>
	
					«FOR i : 1..8»
						<clr-dg-row>
							«FOR h : l.list_elements»
								«h.genTableRows»
							«ENDFOR»
							«IF l.links.size > 0»
									«FOR f : l.links»
										«f.genFlowRows»
									«ENDFOR»
							«ENDIF»
						</clr-dg-row>
					«ENDFOR»
	
	            </clr-dg-row>
	            <clr-dg-footer>
	                <clr-dg-column-toggle>
	                    <clr-dg-column-toggle-title>Elegir columnas</clr-dg-column-toggle-title>
	                    <clr-dg-column-toggle-button>Seleccionar todas</clr-dg-column-toggle-button>
	                </clr-dg-column-toggle>
	                <clr-dg-pagination #pagination [clrDgPageSize]="10">
	                    {{pagination.firstItem + 1}} - {{pagination.lastItem + 1}}
	                    de {{pagination.totalItems}} registros
	                </clr-dg-pagination>
	            </clr-dg-footer>
	    	</clr-datagrid>
	</div>		
	
	'''
	
	// DetailComponent
	def dispatch genUIComponent(DetailComponent detail, Module module, PageContainer page) '''
		<div class="card-block">
		«FOR field : detail.list_elements»
			«field.genUIDetailElement(null)»
		«ENDFOR»
		</div>
		<div class="card-block">
		«FOR flow : detail.links»		
			«flow.genFormFlow»
		«ENDFOR»
		</div>
	'''
	
	// MessageComponent
	def dispatch genUIComponent(MessageComponent m, Module module, PageContainer page) '''
		<div style="overflow: auto">
			«m.msgtext»
		</div>
	'''
	
	// RowComponent
	def dispatch genUIComponent(RowComponent row, Module module, PageContainer page) '''
		<!--<div class="row">
			«FOR c : row.columns»
			Nombre: «c»
«««				«c.genColumnComponent(module)»
			«ENDFOR»
		</div>-->
	'''
	
	/*
	 * genTableRows
	 */
	def dispatch genTableRows(UIField element) ''''''
	
	// Rows Table
	def dispatch genTableRows(UIDisplay element) '''
		«element.ui_field.genRowsUIDisplayField»
	'''
	def dispatch genTableRows(UIFormContainer element) '''
	'''
	
	def CharSequence genColumnComponent(ColumnComponent column, Module module) '''
		<!--<div class="«column.sizes.genColSize»">
			«FOR e : column.elements»
			column: «e»
«««				«e.genUIComponent(module)»
			«ENDFOR»
		</div>-->
	'''
	
	def genColSize(EList<SizeOption> list) {
		var col_class = ""
		for (size : list) {
			col_class = col_class + "col-" + size.sizeop + " "
			if (size.offset !== null) {
				var offset = size.offset as OffSetMD
				col_class = col_class + "col-" + offset.sizeop + " "
			}
			if (size.centermargin !== null) {
				col_class = col_class + "center-margin "
			}
		}
		return col_class
	}
	
	/*
	 * genUIFormElement
	 */
	def dispatch genUIFormElement(UIField e, FormComponent form) '''
		«e.genFormUIField(form)»
	'''
	
	// UIElement - > FormComponent
	def dispatch genUIFormElement(UIDisplay e, FormComponent form) '''
		«e.ui_field.genUIFormEntityField(form)»
	'''
	
	def dispatch genUIFormElement(UIFormContainer e, FormComponent form) '''
«««		«e.genUIFormContainer(form)»
	'''
	
	/*
	 * UIField
	 */
	def dispatch genFormUIField(UITextField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="«field.name.toLowerCase»" class="clr-control-label">«field.name.toLowerCase.toFirstUpper»<span class="required">*</span></label>
		    <div class="clr-control-container clr-col-md-12"> 
		        <label for="«field.name.toLowerCase»" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm clr-input clr-col-sm-11 clr-col-md-11"
		                [class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»').touched)">
		            <input id="«field.name.toLowerCase»" type="text" formControlName="«field.name.toLowerCase»" placeholder="«field.name.toLowerCase.toFirstUpper»" class="clr-input clr-col-sm-12 clr-col-md-12">
		            <span class="tooltip-content">
		                «field.name» es requerido.
		            </span>
		        </label>
		    </div>
		</div>
	'''
	def dispatch genFormUIField(UILongTextField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="«field.name.toLowerCase»" class="clr-control-label">«field.name.toLowerCase.toFirstUpper»<span class="required">*</span></label>
		    <div class="clr-control-container clr-col-md-12"> 
		        <label for="«field.name.toLowerCase»" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm clr-input clr-col-sm-11 clr-col-md-11"
		                [class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»').touched)">
		            <textarea id="«field.name.toLowerCase»" formControlName="«field.name.toLowerCase»" rows="5" placeholder="«field.name.toLowerCase.toFirstUpper»" class="clr-textarea clr-col-sm-12 clr-col-md-12"></textarea>
		            <span class="tooltip-content">
		                «field.name.toLowerCase.toFirstUpper» es requerido.
		            </span>
		        </label>
		    </div>
		</div>
	'''
	def dispatch genFormUIField(UIDateField field, FormComponent form) '''
		<div class="clr-form-control">
			<label for="«field.name.toLowerCase»Aux" class="clr-control-label">«field.name.toLowerCase.toFirstUpper»<span class="required">*</span></label>
			<div class="clr-control-container clr-col-md-12"> 
				<label for="«field.name.toLowerCase»Aux" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm"
						[class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»Aux').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»Aux').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»Aux').touched)">
					<input id="«field.name.toLowerCase»Aux" placeholder="MM/DD/YYYY" type="date" style="width: 700px" class="clr-input" clrDate formControlName="«field.name.toLowerCase»Aux"/>
					<span class="tooltip-content">
						«field.name.toLowerCase» es requerido.
					</span>
				</label>
			</div>
		</div>
	'''
	def dispatch genFormUIField(UIImageField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="vertical-file3" class="clr-control-label" >«field.name.toLowerCase.toFirstUpper»<span class="required">*</span>
		    </label>
		    <div class="clr-control-container">
		        <div class="clr-file-wrapper">
		            <input type="file" id="«field.name.toLowerCase»" formControlName="«field.name.toLowerCase»" placeholder="«field.name.toLowerCase.toFirstUpper»">
		            <control-messages class="control-messages" [control]="«form.name.toLowerCase»Form.controls.«field.name.toLowerCase»"></control-messages>
		        </div>
		    </div>
		</div>
	'''
	def dispatch genFormUIField(UIFileField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="vertical-file3" class="clr-control-label" >«field.name.toLowerCase.toFirstUpper»<span class="required">*</span>
		    </label>
		    <div class="clr-control-container">
		        <div class="clr-file-wrapper">
		            <input type="file" id="«field.name.toLowerCase»" formControlName="«field.name.toLowerCase»" placeholder="«field.name.toLowerCase.toFirstUpper»">
		            <control-messages class="control-messages" [control]="«form.name.toLowerCase»Form.controls.«field.name.toLowerCase»"></control-messages>
		        </div>
		    </div>
		</div>
	'''
	def dispatch genFormUIField(UIEmailField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="«field.name.toLowerCase»" class="clr-control-label">«field.name.toLowerCase.toFirstUpper»<span class="required">*</span></label>
		    <div class="clr-control-container clr-col-md-12"> 
		        <label for="«field.name.toLowerCase»" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm clr-input clr-col-sm-11 clr-col-md-11"
		                [class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»').touched)">
		            <input id="«field.name.toLowerCase»" type="text" formControlName="«field.name.toLowerCase»" placeholder="«field.name.toLowerCase.toFirstUpper»" class="clr-input clr-col-sm-12 clr-col-md-12">
		            <span class="tooltip-content">
		                «field.name.toLowerCase.toFirstUpper» es requerido.
		            </span>
		        </label>
		    </div>
		</div>
	'''
	def dispatch genFormUIField(UIDecimalField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="«field.name.toLowerCase»" class="clr-control-label">«field.name.toLowerCase.toFirstUpper»<span class="required">*</span></label>
		    <div class="clr-control-container clr-col-md-12"> 
		        <label for="«field.name.toLowerCase»" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm clr-input clr-col-sm-11 clr-col-md-11"
		                [class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»').touched)">
		            <input id="«field.name.toLowerCase»" type="number" formControlName="«field.name.toLowerCase»" placeholder="Semanas_cotizadas" class="clr-input clr-col-sm-12 clr-col-md-12">
		            <span class="tooltip-content">
		                «field.name.toLowerCase.toFirstUpper» es requerido.
		            </span>
		        </label>
		    </div>
		</div>
	'''
	def dispatch genFormUIField(UIIntegerField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="«field.name.toLowerCase»" class="clr-control-label">«field.name.toLowerCase.toFirstUpper»<span class="required">*</span></label>
		    <div class="clr-control-container clr-col-md-12"> 
		        <label for="«field.name.toLowerCase»" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm clr-input clr-col-sm-11 clr-col-md-11"
		                [class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»').touched)">
		            <input id="«field.name.toLowerCase»" type="number" formControlName="«field.name.toLowerCase»" placeholder="Semanas_cotizadas" class="clr-input clr-col-sm-12 clr-col-md-12">
		            <span class="tooltip-content">
		                «field.name.toLowerCase.toFirstUpper» es requerido.
		            </span>
		        </label>
		    </div>
		</div>
	'''
	def dispatch genFormUIField(UICurrencyField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="«field.name.toLowerCase»" class="clr-control-label">«field.name.toLowerCase.toFirstUpper»<span class="required">*</span></label>
		    <div class="clr-control-container clr-col-md-12"> 
		        <label for="«field.name.toLowerCase»" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm clr-input clr-col-sm-11 clr-col-md-11"
		                [class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»').touched)">
		            <input id="«field.name.toLowerCase»" type="number" formControlName="«field.name.toLowerCase»" placeholder="Semanas_cotizadas" class="clr-input clr-col-sm-12 clr-col-md-12">
		            <span class="tooltip-content">
		                «field.name.toLowerCase.toFirstUpper» es requerido.
		            </span>
		        </label>
		    </div>
		</div>
	'''	
	
	/*
	 * UILinkCommandQueryFlow
	 */
	def dispatch genFormFlow(UICommandFlow flow) '''
		<button id="«flow.name.toLowerCase»" type="submit" class="btn btn-outline" [routerLink]="['../«flow.success_flow.genQueryFlowToContainer.getParentModule.name.toLowerCase»']" ><clr-icon shape="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»"></clr-icon>«uiFlowUtils.getFlowLabel(flow)»</button>
	'''
	def dispatch genFormFlow(UIQueryFlow flow) '''
		<button id="«flow.name.toLowerCase»" type="submit" class="btn btn-outline" [routerLink]="['../«flow.success_flow.genQueryFlowToContainer.getParentModule.name.toLowerCase»']" ><clr-icon shape="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»"></clr-icon>«uiFlowUtils.getFlowLabel(flow)»</button>
	'''
	def dispatch genFormFlow(UILinkFlow flow) '''
		<button id="«flow.name.toLowerCase»" type="submit" class="btn btn-outline" [routerLink]="['../«flow.link_to.genCommandFlowToContainer.getParentModule.name.toLowerCase»']" ><clr-icon shape="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»"></clr-icon>«uiFlowUtils.getFlowLabel(flow)»</button>
	'''	
	
		/*
	 * genEntityField
	 */
	def dispatch genUIFormEntityField(EntityReferenceField field, FormComponent form) '''
«««		«field.superType.genUIFormRelationshipField(field)»
	'''
	
	def dispatch genUIFormEntityField(EntityTextField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="«field.name.toLowerCase»" class="clr-control-label">«entityFieldUtils.getFieldGlossaryName(field)»«IF entityFieldUtils.isFieldRequired(field)»<span class="required">*</span>«ENDIF»</label>
		    <div class="clr-control-container clr-col-md-12"> 
		        <label for="«field.name.toLowerCase»" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm clr-input clr-col-sm-11 clr-col-md-11"
		                [class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»').touched)">
		            <input id="«field.name.toLowerCase»" type="text" formControlName="«field.name.toLowerCase»" placeholder="«entityFieldUtils.getFieldGlossaryName(field)»" class="clr-input clr-col-sm-12 clr-col-md-12">
		            «IF entityFieldUtils.isFieldRequired(field)»
		            <span class="tooltip-content">
		                «entityFieldUtils.getFieldGlossaryName(field)» es requerido.
		            </span>
		           «ENDIF»
		        </label>
		    </div>
		</div>
	'''
	
	def dispatch genUIFormEntityField(EntityLongTextField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="«field.name.toLowerCase»" class="clr-control-label">«entityFieldUtils.getFieldGlossaryName(field)»«IF entityFieldUtils.isFieldRequired(field)»<span class="required">*</span>«ENDIF»</label>
		    <div class="clr-control-container clr-col-md-12"> 
		        <label for="«field.name.toLowerCase»" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm clr-input clr-col-sm-11 clr-col-md-11"
		                [class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»').touched)">
		            <textarea id="«field.name.toLowerCase»" formControlName="«field.name.toLowerCase»" rows="5" placeholder="«entityFieldUtils.getFieldGlossaryName(field)»" class="clr-textarea clr-col-sm-12 clr-col-md-12"></textarea>
		            «IF entityFieldUtils.isFieldRequired(field)»
		            <span class="tooltip-content">
		                «entityFieldUtils.getFieldGlossaryName(field)» es requerido.
		            </span>
		           «ENDIF»
		        </label>
		    </div>
		</div>
	'''
	
	def dispatch genUIFormEntityField(EntityDateField field, FormComponent form) '''
		<div class="clr-form-control">
			<label for="«field.name.toLowerCase»Aux" class="clr-control-label">«entityFieldUtils.getFieldGlossaryName(field)»«IF entityFieldUtils.isFieldRequired(field)»<span class="required">*</span>«ENDIF»</label>
			<div class="clr-control-container clr-col-md-12"> 
				<label for="«field.name.toLowerCase»Aux" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm"
						[class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»Aux').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»Aux').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»Aux').touched)">
					<input id="«field.name.toLowerCase»Aux" placeholder="MM/DD/YYYY" type="date" style="width: 700px" class="clr-input" clrDate formControlName="«field.name.toLowerCase»Aux"/>
		            «IF entityFieldUtils.isFieldRequired(field)»
		            <span class="tooltip-content">
		                «entityFieldUtils.getFieldGlossaryName(field)» es requerido.
		            </span>
		           «ENDIF»				
		    	</label>
			</div>
		</div>	
	'''
	
	def dispatch genUIFormEntityField(EntityImageField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="vertical-file3" class="clr-control-label" >«entityFieldUtils.getFieldGlossaryName(field)»«IF entityFieldUtils.isFieldRequired(field)»<span class="required">*</span>«ENDIF»</label>
		    <div class="clr-control-container">
		        <div class="clr-file-wrapper">
		            <input type="file" id="«field.name.toLowerCase»" formControlName="«field.name.toLowerCase»" placeholder="«entityFieldUtils.getFieldGlossaryName(field)»">
		            <control-messages class="control-messages" [control]="«form.name.toLowerCase»Form.controls.«field.name.toLowerCase»"></control-messages>
		        </div>
		    </div>
		</div>
	'''
	
	def dispatch genUIFormEntityField(EntityFileField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="vertical-file3" class="clr-control-label" >«entityFieldUtils.getFieldGlossaryName(field)»«IF entityFieldUtils.isFieldRequired(field)»<span class="required">*</span>«ENDIF»</label>
		    <div class="clr-control-container">
		        <div class="clr-file-wrapper">
		            <input type="file" id="«field.name.toLowerCase»" formControlName="«field.name.toLowerCase»" placeholder="«entityFieldUtils.getFieldGlossaryName(field)»">
		            <control-messages class="control-messages" [control]="«form.name.toLowerCase»Form.controls.«field.name.toLowerCase»"></control-messages>
		        </div>
		    </div>
		</div>
	'''
	
	def dispatch genUIFormEntityField(EntityEmailField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="«field.name.toLowerCase»" class="clr-control-label">«entityFieldUtils.getFieldGlossaryName(field)»«IF entityFieldUtils.isFieldRequired(field)»<span class="required">*</span>«ENDIF»</label>
		    <div class="clr-control-container clr-col-md-12"> 
		        <label for="«field.name.toLowerCase»" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm clr-input clr-col-sm-11 clr-col-md-11"
		                [class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»').touched)">
		            <input id="«field.name.toLowerCase»" type="text" formControlName="«field.name.toLowerCase»" placeholder="«entityFieldUtils.getFieldGlossaryName(field)»" class="clr-input clr-col-sm-12 clr-col-md-12">
		            «IF entityFieldUtils.isFieldRequired(field)»
		            <span class="tooltip-content">
		                «field.name» es requerido.
		            </span>
		           «ENDIF»
		        </label>
		    </div>
		</div>
	'''
	
	def dispatch genUIFormEntityField(EntityDecimalField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="«field.name.toLowerCase»" class="clr-control-label">«entityFieldUtils.getFieldGlossaryName(field)»«IF entityFieldUtils.isFieldRequired(field)»<span class="required">*</span>«ENDIF»</label>
		    <div class="clr-control-container clr-col-md-12"> 
		        <label for="«field.name.toLowerCase»" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm clr-input clr-col-sm-11 clr-col-md-11"
		                [class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»').touched)">
		            <input id="«field.name.toLowerCase»" type="number" formControlName="«field.name.toLowerCase»" placeholder="«entityFieldUtils.getFieldGlossaryName(field)»" class="clr-input clr-col-sm-12 clr-col-md-12">
		            «IF entityFieldUtils.isFieldRequired(field)»
		            <span class="tooltip-content">
		                «field.name» es requerido.
		            </span>
		           «ENDIF»
		        </label>
		    </div>
		</div>
	'''
	
	def dispatch genUIFormEntityField(EntityIntegerField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="«field.name.toLowerCase»" class="clr-control-label">«entityFieldUtils.getFieldGlossaryName(field)»«IF entityFieldUtils.isFieldRequired(field)»<span class="required">*</span>«ENDIF»</label>
		    <div class="clr-control-container clr-col-md-12"> 
		        <label for="«field.name.toLowerCase»" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm clr-input clr-col-sm-11 clr-col-md-11"
		                [class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»').touched)">
		            <input id="«field.name.toLowerCase»" type="number" formControlName="«field.name.toLowerCase»" placeholder="«entityFieldUtils.getFieldGlossaryName(field)»" class="clr-input clr-col-sm-12 clr-col-md-12">
		            «IF entityFieldUtils.isFieldRequired(field)»
		            <span class="tooltip-content">
		                «field.name» es requerido.
		            </span>
		           «ENDIF»
		        </label>
		    </div>
		</div>
	'''
	
	def dispatch genUIFormEntityField(EntityCurrencyField field, FormComponent form) '''
		<div class="clr-form-control">
		    <label for="«field.name.toLowerCase»" class="clr-control-label">«entityFieldUtils.getFieldGlossaryName(field)»«IF entityFieldUtils.isFieldRequired(field)»<span class="required">*</span>«ENDIF»</label>
		    <div class="clr-control-container clr-col-md-12"> 
		        <label for="«field.name.toLowerCase»" aria-haspopup="true" role="tooltip" class="tooltip tooltip-validation tooltip-sm clr-input clr-col-sm-11 clr-col-md-11"
		                [class.invalid]="«form.name.toLowerCase»Form.get('«field.name.toLowerCase»').invalid && («form.name.toLowerCase»Form.get('«field.name.toLowerCase»').dirty || «form.name.toLowerCase»Form.get('«field.name.toLowerCase»').touched)">
		            <input id="«field.name.toLowerCase»" type="number" formControlName="«field.name.toLowerCase»" placeholder="«entityFieldUtils.getFieldGlossaryName(field)»" class="clr-input clr-col-sm-12 clr-col-md-12">
		            «IF entityFieldUtils.isFieldRequired(field)»
		            <span class="tooltip-content">
		                «field.name» es requerido.
		            </span>
		           «ENDIF»
		        </label>
		    </div>
		</div>
	'''	
	
		/*
	 * UIFormContainer
	 */
	def dispatch genUIFormContainer(UIFormPanel panel, FormComponent form) '''
	'''
	
	def dispatch genUIFormContainer(UIFormRow row, FormComponent form) '''
		<div class="row">
			«FOR c : row.columns»
				«c.genUIFormColumn(form)»
			«ENDFOR»
		</div>
	'''
	
	/*
	 * UIFormColumn
	 */
	def CharSequence genUIFormColumn(UIFormColumn column, FormComponent form) '''
		<div class="«column.sizes.genColSize»">
			«FOR e : column.elements»
				«e.genUIFormElement(form)»
			«ENDFOR»
		</div>
	'''
	
	/*
	 * ContainerOrComponent
	 */
	def dispatch genQueryFlowToContainer(PageContainer page) {
		return page
	}
	def dispatch genQueryFlowToContainer(UIComponent component) {}
	
	def Module getParentModule(PageContainer page) {
		return page.eContainer as Module
	}
	
	/*
	 * ContainerOrComponent
	 */
	def dispatch genCommandFlowToContainer(PageContainer page, UICommandFlow flow) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«page.getParentModule.name.toLowerCase»/«page.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	def dispatch genCommandFlowToContainer(UIComponent component, UICommandFlow flow) ''''''
	
	/*
	 * ContainerOrComponent
	 */
	def dispatch genCommandFlowToContainer(PageContainer page) {
		return page
	}
	def dispatch genCommandFlowToContainer(UIComponent component) {}
	
	/*
	 * genUIDetailElement
	 */
	def dispatch genUIDetailElement(UIField e, FormComponent form) '''
«««		«e.genFormUIField(form)»
	'''
	def dispatch genUIDetailElement(UIDisplay e, FormComponent form) '''
		«e.ui_field.genUIDetailEntityField(form)»
	'''
	def dispatch genUIDetailElement(UIFormContainer e, FormComponent form) '''
«««		«e.genUIDetailFormContainer(form)»
	'''
	
	/*
	 * UIFormContainer
	 */
	def dispatch genUIDetailFormContainer(UIFormPanel e, FormComponent form) '''
	'''

	def dispatch genUIDetailFormContainer(UIFormRow e, FormComponent form) '''
		«e.genRowDetailComponent(form)»
	'''
	
	def CharSequence genRowDetailComponent(UIFormRow row, FormComponent form) '''
		<div class="row">
			«FOR c : row.columns»
				«c.genUIDetailColumn(form)»
			«ENDFOR»
		</div>
	'''
	
	/*
	 * genUIDetailEntityField
	 */
	def dispatch genUIDetailEntityField(EntityReferenceField field, FormComponent form) '''
		<div class="form-group">
			<label for="«field.name.toLowerCase»">«entityFieldUtils.getFieldGlossaryName(field)»</label>
			<input type="text" id="«field.name.toLowerCase»" readonly size="30" value="«entityFieldUtils.fakerDomainData(field)»" />
		</div>
	'''
	
	def dispatch genUIDetailEntityField(EntityTextField field, FormComponent form) '''
		<div class="form-group">
			<label for="«field.name.toLowerCase»">«entityFieldUtils.getFieldGlossaryName(field)»</label>
			<input type="text" id="«field.name.toLowerCase»" readonly size="30" value="«entityFieldUtils.fakerDomainData(field)»" />
		</div>
	'''
	
	def dispatch genUIDetailEntityField(EntityLongTextField field, FormComponent form) '''
		<div class="form-group">
			<label for="«field.name.toLowerCase»">«entityFieldUtils.getFieldGlossaryName(field)»</label>
			<input type="text" id="«field.name.toLowerCase»" readonly size="30" value="«entityFieldUtils.fakerDomainData(field)»" />
		</div>
	'''
	
	def dispatch genUIDetailEntityField(EntityDateField field, FormComponent form) '''
		<div class="form-group">
			<label for="«field.name.toLowerCase»">«entityFieldUtils.getFieldGlossaryName(field)»</label>
			<input type="text" id="«field.name.toLowerCase»" readonly size="30" value="«entityFieldUtils.fakerDomainData(field)»" />
		</div>
	'''
	
	def dispatch genUIDetailEntityField(EntityImageField field, FormComponent form) '''
		<div class="form-group">
			<label for="«field.name.toLowerCase»">«entityFieldUtils.getFieldGlossaryName(field)»</label>
			<input type="text" id="«field.name.toLowerCase»" readonly size="30" value="«entityFieldUtils.fakerDomainData(field)»" />
		</div>
	'''
	
	def dispatch genUIDetailEntityField(EntityFileField field, FormComponent form) '''
		<div class="form-group">
			<label for="«field.name.toLowerCase»">«entityFieldUtils.getFieldGlossaryName(field)»</label>
			<input type="text" id="«field.name.toLowerCase»" readonly size="30" value="«entityFieldUtils.fakerDomainData(field)»" />
		</div>
	'''
	
	def dispatch genUIDetailEntityField(EntityEmailField field, FormComponent form) '''
		<div class="form-group">
			<label for="«field.name.toLowerCase»">«entityFieldUtils.getFieldGlossaryName(field)»</label>
			<input type="text" id="«field.name.toLowerCase»" readonly size="30" value="«entityFieldUtils.fakerDomainData(field)»" />
		</div>
	'''
	
	def dispatch genUIDetailEntityField(EntityDecimalField field, FormComponent form) '''
		<div class="form-group">
			<label for="«field.name.toLowerCase»">«entityFieldUtils.getFieldGlossaryName(field)»</label>
			<input type="text" id="«field.name.toLowerCase»" readonly size="30" value="«entityFieldUtils.fakerDomainData(field)»" />
		</div>
	'''
	
	def dispatch genUIDetailEntityField(EntityIntegerField field, FormComponent form) '''
		<div class="form-group">
			<label for="«field.name.toLowerCase»">«entityFieldUtils.getFieldGlossaryName(field)»</label>
			<input type="text" id="«field.name.toLowerCase»" readonly size="30" value="«entityFieldUtils.fakerDomainData(field)»" />
		</div>
	'''
	
	def dispatch genUIDetailEntityField(EntityCurrencyField field, FormComponent form) '''
		<div class="form-group">
			<label for="«field.name.toLowerCase»">«entityFieldUtils.getFieldGlossaryName(field)»</label>
			<input type="text" id="«field.name.toLowerCase»" readonly size="30" value="«entityFieldUtils.fakerDomainData(field)»" />
		</div>
	'''
	
	def CharSequence genUIDetailColumn(UIFormColumn column, FormComponent form) '''
		<div class="«column.sizes.genColSize»">
			«FOR e : column.elements»
				«e.genUIDetailElement(form)»
			«ENDFOR»
		</div>
	'''
	
	/*
	 * UILinkCommandQueryFlow
	 */
	def dispatch genFlowRows(UICommandFlow flow) '''
«««		«flow.success_flow.genCommandFlowToContainer(flow)»
	'''
	def dispatch genFlowRows(UIQueryFlow flow) '''
«««		«flow.success_flow.genQueryFlowToContainer(flow)»
	'''
	def dispatch genFlowRows(UILinkFlow flow) '''
«««		<submit-button id="«flow.name.toLowerCase»" to="/«flow.link_to.getParentModule.name.toLowerCase»/«flow.link_to.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	
	/*
	 * UIElement
	 */
	def dispatch genTableHeader(UIField element) ''''''
	
	def dispatch genTableHeader(UIFormContainer element) ''''''
	
	
	// Headers
	def dispatch genTableHeader(UIDisplay element) '''
		«element.ui_field.genHeaderUIDisplayField»
	'''
	
	def dispatch genHeaderUIDisplayField(EntityReferenceField field) '''
		<clr-dg-column [clrDgField]="'«entityFieldUtils.getFieldGlossaryName(field)»'" >
			<ng-container *clrDgHideableColumn="{hidden: false}"> 
		       		«entityFieldUtils.getFieldGlossaryName(field)»
		    </ng-container>    
		</clr-dg-column>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityTextField field) '''
		<clr-dg-column [clrDgField]="'«entityFieldUtils.getFieldGlossaryName(field)»'" >
			<ng-container *clrDgHideableColumn="{hidden: false}"> 
		       		«entityFieldUtils.getFieldGlossaryName(field)»
		    </ng-container>    
		</clr-dg-column>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityLongTextField field) '''
		<clr-dg-column [clrDgField]="'«entityFieldUtils.getFieldGlossaryName(field)»'" >
			<ng-container *clrDgHideableColumn="{hidden: false}"> 
		       		«entityFieldUtils.getFieldGlossaryName(field)»
		    </ng-container>    
		</clr-dg-column>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityDateField field) '''
		<clr-dg-column [clrDgField]="'«entityFieldUtils.getFieldGlossaryName(field)»'" >
			<ng-container *clrDgHideableColumn="{hidden: false}"> 
		       		«entityFieldUtils.getFieldGlossaryName(field)»
		    </ng-container>    
		</clr-dg-column>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityImageField field) '''
		<clr-dg-column [clrDgField]="'«entityFieldUtils.getFieldGlossaryName(field)»'" >
			<ng-container *clrDgHideableColumn="{hidden: false}"> 
		       		«entityFieldUtils.getFieldGlossaryName(field)»
		    </ng-container>    
		</clr-dg-column>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityFileField field) '''
		<clr-dg-column [clrDgField]="'«entityFieldUtils.getFieldGlossaryName(field)»'" >
			<ng-container *clrDgHideableColumn="{hidden: false}"> 
		       		«entityFieldUtils.getFieldGlossaryName(field)»
		    </ng-container>    
		</clr-dg-column>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityEmailField field) '''
		<clr-dg-column [clrDgField]="'«entityFieldUtils.getFieldGlossaryName(field)»'" >
			<ng-container *clrDgHideableColumn="{hidden: false}"> 
		       		«entityFieldUtils.getFieldGlossaryName(field)»
		    </ng-container>    
		</clr-dg-column>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityDecimalField field) '''
		<clr-dg-column [clrDgField]="'«entityFieldUtils.getFieldGlossaryName(field)»'" >
			<ng-container *clrDgHideableColumn="{hidden: false}"> 
		       		«entityFieldUtils.getFieldGlossaryName(field)»
		    </ng-container>    
		</clr-dg-column>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityIntegerField field) '''
		<clr-dg-column [clrDgField]="'«entityFieldUtils.getFieldGlossaryName(field)»'" >
			<ng-container *clrDgHideableColumn="{hidden: false}"> 
		       		«entityFieldUtils.getFieldGlossaryName(field)»
		    </ng-container>    
		</clr-dg-column>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityCurrencyField field) '''
		<clr-dg-column [clrDgField]="'«entityFieldUtils.getFieldGlossaryName(field)»'" >
			<ng-container *clrDgHideableColumn="{hidden: false}"> 
		       		«entityFieldUtils.getFieldGlossaryName(field)»
		    </ng-container>    
		</clr-dg-column>
	'''
	
	def dispatch genRowsUIDisplayField(EntityReferenceField field) '''
		<clr-dg-cell >«entityFieldUtils.fakerDomainData(field)»</clr-dg-cell >
	'''
	
	def dispatch genRowsUIDisplayField(EntityTextField field) '''
		<clr-dg-cell >«entityFieldUtils.fakerDomainData(field)»</clr-dg-cell >
	'''
	
	def dispatch genRowsUIDisplayField(EntityLongTextField field) '''
		<clr-dg-cell >«entityFieldUtils.fakerDomainData(field)»</clr-dg-cell >
	'''
	
	def dispatch genRowsUIDisplayField(EntityDateField field) '''
		<clr-dg-cell >«entityFieldUtils.fakerDomainData(field)»</clr-dg-cell >
	'''
	
	def dispatch genRowsUIDisplayField(EntityImageField field) '''
		<clr-dg-cell ><img src="https://fakeimg.pl/60x60/?text=Picture&font=lobster"></img></clr-dg-cell >
	'''
	
	def dispatch genRowsUIDisplayField(EntityFileField field) '''
		<clr-dg-cell >«entityFieldUtils.fakerDomainData(field)»</clr-dg-cell >
	'''
	
	def dispatch genRowsUIDisplayField(EntityEmailField field) '''
		<clr-dg-cell >«entityFieldUtils.fakerDomainData(field)»</clr-dg-cell >
	'''
	
	def dispatch genRowsUIDisplayField(EntityDecimalField field) '''
		<clr-dg-cell >«entityFieldUtils.fakerDomainData(field)»</clr-dg-cell >
	'''
	
	def dispatch genRowsUIDisplayField(EntityIntegerField field) '''
		<clr-dg-cell >«entityFieldUtils.fakerDomainData(field)»</clr-dg-cell >
	'''
	
	def dispatch genRowsUIDisplayField(EntityCurrencyField field) '''
		<clr-dg-cell >«entityFieldUtils.fakerDomainData(field)»</clr-dg-cell >
	'''

	/*
	 * UILinkCommandQueryFlow
	 */
	def dispatch genPageFlow(UICommandFlow flow) '''
    
    	<button type="submit" class="btn btn-primary" [routerLink]="['../«flow.success_flow.genCommandFlowToContainer.getParentModule.name.toLowerCase»']" ><clr-icon shape="«uiFlowUtils.getFlowIcon(flow, "Font Clarity")»"></clr-icon> «uiFlowUtils.getFlowLabel(flow)»</button>
    
«««		<submit-button id="«flow.name.toLowerCase»" to="/«flow.success_flow.genCommandFlowToContainer.getParentModule.name.toLowerCase»/«flow.success_flow.genCommandFlowToContainer.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	def dispatch genPageFlow(UIQueryFlow flow) '''
    
    	<button type="submit" class="btn btn-primary" [routerLink]="['../«flow.success_flow.genCommandFlowToContainer.getParentModule.name.toLowerCase»']" ><clr-icon shape="«uiFlowUtils.getFlowIcon(flow, "Font Clarity")»"></clr-icon> «uiFlowUtils.getFlowLabel(flow)»</button>
    
«««		<submit-button id="«flow.name.toLowerCase»" to="/«flow.success_flow.genCommandFlowToContainer.getParentModule.name.toLowerCase»/«flow.success_flow.genQueryFlowToContainer.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	def dispatch genPageFlow(UILinkFlow flow) '''
    
    	<button type="submit" class="btn btn-primary" [routerLink]="['../«flow.link_to.genCommandFlowToContainer.getParentModule.name.toLowerCase»']" ><clr-icon shape="«uiFlowUtils.getFlowIcon(flow, "Font Clarity")»"></clr-icon> «uiFlowUtils.getFlowLabel(flow)»</button>
    
«««		<submit-button id="«flow.name.toLowerCase»" to="/«flow.link_to.genCommandFlowToContainer.getParentModule.name.toLowerCase»/«flow.link_to.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''	

}