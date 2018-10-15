package com.softtek.generator.uiprototype

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.System
import com.softtek.rdl2.PageContainer

class IndexJsGenerator {

	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("prototipo/src/index.js", genIndexJs(resource, fsa))
	}
	
	def CharSequence genIndexJs(Resource resource, IFileSystemAccess2 access2) '''
		/*eslint no-mixed-spaces-and-tabs: ["error", "smart-tabs"]*/
		'use strict'
		
		if (module.hot) {
		  module.hot.accept()
		}
		
		import riot from 'riot'
		
		// Hoja de estilos
		import './styles/index.scss'
		
		// Applicación
		import './components/app/app.tag'
		
		// Componentes comunes
		import './components/common/layout/page.tag'
		import './components/common/layout/content.tag'
		import './components/common/layout/tablist.tag'
		import './components/common/layout/footer/footerbar.tag'
		import './components/common/layout/header/topbar.tag'
		import './components/common/layout/sidebar/menu-item.tag'
		import './components/common/layout/sidebar/menu-section.tag'
		import './components/common/layout/sidebar/side-menu.tag'
		import './components/common/layout/sidebar/sidebar-menu.tag'
		import './components/common/layout/sidebar/sidebar-profile.tag'
		import './components/common/layout/sidebar/sidebar.tag'
		import './components/common/form/formbox.tag'
		import './components/common/form/date-picker.tag'
		import './components/common/form/select-auto.tag'
		import './components/common/form/inputbox.tag'
		import './components/common/form/option-box.tag'
		import './components/common/form/search.tag'
		import './components/common/form/panel.tag'
		import './components/common/form/select-box.tag'
		import './components/common/form/attach-photo.tag'
		import './components/common/form/outputtext.tag'
		import './components/common/form/progress-bar.tag'
		import './components/common/form/note.tag'
		import './components/common/form/login.tag'
		import './components/common/form/pagination-bar.tag'
		import './components/common/form/actions.tag'
		import './components/common/form/action-group.tag'
		import './components/common/form/action-button.tag'
		import './components/common/grid/row.tag'
		import './components/common/grid/column.tag'
		
		// Patrones Funcionales
		import './components/patterns/crud/searchpanel.tag'
		import './components/patterns/crud/edit-button.tag'
		import './components/patterns/crud/delete-button.tag'
		import './components/patterns/crud/submit-button.tag'
		import './components/patterns/crud/table-results.tag'
		import './components/patterns/crud/simple-admin.tag'
		import './components/patterns/crud/select-list.tag'
		import './components/patterns/crud/modal-box.tag'
		import './components/patterns/wizard/form-wizard.tag'
		import './components/patterns/wizard/step-wizard.tag'
		
		import './components/app/app.tag'
		
		// Componentes generados
		«FOR System s : resource.allContents.toIterable.filter(typeof(System))»
			«FOR m : s.modules_ref»
				«FOR page : m.module_ref.elements.filter(typeof(PageContainer))»
					import './components/app/«m.module_ref.name.toLowerCase»/«page.name.toLowerCase».tag'
				«ENDFOR»
			«ENDFOR»
		«ENDFOR»
		
		const msgs = require('json-loader!./default-messages.json')
		var msgJSON = JSON.stringify(msgs)
		localStorage.setItem('messages', msgJSON)
		
		const config = require('json-loader!./config.json')
		var precision = '2' // 2 is the default value
		for (var k = 0; k < config.keys.length; k++) {
		  var ks = config.keys[k]
		  if (ks.key === 'precision') {
		    precision = ks.value
		    break
		  }
		}
		
		localStorage.setItem('precision', precision)
		
		const json = require('./tabledata.js')
		var filenames = []
		for (var j = 0; j < json.files.length; j++) {
		  filenames[j] = (json.files[j].path)
		  for (var c = 0; c < filenames[j].ids.length; c++) {
		    localStorage.setItem('rows_' + filenames[j].ids[c].id, JSON.stringify(filenames[j].ids[c].rows))
		    localStorage.setItem('header_' + filenames[j].ids[c].id, JSON.stringify(filenames[j].ids[c].headers))
		    if (filenames[j].ids[c].actions !== 'undefined') {
		      localStorage.setItem('actions_' + filenames[j].ids[c].id, JSON.stringify(filenames[j].ids[c].actions))
		    }
		  }
		}
		
		require('riot-routehandler')
		var routes = [
			{ route: '/login/', tag: 'login' },
			{ route: '/home/', tag: 'app' },
			«FOR System s : resource.allContents.toIterable.filter(typeof(System))»
				«FOR m : s.modules_ref»
					«FOR page : m.module_ref.elements.filter(typeof(PageContainer))»
						{ route: '/«m.module_ref.name.toLowerCase»/«page.name.toLowerCase»', tag: '«page.name.toLowerCase»' },
					«ENDFOR»
				«ENDFOR»
			«ENDFOR»
		]
		riot.mount('*', { routes: routes, options: { hashbang: true, params: { title: 'Login', username: 'Usuario', password: 'Contraseña', link: '//' } } })
	'''
}