package com.softtek.generator.clarity

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2

class AdminTsClarityGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("clarity/src/app/admin/admin.component.ts", genAdminTs(resource, fsa))
	}	
	
	def CharSequence genAdminTs(Resource resource, IFileSystemAccess2 access2) '''
	/* PSG Model Ts */
	import { Component } from '@angular/core';
	import { Router, NavigationExtras } from '@angular/router';
	import { AuthenticationService } from '../_services';
	import { Permission } from '../_models/permission';
	import { User } from '../_models';
	
	@Component({
	  templateUrl: 'admin.component.html',
	})
	export class AdminComponent {
	  token: string;
	  valueName: string;
	  user: User;
	  permissions: Permission[];
	
	  // Menu
	  private company_update: boolean = false;
	  private company_delete: boolean = false;
	  private company_create: boolean = false;
	  private company_read: boolean = false;
	  private property_update: boolean = false;
	  private property_delete: boolean = false;
	  private property_create: boolean = false;
	  private property_read: boolean = false;
	  private unit_update: boolean = false;
	  private unit_delete: boolean = false;
	  private unit_create: boolean = false;
	  private unit_read: boolean = false;
	  private parkingspot_update: boolean = false;
	  private parkingspot_delete: boolean = false;
	  private parkingspot_create: boolean = false;
	  private parkingspot_read: boolean = false;
	  private person_update: boolean = false;
	  private person_delete: boolean = false;
	  private person_create: boolean = false;
	  private person_read: boolean = false;
	  private vehicle_update: boolean = false;
	  private vehicle_delete: boolean = false;
	  private vehicle_create: boolean = false;
	  private vehicle_read: boolean = false;
	  private note_update: boolean = false;
	  private note_delete: boolean = false;
	  private note_create: boolean = false;
	  private note_read: boolean = false;
	  private post_update: boolean = false;
	  private post_delete: boolean = false;
	  private post_create: boolean = false;
	  private post_read: boolean = false;
	
	  // Rdl2
	  private category_update: boolean = false;
	  private category_delete: boolean = false;
	  private category_create: boolean = false;
	  private category_read: boolean = false;
	
	  // Seguridad
	  private users_update: boolean = false;
	  private users_delete: boolean = false;
	  private users_create: boolean = false;
	  private users_read: boolean = false;
	
	  private roles_update: boolean = false;
	  private roles_delete: boolean = false;
	  private roles_create: boolean = false;
	  private roles_read: boolean = false;
	
	  private permissions_update: boolean = false;
	  private permissions_delete: boolean = false;
	  private permissions_create: boolean = false;
	  private permissions_read: boolean = false;
	
	  constructor(public router: Router, public authService: AuthenticationService) {}
	
	  ngOnInit() {
	    this.getUser();
	  }
	
	  enabledLinks(user) {}
	
	  buildMenu() {
	    this.permissions.forEach(element => {
	      if (element.code == 'COMPANY:CREATE') {
	        this.company_create = true;
	      }
	
	      if (element.code == 'COMPANY:UPDATE') {
	        this.company_update = true;
	      }
	
	      if (element.code == 'COMPANY:DELETE') {
	        this.company_delete = true;
	      }
	
	      if (element.code == 'COMPANY:READ') {
	        this.company_read = true;
	      }
	
	      if (element.code == 'COMPANY:*') {
	        this.company_update = true;
	        this.company_create = true;
	        this.company_delete = true;
	        this.company_read = true;
	      }
	
	      if (element.code == '*:*') {
	        this.company_update = true;
	        this.company_create = true;
	        this.company_delete = true;
	        this.company_read = true;
	      }
	
	      if (element.code == 'PROPERTY:CREATE') {
	        this.property_create = true;
	      }
	
	      if (element.code == 'PROPERTY:UPDATE') {
	        this.property_update = true;
	      }
	
	      if (element.code == 'PROPERTY:DELETE') {
	        this.property_delete = true;
	      }
	
	      if (element.code == 'PROPERTY:READ') {
	        this.property_read = true;
	      }
	
	      if (element.code == 'PROPERTY:*') {
	        this.property_update = true;
	        this.property_create = true;
	        this.property_delete = true;
	        this.property_read = true;
	      }
	
	      if (element.code == '*:*') {
	        this.property_update = true;
	        this.property_create = true;
	        this.property_delete = true;
	        this.property_read = true;
	      }
	
	      if (element.code == 'UNIT:CREATE') {
	        this.unit_create = true;
	      }
	
	      if (element.code == 'UNIT:UPDATE') {
	        this.unit_update = true;
	      }
	
	      if (element.code == 'UNIT:DELETE') {
	        this.unit_delete = true;
	      }
	
	      if (element.code == 'UNIT:READ') {
	        this.unit_read = true;
	      }
	
	      if (element.code == 'UNIT:*') {
	        this.unit_update = true;
	        this.unit_create = true;
	        this.unit_delete = true;
	        this.unit_read = true;
	      }
	
	      if (element.code == '*:*') {
	        this.unit_update = true;
	        this.unit_create = true;
	        this.unit_delete = true;
	        this.unit_read = true;
	      }
	
	      if (element.code == 'PARKINGSPOT:CREATE') {
	        this.parkingspot_create = true;
	      }
	
	      if (element.code == 'PARKINGSPOT:UPDATE') {
	        this.parkingspot_update = true;
	      }
	
	      if (element.code == 'PARKINGSPOT:DELETE') {
	        this.parkingspot_delete = true;
	      }
	
	      if (element.code == 'PARKINGSPOT:READ') {
	        this.parkingspot_read = true;
	      }
	
	      if (element.code == 'PARKINGSPOT:*') {
	        this.parkingspot_update = true;
	        this.parkingspot_create = true;
	        this.parkingspot_delete = true;
	        this.parkingspot_read = true;
	      }
	
	      if (element.code == '*:*') {
	        this.parkingspot_update = true;
	        this.parkingspot_create = true;
	        this.parkingspot_delete = true;
	        this.parkingspot_read = true;
	      }
	
	      if (element.code == 'PERSON:CREATE') {
	        this.person_create = true;
	      }
	
	      if (element.code == 'PERSON:UPDATE') {
	        this.person_update = true;
	      }
	
	      if (element.code == 'PERSON:DELETE') {
	        this.person_delete = true;
	      }
	
	      if (element.code == 'PERSON:READ') {
	        this.person_read = true;
	      }
	
	      if (element.code == 'PERSON:*') {
	        this.person_update = true;
	        this.person_create = true;
	        this.person_delete = true;
	        this.person_read = true;
	      }
	
	      if (element.code == '*:*') {
	        this.person_update = true;
	        this.person_create = true;
	        this.person_delete = true;
	        this.person_read = true;
	      }
	
	      if (element.code == 'VEHICLE:CREATE') {
	        this.vehicle_create = true;
	      }
	
	      if (element.code == 'VEHICLE:UPDATE') {
	        this.vehicle_update = true;
	      }
	
	      if (element.code == 'VEHICLE:DELETE') {
	        this.vehicle_delete = true;
	      }
	
	      if (element.code == 'VEHICLE:READ') {
	        this.vehicle_read = true;
	      }
	
	      if (element.code == 'VEHICLE:*') {
	        this.vehicle_update = true;
	        this.vehicle_create = true;
	        this.vehicle_delete = true;
	        this.vehicle_read = true;
	      }
	
	      if (element.code == '*:*') {
	        this.vehicle_update = true;
	        this.vehicle_create = true;
	        this.vehicle_delete = true;
	        this.vehicle_read = true;
	      }
	
	      if (element.code == 'NOTE:CREATE') {
	        this.note_create = true;
	      }
	
	      if (element.code == 'NOTE:UPDATE') {
	        this.note_update = true;
	      }
	
	      if (element.code == 'NOTE:DELETE') {
	        this.note_delete = true;
	      }
	
	      if (element.code == 'NOTE:READ') {
	        this.note_read = true;
	      }
	
	      if (element.code == 'NOTE:*') {
	        this.note_update = true;
	        this.note_create = true;
	        this.note_delete = true;
	        this.note_read = true;
	      }
	
	      if (element.code == '*:*') {
	        this.note_update = true;
	        this.note_create = true;
	        this.note_delete = true;
	        this.note_read = true;
	      }
	
	      if (element.code == 'POST:CREATE') {
	        this.post_create = true;
	      }
	
	      if (element.code == 'POST:UPDATE') {
	        this.post_update = true;
	      }
	
	      if (element.code == 'POST:DELETE') {
	        this.post_delete = true;
	      }
	
	      if (element.code == 'POST:READ') {
	        this.post_read = true;
	      }
	
	      if (element.code == 'POST:*') {
	        this.post_update = true;
	        this.post_create = true;
	        this.post_delete = true;
	        this.post_read = true;
	      }
	
	      if (element.code == '*:*') {
	        this.post_update = true;
	        this.post_create = true;
	        this.post_delete = true;
	        this.post_read = true;
	      }
	
	      // Seguridad
	      if (element.code == 'USERS:CREATE') {
	        this.users_create = true;
	      }
	
	      if (element.code == 'USERS:UPDATE') {
	        this.users_update = true;
	      }
	
	      if (element.code == 'USERS:DELETE') {
	        this.users_delete = true;
	      }
	
	      if (element.code == 'USERS:READ') {
	        this.users_read = true;
	      }
	
	      if (element.code == 'USERS:*') {
	        this.users_update = true;
	        this.users_create = true;
	        this.users_delete = true;
	        this.users_read = true;
	      }
	
	      if (element.code == '*:*') {
	        this.users_update = true;
	        this.users_create = true;
	        this.users_delete = true;
	        this.users_read = true;
	      }
	
	      if (element.code == 'ROLES:CREATE') {
	        this.roles_create = true;
	      }
	
	      if (element.code == 'ROLES:UPDATE') {
	        this.roles_update = true;
	      }
	
	      if (element.code == 'ROLES:DELETE') {
	        this.roles_delete = true;
	      }
	
	      if (element.code == 'ROLES:READ') {
	        this.roles_read = true;
	      }
	
	      if (element.code == 'ROLES:*') {
	        this.roles_update = true;
	        this.roles_create = true;
	        this.roles_delete = true;
	        this.roles_read = true;
	      }
	
	      if (element.code == '*:*') {
	        this.roles_update = true;
	        this.roles_create = true;
	        this.roles_delete = true;
	        this.roles_read = true;
	      }
	
	      if (element.code == 'PERMISSIONS:CREATE') {
	        this.permissions_create = true;
	      }
	
	      if (element.code == 'PERMISSIONS:UPDATE') {
	        this.permissions_update = true;
	      }
	
	      if (element.code == 'PERMISSIONS:DELETE') {
	        this.permissions_delete = true;
	      }
	
	      if (element.code == 'PERMISSIONS:READ') {
	        this.permissions_read = true;
	      }
	
	      if (element.code == 'PERMISSIONS:*') {
	        this.permissions_update = true;
	        this.permissions_create = true;
	        this.permissions_delete = true;
	        this.permissions_read = true;
	      }
	
	      if (element.code == '*:*') {
	        this.category_update = true;
	        this.category_create = true;
	        this.category_delete = true;
	        this.category_read = true;
	      }
	
	      if (element.code == 'CATEGORY:CREATE') {
	        this.category_create = true;
	      }
	
	      if (element.code == 'CATEGORY:UPDATE') {
	        this.category_update = true;
	      }
	
	      if (element.code == 'CATEGORY:DELETE') {
	        this.category_delete = true;
	      }
	
	      if (element.code == 'CATEGORY:READ') {
	        this.category_read = true;
	      }
	
	      if (element.code == 'CATEGORY:*') {
	        this.category_update = true;
	        this.category_create = true;
	        this.category_delete = true;
	        this.category_read = true;
	      }
	
	      if (element.code == '*:*') {
	        this.category_update = true;
	        this.category_create = true;
	        this.category_delete = true;
	        this.category_read = true;
	      }
	    });
	  }
	
	  getUser() {
	    var obj = JSON.parse(localStorage.getItem('currentUser'));
	    this.token = obj['access_token'];
	
	    this.authService.getUser(this.token).subscribe(result => {
	      var obj = JSON.parse(localStorage.getItem('currentUser'));
	
	      this.user = obj['user'];
	      this.permissions = obj['permissions'];
	      this.token = obj['token'];
	      this.valueName = this.user.display_name;
	
	      this.buildMenu();
	    });
	  }
	
	  logout(): void {
	    localStorage.removeItem('currentUser');
	    this.router.navigate(['login']);
	  }
	}
	
	'''
}