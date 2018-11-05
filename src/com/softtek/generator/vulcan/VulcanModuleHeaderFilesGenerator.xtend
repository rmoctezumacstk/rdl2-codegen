package com.softtek.generator.vulcan

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.System
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.FormComponent
import com.softtek.rdl2.InlineFormComponent
import com.softtek.rdl2.ListComponent
import com.softtek.rdl2.DetailComponent
import com.softtek.rdl2.MessageComponent
import com.softtek.rdl2.RowComponent
import com.softtek.rdl2.ModuleRef
import com.softtek.rdl2.Entity

class VulcanModuleHeaderFilesGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("vulcan/lib/modules/components.js", genComponentsJs(resource, fsa))
		fsa.generateFile("vulcan/lib/modules/index.js", genIndexJs(resource, fsa))
		fsa.generateFile("vulcan/lib/modules/routes.js", genRoutesJs(resource, fsa))
	}
	
	def CharSequence genComponentsJs(Resource resource, IFileSystemAccess2 fsa) '''
		import "../components/common/Header";
		import "../components/common/Layout";
		import "../components/common/SideNavigation";
		import "../components/common/Login";
		
		«FOR System s : resource.allContents.toIterable.filter(typeof(System))»
			«FOR m : s.modules_ref»
				«FOR page : m.module_ref.elements.filter(typeof(PageContainer))»
					«IF page.screen_type === null»
						import "../components/«m.module_ref.name.toLowerCase»/«page.name.toLowerCase»/«page.name»";
						«FOR c : page.components»
							«c.genUIComponentComponentJs(page, m)»
						«ENDFOR»
					«ENDIF»
				«ENDFOR»
			«ENDFOR»
		«ENDFOR»
	'''

	def CharSequence genIndexJs(Resource resource, IFileSystemAccess2 fsa) '''
		import "./routes";
		import "./components";
		«FOR System s : resource.allContents.toIterable.filter(typeof(System))»
			«FOR m : s.modules_ref»
				«FOR entity : m.module_ref.elements.filter(typeof(Entity))»
					import "./«entity.name.toLowerCase»/collection.js";
				«ENDFOR»
			«ENDFOR»
		«ENDFOR»
	'''
	
	def CharSequence genRoutesJs(Resource resource, IFileSystemAccess2 fsa) '''
		import { addRoute } from "meteor/vulcan:core";

		addRoute({
		  name: "login",
		  path: "/login",
		  componentName: "Login"
		});

		«resource.genHomeRoute»

		«FOR System s : resource.allContents.toIterable.filter(typeof(System))»
			«FOR m : s.modules_ref»
				«FOR page : m.module_ref.elements.filter(typeof(PageContainer))»
					«IF page.screen_type === null»
						addRoute({
						  name: "«page.name.toLowerCase»",
						  path: "/«page.name.toLowerCase»",
						  componentName: "«page.name»"
						});
						
					«ENDIF»
				«ENDFOR»
			«ENDFOR»
		«ENDFOR»
	'''
	
	def CharSequence genHomeRoute(Resource resource) '''
		«FOR System s : resource.allContents.toIterable.filter(typeof(System))»
			«FOR m : s.modules_ref»
				«FOR page : m.module_ref.elements.filter(typeof(PageContainer))»
					«IF page.home!==null && page.home.trim.equals("true")»
						addRoute({
						  name: "home",
						  path: "/",
						  componentName: "«page.name»"
						});
					«ENDIF»
				«ENDFOR»
			«ENDFOR»
		«ENDFOR»
	'''
	
	/*
	 * UIComponent
	 */
	def dispatch genUIComponentComponentJs(FormComponent c, PageContainer p, ModuleRef m) '''
		import "../components/«m.module_ref.name.toLowerCase»/«p.name.toLowerCase»/«c.name»";
	'''
	def dispatch genUIComponentComponentJs(InlineFormComponent c, PageContainer p, ModuleRef m) '''
		import "../components/«m.module_ref.name.toLowerCase»»/«p.name.toLowerCase»/«c.name»";
	'''
	def dispatch genUIComponentComponentJs(ListComponent c, PageContainer p, ModuleRef m) '''
		import "../components/«m.module_ref.name.toLowerCase»/«p.name.toLowerCase»/«c.name»";
	'''
	def dispatch genUIComponentComponentJs(DetailComponent c, PageContainer p, ModuleRef m) '''
		import "../components/«m.module_ref.name.toLowerCase»/«p.name.toLowerCase»/«c.name»";
	'''
	def dispatch genUIComponentComponentJs(MessageComponent c, PageContainer p, ModuleRef m) ''''''
	def dispatch genUIComponentComponentJs(RowComponent c, PageContainer p, ModuleRef m) ''''''	
}