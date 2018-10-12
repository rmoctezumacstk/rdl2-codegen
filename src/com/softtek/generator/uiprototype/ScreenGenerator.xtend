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

class ScreenGenerator {
	
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				fsa.generateFile("prototipo/src/components/app/" + m.name.toLowerCase + "/" + p.name.toLowerCase + ".tag", p.generateTag)
			}
		}
	}
	
	def CharSequence generateTag(PageContainer page) '''
		<«page.name.toLowerCase»>
			<page id="«page.name.toLowerCase»" title="«page.page_title»">
				«FOR c : page.components»
					«c.genUIComponent»
				«ENDFOR»
				«FOR flow : page.links»
					«flow.genPageFlow»
				«ENDFOR»
			</page>
		</«page.name.toLowerCase»>
	'''
	
	/*
	 * genUIComponent
	 */
	def dispatch genUIComponent(FormComponent form) '''
		<formbox id="«form.name.toLowerCase»" title="«form.form_title»">
			«FOR field : form.form_elements»
				«field.genUIFormElement»
			«ENDFOR»
			«FOR flow : form.links»
				«flow.genFormFlow»
			«ENDFOR»
		</formbox>
	'''
	
	def dispatch genUIComponent(ListComponent l) '''
	    <table-results id="«l.name.toLowerCase»" title="«l.list_title»">
	    </table-results>
	'''
	
	def dispatch genUIComponent(DetailComponent detail) '''
		«FOR field : detail.list_elements»
			«field.genUIDetailElement»
		«ENDFOR»
	'''
	
	def dispatch genUIComponent(MessageComponent m) '''
		<div class="alert alert-info alert-dismissible fade in" role="alert">
			<button type="button" class="close" data-dismiss="alert" aria-label="Cerrar">
				<span aria-hidden="true">×</span>
			</button>
			«m.msgtext»
		</div>
	'''
	
	
	/*
	 * genUIFormElement
	 */
	def dispatch genUIFormElement(UIField e) ''''''
	
	def dispatch genUIFormElement(UIDisplay e) '''
		«e.ui_field.genUIFormEntityField»
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

	def dispatch genUIFormRelationshipField(Entity toEntity, EntityReferenceField fromField) '''
	    <search-box id="«fromField.name.toLowerCase»" link="«toEntity.name.toLowerCase»_modal" caption="«entityFieldUtils.getFieldGlossaryName(fromField)»" placeholder="«entityFieldUtils.getFieldGlossaryDescription(fromField)»" />
	    <modal-box id="«fromField.name.toLowerCase»_modal"  data="«fromField.name.toLowerCase»-results" title="Seleccionar «entityFieldUtils.getFieldGlossaryName(fromField)» " action="select-one" pagination="true"/>
	'''


	/*
	 * genPageFlow
	 */
	def CharSequence genPageFlow(UILinkFlow flow) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«flow.link_to.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	

	/*
	 * genFormFlow
	 */
	def CharSequence genFormFlow(UILinkFlow flow) '''
		<submit-button id="«flow.name.toLowerCase»" to="/«flow.link_to.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''


	/*
	 * genUIDetailElement
	 */
	def dispatch genUIDetailElement(UIField e) ''''''
	
	def dispatch genUIDetailElement(UIDisplay e) '''
		«e.ui_field.genUIDetailEntityField»
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