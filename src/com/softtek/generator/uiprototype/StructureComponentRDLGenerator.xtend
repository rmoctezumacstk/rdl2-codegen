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
import com.softtek.rdl2.ListComponent

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
	   	      if (a instanceof PageContainer){
		       tempImportList.addAll(genImportElements(a,model,fsa))
		      }
	     }
	    }
	  }
	 return tempImportList
	}
	

	def genImportElements(PageContainer t, Model model, IFileSystemAccess2 fsa){
	    var importList = new ArrayList<String>()
	    var importStmt = 'import \'./components/app/'+ model.module.name.toLowerCase +'/'+t.name.toLowerCase+'.tag\''
	    importList.add(importStmt)
		return importList
	}
	
	
	def doGenRoutes(Resource resource, IFileSystemAccess2 fsa) {
	  var tempRouteList = new ArrayList<String>()
	  for ( m: resource.contents){
	   var model  = m as Model
	    if (model.module!==null){
	  	 for (AbstractElement a: model.module.elements){
	   	      if (a instanceof PageContainer){
		       tempRouteList.addAll(genRouteElements(a,model,fsa))
		      }
	     }
	    }
	  }
	 return tempRouteList
	}
	
	
	def genRouteElements(PageContainer t, Model model, IFileSystemAccess2 fsa){
		var admin  = '{ route: \'/'+ model.module.name.toLowerCase+'/'+t.name.toLowerCase+'\', tag: \''+t.name.toLowerCase+'\' }'
		var routeList = new ArrayList<String>()
	    routeList.add(admin)
		return routeList
	}
	
	
	def doGenMenu(Resource resource, IFileSystemAccess2 fsa) {
	  var tempMenuList = new ArrayList<String>()
	  for ( m: resource.contents){
	   var model  = m as Model
	    if (model.module!==null){
	     //var title   = '<h3>'+model.module.name.toFirstUpper+'</h3>'
	     //tempMenuList.add(title)
	  	 for (AbstractElement a: model.module.elements){
	   	      if (a instanceof PageContainer){
		       tempMenuList.addAll(genMenuElements(a,model,fsa))
		      }
	     }
	    }
	  }
	 return tempMenuList
	}
	
	def genMenuElements(PageContainer page, Model model, IFileSystemAccess2 fsa){
	  var menuList = new ArrayList<String>()
	
	  if ( page.landmark!==null && page.landmark.trim.equals("true")){
	    var label=page.page_title
		var ul      = '<ul class=\"nav side-menu\">'
		var li      = '<li><a><i class="fa fa-home"></i>'+ label +'<span class="fa fa-chevron-down"></span></a>'
		var liAdd   = '<li><a href=\"/'+model.module.name.toLowerCase+ '/' +page.name.toLowerCase+'\">'+label +'</a></li>'
		menuList.add(ul)
	    menuList.add(li)
	    menuList.add("<ul class=\"nav child_menu\">")
	    menuList.add(liAdd)
	    menuList.add("</ul>")
	    menuList.add("</li>")
	    menuList.add("</ul>")
	  }
	  return menuList
	}
	
	
	def genTableDataElements(Entity t, Model model, IFileSystemAccess2 fsa){
		var dataList = new ArrayList<String>()
		var data= '{ path: require(\'json-loader!./tabledata/'+ model.module.name.toLowerCase +'/modal'+ t.name.toLowerCase +'.json\') }'
	    dataList.add(data)
		return dataList
	}
	
	
    def doGenInnerTableData(Resource resource, IFileSystemAccess2 fsa) {
	  var tempTableList = new ArrayList<String>()
	  for ( m: resource.contents){
	   var model  = m as Model
	    if (model.module!==null){
	  	 for (AbstractElement p: model.module.elements){
	   	      if (p instanceof PageContainer){
	   	       for (list : p.components.filter(typeof(ListComponent))) {
					var data= '{ path: require(\'json-loader!./tabledata/'+ model.module.name.toLowerCase +'/'+ list.name.toLowerCase +'.json\') }'
	                tempTableList.add(data)
				}
		      }
	     }
	    }
	  }
	 return tempTableList
	}
	

	def dispatch genApiIndex(ArrayList<String> importElementList, ArrayList<String> routeElementList, IFileSystemAccess2 fsa) '''
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
	  «FOR String r: routeElementList SEPARATOR ','»
	  	  «r»
	  «ENDFOR»
	]
	riot.mount('*', { routes: routes, options: { hashbang: true, params: { title: 'Login', username: 'Usuario', password: 'Contraseña', link: '//' } } })
		
	'''
	
	def dispatch genApiApp(ArrayList<String> menuElementList) '''
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
									«FOR String m: menuElementList»
											«m»
									«ENDFOR»
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
	
	def dispatch genApiTableData(ArrayList<String> tableDataList) '''
		module.exports = {files: [
		 «FOR String t: tableDataList SEPARATOR ','»
		  «t»
		 «ENDFOR»
		]}
	'''
		
	
	def static toLowerCase(String it){
	  toLowerCase
	}
	
}