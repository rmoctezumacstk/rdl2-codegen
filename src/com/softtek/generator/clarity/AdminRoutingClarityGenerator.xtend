package com.softtek.generator.clarity

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.System
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.Module

class AdminRoutingClarityGenerator {
	
		def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			fsa.generateFile("clarity/src/app/admin/"+m.name.toLowerCase+"/"+m.name.toLowerCase+".psg.routing.ts", genIndexRouting(resource, fsa))
		}	
		
	}
	
	def CharSequence genIndexRouting(Resource resource, IFileSystemAccess2 access2) '''
		/** PSG Routing **/
		import { NgModule } from '@angular/core';
		import { RouterModule, Routes } from '@angular/router';
		import { AdminComponent } from './admin.component';
		import { AdminDashboardComponent } from './admin-dashboard.component';
		import { AuthGuard } from '../_guards';
		«FOR m: resource.allContents.toIterable.filter(typeof(Module))»
		import { «m.name.toLowerCase.toFirstUpper»Demo } from './«m.name.toLowerCase».psg';  	
  		«FOR p : m.elements.filter(typeof(PageContainer))»
  		import { «p.name» } from './«p.name.toLowerCase»/«p.name.toLowerCase».psg';
  		«ENDFOR»
	  	«ENDFOR»
	  	
		const adminRoutes: Routes = [
		  {
		  	«FOR m: resource.allContents.toIterable.filter(typeof(Module))»
		  	path: '',
			component: «m.name»Demo,
			children: [
				{	path: '', redirectTo: '', component: «m.name»Demo },
		  		«FOR p : m.elements.filter(typeof(PageContainer))»
		  	    {
		  	    path: '«p.name.toLowerCase»',
		  		component: «p.name»,
		  		},
		  		«ENDFOR»	      
	    	], 
		  	«ENDFOR»
	  },
	];
	
	@NgModule({
	  imports: [RouterModule.forChild(adminRoutes)],
	  exports: [RouterModule],
	})
	export class AdminRoutingModule {}
	'''
	
}