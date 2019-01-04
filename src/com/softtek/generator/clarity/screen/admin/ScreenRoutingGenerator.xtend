package com.softtek.generator.clarity.screen.admin

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer

class ScreenRoutingGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				if (p.screen_type === null) {
					fsa.generateFile("clarity/src/app/admin/"+ m.name.toLowerCase + "/" + m.name.toLowerCase +".psg.routing.ts", p.generateRoutingScreen(m))
				}
			}
		}
	}
	
	def CharSequence generateRoutingScreen(PageContainer container, Module module) '''
	/* PSG  «module.name.toFirstUpper» Routing */
	import { ModuleWithProviders } from '@angular/core';
	import { RouterModule, Routes } from '@angular/router';	
	import { «module.name.toLowerCase.toFirstUpper»Demo } from './«module.name.toLowerCase».psg';  	
	«FOR p : module.elements.filter(typeof(PageContainer))»
	import { «p.name.toFirstUpper» } from './«p.name.toLowerCase»/«p.name.toLowerCase».psg';
	«ENDFOR»
	  	
	const ROUTES: Routes = [
	  {
	    path: '',
	    component: «module.name.toLowerCase.toFirstUpper»Demo,
	    children: [
		«FOR page : module.elements.filter(typeof(PageContainer))»
			«IF page.landmark!==null && page.landmark.trim.equals("true")»
			{ path: '', redirectTo: '«page.name.toLowerCase»', component: «module.name.toLowerCase.toFirstUpper»Demo },
			«ENDIF»
		«ENDFOR»
  		«FOR p : module.elements.filter(typeof(PageContainer))»
  	    {
  	    	path: '«p.name.toLowerCase»',
  			component: «p.name.toLowerCase.toFirstUpper»,
  		},
  		«ENDFOR»	
	    ],
	  },
	];
	  	

	export const ROUTING: ModuleWithProviders = RouterModule.forChild(ROUTES);
	'''


}