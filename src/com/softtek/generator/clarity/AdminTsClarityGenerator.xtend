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
	
		  // Roles
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
	
		  // Permission
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