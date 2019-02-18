package com.softtek.generator.clarity

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.System
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.ModuleRef
import com.softtek.rdl2.Module

class AdminHtmlClarityGenerator {

	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		
		fsa.generateFile("clarity/src/app/admin/admin.component.html", genAdminTag(resource, fsa))
	}
	
	def CharSequence genAdminTag(Resource resource, IFileSystemAccess2 access2) '''
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
            
                            
            
            «FOR Module m : resource.allContents.toIterable.filter(typeof(Module))»
            
            <clr-vertical-nav-group>
                <a href="javascript://" clrVerticalNavLink>
                    <clr-icon shape="lock" clrVerticalNavIcon></clr-icon>
                    «m.name»
                </a>
             <clr-vertical-nav-group-children *clrIfExpanded>
		
				«FOR page : m.elements.filter(typeof(PageContainer))»
					«IF page.landmark!==null && page.landmark.trim.equals("true")»
                        <div>
                            <a clrVerticalNavLink routerLink="./«m.name.toLowerCase»" routerLinkActive="active">
                                <clr-icon shape="directory"></clr-icon>
                                «page.page_title»
                            </a>
                        </div>
					«ENDIF»
				«ENDFOR»
				
            «ENDFOR»
                   
            </clr-vertical-nav-group-children>
            </clr-vertical-nav-group>       
                       
            </ng-container>
            <ng-container>
                <clr-vertical-nav-group>
                    <a href="javascript://" clrVerticalNavLink>
                        <clr-icon shape="lock" clrVerticalNavIcon></clr-icon>
                        Seguridad
                    </a>
                 <clr-vertical-nav-group-children *clrIfExpanded>
                  
                <div>
                    <a clrVerticalNavLink routerLink="./administracion" routerLinkActive="active">
                        <clr-icon shape="directory"></clr-icon>
                        Administración
                    </a>
                </div>
                
                <div>
                    <a clrVerticalNavLink routerLink="./user" routerLinkActive="active">
                        <clr-icon shape="directory"></clr-icon>
                        Usuario
                    </a>
                </div>
                <div>
                    <a clrVerticalNavLink routerLink="./rol" routerLinkActive="active">
                        <clr-icon shape="directory"></clr-icon>
                        Role
                    </a>
                </div>         
                    
                </clr-vertical-nav-group-children>
            	</clr-vertical-nav-group>
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