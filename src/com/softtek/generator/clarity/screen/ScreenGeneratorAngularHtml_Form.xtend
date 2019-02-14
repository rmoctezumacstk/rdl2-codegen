package com.softtek.generator.clarity.screen

import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.rdl2.FormComponent
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.UIField
import com.softtek.rdl2.UIDisplay
import com.softtek.rdl2.UIFormContainer
import com.softtek.rdl2.UITextField
import com.softtek.rdl2.UILongTextField
import com.softtek.rdl2.UIDateField
import com.softtek.rdl2.UIImageField
import com.softtek.rdl2.UIFileField
import com.softtek.rdl2.UIEmailField
import com.softtek.rdl2.UIDecimalField
import com.softtek.rdl2.UIIntegerField
import com.softtek.rdl2.UICurrencyField
import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.EntityTextField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.rdl2.UICommandFlow
import com.softtek.rdl2.UIQueryFlow
import com.softtek.rdl2.UILinkFlow
import com.softtek.rdl2.UIComponent
import com.softtek.generator.utils.UIFlowUtils

class ScreenGeneratorAngularHtml_Form {
	
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def CharSequence genUIComponent_FormComponent(FormComponent form, Module module, PageContainer page) '''
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
	 * UILinkCommandQueryFlow
	 */
	def dispatch genFormFlow(UICommandFlow flow) '''
		<button id="«flow.name.toLowerCase»" type="submit" class="btn btn-outline" [routerLink]="['../«flow.success_flow.genQueryFlowToContainer.getParentModule.name.toLowerCase»']" ><clr-icon shape="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»"></clr-icon>«uiFlowUtils.getFlowLabel(flow)»</button>
	'''
	def dispatch genFormFlow(UIQueryFlow flow) '''
		<button id="«flow.name.toLowerCase»" type="submit" class="btn btn-outline" [routerLink]="['../«flow.success_flow.genQueryFlowToContainer.getParentModule.name.toLowerCase»']" ><clr-icon shape="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»"></clr-icon>«uiFlowUtils.getFlowLabel(flow)»</button>
	'''
	def dispatch genFormFlow(UILinkFlow flow) '''
«««		<button id="«flow.name.toLowerCase»" type="submit" class="btn btn-outline" [routerLink]="['../«flow.link_to.genCommandFlowToContainer.getParentModule.name.toLowerCase»']" ><clr-icon shape="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»"></clr-icon>«uiFlowUtils.getFlowLabel(flow)»</button>
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
}