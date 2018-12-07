package com.softtek.generator.banorte.angular

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer

class BanorteGeneratorAngularRouting {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("banorte/app-routing.module.ts", generateRouting(resource, fsa))
	}
	
	def CharSequence generateRouting(Resource resource, IFileSystemAccess2 access2) '''
	import { RouterModule, Routes } from '@angular/router';
	
	import { HomeComponent } from './home';
	import { LoginComponent } from './login';
	import { AuthGuard } from './_guards';
	
	«FOR m : resource.allContents.toIterable.filter(typeof(Module))»
		«FOR p : m.elements.filter(typeof(PageContainer))»
		import { «p.name»Component } from './«p.name.toLowerCase»/«p.name.toLowerCase».component';
		«ENDFOR»
	«ENDFOR» 	
	const routes: Routes = [

	«FOR m : resource.allContents.toIterable.filter(typeof(Module))»
		«FOR p : m.elements.filter(typeof(PageContainer))»
		{ path: '«p.name.toLowerCase»component', component: «p.name»Component},
		«ENDFOR»
	«ENDFOR»
	  { path: '', component: HomeComponent, canActivate: [AuthGuard] },
	  { path: '*', redirectTo: '/appnotfound', pathMatch: 'full' },
	  { path: '**', redirectTo: '/appnotfound', pathMatch: 'full' }
	];
	
	@NgModule({
	  imports: [ RouterModule.forRoot(routes, {onSameUrlNavigation: 'reload'}) ],
	  // imports: [ RouterModule.forRoot(routes, { enableTracing: true } ) ],
	
	  exports: [ RouterModule ]
	})
	export class AppRoutingModule { appFuncionalidadModulos; }	
	'''
}