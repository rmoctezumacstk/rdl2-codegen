package com.softtek.generator.uiprototype

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

class ScreenGenerator {
	
	var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				if (p.screen_type === null) {
					fsa.generateFile("prototipo/src/components/app/" + m.name.toLowerCase + "/" + p.name.toLowerCase + ".tag", p.generateTag(m))
				}
			}
		}
	}
	
	def CharSequence generateTag(PageContainer page, Module module) '''
		<«page.name.toLowerCase»>
			<page id="«page.name.toLowerCase»" title="«page.page_title»">
				«FOR c : page.components»
					«c.genUIComponent(module)»
				«ENDFOR»
				<div class="ln_solid"></div>
				«FOR flow : page.links»
					«flow.genPageFlow»
				«ENDFOR»
			</page>
		</«page.name.toLowerCase»>
	'''
	
	/*
	 * genUIComponent
	 */
	def dispatch genUIComponent(FormComponent form, Module module) '''
		<formbox id="«form.name.toLowerCase»" title="«form.form_title»">
			«FOR field : form.form_elements»
				«field.genUIFormElement»
			«ENDFOR»
			<div class="ln_solid"></div>
			«FOR flow : form.links»
				«flow.genFormFlow»
			«ENDFOR»
		</formbox>
	'''

	def dispatch genUIComponent(InlineFormComponent form, Module module) '''
		<simple-admin id="«form.name.toLowerCase»" maxrows="8"/>
	'''

/*
	    <table-results id="«l.name.toLowerCase»" title="«l.list_title»">
	    </table-results>
 */
	
	def dispatch genUIComponent(ListComponent l, Module module) '''
		<table class="table">
			<thead>
				<tr>
					«FOR h : l.list_elements»
						«h.genTableHeader»
					«ENDFOR»
					«IF l.links.size > 0»
						<th></th>
					«ENDIF»
				</tr>
			</thead>
			<tbody>
				«FOR i : 1..8»
					<tr>
						«FOR h : l.list_elements»
							«h.genTableRows»
						«ENDFOR»
						«IF l.links.size > 0»
							<th>
								«FOR f : l.links»
									«f.genFlowRows»
								«ENDFOR»
							</th>
						«ENDIF»
					</tr>
				«ENDFOR»
			</tbody>
		</table>
	'''
	
	def dispatch genUIComponent(DetailComponent detail, Module module) '''
		«FOR field : detail.list_elements»
			«field.genUIDetailElement»
		«ENDFOR»
		<div class="ln_solid"></div>
		«FOR flow : detail.links»
			«flow.genFormFlow»
		«ENDFOR»
	'''

/*
		<div class="alert alert-info alert-dismissible fade in" role="alert">
			<button type="button" class="close" data-dismiss="alert" aria-label="Cerrar">
				<span aria-hidden="true">×</span>
			</button>
			«m.msgtext»
		</div>
 */
	
	def dispatch genUIComponent(MessageComponent m, Module module) '''
		<div class="well" style="overflow: auto">
			«m.msgtext»
		</div>
	'''
	
	def dispatch genUIComponent(RowComponent row, Module module) '''
		<div class="row">
			«FOR c : row.columns»
				«c.genColumnComponent(module)»
			«ENDFOR»
		</div>
	'''
	
	def CharSequence genColumnComponent(ColumnComponent column, Module module) '''
		<div class="«column.sizes.genColSize»">
			«FOR e : column.elements»
				«e.genUIComponent(module)»
			«ENDFOR»
		</div>
	'''
	
	def genColSize(EList<SizeOption> list) {
		var col_class = ""
		for (size : list) {
			col_class = col_class + "col-" + size.sizeop + " "
		}
		return col_class
	}
	
	
	/*
	 * genUIFormElement
	 */
	def dispatch genUIFormElement(UIField e) '''
		«e.genFormUIField»
	'''
	def dispatch genUIFormElement(UIDisplay e) '''
		«e.ui_field.genUIFormEntityField»
	'''
	def dispatch genUIFormElement(UIFormContainer e) '''
		«e.genUIFormContainer»
	'''


	/*
	 * UIField
	 */
	def dispatch genFormUIField(UITextField field) '''
		<inputbox id="«field.name.toLowerCase»" type="text" label="«field.name»" value="" placeholder="" required=true disabled=false />
	'''
	def dispatch genFormUIField(UILongTextField field) '''
		<inputbox id="«field.name.toLowerCase»" type="textarea" lines=5 label="«field.name»" value="" placeholder="" required=true disabled=false />
	'''
	def dispatch genFormUIField(UIDateField field) '''
		<date-picker id="«field.name.toLowerCase»" type="date" label="«field.name»" value="" placeholder="" required=true disabled=false format="yyyy/mm/dd" mindate="1900-01-01" maxdate="2200-12-31" />
	'''
	def dispatch genFormUIField(UIImageField field) '''
		<attach-photo id="«field.name.toLowerCase»" label="«field.name»" height="200" width="400" maxsizemb="2" filetypes="jpg, png, bmp" />
	'''
	def dispatch genFormUIField(UIFileField field) '''
		<attach-photo id="«field.name.toLowerCase»" label="«field.name»" height="200" width="400" maxsizemb="2" filetypes="doc, docx, pdf" />
	'''
	def dispatch genFormUIField(UIEmailField field) '''
		<inputbox id="«field.name.toLowerCase»" type="email"  label="«field.name»" value="" placeholder="" required=true disabled=false />
	'''
	def dispatch genFormUIField(UIDecimalField field) '''
		<inputbox id="«field.name.toLowerCase»" type="number" label="«field.name»" placeholder="" required=true />
	'''
	def dispatch genFormUIField(UIIntegerField field) '''
		<inputbox id="«field.name.toLowerCase»" type="integer" label="«field.name»" value="" placeholder="" required=true disabled=false min=0 max=1000000 />
	'''
	def dispatch genFormUIField(UICurrencyField field) '''
		<inputbox id="«field.name.toLowerCase»" type="currency" label="«field.name»" value=""  placeholder="" required=true disabled=false min=0.00 max=1000000.00 />
	'''	
	
	/*
	 * genEntityField
	 */
	def dispatch genUIFormEntityField(EntityReferenceField field) '''
		«field.superType.genUIFormRelationshipField(field)»
	'''
	
	def dispatch genUIFormEntityField(EntityTextField field) '''
		<inputbox id="«field.name.toLowerCase»" type="text" label="«entityFieldUtils.getFieldGlossaryName(field)»" value="" placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=false«ENDIF» disabled=false />
	'''
	
	def dispatch genUIFormEntityField(EntityLongTextField field) '''
		<inputbox id="«field.name.toLowerCase»" type="textarea" lines=5 label="«entityFieldUtils.getFieldGlossaryName(field)»" value="" placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=false«ENDIF» disabled=false minsize=3 maxsize=500 />
	'''
	
	def dispatch genUIFormEntityField(EntityDateField field) '''
		<date-picker id="«field.name.toLowerCase»" type="date" label="«entityFieldUtils.getFieldGlossaryName(field)»" value="" placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=false«ENDIF» disabled=false format="yyyy/mm/dd" mindate="1900-01-01" maxdate="2200-12-31" />
	'''
	
	def dispatch genUIFormEntityField(EntityImageField field) '''
		<attach-photo id="«field.name.toLowerCase»" label="«entityFieldUtils.getFieldGlossaryName(field)»" height="200" width="400" maxsizemb="2" filetypes="jpg, png, bmp" />
	'''
	
	def dispatch genUIFormEntityField(EntityFileField field) '''
		<attach-photo id="«field.name.toLowerCase»" label="«entityFieldUtils.getFieldGlossaryName(field)»" height="200" width="400" maxsizemb="2" filetypes="doc, docx, pdf" />
	'''
	
	def dispatch genUIFormEntityField(EntityEmailField field) '''
		<inputbox id="«field.name.toLowerCase»" type="email"  label="«entityFieldUtils.getFieldGlossaryName(field)»" value="" placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=false«ENDIF» disabled=false />
	'''
	
	def dispatch genUIFormEntityField(EntityDecimalField field) '''
		<inputbox id="«field.name.toLowerCase»" type="number" label="«entityFieldUtils.getFieldGlossaryName(field)»" placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=false«ENDIF» />
	'''
	
	def dispatch genUIFormEntityField(EntityIntegerField field) '''
		<inputbox id="«field.name.toLowerCase»" type="integer" label="«entityFieldUtils.getFieldGlossaryName(field)»" value="" placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=false«ENDIF» disabled=false min=0 max=1000000 />
	'''
	
	def dispatch genUIFormEntityField(EntityCurrencyField field) '''
		<inputbox id="«field.name.toLowerCase»" type="currency" label="«entityFieldUtils.getFieldGlossaryName(field)»" value=""  placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=false«ENDIF» disabled=false min=0.00 max=1000000.00 />
	'''

	/*
	 * genUIFormRelationshipField
	 */
	def dispatch genUIFormRelationshipField(Enum toEnum, EntityReferenceField fromField) '''
		«IF fromField.getWidgetType == "SelectList"»
			«fromField.genEnumSelectBox(toEnum, "select")»
		«ENDIF»
		«IF fromField.getWidgetType == "Option" || fromField.getWidgetType === null»
			«fromField.genEnumSelectBox(toEnum, "option")»
		«ENDIF»
		«IF fromField.getWidgetType == "Check"»
			«fromField.genEnumSelectBox(toEnum, "check")»
		«ENDIF»
		«IF fromField.getWidgetType == "Autocomplete"»
			<select-auto id="«fromField.name.toLowerCase»" placeholder="«entityFieldUtils.getFieldGlossaryName(fromField)»" «IF entityFieldUtils.isFieldRequired(fromField)»required=true«ELSE»required=false«ENDIF» disabled=false>
				«FOR l : toEnum.enum_literals»
					<option id="«l.key»" label="«l.value»»" />
				«ENDFOR»
			</select-auto>
		«ENDIF»
	'''
	
	def CharSequence genEnumSelectBox(EntityReferenceField fromField, Enum toEnum, String selectBoxType) '''
		<select-box id="«toEnum.name.toLowerCase»" type="«selectBoxType»" placeholder="«entityFieldUtils.getFieldGlossaryDescription(fromField)»">
			«FOR l : toEnum.enum_literals»
				<option-box id="«l.key»" label="«l.value»" />
			«ENDFOR»
		</select-box>
	'''
	


/*
	    <search-box id="«fromField.name.toLowerCase»" link="«toEntity.name.toLowerCase»_modal" caption="«entityFieldUtils.getFieldGlossaryName(fromField)»" placeholder="«entityFieldUtils.getFieldGlossaryDescription(fromField)»" />
	    <modal-box id="«fromField.name.toLowerCase»_modal"  data="«fromField.name.toLowerCase»-results" title="Seleccionar «entityFieldUtils.getFieldGlossaryName(fromField)» " action="select-one" pagination="true"/>
 */

	def dispatch genUIFormRelationshipField(Entity toEntity, EntityReferenceField fromField) '''
		«IF fromField.getWidgetType == "SelectList" || fromField.getWidgetType === null»
			«fromField.genEntitySelectBox(toEntity, "select")»
		«ENDIF»
		«IF fromField.getWidgetType == "Option"»
			«fromField.genEntitySelectBox(toEntity, "option")»
		«ENDIF»
		«IF fromField.getWidgetType == "Check"»
			«fromField.genEntitySelectBox(toEntity, "check")»
		«ENDIF»
		«IF fromField.getWidgetType == "Autocomplete"»
			<select-auto id="«fromField.name.toLowerCase»" placeholder="«entityFieldUtils.getFieldGlossaryName(fromField)»" «IF entityFieldUtils.isFieldRequired(fromField)»required=true«ELSE»required=false«ENDIF» disabled=false>
				«FOR i : 1..5»
					<option id="«RandomStringUtils.randomAlphanumeric(8)»" label="«entityFieldUtils.fakerDomainData(entityUtils.getToStringField(toEntity))»" />
				«ENDFOR»
			</select-auto>
		«ENDIF»
	'''
	
	def CharSequence genEntitySelectBox(EntityReferenceField fromField, Entity toEntity, String selectBoxType) '''
		<select-box id="«fromField.name.toLowerCase»" type="«selectBoxType»" placeholder="«entityFieldUtils.getFieldGlossaryName(fromField)»">
			«FOR i : 1..5»
				<option-box id="«RandomStringUtils.randomAlphanumeric(8)»" label="«entityFieldUtils.fakerDomainData(entityUtils.getToStringField(toEntity))»" />
			«ENDFOR»
		</select-box>
	'''
	
	
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

	/*
	 * UIFormContainer
	 */
	def dispatch genUIFormContainer(UIFormPanel panel) '''
	'''
	
	def dispatch genUIFormContainer(UIFormRow row) '''
		<div class="row">
			«FOR c : row.columns»
				«c.genUIFormColumn»
			«ENDFOR»
		</div>
	'''
	
	/*
	 * UIFormColumn
	 */
	def CharSequence genUIFormColumn(UIFormColumn column) '''
		<div class="«column.sizes.genColSize»">
			«FOR e : column.elements»
				«e.genUIFormElement»
			«ENDFOR»
		</div>
	'''


	/*
	 * UILinkCommandQueryFlow
	 */
	def dispatch genPageFlow(UICommandFlow flow) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«flow.success_flow.genCommandFlowToContainer.getParentModule.name.toLowerCase»/«flow.success_flow.genCommandFlowToContainer.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	def dispatch genPageFlow(UIQueryFlow flow) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«flow.success_flow.genCommandFlowToContainer.getParentModule.name.toLowerCase»/«flow.success_flow.genQueryFlowToContainer.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	def dispatch genPageFlow(UILinkFlow flow) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«flow.link_to.genCommandFlowToContainer.getParentModule.name.toLowerCase»/«flow.link_to.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''	

	/*
	 * UILinkCommandQueryFlow
	 */
	def dispatch genFormFlow(UICommandFlow flow) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«flow.success_flow.genQueryFlowToContainer.getParentModule.name.toLowerCase»/«flow.success_flow.genCommandFlowToContainer.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	def dispatch genFormFlow(UIQueryFlow flow) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«flow.success_flow.genQueryFlowToContainer.getParentModule.name.toLowerCase»/«flow.success_flow.genQueryFlowToContainer.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	def dispatch genFormFlow(UILinkFlow flow) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«flow.link_to.genCommandFlowToContainer.getParentModule.name.toLowerCase»/«flow.link_to.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''

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


	/*
	 * genUIDetailElement
	 */
	def dispatch genUIDetailElement(UIField e) '''
		«e.genFormUIField»
	'''
	def dispatch genUIDetailElement(UIDisplay e) '''
		«e.ui_field.genUIDetailEntityField»
	'''
	def dispatch genUIDetailElement(UIFormContainer e) '''
		«e.genUIDetailFormContainer»
	'''
	
	/*
	 * UIFormContainer
	 */
	def dispatch genUIDetailFormContainer(UIFormPanel e) '''
	'''

	def dispatch genUIDetailFormContainer(UIFormRow e) '''
		«e.genRowDetailComponent»
	'''
	
	def CharSequence genRowDetailComponent(UIFormRow row) '''
		<div class="row">
			«FOR c : row.columns»
				«c.genUIDetailColumn»
			«ENDFOR»
		</div>
	'''
	
	def CharSequence genUIDetailColumn(UIFormColumn column) '''
		<div class="«column.sizes.genColSize»">
			«FOR e : column.elements»
				«e.genUIDetailElement»
			«ENDFOR»
		</div>
	'''
	
	
	/*
	 * genUIDetailEntityField
	 */
	def dispatch genUIDetailEntityField(EntityReferenceField field) '''
		<outputtext label="«entityFieldUtils.getFieldGlossaryName(field)»" value="«entityFieldUtils.fakerDomainData(field)»"></outputtext>
	'''
	
	def dispatch genUIDetailEntityField(EntityTextField field) '''
		<outputtext label="«entityFieldUtils.getFieldGlossaryName(field)»" value="«entityFieldUtils.fakerDomainData(field)»"></outputtext>
	'''
	
	def dispatch genUIDetailEntityField(EntityLongTextField field) '''
		<outputtext label="«entityFieldUtils.getFieldGlossaryName(field)»" value="«entityFieldUtils.fakerDomainData(field)»"></outputtext>
	'''
	
	def dispatch genUIDetailEntityField(EntityDateField field) '''
		<outputtext label="«entityFieldUtils.getFieldGlossaryName(field)»" value="«entityFieldUtils.fakerDomainData(field)»"></outputtext>
	'''
	
	def dispatch genUIDetailEntityField(EntityImageField field) '''
		<img src="«entityFieldUtils.fakerDomainData(field)»" alt="«entityFieldUtils.getFieldGlossaryName(field)»">
	'''
	
	def dispatch genUIDetailEntityField(EntityFileField field) '''
		<outputtext label="«entityFieldUtils.getFieldGlossaryName(field)»" value="«entityFieldUtils.fakerDomainData(field)»"></outputtext>
	'''
	
	def dispatch genUIDetailEntityField(EntityEmailField field) '''
		<outputtext label="«entityFieldUtils.getFieldGlossaryName(field)»" value="«entityFieldUtils.fakerDomainData(field)»"></outputtext>
	'''
	
	def dispatch genUIDetailEntityField(EntityDecimalField field) '''
		<outputtext label="«entityFieldUtils.getFieldGlossaryName(field)»" value="«entityFieldUtils.fakerDomainData(field)»"></outputtext>
	'''
	
	def dispatch genUIDetailEntityField(EntityIntegerField field) '''
		<outputtext label="«entityFieldUtils.getFieldGlossaryName(field)»" value="«entityFieldUtils.fakerDomainData(field)»"></outputtext>
	'''
	
	def dispatch genUIDetailEntityField(EntityCurrencyField field) '''
		<outputtext label="«entityFieldUtils.getFieldGlossaryName(field)»" value="«entityFieldUtils.fakerDomainData(field)»"></outputtext>
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
		<th>«entityFieldUtils.getFieldGlossaryName(field)»</th>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityTextField field) '''
		<th>«entityFieldUtils.getFieldGlossaryName(field)»</th>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityLongTextField field) '''
		<th>«entityFieldUtils.getFieldGlossaryName(field)»</th>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityDateField field) '''
		<th>«entityFieldUtils.getFieldGlossaryName(field)»</th>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityImageField field) '''
		<th>«entityFieldUtils.getFieldGlossaryName(field)»</th>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityFileField field) '''
		<th>«entityFieldUtils.getFieldGlossaryName(field)»</th>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityEmailField field) '''
		<th>«entityFieldUtils.getFieldGlossaryName(field)»</th>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityDecimalField field) '''
		<th>«entityFieldUtils.getFieldGlossaryName(field)»</th>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityIntegerField field) '''
		<th>«entityFieldUtils.getFieldGlossaryName(field)»</th>
	'''
	
	def dispatch genHeaderUIDisplayField(EntityCurrencyField field) '''
		<th>«entityFieldUtils.getFieldGlossaryName(field)»</th>
	'''

	/*
	 * genTableRows
	 */
	def dispatch genTableRows(UIField element) ''''''
	
	def dispatch genTableRows(UIDisplay element) '''
		«element.ui_field.genRowsUIDisplayField»
	'''
	
	def dispatch genRowsUIDisplayField(EntityReferenceField field) '''
		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityTextField field) '''
		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityLongTextField field) '''
		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityDateField field) '''
		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityImageField field) '''
		<th><img src="https://fakeimg.pl/60x60/?text=Picture&font=lobster"></img></th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityFileField field) '''
		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityEmailField field) '''
		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityDecimalField field) '''
		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityIntegerField field) '''
		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''
	
	def dispatch genRowsUIDisplayField(EntityCurrencyField field) '''
		<th>«entityFieldUtils.fakerDomainData(field)»</th>
	'''

	/*
	 * UILinkCommandQueryFlow
	 */
	def dispatch genFlowRows(UICommandFlow flow) '''
		«flow.success_flow.genCommandFlowToContainer(flow)»
	'''
	def dispatch genFlowRows(UIQueryFlow flow) '''
		«flow.success_flow.genQueryFlowToContainer(flow)»
	'''
	def dispatch genFlowRows(UILinkFlow flow) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«flow.link_to.getParentModule.name.toLowerCase»/«flow.link_to.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''

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
	def dispatch genQueryFlowToContainer(PageContainer page, UIQueryFlow flow) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«page.getParentModule.name.toLowerCase»/«page.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	def dispatch genQueryFlowToContainer(UIComponent component, UIQueryFlow flow) ''''''

	
	def Module getParentModule(PageContainer page) {
		return page.eContainer as Module
	}
}