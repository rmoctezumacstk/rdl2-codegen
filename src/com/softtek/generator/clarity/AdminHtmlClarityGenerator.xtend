package com.softtek.generator.clarity

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.System
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.ModuleRef

class AdminHtmlClarityGenerator {

	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("clarity/src/app/admin/admin.component.html", genAppTag(resource, fsa))
	}
	
	def CharSequence genAppTag(Resource resource, IFileSystemAccess2 access2) '''
	<!-- PSG Main Html -->
	<clr-main-container>
	  <clr-header class="header-6">
	      <div class="branding">
	          <a href="#" class="nav-link">
	              <img src="../../assets/logo.png" width="30px">
	              <span class="title">   APPICATION DEVELOPMENT </span>
	          </a>
	      </div>
	      <div class="header-actions">
	          <clr-dropdown>
	              <button class="nav-text" clrDropdownTrigger>
	                  <div>{{valueName}}
	                  <clr-icon shape="cog"></clr-icon>
	                  <clr-icon shape="caret down"></clr-icon>
	                  </div>
	              </button>
	              <clr-dropdown-menu clrPosition="bottom-right" *clrIfOpen>
	                  <a href="javascript://" clrDropdownItem>Acerca</a>
	                  <a href="javascript://" clrDropdownItem>Configuración</a>
	                  <a [routerLink]="['/login']" clrDropdownItem>Salir</a>
	              </clr-dropdown-menu>
	          </clr-dropdown>
	      </div>
	  </clr-header>
	  <div class="content-container">
	    <main class="content-area">
	      <div class="card">
	      <router-outlet></router-outlet>
	      </div>
	    </main>
	    <nav class="sidenav" [clr-nav-level]="2">
	        <section class="sidenav-content">
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
	            
	              
	                
						<li *ngIf="direccion_read">
						    <a routerLink="./direccion" routerLinkActive="active">
						        <clr-icon shape="application"></clr-icon>
						        Direccion
						    </a> 
						</li>
						<li *ngIf="afiliado_read">
						    <a routerLink="./afiliado" routerLinkActive="active">
						        <clr-icon shape="application"></clr-icon>
						        Afiliado
						    </a> 
						</li>
						<li *ngIf="tipopension_read">
						    <a routerLink="./tipopension" routerLinkActive="active">
						        <clr-icon shape="application"></clr-icon>
						        Tipopension
						    </a> 
						</li>
						<li *ngIf="solicitudpension_read">
						    <a routerLink="./solicitudpension" routerLinkActive="active">
						        <clr-icon shape="application"></clr-icon>
						        Solicitudpension
						    </a> 
						</li>
						<li *ngIf="beneficiario_read">
						    <a routerLink="./beneficiario" routerLinkActive="active">
						        <clr-icon shape="application"></clr-icon>
						        Beneficiario
						    </a> 
						</li>
	                </ul>
	            </section>
	        </section>
	    </nav>
	  </div>
	</clr-main-container>
	<!-- ./PSG Main Html -->
	
	
		
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