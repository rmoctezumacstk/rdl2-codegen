package com.softtek.generator.uiprototype

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Model
import com.softtek.rdl2.Entity
import com.softtek.rdl2.AbstractElement
import com.softtek.rdl2.Enum
import com.softtek.rdl2.ActionAdd
import com.softtek.rdl2.ActionEdit
import com.softtek.rdl2.ActionDelete
import com.softtek.rdl2.ActionSearch
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.Task
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import java.util.ArrayList
import java.util.HashSet

class StructureComponentRDLGenerator {
	var TRUE = "true";
	var SEARCH_SIMPLE = "Simple";
	var SEARCH_COMPLEX = "Complex";
	var SEARCH_NONE = "None";
	
	def doGeneratorStructure(Resource resource, IFileSystemAccess2 fsa) {
		
		//var model  = resource.contents.head as Model
        //println(elementList)
		/* Create structure */
		//fsa.generateFile('''prototipo/src/index.js''', genApiIndex(resource.contents,fsa))
		//fsa.generateFile('''prototipo/src/tabledata.js''', genApiTableData(model))
		//fsa.generateFile('''prototipo/src/components/app/app.tag''', genApiApp(model))
		
	}
	
	def doGenImports(Resource resource, IFileSystemAccess2 fsa) {
	  var tempImportList = new ArrayList<String>()
	  for ( m: resource.contents){
	   var model  = m as Model
	    if (model.module!==null){
	  	 for (AbstractElement a: model.module.elements){
	   	      if (a instanceof Entity){
		       tempImportList.addAll(genImportElements(a,model,fsa))
		      }
	     }
	    }
	  }
	 return tempImportList
	}
	

	def genImportElements(Entity t, Model model, IFileSystemAccess2 fsa){
	    var importList = new ArrayList<String>()
	    var importStmt = 'import \'./components/app/'+t.name.toLowerCase+'/'+t.name.toLowerCase
	    importList.add(importStmt+'-admin.tag\'')
		
		if (t.actions !== null && !t.actions.action.filter(ActionSearch).isNullOrEmpty && (SEARCH_SIMPLE.equals(t.actions.action.filter(ActionSearch).get(0).value) || SEARCH_COMPLEX.equals(t.actions.action.filter(ActionSearch).get(0).value)))
		importList.add(importStmt+'-form.tag\'')
		
		if (t.actions !== null && (!t.actions.action.filter(ActionAdd).isNullOrEmpty && TRUE.equals(t.actions.action.filter(ActionAdd).get(0).value)))		
		importList.add(importStmt+'-add.tag\'')
			
		if (t.actions !== null && (!t.actions.action.filter(ActionEdit).isNullOrEmpty && TRUE.equals(t.actions.action.filter(ActionEdit).get(0).value)))
		importList.add(importStmt+'-edit.tag\'')
		
		if (t.actions !== null && (!t.actions.action.filter(ActionDelete).isNullOrEmpty && TRUE.equals(t.actions.action.filter(ActionDelete).get(0).value)))
		importList.add(importStmt+'-delete.tag\'')
		
		return importList
	}
	
	
	def genImportElements(Enum t, Model model, IFileSystemAccess2 fsa){	
	}
	
	def genImportElements(PageContainer t, Model model, IFileSystemAccess2 fsa) {
	}
	
	def genImportElements(Task t, Model model, IFileSystemAccess2 fsa) {
	}
	
	def createAbstractElementRoutes(EList<EObject> contents,IFileSystemAccess2 fsa) {
	 var routes=""
	 for ( m: contents){
	  var model  = m as Model
	  if (model.module!==null)
	   for (AbstractElement a: model.module.elements){
		  routes = routes + genAbstractElementRoutes(model, fsa)
	   }
	  }
	 return routes
	}
	
	
	
	def dispatch genApiIndex(ArrayList<String> importElementList, IFileSystemAccess2 fsa) '''
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
	
	// Componentes generados
	«FOR String a: importElementList»
	  «a»
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
	
	]
	riot.mount('*', { routes: routes, options: { hashbang: true, params: { title: 'Login', username: 'Usuario', password: 'Contraseña', link: '//' } } })
		
	'''
	//«createAbstractElementRoutes(contents, fsa)»
	def dispatch genAbstractElementRoutes(Model model, IFileSystemAccess2 fsa) {
		
		var routes = '';
		
		for (AbstractElement a: model.module.elements){
			routes = routes + a.genAbstractElementRouteAdmin(model,fsa);
		}
		for (AbstractElement a: model.module.elements){
			routes = routes + a.genAbstractElementRouteAdd(model,fsa);
		}
		for (AbstractElement a: model.module.elements){
			routes = routes + a.genAbstractElementRouteEdit(model,fsa);
		}
		for (AbstractElement a: model.module.elements){
			routes = routes + a.genAbstractElementRouteDelete(model,fsa);
		}
		
		routes = routes.substring(0, routes.length-1);
		
		//routes = routes //+ ''']
		// riot.mount('*', { routes: routes, options: { hashbang: true, params: { title: 'Login', username: 'Usuario', password: 'Contraseña', link: '//' } } })'''
	}
	
	
	
	def dispatch genAbstractElement(Entity t, Model model, IFileSystemAccess2 fsa) '''
		import './components/app/«t.name.toLowerCase»/«t.name.toLowerCase»-admin.tag'
		
		«IF t.actions !== null && !t.actions.action.filter(ActionSearch).isNullOrEmpty && (SEARCH_SIMPLE.equals(t.actions.action.filter(ActionSearch).get(0).value) || SEARCH_COMPLEX.equals(t.actions.action.filter(ActionSearch).get(0).value))»
		import './components/app/«t.name.toLowerCase»/«t.name.toLowerCase»-form.tag'
		«ENDIF»
		
		«IF t.actions !== null && (!t.actions.action.filter(ActionAdd).isNullOrEmpty && TRUE.equals(t.actions.action.filter(ActionAdd).get(0).value))»		
		import './components/app/«t.name.toLowerCase»/«t.name.toLowerCase»-add.tag'
		«ENDIF»
			
		«IF t.actions !== null && (!t.actions.action.filter(ActionEdit).isNullOrEmpty && TRUE.equals(t.actions.action.filter(ActionEdit).get(0).value))»
		import './components/app/«t.name.toLowerCase»/«t.name.toLowerCase»-edit.tag'
		«ENDIF»
		
		«IF t.actions !== null && (!t.actions.action.filter(ActionDelete).isNullOrEmpty && TRUE.equals(t.actions.action.filter(ActionDelete).get(0).value))»
		import './components/app/«t.name.toLowerCase»/«t.name.toLowerCase»-delete.tag'
		«ENDIF»
	'''
	
	def dispatch genAbstractElement(Enum t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElement(PageContainer t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElement(Task t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElementRouteAdmin(Enum t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElementRouteAdmin(PageContainer t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElementRouteAdmin(Task t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElementRouteAdmin(Entity t, Model model, IFileSystemAccess2 fsa) {
		var admin = '''{ route: '/«t.name.toLowerCase»-admin/', tag: '«t.name.toLowerCase»-admin' },
		'''
		return admin;
	}
	
	def dispatch genAbstractElementRouteAdd(Enum t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElementRouteAdd(PageContainer t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElementRouteAdd(Task t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElementRouteAdd(Entity t, Model model, IFileSystemAccess2 fsa) {
		var add = '''{ route: '/«t.name.toLowerCase»-add/', tag: '«t.name.toLowerCase»-add' },
		'''
		return add;
	}
	
	def dispatch genAbstractElementRouteEdit(Enum t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElementRouteEdit(PageContainer t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElementRouteEdit(Task t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElementRouteEdit(Entity t, Model model, IFileSystemAccess2 fsa) {
		var edit = '''{ route: '/«t.name.toLowerCase»-edit/', tag: '«t.name.toLowerCase»-edit' },
		'''
		return edit;
	}
	
	def dispatch genAbstractElementRouteDelete(Enum t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElementRouteDelete(PageContainer t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genAbstractElementRouteDelete(Task t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	
	def dispatch genAbstractElementRouteDelete(Entity t, Model model, IFileSystemAccess2 fsa) {
		var delete = '''{ route: '/«t.name.toLowerCase»-delete/', tag: '«t.name.toLowerCase»-delete' },
		'''
		return delete;	
	}
	
	def dispatch genAbstractElementRoute(Enum t, Model model, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genApiApp(Model model) '''
			<app>
			<style>
			a {color:#C4CFDA;}
			.nav>li>a:focus, .nav>li>a:hover {
			    background-color: #2A3F54;
					color: #fff;
			}
			.nav.child_menu li:hover, .nav.child_menu li.active {
			    background-color: #2A3F54;
			}
			</style>
			
				<div class="main_container">
					<div class="col-md-3 left_col">
						<div class="left_col scroll-view">
							<div class="navbar nav_title" style="border: 0;">
								<a href="index.html" class="site_title"><i class="fa fa-diamond"></i> <span>Prototipo IU</span></a>
							</div>
							<div class="clearfix"></div>
							<!-- menu profile quick info -->
							<div class="profile clearfix">
								<div class="profile_pic">
									<img src="https://x1.xingassets.com/assets/frontend_minified/img/users/nobody_m.original.jpg" alt="..." class="img-circle profile_img">
								</div>
								<div class="profile_info">
									<span>Welcome,</span>
									<h2>Juan Pérez González</h2>
								</div>
							</div>
							<!-- /menu profile quick info -->
				
							<br />
				
							<!-- sidebar menu -->
							<div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
								<div class="menu_section">
								    «IF model.module!==null»
									<h3>«model.module.name.toFirstUpper»</h3>
									<ul class="nav side-menu">
									    
								        «FOR AbstractElement a: model.module.elements»
											«a.genAbstractElementMenuSection(model)»
										«ENDFOR»
									</ul>
									«ENDIF»
								</div>
							</div>
						<!-- /sidebar menu -->
				        
						<!-- /menu footer buttons -->
						<div class="sidebar-footer hidden-small">
							<a data-toggle="tooltip" data-placement="top" title="Settings">
								<span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
							</a>
							<a data-toggle="tooltip" data-placement="top" title="FullScreen">
								<span class="glyphicon glyphicon-fullscreen" aria-hidden="true"></span>
							</a>
							<a data-toggle="tooltip" data-placement="top" title="Lock">
								<span class="glyphicon glyphicon-eye-close" aria-hidden="true"></span>
							</a>
							<a data-toggle="tooltip" data-placement="top" title="Logout" href="login.html">
								<span class="glyphicon glyphicon-off" aria-hidden="true"></span>
							</a>
						</div>
						<!-- /menu footer buttons -->
					</div>
				</div>
			        
				<!-- top navigation -->
				<div class="top_nav">
					<div class="nav_menu">
						<nav>
							<div class="nav toggle">
								<a id="menu_toggle"><i class="fa fa-bars"></i></a>
							</div>
							<ul class="nav navbar-nav navbar-right">
								<li >
								<a href="javascript:;" class="user-profile" style="background-color: #EDEDED;" >		
									<img class="user-profile" src="https://x1.xingassets.com/assets/frontend_minified/img/users/nobody_m.original.jpg" alt="">Juan Pérez
									<span class=" fa fa-angle-down"></span>
								</a>					
								</li>
								<li role="presentation" class="dropdown" >
									<a href="javascript:;" class="dropdown-toggle info-number" data-toggle="dropdown" aria-expanded="false" style="background-color: #EDEDED;">
										<i class="fa fa-envelope-o"></i>
										<span class="badge bg-green">6</span>
									</a>
								</li>
							</ul>
						</nav>
					</div>
				</div>
				<!-- /top navigation -->
				</div>
			</app>
	'''
	
	def dispatch genAbstractElementMenuSection(Enum t, Model model) '''
	'''
	
	def dispatch genAbstractElementMenuSection(PageContainer t, Model model) '''
	'''
	
	def dispatch genAbstractElementMenuSection(Task t, Model model) '''
	'''
	
	def dispatch genAbstractElementMenuSection(Entity t, Model model) '''

			<li><a><i class="fa fa-home"></i> «IF t.glossary !== null && t.glossary.glossary_name !== null && !t.glossary.glossary_name.label.isNullOrEmpty»«t.glossary.glossary_name.label»«ELSE»«t.name.toFirstUpper»«ENDIF» <span class="fa fa-chevron-down"></span></a>
				<ul class="nav child_menu">
					<li><a href="/«t.name.toLowerCase»-admin">Mantenimiento de «IF t.glossary !== null && t.glossary.glossary_name !== null && !t.glossary.glossary_name.label.isNullOrEmpty»«t.glossary.glossary_name.label»«ELSE»«t.name.toFirstUpper»«ENDIF»s</a></li>
					<li><a href="/«t.name.toLowerCase»-add">Alta de «IF t.glossary !== null && t.glossary.glossary_name !== null && !t.glossary.glossary_name.label.isNullOrEmpty»«t.glossary.glossary_name.label»«ELSE»«t.name.toFirstUpper»«ENDIF»</a></li>
				</ul>
			</li>

	'''	 
	 
	def dispatch genApiTableData(Model model) {
		var s = '';
		var result = '';
		
		if (model.module!==null) {
		  for (AbstractElement a : model.module.elements){
		 	s = s + a.genAbstractElementTableData(model)	
		  }
		
		  s = s.substring(0, s.length-2)
		}
		result = 'module.exports = {files: [' + s + ']}';
		return result
	}
		
	
	def dispatch genAbstractElementTableData(Enum t, Model model) ''''''
	
	def dispatch genAbstractElementTableData(PageContainer t, Model model) ''''''
	
	def dispatch genAbstractElementTableData(Task t, Model model) ''''''
	
	def dispatch genAbstractElementTableData(Entity t, Model model) '''
		{ path: require('json-loader!./tabledata/modal«t.name.toLowerCase».json') },
	'''
	def static toLowerCase(String it){
	  toLowerCase
	}
	
}