package com.softtek.generator.uiprototype

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.FormComponent
import com.softtek.rdl2.ListComponent
import com.softtek.rdl2.DetailComponent
import com.softtek.rdl2.MessageComponent
import com.softtek.rdl2.UIElement
import com.softtek.rdl2.UIField
import com.softtek.rdl2.UIDisplay

class ScreenGenerator {
	
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
			</page>
		</«page.name.toLowerCase»>
	'''
	
	/*
	 * genUIComponent
	 */
	def dispatch genUIComponent(FormComponent form) '''
		<formbox id="«form.name.toLowerCase»" title="«form.form_title»">
			«FOR field : form.form_elements»
				«field.genUIElement»
			«ENDFOR»
		</formbox>
	'''
	
	def dispatch genUIComponent(ListComponent l) ''''''
	
	def dispatch genUIComponent(DetailComponent d) ''''''
	
	def dispatch genUIComponent(MessageComponent m) ''''''
	
	
	/*
	 * genUIElement
	 */
	def dispatch genUIElement(UIField element) ''''''
	
	def dispatch genUIElement(UIDisplay element) ''''''
}