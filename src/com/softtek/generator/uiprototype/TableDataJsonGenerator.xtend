package com.softtek.generator.uiprototype

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.ListComponent
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
import com.softtek.generator.utils.EntityFieldUtils
import org.apache.commons.lang3.RandomStringUtils
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.UILinkFlow
import com.softtek.generator.utils.UIFlowUtils
import com.softtek.rdl2.UICommandFlow
import com.softtek.rdl2.UIQueryFlow
import com.softtek.rdl2.InlineFormComponent
import com.softtek.rdl2.UIFormContainer
import com.softtek.rdl2.UIComponent
import com.softtek.rdl2.Enum
import com.softtek.rdl2.Entity
import com.softtek.generator.utils.EntityUtils

//import org.eclipse.xtext.naming.IQualifiedNameProvider
//import com.google.inject.Inject

class TableDataJsonGenerator {
	
	var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	//@Inject extension IQualifiedNameProvider
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				for (list : p.components.filter(typeof(ListComponent))) {
					fsa.generateFile("prototipo/src/tabledata/" + m.name.toLowerCase + "/" + list.name.toLowerCase + ".json", list.genListTableData)
				}
				for (inlineform : p.components.filter(typeof(InlineFormComponent))) {
					fsa.generateFile("prototipo/src/tabledata/" + m.name.toLowerCase + "/" + inlineform.name.toLowerCase + ".json", inlineform.genInlineFormTableData)
				}
			}
		}
	}
	
	def CharSequence genListTableData(ListComponent list) '''
		{
			"ids": [
				{
					"id": "«list.name.toLowerCase»",
					"headers": [
						«FOR h : list.list_elements  SEPARATOR ","»
							«h.genTableHeader»
						«ENDFOR»
					],
					"rows": [
						«FOR i : 1..8 SEPARATOR ","»
							{
								"id": "«RandomStringUtils.randomAlphanumeric(8)»",
								"data": [
									«FOR r : list.list_elements SEPARATOR ","»
										«r.genTableRows»
									«ENDFOR»
								]
							}
						«ENDFOR»
					]
					«IF list.links.size > 0»
						,"actions": [
							{
								"group": "Acciones",
								"actions": [
									«FOR f : list.links SEPARATOR ","»
										«f.genFlowRows»
									«ENDFOR»
								]
							}
						]
					«ENDIF»
				}
			]
		}
	'''


	def CharSequence genInlineFormTableData(InlineFormComponent form) '''
		{
			"ids": [
				{
					"id": "«form.name.toLowerCase»",
					"headers": [
						«FOR h : form.form_elements  SEPARATOR ","»
							«h.genTableHeader»
						«ENDFOR»
					],
					"rows": [
					]
				}
			]
		}
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
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»",
			"type": "select",
			«IF entityFieldUtils.isFieldRequired(field)»"required": "true"«ELSE»"required" : "false"«ENDIF»,
			«field.superType.genEnumEntityData»
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityTextField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»",
			«IF entityFieldUtils.isFieldRequired(field)»"required": "true"«ELSE»"required" : "false"«ENDIF»
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityLongTextField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»",
			«IF entityFieldUtils.isFieldRequired(field)»"required": "true"«ELSE»"required" : "false"«ENDIF»
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityDateField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»",
			"type": "date",
			«IF entityFieldUtils.isFieldRequired(field)»"required": "true"«ELSE»"required" : "false"«ENDIF»
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityImageField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»",
			«IF entityFieldUtils.isFieldRequired(field)»"required": "true"«ELSE»"required" : "false"«ENDIF»
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityFileField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»",
			«IF entityFieldUtils.isFieldRequired(field)»"required": "true"«ELSE»"required" : "false"«ENDIF»
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityEmailField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»",
			«IF entityFieldUtils.isFieldRequired(field)»"required": "true"«ELSE»"required" : "false"«ENDIF»
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityDecimalField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»",
			«IF entityFieldUtils.isFieldRequired(field)»"required": "true"«ELSE»"required" : "false"«ENDIF»
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityIntegerField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»",
			«IF entityFieldUtils.isFieldRequired(field)»"required": "true"«ELSE»"required" : "false"«ENDIF»
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityCurrencyField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»",
			«IF entityFieldUtils.isFieldRequired(field)»"required": "true"«ELSE»"required" : "false"«ENDIF»
		}
	'''


	/*
	 * EnumEntity
	 */
	def dispatch genEnumEntityData(Enum toEnum) '''
		"data": [
			«FOR l : toEnum.enum_literals SEPARATOR ","»
				"«l.value»"
			«ENDFOR»
		]
	'''
	def dispatch genEnumEntityData(Entity toEntity) '''
		"data": [
			«FOR i : 1..5 SEPARATOR ","»
				"«entityFieldUtils.fakerDomainData(entityUtils.getToStringField(toEntity))»"
			«ENDFOR»
		]
	'''

	/*
	 * UIElement
	 */
	def dispatch genTableRows(UIField element) ''''''
	def dispatch genTableRows(UIDisplay element) '''
		«element.ui_field.genRowsUIDisplayField»
	'''
	def dispatch genTableRows(UIFormContainer element) ''''''
	
	
	def dispatch genRowsUIDisplayField(EntityReferenceField field) '''
		"«entityFieldUtils.fakerDomainData(field)»"
	'''
	
	def dispatch genRowsUIDisplayField(EntityTextField field) '''
		"«entityFieldUtils.fakerDomainData(field)»"
	'''
	
	def dispatch genRowsUIDisplayField(EntityLongTextField field) '''
		"«entityFieldUtils.fakerDomainData(field)»"
	'''
	
	def dispatch genRowsUIDisplayField(EntityDateField field) '''
		"«entityFieldUtils.fakerDomainData(field)»"
	'''
	
	def dispatch genRowsUIDisplayField(EntityImageField field) '''
		"«entityFieldUtils.fakerDomainData(field)»"
	'''
	
	def dispatch genRowsUIDisplayField(EntityFileField field) '''
		"«entityFieldUtils.fakerDomainData(field)»"
	'''
	
	def dispatch genRowsUIDisplayField(EntityEmailField field) '''
		"«entityFieldUtils.fakerDomainData(field)»"
	'''
	
	def dispatch genRowsUIDisplayField(EntityDecimalField field) '''
		"«entityFieldUtils.fakerDomainData(field)»"
	'''
	
	def dispatch genRowsUIDisplayField(EntityIntegerField field) '''
		"«entityFieldUtils.fakerDomainData(field)»"
	'''
	
	def dispatch genRowsUIDisplayField(EntityCurrencyField field) '''
		"«entityFieldUtils.fakerDomainData(field)»"
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
		{
			"label": "«uiFlowUtils.getFlowLabel(flow)»",
			"link": "/«flow.link_to.getParentModule.name.toLowerCase»/«flow.link_to.name.toLowerCase»/"
		}
	'''


	/*
	 * ContainerOrComponent
	 */
	def dispatch genCommandFlowToContainer(PageContainer page, UICommandFlow flow) '''
		{
			"label": "«uiFlowUtils.getFlowLabel(flow)»",
			"link": "/«page.getParentModule.name.toLowerCase»/«page.name.toLowerCase»/"
		}
	'''
	def dispatch genCommandFlowToContainer(UIComponent component, UICommandFlow flow) ''''''


	/*
	 * ContainerOrComponent
	 */
	def dispatch genQueryFlowToContainer(PageContainer page, UIQueryFlow flow) '''
		{
			"label": "«uiFlowUtils.getFlowLabel(flow)»",
			"link": "/«page.getParentModule.name.toLowerCase»/«page.name.toLowerCase»/"
		}
	'''
	def dispatch genQueryFlowToContainer(UIComponent component, UIQueryFlow flow) ''''''
	

	def Module getParentModule(PageContainer page) {
		return page.eContainer as Module
	}
}