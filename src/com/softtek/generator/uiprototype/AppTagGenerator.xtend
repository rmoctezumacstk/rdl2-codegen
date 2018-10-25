package com.softtek.generator.uiprototype

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.System
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.ModuleRef

class AppTagGenerator {

	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("prototipo/src/components/app/app.tag", genAppTag(resource, fsa))
	}
	
	def CharSequence genAppTag(Resource resource, IFileSystemAccess2 access2) '''
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
							«FOR System s : resource.allContents.toIterable.filter(typeof(System))»
								<div class="menu_section">
									<h3>«s.name»</h3>
									<ul class="nav side-menu">
										«FOR m : s.modules_ref»
											«IF m.countPageLanmarks > 0»
												<li>
													<a><i class="fa fa-home"></i>«m.module_ref.description»<span class="fa fa-chevron-down"></span></a>
													<ul class="nav child_menu">
														«FOR page : m.module_ref.elements.filter(typeof(PageContainer))»
															«IF page.landmark!==null && page.landmark.trim.equals("true")»
																<li>
																	<a href="/«m.module_ref.name.toLowerCase»/«page.name.toLowerCase»/">«page.page_title»</a>
																</li>
															«ENDIF»
														«ENDFOR»
													</ul>
												</li>
											«ENDIF»
										«ENDFOR»
									</ul>
								</div>
							«ENDFOR»
						</div>
					<!-- /sidebar menu -->
					<!-- /menu footer buttons -->
					<div class="sidebar-footer hidden-small">
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
	
	def int countPageLanmarks(ModuleRef m) {
		var count = 0
		
		for (page : m.module_ref.elements.filter(typeof(PageContainer))) {
			if (page.landmark!==null && page.landmark.trim.equals("true")) {
				count++
			}
		}
		
		return count
	}
	
}