package com.softtek.generator.uiprototype

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.System
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.ListComponent
import com.softtek.rdl2.InlineFormComponent

class TableDataJsGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("prototipo/src/tabledata.js", genTableDataJs(resource, fsa))
	}
	
	def CharSequence genTableDataJs(Resource resource, IFileSystemAccess2 access2) '''
		module.exports = {files: [
			«FOR System s : resource.allContents.toIterable.filter(typeof(System))»
				«FOR m : s.modules_ref»
					«FOR page : m.module_ref.elements.filter(typeof(PageContainer))»
						«FOR list : page.components.filter(typeof(ListComponent))»
							{ path: require('json-loader!./tabledata/«m.module_ref.name.toLowerCase»/«list.name.toLowerCase».json') },
						«ENDFOR»
						«FOR inlineform : page.components.filter(typeof(InlineFormComponent))»
							{ path: require('json-loader!./tabledata/«m.module_ref.name.toLowerCase»/«inlineform.name.toLowerCase».json') },
						«ENDFOR»
					«ENDFOR»
				«ENDFOR»
			«ENDFOR»
		]}
	'''
}