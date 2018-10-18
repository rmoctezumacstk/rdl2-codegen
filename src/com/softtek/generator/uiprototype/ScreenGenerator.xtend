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
import com.softtek.rdl2.Statement
import com.softtek.rdl2.StatementReturn
import org.apache.commons.lang3.RandomStringUtils
import com.softtek.rdl2.UICommandFlow
import com.softtek.rdl2.UIQueryFlow

class ScreenGenerator {
	
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
				«FOR flow : page.links»
					«flow.genPageFlow(module)»
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
			«FOR flow : form.links»
				«flow.genFormFlow(module)»
			«ENDFOR»
		</formbox>
	'''
	
	def dispatch genUIComponent(ListComponent l, Module module) '''
	    <table-results id="«l.name.toLowerCase»" title="«l.list_title»">
	    </table-results>
	'''
	
	def dispatch genUIComponent(DetailComponent detail, Module module) '''
		«FOR field : detail.list_elements»
			«field.genUIDetailElement»
		«ENDFOR»
	'''
	
	def dispatch genUIComponent(MessageComponent m, Module module) '''
		<div class="alert alert-info alert-dismissible fade in" role="alert">
			<button type="button" class="close" data-dismiss="alert" aria-label="Cerrar">
				<span aria-hidden="true">×</span>
			</button>
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
	'''
	
	def dispatch genUIFormElement(UIDisplay e) '''
		«e.ui_field.genUIFormEntityField»
	'''
	
	def dispatch genUIFormElement(UIFormContainer e) '''
		«e.genUIFormContainer»
	'''
	
	
	/*
	 * genEntityField
	 */
	def dispatch genUIFormEntityField(EntityReferenceField field) '''
		«field.superType.genUIFormRelationshipField(field)»
	'''
	
	def dispatch genUIFormEntityField(EntityTextField field) '''
		<inputbox id="«field.name.toLowerCase»" type="text" label="«entityFieldUtils.getFieldGlossaryName(field)»" value="" placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=true«ENDIF» disabled=false />
	'''
	
	def dispatch genUIFormEntityField(EntityLongTextField field) '''
		<inputbox id="«field.name.toLowerCase»" type="textarea" lines=5 label="«entityFieldUtils.getFieldGlossaryName(field)»" value="" placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=true«ENDIF» disabled=false minsize=3 maxsize=500 />
	'''
	
	def dispatch genUIFormEntityField(EntityDateField field) '''
		<date-picker id="«field.name.toLowerCase»" type="date" label="«entityFieldUtils.getFieldGlossaryName(field)»" value="" placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=true«ENDIF» disabled=false format="yyyy/mm/dd" mindate="1900-01-01" maxdate="2200-12-31" />
	'''
	
	def dispatch genUIFormEntityField(EntityImageField field) '''
		<attach-photo id="«field.name.toLowerCase»" label="«entityFieldUtils.getFieldGlossaryName(field)»" height="200" width="400" maxsizemb="2" filetypes="jpg, png, bmp" />
	'''
	
	def dispatch genUIFormEntityField(EntityFileField field) '''
		<attach-photo id="«field.name.toLowerCase»" label="«entityFieldUtils.getFieldGlossaryName(field)»" height="200" width="400" maxsizemb="2" filetypes="doc, docx, pdf" />
	'''
	
	def dispatch genUIFormEntityField(EntityEmailField field) '''
		<inputbox id="«field.name.toLowerCase»" type="email"  label="«entityFieldUtils.getFieldGlossaryName(field)»" value="" placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=true«ENDIF» disabled=false />
	'''
	
	def dispatch genUIFormEntityField(EntityDecimalField field) '''
		<inputbox id="«field.name.toLowerCase»" type="number" label="«entityFieldUtils.getFieldGlossaryName(field)»" placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=true«ENDIF» />
	'''
	
	def dispatch genUIFormEntityField(EntityIntegerField field) '''
		<inputbox id="«field.name.toLowerCase»" type="integer" label="«entityFieldUtils.getFieldGlossaryName(field)»" value="" placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=true«ENDIF» disabled=false min=0 max=1000000 />
	'''
	
	def dispatch genUIFormEntityField(EntityCurrencyField field) '''
		<inputbox id="«field.name.toLowerCase»" type="currency" label="«entityFieldUtils.getFieldGlossaryName(field)»" value=""  placeholder="«entityFieldUtils.getFieldGlossaryDescription(field)»" «IF entityFieldUtils.isFieldRequired(field)»required=true«ELSE»required=true«ENDIF» disabled=false min=0.00 max=1000000.00 />
	'''

	/*
	 * genUIFormRelationshipField
	 */
	def dispatch genUIFormRelationshipField(Enum toEnum, EntityReferenceField fromField) '''
		<select-box id="«toEnum.name.toLowerCase»" type="option" placeholder="«entityFieldUtils.getFieldGlossaryDescription(fromField)»">
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
		«IF fromField.getWidgetType == "SelectList"»
			«fromField.genSelectBox(toEntity, "select")»
		«ENDIF»
		«IF fromField.getWidgetType == "Option"»
			«fromField.genSelectBox(toEntity, "option")»
		«ENDIF»
		«IF fromField.getWidgetType == "Check"»
			«fromField.genSelectBox(toEntity, "check")»
		«ENDIF»
		«IF fromField.getWidgetType == "Autocomplete"»
			<select-auto id="«fromField.name.toLowerCase»" placeholder="«entityFieldUtils.getFieldGlossaryName(fromField)»" «IF entityFieldUtils.isFieldRequired(fromField)»required=true«ELSE»required=true«ENDIF» disabled=false>
				«FOR i : 1..5»
					<option id="«RandomStringUtils.randomAlphanumeric(8)»" label="«entityFieldUtils.fakerDomainData(toEntity.getToStringField)»" />
				«ENDFOR»
			</select-auto>
		«ENDIF»
	'''
	
	def CharSequence genSelectBox(EntityReferenceField fromField, Entity toEntity, String selectBoxType) '''
		<select-box id="«fromField.name.toLowerCase»" type="«selectBoxType»" placeholder="«entityFieldUtils.getFieldGlossaryName(fromField)»">
			«FOR i : 1..5»
				<option-box id="«RandomStringUtils.randomAlphanumeric(8)»" label="«entityFieldUtils.fakerDomainData(toEntity.getToStringField)»" />
			«ENDFOR»
		</select-box>
	'''
	
	
	
	def getToStringField(Entity entity) {
		for (m : entity.entity_methods) {
			if (m.name == "toString") {
				for (s : m.def_statements) {
					return s.getReturnStatement
				}
			}
		}
	}

	def dispatch getReturnStatement(Statement statement) {}	
	def dispatch getReturnStatement(StatementReturn statement) {
		return statement.entityfield
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
	 * genPageFlow
	 */
	def CharSequence genPageFlow(UILinkFlow flow, Module m) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«m.name.toLowerCase»/«flow.link_to.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	

	/*
	 * genFormFlow
	 */
	def dispatch genFormFlow(UICommandFlow flow, Module m) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«m.name.toLowerCase»/«flow.command_ref.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	def dispatch genFormFlow(UIQueryFlow flow, Module m) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«m.name.toLowerCase»/«flow.query_ref.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	def dispatch genFormFlow(UILinkFlow flow, Module m) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«m.name.toLowerCase»/«flow.link_to.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''

	/*
	 * genUIDetailElement
	 */
	def dispatch genUIDetailElement(UIField e) '''
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
		<outputtext label="«entityFieldUtils.getFieldGlossaryName(field)»" value="«entityFieldUtils.fakerDomainData(field)»"></outputtext>
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

}