package com.softtek.generator.clarity

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module

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
	          {
	            path: 'company',
	            loadChildren: 'src/app/admin/company/company.psg.module#CompanyDemoModule',
	          },
	          {
	            path: 'property',
	            loadChildren: 'src/app/admin/property/property.psg.module#PropertyDemoModule',
	          },
	          {
	            path: 'unit',
	            loadChildren: 'src/app/admin/unit/unit.psg.module#UnitDemoModule',
	          },
	          {
	            path: 'parkingspot',
	            loadChildren: 'src/app/admin/parkingspot/parkingspot.psg.module#ParkingspotDemoModule',
	          },
	          {
	            path: 'person',
	            loadChildren: 'src/app/admin/person/person.psg.module#PersonDemoModule',
	          },
	          {
	            path: 'vehicle',
	            loadChildren: 'src/app/admin/vehicle/vehicle.psg.module#VehicleDemoModule',
	          },
	          {
	            path: 'note',
	            loadChildren: 'src/app/admin/note/note.psg.module#NoteDemoModule',
	          },
	          {
	            path: 'post',
	            loadChildren: 'src/app/admin/post/post.psg.module#PostDemoModule',
	          },
	          { // Administracion
	            path: 'administracion',
	            loadChildren: 'src/app/admin/administracion/administracion.psg.module#AdministracionDemoModule',
	          },
	          {
	            path: 'user',
	            loadChildren: 'src/app/admin/user/user.psg.module#UserDemoModule',
	          },
	          {
	            path: 'rol',
	            loadChildren: 'src/app/admin/rol/rol.psg.module#RolDemoModule',
	          },
	           «FOR m : resource.allContents.toIterable.filter(typeof(Module))»
  	   	 	  {
            	path: '«m.name.toLowerCase»',
            	loadChildren: 'src/app/admin/«m.name.toLowerCase»/«m.name.toLowerCase».psg.module#«m.name.toFirstUpper»DemoModule',
          	  },
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