package com.softtek.generator.banorte.angular

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer

class BanorteGeneratorAngularCss {
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				if (p.screen_type === null) {
					fsa.generateFile("banorte/" + p.name.toLowerCase + "/" + p.name.toLowerCase + ".component.css", p.generateCss(m))
				}
			}
		}
	}
	
	def CharSequence generateCss(PageContainer container, Module module) '''
	'''
	
}