package com.softtek.generator.clarity

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer

class AdminModuleClarityGenerator {
	
		def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("clarity/src/app/admin/admin.module.ts", generateModule(resource, fsa))
	}
	
	def CharSequence generateModule(Resource resource, IFileSystemAccess2 access2) '''
	import { NgModule, LOCALE_ID } from '@angular/core';
	import { CommonModule, registerLocaleData } from '@angular/common';
	import { HttpModule, Http } from '@angular/http';
	import { ReactiveFormsModule, FormsModule } from '@angular/forms';
	import { AdminComponent } from './admin.component';
	import { AdminDashboardComponent } from './admin-dashboard.component';
	import { AdminRoutingModule } from './admin-routing.module';
	import { HttpClientModule } from '@angular/common/http';
	import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
	import { ClarityModule } from '@clr/angular';
	import { SelectivePreloadingStrategy } from './selective-preloading-strategy';
	
	import localeMx from '@angular/common/locales/es-MX';
	registerLocaleData(localeMx, 'es-MX');
	
	import { PermissionDemoModule } from './permission/permission.psg.module';
	import { UserDemoModule } from './user/user.psg.module';
	import { AdministracionDemoModule } from './administracion/administracion.psg.module';
	//import { RolDemoModule } from './rol/rol.psg.module';
	
	  «FOR m : resource.allContents.toIterable.filter(typeof(Module))»
	  import { «m.name.toLowerCase.toFirstUpper»DemoModule } from './«m.name.toLowerCase»/«m.name.toLowerCase».psg.module';
	  «ENDFOR» 	
	
	@NgModule({
	  imports: [
	    AdminRoutingModule,
	    HttpModule,
	    CommonModule,
	    ReactiveFormsModule,
	    FormsModule,
	    ClarityModule,
	    HttpClientModule,
	    
       «FOR m : resource.allContents.toIterable.filter(typeof(Module))»
		«m.name.toLowerCase.toFirstUpper»DemoModule,
      «ENDFOR» 	
	
	         PermissionDemoModule,
	         UserDemoModule,
	         AdministracionDemoModule,
	        //  RolDemoModule 
	  ],
	  declarations: [AdminComponent,AdminDashboardComponent],
	  providers: [
	
	    SelectivePreloadingStrategy,
	    [{ provide: LOCALE_ID, useValue: 'es-MX' }]
	  ],
	})
	export class AdminModule {}
	
	'''	
	
}