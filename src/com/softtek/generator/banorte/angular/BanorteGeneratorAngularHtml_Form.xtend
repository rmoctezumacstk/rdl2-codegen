package com.softtek.generator.banorte.angular

import com.softtek.rdl2.FormComponent
import com.softtek.rdl2.Module
import com.softtek.rdl2.Enum
import com.softtek.rdl2.Entity
import com.softtek.rdl2.UIField
import com.softtek.rdl2.UIDisplay
import com.softtek.rdl2.UIFormContainer
import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.EntityTextField
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.rdl2.EntityBooleanField
import com.softtek.rdl2.WidgetAttrEnumType
import com.softtek.rdl2.WidgetAttrEnumTypeSelect
import com.softtek.rdl2.WidgetDisplayResult
import com.softtek.rdl2.WidgetLabel
import com.softtek.rdl2.WidgetHelp
import com.softtek.rdl2.WidgetExposedFilter
import com.softtek.rdl2.WidgetType
import com.softtek.rdl2.UIFormPanel
import com.softtek.rdl2.UIFormRow
import com.softtek.rdl2.UIFormColumn
import com.softtek.rdl2.SizeOption
import org.eclipse.emf.common.util.EList
import com.softtek.rdl2.OffSetMD
import com.softtek.rdl2.UICommandFlow
import com.softtek.rdl2.UIQueryFlow
import com.softtek.rdl2.UILinkFlow
import com.softtek.rdl2.UIComponent
import com.softtek.rdl2.PageContainer

class BanorteGeneratorAngularHtml_Form {
	
	//var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	//var uiFlowUtils = new UIFlowUtils
	
	def CharSequence genUIComponent_FormComponent(FormComponent form, Module module) '''
	  <form #«form.name»="ngForm" (ngSubmit)="onSubmit«form.name»()">
	    <div class="col-md-10 col-xs-12 col-sm-12 center-block-no-float-left margin-bottom-1">
	      <div class="row">
	        <div class="col-md-12">
	          <h6>
	            {{
	              globales.etiquetasIdioma[
	                "cib.«form.name.toFirstLower».labels.administradopor"
	              ]
	            }}&nbsp;{{ administrador }}
	          </h6>
	        </div>
	      </div>
	      <div class="row">
	        <div class="col-md-12">
	          <h6>
	            {{globales.etiquetasIdioma["cib.«form.name.toFirstLower».labels.camposrequeridos"]}}
	          </h6>
	        </div>
	      </div>

	      «FOR field : form.form_elements»
	        «field.genUIFormElement(form)»
	      «ENDFOR»
			
		<div class="row">	
	      <div class="col-md-4 col-xs-12 col-sm-12 mb-3 col-md-offset-4">
	        <div class="file-actions-container right">
	          «FOR flow : form.links»
	            «flow.genFormFlow(form)»
	          «ENDFOR»
		        </div>
		      </div>
		    </div>
	    </div>
	  </form>
	'''
	
	/*
	 * genUIFormElement
	 */
	def dispatch genUIFormElement(UIField e, FormComponent form) '''
	'''
	def dispatch genUIFormElement(UIDisplay e, FormComponent form) '''
		«e.ui_field.genUIFormEntityField(form)»
	'''
	def dispatch genUIFormElement(UIFormContainer e, FormComponent form) '''
		«e.genUIFormContainer(form)»
	'''

	/*
	 * genEntityField
	 */
	def dispatch genUIFormEntityField(EntityReferenceField field, FormComponent form) '''
		«field.superType.genUIFormRelationshipField(field, form)»
	'''
	
	def dispatch genUIFormEntityField(EntityTextField field, FormComponent form) '''
	        <div class="mb-3 field-container-default ">
	          <label>«IF entityFieldUtils.isFieldRequired(field)»<span class="required">*</span>«ENDIF»{{globales.etiquetasIdioma["cib.«form.name.toFirstLower».labels.«field.name.toFirstLower»"]}}</label>
	          <input
	            type="text"
	            name="«field.name.toFirstLower»"
	            maxlength="40"
	            #«field.name.toFirstLower»="ngModel"
	            pattern="^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s]*$"
	            minlength="2"
	            class="default-input"
	            required=«IF entityFieldUtils.isFieldRequired(field)»"true"«ELSE»"false"«ENDIF»
	            [(ngModel)]="model.«field.name.toFirstLower»"
	            [ngModelOptions]="{ updateOn: 'change' }"/>
	          <div class="invalid-feedback" *ngIf="!«field.name.toFirstLower».isValid">
	            <label
	              *ngIf="
	                «field.name.toFirstLower».errors &&
	                «field.name.toFirstLower».errors.required &&
	                («field.name.toFirstLower».dirty || «field.name.toFirstLower».touched)
	              "
	              >{{
	                globales.etiquetasIdioma[
	                  "cib.«form.name.toFirstLower».errors.«field.name.toFirstLower».required"
	                ]
	              }}</label
	            >
	            <label
	              *ngIf="
	                «field.name.toFirstLower».errors &&
	                «field.name.toFirstLower».errors.minlength &&
	                («field.name.toFirstLower».dirty || «field.name.toFirstLower».touched)
	              "
	              >{{
	                globales.etiquetasIdioma[
	                  "cib.«form.name.toFirstLower».errors.«field.name.toFirstLower».minlenght"
	                ]
	              }}</label
	            >
	            <label
	              *ngIf="
	                «field.name.toFirstLower».errors &&
	                «field.name.toFirstLower».errors.pattern &&
	                («field.name.toFirstLower».dirty || «field.name.toFirstLower».touched)
	              "
	              >{{
	                globales.etiquetasIdioma[
	                  "cib.«form.name.toFirstLower».errors.«field.name.toFirstLower».novalid"
	                ]
	              }}</label
	            >
	          </div>
	        </div>
	'''
	
	def dispatch genUIFormEntityField(EntityLongTextField field, FormComponent form) '''
	'''
	
	def dispatch genUIFormEntityField(EntityDateField field, FormComponent form) '''
	'''
	
	def dispatch genUIFormEntityField(EntityImageField field, FormComponent form) '''
	'''
	
	def dispatch genUIFormEntityField(EntityFileField field, FormComponent form) '''
          <!-- <div class="row">
              <div class="col-md-4 col-xs-12 col-sm-12 mb-3 col-md-offset-4">
              <input class="inputImagen" id="archivo1"/>
              <div class="botonInputFileModificado">
                  <input type="file" class="inputImagenOculto" id="archivo_oculto1" name="archivo_oculto1"/>
                  <div class="boton">Examinar</div>  
              </div> 
            </div>      
          </div> -->
          <div class="row">
              <div class="col-md-4 col-xs-12 col-sm-12 mb-3 col-md-offset-4">
                <div class="custom-file">
                  <input type="file" class="custom-file-input" id="customFileLang">
                  <label class="custom-file-label" for="customFileLang">Seleccionar Archivo</label>
                </div>
            </div>
          </div>
	'''
	
	def dispatch genUIFormEntityField(EntityEmailField field, FormComponent form) '''
        <div class="field-container-default mb-3">
            <label
              >«IF entityFieldUtils.isFieldRequired(field)»<span class="required">*</span
              >«ENDIF»{{
                globales.etiquetasIdioma["cib.«form.name.toFirstLower».labels.email"]
              }}</label>
            <input
              type="text"
              name="«field.name.toFirstLower»"
              maxlength="80"
              id="«field.name.toFirstLower»"
              #«field.name.toFirstLower»="ngModel"
              class="default-input"
              required=«IF entityFieldUtils.isFieldRequired(field)»"true"«ELSE»"false"«ENDIF»
              [(ngModel)]="model.«field.name.toFirstLower»"
              email="true"
              [ngModelOptions]="{ updateOn: 'change' }"
              [disabled]="modo === 1"/>
            <div class="invalid-feedback" *ngIf="!«field.name.toFirstLower».isValid">
              <label
                *ngIf="
                  «field.name.toFirstLower».errors &&
                  «field.name.toFirstLower».errors.required &&
                  («field.name.toFirstLower».dirty || «field.name.toFirstLower».touched)
                "
                >{{
                  globales.etiquetasIdioma[
                    "cib.«form.name.toFirstLower».errors.email.required"
                  ]
                }}</label>
              <label
                *ngIf="
                  «field.name.toFirstLower».errors &&
                  «field.name.toFirstLower».errors.minlength &&
                  («field.name.toFirstLower».dirty || «field.name.toFirstLower».touched)
                "
                >{{
                  globales.etiquetasIdioma[
                    "cib.«form.name.toFirstLower».errors.email.minlength"
                  ]
                }}</label>
              <label
                *ngIf="
                  «field.name.toFirstLower».errors &&
                  «field.name.toFirstLower».errors.email &&
                  («field.name.toFirstLower».dirty || «field.name.toFirstLower».touched)
                "
                >{{
                  globales.etiquetasIdioma[
                    "cib.«form.name.toFirstLower».errors.email.novalid"
                  ]
                }}</label>
            </div>
        </div>
	'''
	
	def dispatch genUIFormEntityField(EntityDecimalField field, FormComponent form) '''
	'''
	
	def dispatch genUIFormEntityField(EntityIntegerField field, FormComponent form) '''
	'''
	
	def dispatch genUIFormEntityField(EntityCurrencyField field, FormComponent form) '''
	'''

	def dispatch genUIFormEntityField(EntityBooleanField field, FormComponent form) '''
	<div style="margin-top: 20px;">
      <div style="height: 10px;">
        <label>{{
          globales.etiquetasIdioma["cib.«form.name.toFirstLower».labels.alertas"]
        }}</label>
        <label class="switch">
          <input
            type="checkbox"
            name="«field.name.toFirstLower»"
            checked
            (click)="onClick«field.name»(0)"
            *ngIf="1 === notificacionesEmail"
            [(ngModel)]="model.«field.name.toFirstLower»"
          />
          <input
            type="checkbox"
            name="«field.name.toFirstLower»"
            (click)="onClick«field.name»(1)"
            *ngIf="0 === notificacionesEmail"
            [(ngModel)]="model.«field.name.toFirstLower»"
          />
          <span class="slider round"></span>
        </label>
      </div>
    </div>
	'''
	
	/*
	 * genUIFormRelationshipField
	 */
	def dispatch genUIFormRelationshipField(Enum toEnum, EntityReferenceField fromField, FormComponent form) '''
		«IF fromField.getWidgetType == "SelectList"»
			«fromField.genEnumSelectList(toEnum, form)»
		«ENDIF»
		«IF fromField.getWidgetType == "Option" || fromField.getWidgetType === null»

		«ENDIF»
		«IF fromField.getWidgetType == "Check"»

		«ENDIF»
		«IF fromField.getWidgetType == "Autocomplete"»

		«ENDIF»
	'''
	
	def CharSequence genEnumSelectList(EntityReferenceField fromField, Enum toEnum, FormComponent form) '''
        <div class="field-container-default">
          <label
            >«IF entityFieldUtils.isFieldRequired(fromField)»<span class="required">*</span
            >«ENDIF»{{
              globales.etiquetasIdioma["cib.«form.name.toFirstLower».labels.«fromField.name.toFirstLower»"]
            }}</label
          >
          <select
          
            class="default-select"
            id="«fromField.name.toFirstLower»"
            #«fromField.name.toFirstLower»="ngModel"
            name="«fromField.name.toFirstLower»"
            required=«IF entityFieldUtils.isFieldRequired(fromField)»"true"«ELSE»"false"«ENDIF»
            [(ngModel)]="model.«fromField.name.toFirstLower»"
            [ngModelOptions]="{ updateOn: 'change' }"
          >
            <option selected value="null">{{
              globales.etiquetasIdioma["cib.general.labels.seleccione"]
            }}</option>
            <option
              *ngFor="let item of lst«fromField.name»"
              [ngValue]="item.id«fromField.name»"
              >{{ item.«fromField.name.toFirstLower» }}</option
            >
          </select>
          <div class="invalid-feedback" *ngIf="!«fromField.name.toFirstLower».isValid">
            <label
              *ngIf="
                «fromField.name.toFirstLower».errors &&
                «fromField.name.toFirstLower».errors.required &&
                («fromField.name.toFirstLower».dirty || «fromField.name.toFirstLower».touched)
              "
              >{{
                globales.etiquetasIdioma[
                  "cib.«form.name.toFirstLower».errors.«fromField.name.toFirstLower».required"
                ]
              }}</label
            >
          </div>
        </div>
	'''
	
	def dispatch genUIFormRelationshipField(Entity toEntity, EntityReferenceField fromField, FormComponent form) '''
		«IF fromField.getWidgetType == "SelectList" || fromField.getWidgetType === null»
			«fromField.genEntitySelectList(toEntity, form)»
		«ENDIF»
		«IF fromField.getWidgetType == "Option"»
		«ENDIF»
		«IF fromField.getWidgetType == "Check"»
		«ENDIF»
		«IF fromField.getWidgetType == "Autocomplete"»
		«ENDIF»
	'''
	
	def CharSequence genEntitySelectList(EntityReferenceField fromField, Entity toEntity, FormComponent form) '''
        <div class="field-container-default">
          <label
            >«IF entityFieldUtils.isFieldRequired(fromField)»<span class="required">*</span
            >«ENDIF»{{
              globales.etiquetasIdioma["cib.«form.name.toFirstLower».labels.«fromField.name.toFirstLower»"]
            }}</label
          >
          <select
            class="default-select"
            id="«fromField.name.toFirstLower»"
            #«fromField.name.toFirstLower»="ngModel"
            name="«fromField.name.toFirstLower»"
            required=«IF entityFieldUtils.isFieldRequired(fromField)»"true"«ELSE»"false"«ENDIF»
            [(ngModel)]="model.«fromField.name.toFirstLower»"
            [ngModelOptions]="{ updateOn: 'change' }"
          >
            <option selected value="null">{{
              globales.etiquetasIdioma["cib.general.labels.seleccione"]
            }}</option>
            <option
              *ngFor="let item of lst«fromField.name»"
              [ngValue]="item.id«fromField.name»"
              >{{ item.«fromField.name.toFirstLower» }}</option
            >
          </select>
          <div class="invalid-feedback" *ngIf="!«fromField.name.toFirstLower».isValid">
            <label
              *ngIf="
                «fromField.name.toFirstLower».errors &&
                «fromField.name.toFirstLower».errors.required &&
                («fromField.name.toFirstLower».dirty || «fromField.name.toFirstLower».touched)
              "
              >{{
                globales.etiquetasIdioma[
                  "cib.«form.name.toFirstLower».errors.«fromField.name.toFirstLower».required"
                ]
              }}</label
            >
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
	 * UILinkCommandQueryFlow
	 */
	def dispatch genFormFlow(UICommandFlow flow, FormComponent form) '''
      «IF flow.state.toString === "Primary"»
        <button
          type="submit"
          class="btn-default1 btn-size-default1"
          [disabled]="!«form.name».form.valid">
          {{ globales.etiquetasIdioma["cib.«form.name.toFirstLower».buttons.«flow.name.toFirstLower»"] }}
        </button>
      «ELSE»
        <button
          type="button"
          class="btn-default2 btn-size-default2"
          (click)="onClick«flow.name»()">
          {{ globales.etiquetasIdioma["cib.«form.name.toFirstLower».buttons.«flow.name.toFirstLower»"] }}
        </button>
      «ENDIF»
	'''
	def dispatch genFormFlow(UIQueryFlow flow, FormComponent form) '''
      «IF flow.state.toString === "Primary"»
        <button
          type="submit"
          class="btn-default1 btn-size-default1"
          [disabled]="!«form.name».form.valid"
        >
          {{ globales.etiquetasIdioma["cib.«form.name.toFirstLower».buttons.«flow.name.toFirstLower»"] }}
        </button>
      «ELSE»
        <button
          type="button"
          class="btn-default2 btn-size-default2"
          (click)="onClick«flow.name»()">
          {{ globales.etiquetasIdioma["cib.«form.name.toFirstLower».buttons.«flow.name.toFirstLower»"] }}
        </button>
      «ENDIF»	'''
	def dispatch genFormFlow(UILinkFlow flow, FormComponent form) '''
      «IF flow.state.toString === "Primary"»
        <button
          type="submit"
          class="btn-default1 btn-size-default1"
          [disabled]="!«form.name».form.valid"
        >
          {{ globales.etiquetasIdioma["cib.«form.name.toFirstLower».buttons.«flow.name.toFirstLower»"] }}
        </button>
      «ELSE»
        <button
          type="button"
          class="btn-default2 btn-size-default2"
          (click)="onClick«flow.name»()"
        >
          {{ globales.etiquetasIdioma["cib.«form.name.toFirstLower».buttons.«flow.name.toFirstLower»"] }}
        </button>
      «ENDIF»	'''

	/*
	 * ContainerOrComponent
	 */
	def dispatch genCommandFlowToContainer(PageContainer page) {
		return page
	}
	def dispatch genCommandFlowToContainer(UIComponent component) {}
	
	/*
	 * ContainerOrComponent
	 */
	def dispatch genQueryFlowToContainer(PageContainer page) {
		return page
	}
	def dispatch genQueryFlowToContainer(UIComponent component) {}



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
	

	def getWidgetType(EntityReferenceField field) {
		for (attr_field : field.attrs) {
			if (attr_field.widget !== null) {
				for (attr_widget : attr_field.widget.attrs) {
					 return attr_widget.getWidgetAttrEnum
				}
			}
		}
		return null
	}
	
	def dispatch getWidgetAttrEnum(WidgetAttrEnumType e) {
		return e.getWidgetAttrEnumType
	}
	def dispatch getWidgetAttrEnum(WidgetAttrEnumTypeSelect e) {
		return e.widget_select.type
	}
	def dispatch getWidgetAttrEnum(WidgetDisplayResult e) {}


	def dispatch getWidgetAttrEnumType(WidgetLabel e) {}
	def dispatch getWidgetAttrEnumType(WidgetHelp e) {}
	def dispatch getWidgetAttrEnumType(WidgetExposedFilter e) {}
	def dispatch getWidgetAttrEnumType(WidgetType e) {
		return e.type
	}
	
	def Module getParentModule(PageContainer page) {
		return page.eContainer as Module
	}
}