package com.softtek.generator.clarity.screen.admin

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer

class ScreenHtmlGenerator {

	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				if (p.screen_type === null) {
					fsa.generateFile("clarity/src/app/admin/"+ m.name.toLowerCase + "/" + m.name.toLowerCase +".psg.html", p.generateHtmlScreen(m))
				}
			}
		}
	}
	
	def CharSequence generateHtmlScreen(PageContainer container, Module module) '''
	<!-- PSG  «module.name.toFirstUpper» Html -->
	<router-outlet></router-outlet>
	'''
	
}