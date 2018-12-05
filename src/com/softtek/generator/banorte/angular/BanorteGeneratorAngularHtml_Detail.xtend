package com.softtek.generator.banorte.angular

import com.softtek.rdl2.DetailComponent
import com.softtek.rdl2.Module
import com.softtek.rdl2.UIElement
import com.softtek.rdl2.UIField
import com.softtek.rdl2.UIDisplay
import com.softtek.rdl2.UIFormContainer
import com.softtek.rdl2.UIFormPanel
import com.softtek.rdl2.UIFormRow
import com.softtek.rdl2.UIFormColumn
import com.softtek.rdl2.SizeOption
import org.eclipse.emf.common.util.EList
import com.softtek.rdl2.OffSetMD
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
import com.softtek.rdl2.EntityBooleanField
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.rdl2.Entity
import com.softtek.rdl2.Enum
import com.softtek.rdl2.WidgetAttrEnumType
import com.softtek.rdl2.WidgetAttrEnumTypeSelect
import com.softtek.rdl2.WidgetDisplayResult
import com.softtek.rdl2.WidgetLabel
import com.softtek.rdl2.WidgetHelp
import com.softtek.rdl2.WidgetExposedFilter
import com.softtek.rdl2.WidgetType

class BanorteGeneratorAngularHtml_Detail {
	
	var entityFieldUtils = new EntityFieldUtils
	
	def CharSequence genUIComponent_DetailComponent(DetailComponent detail, Module module) '''
      «FOR field : detail.list_elements»
        «field.genUIFormDetail(detail)»
      «ENDFOR»
«««      «FOR flow : detail.links»
«««        «flow.genFormFlow(flow)»
«««      «ENDFOR»
		      
	'''

	/*
	 * genUIFormDetail
	 */
	def dispatch genUIFormDetail(UIField e, DetailComponent detail) '''
	«e»
	'''
	
	def dispatch genUIFormDetail(UIDisplay e, DetailComponent detail) '''
	«e»
	'''
	
	def dispatch genUIFormDetail(UIFormContainer e, DetailComponent detail) '''
	«e.genUIDetailContainer(detail)»
	'''

	/*
	 * UIFormContainer
	 */
	def dispatch genUIDetailContainer(UIFormPanel panel, DetailComponent detail) '''
	'''
	
	def dispatch genUIDetailContainer(UIFormRow row, DetailComponent detail) '''
		<div class="row">
			«FOR c : row.columns»
				«c.genUIDetailColumn(detail)»
			«ENDFOR»
		</div>
	'''
	
	/*
	 * UIFormColumn
	 */
	def CharSequence genUIDetailColumn(UIFormColumn column, DetailComponent detail) '''
		<div class="«column.sizes.genColSize»">
			«FOR e : column.elements»
				«e.genUIDetailElement(detail)»
			«ENDFOR»
		</div>
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
	def dispatch genUIDetailElement(UIField e, DetailComponent detail) '''
	
	'''
	def dispatch genUIDetailElement(UIDisplay e, DetailComponent detail) '''
	«e.ui_field.genUIDetailEntityField(detail)»
	'''
	def dispatch genUIDetailElement(UIFormContainer e, DetailComponent detail) '''
	'''
	
	/*
	 * genUIFormRelationshipField
	 */
	def dispatch genUIDetailRelationshipField(Enum toEnum, EntityReferenceField fromField, DetailComponent detail) '''
		«IF fromField.getWidgetType == "SelectList"»
			«fromField.genEnumSelectList(toEnum, detail)»
		«ENDIF»
		«IF fromField.getWidgetType == "Option" || fromField.getWidgetType === null»

		«ENDIF»
		«IF fromField.getWidgetType == "Check"»

		«ENDIF»
		«IF fromField.getWidgetType == "Autocomplete"»

		«ENDIF»
	'''	

	def dispatch genUIDetailRelationshipField(Entity toEntity, EntityReferenceField fromField, DetailComponent detail) '''
	Entity«toEntity»
«««		«IF fromField.getWidgetType == "SelectList" || fromField.getWidgetType === null»
«««			«fromField.genEntitySelectList(toEntity, form)»
«««		«ENDIF»
«««		«IF fromField.getWidgetType == "Option"»
«««		«ENDIF»
«««		«IF fromField.getWidgetType == "Check"»
«««		«ENDIF»
«««		«IF fromField.getWidgetType == "Autocomplete"»
«««		«ENDIF»
	'''	
	
	/*
	 * genEntityField
	 */
	def dispatch genUIDetailEntityField(EntityReferenceField field, DetailComponent detail) '''
		«field.superType.genUIDetailRelationshipField(field, detail)»
	'''	
	
	def dispatch genUIDetailEntityField(EntityTextField field, DetailComponent detail) '''
	<div class="mb-3 field-container-default ">
      <label
        >«IF entityFieldUtils.isFieldRequired(field)»<span class="required">*</span
        >«ENDIF»{{
          globales.etiquetasIdioma["cib.«detail.name.toFirstLower».labels.«field.name.toFirstLower»"]
        }}</label
      >
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
        [ngModelOptions]="{ updateOn: 'change' }"
      />
«««      <div class="invalid-feedback" *ngIf="!«field.name.toFirstLower».isValid">
«««        <label
«««          *ngIf="
«««            «field.name.toFirstLower».errors &&
«««            «field.name.toFirstLower».errors.required &&
«««            («field.name.toFirstLower».dirty || «field.name.toFirstLower».touched)
«««          "
«««          >{{
«««            globales.etiquetasIdioma[
«««              "cib.«detail.name.toFirstLower».errors.«field.name.toFirstLower».required"
«««            ]
«««          }}</label
«««        >
«««        <label
«««          *ngIf="
«««            «field.name.toFirstLower».errors &&
«««            «field.name.toFirstLower».errors.minlength &&
«««            («field.name.toFirstLower».dirty || «field.name.toFirstLower».touched)
«««          "
«««          >{{
«««            globales.etiquetasIdioma[
«««              "cib.«detail.name.toFirstLower».errors.«field.name.toFirstLower».minlenght"
«««            ]
«««          }}</label
«««        >
«««        <label
«««          *ngIf="
«««            «field.name.toFirstLower».errors &&
«««            «field.name.toFirstLower».errors.pattern &&
«««            («field.name.toFirstLower».dirty || «field.name.toFirstLower».touched)
«««          "
«««          >{{
«««            globales.etiquetasIdioma[
«««              "cib.«detail.name.toFirstLower».errors.«field.name.toFirstLower».novalid"
«««            ]
«««          }}</label
«««        >
«««      </div>
    </div>
	'''
	def dispatch genUIDetailEntityField(EntityLongTextField field, DetailComponent detail) ''''''
	def dispatch genUIDetailEntityField(EntityDateField  field, DetailComponent detail) ''''''
	def dispatch genUIDetailEntityField(EntityImageField field, DetailComponent detail) ''''''
	def dispatch genUIDetailEntityField(EntityFileField  field, DetailComponent detail) ''''''
	def dispatch genUIDetailEntityField(EntityEmailField  field, DetailComponent detail) ''''''
	def dispatch genUIDetailEntityField(EntityDecimalField field, DetailComponent detail) ''''''
	def dispatch genUIDetailEntityField(EntityIntegerField field, DetailComponent detail) ''''''
	def dispatch genUIDetailEntityField(EntityCurrencyField field, DetailComponent detail) ''''''
	def dispatch genUIDetailEntityField(EntityBooleanField field, DetailComponent detail) ''''''
	
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
	
	def CharSequence genEnumSelectList(EntityReferenceField fromField, Enum toEnum, DetailComponent detail) '''
    <div class="field-container-default">
      <label
        >«IF entityFieldUtils.isFieldRequired(fromField)»<span class="required">*</span
        >«ENDIF»{{
          globales.etiquetasIdioma["cib.«detail.name.toFirstLower».labels.«fromField.name.toFirstLower»"]
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
              "cib.«detail.name.toFirstLower».errors.«fromField.name.toFirstLower».required"
            ]
          }}</label
        >
      </div>
    </div>
	'''
}