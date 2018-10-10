package com.softtek.generator.uiprototype

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Model
import com.softtek.rdl2.Entity
import com.softtek.rdl2.AbstractElement
import com.softtek.rdl2.Enum
import com.softtek.rdl2.ActionEdit
import com.softtek.rdl2.ActionDelete
import com.softtek.rdl2.ActionSearch
import com.softtek.rdl2.ActionAdd
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.Task

class AdminComponentRDLGenerator {
	var TRUE = "true";
	var SEARCH_SIMPLE = "Simple";
	var SEARCH_COMPLEX = "Complex";
	var SEARCH_NONE = "None";
	
	def doGeneratorAdmin(Resource resource, IFileSystemAccess2 fsa) {
	var model  = resource.contents.head as Model
	    if (model.module!==null)
		for (AbstractElement a : model.module.elements){
			a.genAbstractElement(model,fsa)
		}
	}
	
	def dispatch genAbstractElement(Entity t, Model model, IFileSystemAccess2 fsa) '''
	«fsa.generateFile('''prototipo/src/components/app/«t.name.toLowerCase»/«t.name.toLowerCase»-admin.tag''', t.genApiAdmin(model).gen(model))»
	'''
	
	def dispatch genAbstractElement(Enum t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElement(PageContainer t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElement(Task t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	/* Create the admin page */
	def dispatch genApiAdmin(Entity t, Model model) 
	'''
		<«t.name.toLowerCase»-admin>
			«IF t.glossary !== null && t.glossary.glossary_name !== null && !t.glossary.glossary_name.label.isNullOrEmpty»
			<page id="«t.name.toLowerCase»-admin" title="Administrar «t.glossary.glossary_name.label.toFirstUpper»">
			«ELSE»
			<page id="«t.name.toLowerCase»-admin" title="Administrar «t.name.toFirstUpper»">
			«ENDIF»		
				<searchpanel add="«t.name.toLowerCase»-add">
					«IF t.actions !== null && !t.actions.action.filter(ActionSearch).isNullOrEmpty && (SEARCH_SIMPLE.equals(t.actions.action.filter(ActionSearch).get(0).value) || SEARCH_COMPLEX.equals(t.actions.action.filter(ActionSearch).get(0).value)) && t.actions.action.filter(ActionAdd).isNullOrEmpty»
					<searchcriteria viewsearch="true" typesearch="«t.actions.action.filter(ActionSearch).get(0).value»" viewadd="false">
					«ELSEIF t.actions !== null && !t.actions.action.filter(ActionSearch).isNullOrEmpty && (SEARCH_SIMPLE.equals(t.actions.action.filter(ActionSearch).get(0).value) || SEARCH_COMPLEX.equals(t.actions.action.filter(ActionSearch).get(0).value)) && !t.actions.action.filter(ActionAdd).isNullOrEmpty»
					<searchcriteria viewsearch="true" typesearch="«t.actions.action.filter(ActionSearch).get(0).value»" viewadd="«t.actions.action.filter(ActionAdd).get(0).value»">
					«ELSEIF  t.actions !== null && !t.actions.action.filter(ActionSearch).isNullOrEmpty && SEARCH_NONE.equals(t.actions.action.filter(ActionSearch).get(0).value) && t.actions.action.filter(ActionAdd).isNullOrEmpty»
					<searchcriteria viewsearch="false" viewadd="false">
					«ELSEIF  t.actions !== null && !t.actions.action.filter(ActionSearch).isNullOrEmpty && SEARCH_NONE.equals(t.actions.action.filter(ActionSearch).get(0).value) && !t.actions.action.filter(ActionAdd).isNullOrEmpty»
					<searchcriteria viewsearch="false" viewadd="«t.actions.action.filter(ActionAdd).get(0).value»">
					«ELSEIF  t.actions !== null && t.actions.action.filter(ActionSearch).isNullOrEmpty && !t.actions.action.filter(ActionAdd).isNullOrEmpty»
					<searchcriteria viewsearch="false" viewadd="«t.actions.action.filter(ActionAdd).get(0).value»">
					«ELSE»
					<searchcriteria viewsearch="false" viewadd="false">
					«ENDIF»
						<«t.name.toLowerCase»-form />
					</searchcriteria>

					«IF t.actions !== null && (!t.actions.action.filter(ActionEdit).isNullOrEmpty && "true".equals(t.actions.action.filter(ActionEdit).get(0).value)) && (!t.actions.action.filter(ActionDelete).isNullOrEmpty && "true".equals(t.actions.action.filter(ActionDelete).get(0).value))»
					<searchresults id="«t.name.toLowerCase»-results" edit="«t.name.toLowerCase»-edit" delete="«t.name.toLowerCase»-delete" pagination="true">
					«ELSEIF t.actions !== null && (!t.actions.action.filter(ActionEdit).isNullOrEmpty && "true".equals(t.actions.action.filter(ActionEdit).get(0).value))»
					<searchresults id="«t.name.toLowerCase»-results" edit="«t.name.toLowerCase»-edit" pagination="true">
					«ELSEIF t.actions !== null && (!t.actions.action.filter(ActionDelete).isNullOrEmpty && "true".equals(t.actions.action.filter(ActionDelete).get(0).value))»
					<searchresults id="«t.name.toLowerCase»-results" delete="«t.name.toLowerCase»-delete" pagination="true">
					«ELSE»
					<searchresults id="«t.name.toLowerCase»-results" pagination="true">
					«ENDIF»
					</searchresults>
				</searchpanel>
			</page>
		</«t.name.toLowerCase»-admin>
	'''
	
	def dispatch genApiAdmin(Enum t, Model model) '''
	'''
	
	def dispatch genApiAdmin(PageContainer t, Model model) '''
	'''
	
	def dispatch genApiAdmin(Task t, Model model) '''
	'''
	
	def gen(CharSequence body, Model model) '''
		«body»
	'''
	
	def static toUpperCase(String it){
	  toUpperCase
	}
	
	def static toLowerCase(String it){
	  toLowerCase
	}
}