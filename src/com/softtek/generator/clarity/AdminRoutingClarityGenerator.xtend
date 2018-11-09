package com.softtek.generator.clarity

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.System
import com.softtek.rdl2.PageContainer

class AdminRoutingClarityGenerator {
	
		def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("clarity/src/app/admin/admin-routing.module.ts", genIndexRouting(resource, fsa))
	}
	
	def CharSequence genIndexRouting(Resource resource, IFileSystemAccess2 access2) '''
		/** PSG Routing **/
		import { NgModule } from '@angular/core';
		import { RouterModule, Routes } from '@angular/router';
		import { AdminComponent } from './admin.component';
		import { AdminDashboardComponent } from './admin-dashboard.component';
		import { AuthGuard } from '../_guards';
		
		const adminRoutes: Routes = [
		  {
		    path: '',
		    component: AdminComponent,
		    canActivate: [AuthGuard],
		    children: [
		      {
		        path: '', 
		        canActivate: [AuthGuard],
		        children: [
		«FOR System s : resource.allContents.toIterable.filter(typeof(System))»
			«FOR m : s.modules_ref»
				«FOR page : m.module_ref.elements.filter(typeof(PageContainer))»
					«IF page.screen_type === null»
					{ 
			        	path: 'direccion', 
			        	loadChildren: 'src/app/admin/«m.module_ref.name.toLowerCase»/«page.name.toLowerCase»'
			        },
					«ENDIF»
				«ENDFOR»
			«ENDFOR»
		«ENDFOR»
	        ],
	      },
	    ],
	  },
	];
	
	@NgModule({
	  imports: [RouterModule.forChild(adminRoutes)],
	  exports: [RouterModule],
	})
	export class AdminRoutingModule {}
	'''
	
}