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

class TableDataGenerator {
	
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				for (list : p.components.filter(typeof(ListComponent))) {
					fsa.generateFile("prototipo/src/tabledata/" + m.name.toLowerCase + "/" + list.name.toLowerCase + ".json", list.genListTableData)
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

	
	/*
	 * genTableHeader
	 */
	def dispatch genTableHeader(UIField element) ''''''
	
	def dispatch genTableHeader(UIDisplay element) '''
		«element.ui_field.genHeaderUIDisplayField»
	'''
	
	def dispatch genHeaderUIDisplayField(EntityReferenceField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»"
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityTextField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»"
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityLongTextField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»"
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityDateField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»"
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityImageField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»"
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityFileField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»"
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityEmailField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»"
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityDecimalField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»"
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityIntegerField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»"
		}
	'''
	
	def dispatch genHeaderUIDisplayField(EntityCurrencyField field) '''
		{
			"label": "«entityFieldUtils.getFieldGlossaryName(field)»"
		}
	'''


	/*
	 * genTableRows
	 */
	def dispatch genTableRows(UIField element) ''''''
	
	def dispatch genTableRows(UIDisplay element) '''
		«element.ui_field.genRowsUIDisplayField»
	'''
	
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
	 * genFlowRows
	 */
	def CharSequence genFlowRows(UILinkFlow flow) '''
		{
			"label": "«uiFlowUtils.getFlowLabel(flow)»",
			"link": "/«flow.link_to.name.toLowerCase»/"
		}
	'''
}