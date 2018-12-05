package com.softtek.generator.banorte.angular

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer

class BanorteGeneratorAngularModule {

	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			fsa.generateFile("banorte/" + m.name.toFirstLower + "/app.module.ts", m.generateRouting(resource, fsa))
		}
	}
	
	def CharSequence generateRouting(Module m, Resource resource, IFileSystemAccess2 access2) '''
	import { BrowserModule, SafeHtml } from '@angular/platform-browser';
	import { NgModule } from '@angular/core';
	import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
	import { TooltipModule} from 'ng2-tooltip-directive';
	import { MyHttpInterceptor } from './my-http-interceptor';
	import { ReactiveFormsModule } from '@angular/forms';
	import { FormsModule } from '@angular/forms';
	
	// Modulos
	import { PortalModule } from './modulo-portal/modulo-portal.module';
	import { PortalRoutingModule } from './modulo-portal/modulo-portal-routing.module';
	
	«FOR p : m.elements.filter(typeof(PageContainer))»
	import { «p.name»Component }  from './«p.name.toLowerCase»/«p.name.toLowerCase».component';
	«ENDFOR»
	
	@NgModule({
	  declarations: [
	   
	   	«FOR p : m.elements.filter(typeof(PageContainer))»
	   	«p.name»Component,
	   	«ENDFOR»
	
	  ],
	  imports: [
	    BrowserModule,
	    HttpClientModule,
	    ReactiveFormsModule,
	    PortalModule,
	    AppRoutingModule,
	    PortalRoutingModule,
	   TooltipModule,
	   FormsModule
	  ],
	  providers: [
	    PalistamodulosService,
	    PortalGuard /*,
	    { provide : HTTP_INTERCEPTORS, useClass : PalistaModulosApiInterceptor, multi : true },*/
	    , { provide: HTTP_INTERCEPTORS, useClass: JwtInterceptor, multi: true },
	    { provide: HTTP_INTERCEPTORS, useClass: ErrorInterceptor, multi: true }
	  ],
	  bootstrap: [AppComponent]
	})
	export class AppModule { }	
	'''	
}