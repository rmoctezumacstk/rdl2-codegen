package com.softtek.generator.clarity.screen

import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.generator.utils.UIFlowUtils
import com.softtek.rdl2.ListComponent
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer
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

class ScreenGeneratorAngularHtml_List {
	
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def CharSequence genUIComponent_ListFormComponent(ListComponent l, Module module, PageContainer page) '''
		
		    <clr-datagrid [clrDgLoading]="loading">
		        <clr-dg-placeholder>No se encontró información.</clr-dg-placeholder>
		        
		        «FOR h : l.list_elements»
					«h.genTableHeader»
				«ENDFOR»
				
		        <clr-dg-row *clrDgItems="let «page.name.toLowerCase» of «page.name.toLowerCase»Array" [clrDgItem]="«page.name.toLowerCase»">
«««		                <div hidden="true">
«««		                    <div>
«««		                        <button class="action-item" (click)="setClickedRowEdita«page.name.toLowerCase.toFirstUpper»(i, «page.name.toLowerCase»)">Editar</button> 
«««		                    </div>
«««		                    <div>
«««		                        <button class="action-item" (click)="setClickedRowElimina«page.name.toLowerCase.toFirstUpper»(i, «page.name.toLowerCase»)">Eliminar</button>
«««		                    </div>
«««		                </div>
«««		                <clr-dg-action-overflow>
«««		                    <button class="action-item" *ngIf="beneficiario_update" (click)="setClickedRowEdita«page.name.toLowerCase.toFirstUpper»(i, «page.name.toLowerCase»)">
«««		                        <clr-icon shape="note" ></clr-icon> Editar
«««		                    </button>
«««		                    <button class="action-item" *ngIf="beneficiario_delete" (click)="setClickedRowElimina«page.name.toLowerCase.toFirstUpper»(i, «page.name.toLowerCase»)">
«««		                        <clr-icon shape="trash"></clr-icon> Borrar
«««		                    </button>
«««		                </clr-dg-action-overflow>
«««		
«««				<clr-dg-row>
					«FOR h : l.list_elements»
						«h.genTableRows»
					«ENDFOR»
					
«««					«l.name»
«««					«IF l.links.size > 0»
«««						«FOR f : l.links»
«««							«f.genFlowRows»
«««						«ENDFOR»
«««					«ENDIF»
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
	'''
	
	/*
	 * UIElement
	 */
	def dispatch genTableHeader(UIField element) ''''''
	def dispatch genTableHeader(UIDisplay element) '''
		«element.ui_field.genHeaderUIDisplayField»
	'''
	def dispatch genTableHeader(UIFormContainer element) ''''''
	
	
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
	
	/*
	 * genTableRows
	 */
	def dispatch genTableRows(UIField element) ''''''
	def dispatch genTableRows(UIDisplay element) '''
«««	«element.ui_field»
		«element.ui_field.genRowsUIDisplayField»
	'''
	def dispatch genTableRows(UIFormContainer element) '''
	'''
	
	def dispatch genRowsUIDisplayField(EntityReferenceField field) '''
«««		<clr-dg-cell >{{«field».«field»}}</clr-dg-cell >
	'''
	
	def dispatch genRowsUIDisplayField(EntityTextField field) '''
«««		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityLongTextField field) '''
«««		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityDateField field) '''
«««		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityImageField field) '''
«««		<th><img src="https://fakeimg.pl/60x60/?text=Picture&font=lobster"></img></th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityFileField field) '''
«««		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityEmailField field) '''
«««		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityDecimalField field) '''
«««		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityIntegerField field) '''
«««		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityCurrencyField field) '''
«««		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
}