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
<div class="main-container nav-group-links">
    <header class="header header-6">
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
    </header>
    <div class="content-container">
        <div class="content-area">
            <div class="card">
                <router-outlet></router-outlet>
            </div>
        </div>
        <clr-vertical-nav [clrVerticalNavCollapsible]="true" [(clrVerticalNavCollapsed)]="collapse">
            <ng-container>

				<div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
					«FOR System s : resource.allContents.toIterable.filter(typeof(System))»
		                <div style="margin-left: 1rem">
		                <h5>«s.name»</h5>
		                </div>
						<clr-vertical-nav-group>
							«FOR m : s.modules_ref»
								«IF m.countPageLanmarks > 0»
				                    <a href="javascript://" clrVerticalNavLink>
				                        <clr-icon shape="list" clrVerticalNavIcon></clr-icon>
				                        «m.module_ref.description»
				                    </a>
									<clr-vertical-nav-group-children *clrIfExpanded>
										«FOR page : m.module_ref.elements.filter(typeof(PageContainer))»
											«IF page.landmark!==null && page.landmark.trim.equals("true")»
						                        <div>
						                            <a clrVerticalNavLink routerLink="./«page.name.toLowerCase»" routerLinkActive="active">
						                                <clr-icon shape="application"></clr-icon>
						                                «page.page_title»
						                            </a>
						                        </div>
											«ENDIF»
										«ENDFOR»
									</clr-vertical-nav-group-children>
								«ENDIF»
							«ENDFOR»
						</clr-vertical-nav-group>
					«ENDFOR»
				</div>
			
            </ng-container>          
        </clr-vertical-nav>        
    </div>
</div> 
<!-- ./PSG Main Html -->
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