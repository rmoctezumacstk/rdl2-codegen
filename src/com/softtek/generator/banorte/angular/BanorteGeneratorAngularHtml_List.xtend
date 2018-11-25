package com.softtek.generator.banorte.angular

import com.softtek.rdl2.ListComponent
import com.softtek.rdl2.Module
import com.softtek.rdl2.UIField
import com.softtek.rdl2.UIDisplay
import com.softtek.rdl2.UIFormContainer
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
import com.softtek.rdl2.UIFormPanel
import com.softtek.rdl2.UIFormRow
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.FormComponent

class BanorteGeneratorAngularHtml_List {
	
	def CharSequence genUIComponent_ListComponent(ListComponent list, Module module) '''
	  <div class="table-default table">
	    <div class="header">
	      «FOR e : list.list_elements»
	      	«e.genUIElementTableColumnHeader(module)»
	      «ENDFOR»
	    </div>
	    
	    «IF list.entity !== null»
	    <div class="row" *ngFor="let item of lst«list.entity.name»">
	      «FOR e : list.list_elements»
	      	«e.genUIElementTableColumnBody»
	      «ENDFOR»
	    </div>
	    «ENDIF»
	  </div>
	'''
	
	
	/*
	 * UIElement
	 */
	def dispatch genUIElementTableColumnHeader(UIField element, Module module) '''
	'''
	def dispatch genUIElementTableColumnHeader(UIDisplay element, Module module) '''
		«element.ui_field.genUIDisplayTableColumnHeader(module)»
	'''
	def dispatch genUIElementTableColumnHeader(UIFormContainer element, Module module) '''
		«element.genUIFormContainerTableColumnHeader(module)»
	'''

	/*
	 * EntityField
	 */
	def dispatch genUIDisplayTableColumnHeader(EntityReferenceField field, Module module) '''
      <div class="col-md-1">
        {{ globales.etiquetasIdioma["cib.«module.name.toFirstLower».labels.«field.name.toFirstLower»"] }}
      </div>
	'''
	def dispatch genUIDisplayTableColumnHeader(EntityTextField field, Module module) '''
      <div class="col-md-1">
        {{ globales.etiquetasIdioma["cib.«module.name.toFirstLower».labels.«field.name.toFirstLower»"] }}
      </div>
	'''
	def dispatch genUIDisplayTableColumnHeader(EntityLongTextField field, Module module) '''
      <div class="col-md-1">
        {{ globales.etiquetasIdioma["cib.«module.name.toFirstLower».labels.«field.name.toFirstLower»"] }}
      </div>
	'''
	def dispatch genUIDisplayTableColumnHeader(EntityDateField field, Module module) '''
      <div class="col-md-1">
        {{ globales.etiquetasIdioma["cib.«module.name.toFirstLower».labels.«field.name.toFirstLower»"] }}
      </div>
	'''
	def dispatch genUIDisplayTableColumnHeader(EntityImageField field, Module module) '''
      <div class="col-md-1">
        {{ globales.etiquetasIdioma["cib.«module.name.toFirstLower».labels.«field.name.toFirstLower»"] }}
      </div>
	'''
	def dispatch genUIDisplayTableColumnHeader(EntityFileField field, Module module) '''
      <div class="col-md-1">
        {{ globales.etiquetasIdioma["cib.«module.name.toFirstLower».labels.«field.name.toFirstLower»"] }}
      </div>
	'''
	def dispatch genUIDisplayTableColumnHeader(EntityEmailField field, Module module) '''
      <div class="col-md-1">
        {{ globales.etiquetasIdioma["cib.«module.name.toFirstLower».labels.«field.name.toFirstLower»"] }}
      </div>
	'''
	def dispatch genUIDisplayTableColumnHeader(EntityDecimalField field, Module module) '''
      <div class="col-md-1">
        {{ globales.etiquetasIdioma["cib.«module.name.toFirstLower».labels.«field.name.toFirstLower»"] }}
      </div>
	'''
	def dispatch genUIDisplayTableColumnHeader(EntityIntegerField field, Module module) '''
      <div class="col-md-1">
        {{ globales.etiquetasIdioma["cib.«module.name.toFirstLower».labels.«field.name.toFirstLower»"] }}
      </div>
	'''
	def dispatch genUIDisplayTableColumnHeader(EntityCurrencyField field, Module module) '''
      <div class="col-md-1">
        {{ globales.etiquetasIdioma["cib.«module.name.toFirstLower».labels.«field.name.toFirstLower»"] }}
      </div>
	'''
	def dispatch genUIDisplayTableColumnHeader(EntityBooleanField field, Module module) '''
      <div class="col-md-1">
        {{ globales.etiquetasIdioma["cib.«module.name.toFirstLower».labels.«field.name.toFirstLower»"] }}
      </div>
	'''

	/*
	 * UIFormContainer
	 */
	def dispatch genUIFormContainerTableColumnHeader(UIFormPanel container, Module module) '''
	'''
	def dispatch genUIFormContainerTableColumnHeader(UIFormRow container, Module module) '''
		«FOR column : container.columns»
			«FOR e : column.elements»
				«e.genUIElementTableColumnHeader(module)»
			«ENDFOR»
		«ENDFOR»
	'''
	
	
	/*
	 * UIElement
	 */
	def dispatch genUIElementTableColumnBody(UIField element) '''
	'''
	def dispatch genUIElementTableColumnBody(UIDisplay element) '''
		«element.ui_field.genUIDisplayTableColumnBody»
	'''
	def dispatch genUIElementTableColumnBody(UIFormContainer element) '''
		«element.genUIFormContainerTableColumnBody»
	'''

	/*
	 * EntityField
	 */
	def dispatch genUIDisplayTableColumnBody(EntityReferenceField field) '''
		<div class="col-md-1">{{ item.«field.name.toFirstLower» }}</div>
	'''
	def dispatch genUIDisplayTableColumnBody(EntityTextField field) '''
      <div class="col-md-1">{{ item.«field.name.toFirstLower» }}</div>
	'''
	def dispatch genUIDisplayTableColumnBody(EntityLongTextField field) '''
      <div class="col-md-1">{{ item.«field.name.toFirstLower» }}</div>
	'''
	def dispatch genUIDisplayTableColumnBody(EntityDateField field) '''
      <div class="col-md-1">{{ item.«field.name.toFirstLower» }}</div>
	'''
	def dispatch genUIDisplayTableColumnBody(EntityImageField field) '''
      <div class="col-md-1">{{ item.«field.name.toFirstLower» }}</div>
	'''
	def dispatch genUIDisplayTableColumnBody(EntityFileField field) '''
      <div class="col-md-1">{{ item.«field.name.toFirstLower» }}</div>
	'''
	def dispatch genUIDisplayTableColumnBody(EntityEmailField field) '''
      <div class="col-md-1">{{ item.«field.name.toFirstLower» }}</div>
	'''
	def dispatch genUIDisplayTableColumnBody(EntityDecimalField field) '''
      <div class="col-md-1">{{ item.«field.name.toFirstLower» }}</div>
	'''
	def dispatch genUIDisplayTableColumnBody(EntityIntegerField field) '''
      <div class="col-md-1">{{ item.«field.name.toFirstLower» }}</div>
	'''
	def dispatch genUIDisplayTableColumnBody(EntityCurrencyField field) '''
      <div class="col-md-1">{{ item.«field.name.toFirstLower» }}</div>
	'''
	def dispatch genUIDisplayTableColumnBody(EntityBooleanField field) '''
      <div class="col-md-1">{{ item.«field.name.toFirstLower» }}</div>
	'''

	/*
	 * UIFormContainer
	 */
	def dispatch genUIFormContainerTableColumnBody(UIFormPanel container) '''
	'''
	def dispatch genUIFormContainerTableColumnBody(UIFormRow container) '''
		«FOR column : container.columns»
			«FOR e : column.elements»
				«e.genUIElementTableColumnBody»
			«ENDFOR»
		«ENDFOR»
	'''
}