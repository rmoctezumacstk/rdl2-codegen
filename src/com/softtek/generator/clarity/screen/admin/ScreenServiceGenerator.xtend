package com.softtek.generator.clarity.screen.admin

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity
import com.softtek.rdl2.System
import com.softtek.rdl2.EntityTextField
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.Enum

class ScreenServiceGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(Entity)) {
				fsa.generateFile("clarity/src/app/admin/"+ m.name.toLowerCase + "/" + e.name.toLowerCase +".psg.service.ts", e.generateServiceScreen(m, resource))
			}
		}
	}
	
	def CharSequence generateServiceScreen(Entity entity, Module module, Resource resource) '''
	/* PSG  «entity.name.toFirstUpper» Service */
	import { Injectable } from '@angular/core';
	import { Observable } from 'rxjs';
	import { map, catchError } from 'rxjs/operators';
	import { HttpModule, Http } from '@angular/http';
	import { environment } from '../../../environments/environment';
	import { HttpHeaders, HttpClient } from '@angular/common/http';
	import { Headers, RequestOptions } from '@angular/http';
	
	import { «entity.name.toLowerCase.toFirstUpper» } from './«entity.name.toLowerCase».psg.model';
	
	@Injectable()
	export class «entity.name.toLowerCase.toFirstUpper»Service {
	  private env: any = environment;
	  private token: string;
	  «entity.name.toLowerCase» = new «entity.name.toLowerCase.toFirstUpper»();
	
	  constructor(private http: Http) {}
	
	  postGuarda«entity.name.toLowerCase.toFirstUpper»(«entity.name.toLowerCase») {
	     var obj = JSON.parse(localStorage.getItem('currentUser'));
	     this.token = obj['token'];
	     let headers = new Headers();
	     headers.append('Content-Type', 'application/json');
	     headers.append('Authorization', 'Bearer ' + this.token);
	     let opts = new RequestOptions({ headers: headers });
	     return this.http
	       «FOR System s : resource.allContents.toIterable.filter(typeof(System))»
	       //.post(`${environment.apiUrl}/«s.name.toLowerCase»/«entity.name.toLowerCase»`, «entity.name.toLowerCase», opts)
	       «ENDFOR»
	       .post(`${environment.apiUrl}/bookstore/«entity.name.toLowerCase»`, «entity.name.toLowerCase», opts)
	       .pipe(map(res => res, catchError(error => error)));
	   }
	   
	  getRecupera«entity.name.toLowerCase.toFirstUpper»() {
	    var obj = JSON.parse(localStorage.getItem('currentUser'));
	    this.token = obj['token'];
	    let headers = new Headers();
	    headers.append('Content-Type', 'application/json');
	    headers.append('Authorization', 'Bearer ' + this.token);
	    let opts = new RequestOptions({ headers: headers });
	    return this.http
	      .get(`${environment.apiUrl}/bookstore/«entity.name.toLowerCase»`, opts)
	      .pipe(map(res => res, catchError(error => error)));
	  }
	  
	  getRecupera«entity.name.toLowerCase.toFirstUpper»PorId(id) {
	    var obj = JSON.parse(localStorage.getItem('currentUser'));
	    this.token = obj['token'];
	    let headers = new Headers();
	    headers.append('Content-Type', 'application/json');
	    headers.append('Authorization', 'Bearer ' + this.token);
	    let opts = new RequestOptions({ headers: headers });
	    return this.http
	      .get(`${environment.apiUrl}/bookstore/«entity.name.toLowerCase»/` + id, opts)
	      .pipe(map(res => res, catchError(error => error)));
	  }

	  delete«entity.name.toLowerCase.toFirstUpper»(id) {
	    var obj = JSON.parse(localStorage.getItem('currentUser'));
	    this.token = obj['token'];
	    let headers = new Headers();
	    headers.append('Content-Type', 'application/json');
	    headers.append('Authorization', 'Bearer ' + this.token);
	    let opts = new RequestOptions({ headers: headers });
	    return this.http
	      .delete(`${environment.apiUrl}/bookstore/«entity.name.toLowerCase»/` + id, opts)
	      .pipe(map(res => res, catchError(error => error)));
	  }
	  
	  updateEdita«entity.name.toLowerCase.toFirstUpper»(«entity.name.toLowerCase», id) {
	    var obj = JSON.parse(localStorage.getItem('currentUser'));
	    this.token = obj['token'];
	    let headers = new Headers();
	    headers.append('Content-Type', 'application/json');
	    headers.append('Authorization', 'Bearer ' + this.token);
	    let opts = new RequestOptions({ headers: headers });
	    return this.http
	      .put(`${environment.apiUrl}/bookstore/«entity.name.toLowerCase»/` + id, «entity.name.toLowerCase», opts)
	      .pipe(map(res => res, catchError(error => error)));
	  }
	  
	«FOR Entity a : module.elements.filter(Entity)»
		«IF a != entity»
		getRecupera«entity.name.toLowerCase.toFirstUpper»Por«a.name.toLowerCase.toFirstUpper»(id){
			var obj = JSON.parse(localStorage.getItem('currentUser'));
			this.token = obj['token'];
			let headers = new Headers;
			headers.append('Content-Type','application/json');
			headers.append('Authorization', 'Bearer ' + this.token);
			let opts = new RequestOptions({ headers: headers });
			return this.http.get(`${environment.apiUrl}/«module.name.toLowerCase»/«entity.name.toLowerCase»?«a.name.toLowerCase»Id=`+ id, opts)
			.pipe(map((res => res),catchError(error => error)));  
			}		
		«ENDIF»
	«ENDFOR»	

	  reset«entity.name.toLowerCase.toFirstUpper»(): «entity.name.toLowerCase.toFirstUpper» {
	    this.clear();
	    return this.«entity.name.toLowerCase»;
	  }
	
	  get«entity.name.toLowerCase.toFirstUpper»(): «entity.name.toLowerCase.toFirstUpper» {
	    var «entity.name.toLowerCase»: «entity.name.toLowerCase.toFirstUpper» = {
  		«FOR f : entity.entity_fields»
  			«f.getAttributeGet(module,entity)»
  		«ENDFOR»	
	    };
	    return «entity.name.toLowerCase»;
	  }
	
	  set«entity.name.toLowerCase.toFirstUpper»(«entity.name.toLowerCase»: «entity.name.toLowerCase.toFirstUpper») {
  		«FOR f : entity.entity_fields»
  			«f.getAttributeSet(module,entity)»
  		«ENDFOR»
	  }
	
	  clear() {
	    «FOR f : entity.entity_fields»
  			«f.getAttributeClear(module, entity)»
  		«ENDFOR»
	  }
	}
	'''

	/********************/	
	/*  Get Attributes  */	
	def dispatch getAttributeGet(EntityTextField      f, Module module, Entity t)'''«f.name.toLowerCase»: this.«t.name.toLowerCase».«f.name.toLowerCase»,'''
	def dispatch getAttributeGet(EntityLongTextField  f, Module module, Entity t)'''«f.name.toLowerCase»: this.«t.name.toLowerCase».«f.name.toLowerCase»,'''
	def dispatch getAttributeGet(EntityDateField      f, Module module, Entity t)'''
	«f.name.toLowerCase»: this.«t.name.toLowerCase».«f.name.toLowerCase»,
	«f.name.toLowerCase»Aux: this.«t.name.toLowerCase».«f.name.toLowerCase»Aux,
	'''
	def dispatch getAttributeGet(EntityImageField     f, Module module, Entity t)'''«f.name.toLowerCase»: this.«t.name.toLowerCase».«f.name.toLowerCase»,'''
	def dispatch getAttributeGet(EntityFileField      f, Module module, Entity t)'''«f.name.toLowerCase»: this.«t.name.toLowerCase».«f.name.toLowerCase»,'''
	def dispatch getAttributeGet(EntityEmailField     f, Module module, Entity t)'''«f.name.toLowerCase»: this.«t.name.toLowerCase».«f.name.toLowerCase»,'''
	def dispatch getAttributeGet(EntityDecimalField   f, Module module, Entity t)'''«f.name.toLowerCase»: this.«t.name.toLowerCase».«f.name.toLowerCase»,'''
	def dispatch getAttributeGet(EntityIntegerField   f, Module module, Entity t)'''«f.name.toLowerCase»: this.«t.name.toLowerCase».«f.name.toLowerCase»,'''
	def dispatch getAttributeGet(EntityCurrencyField  f, Module module, Entity t)'''«f.name.toLowerCase»: this.«t.name.toLowerCase».«f.name.toLowerCase»,'''
	
	def dispatch getAttributeGet(EntityReferenceField f, Module module, Entity t)'''
	«IF !f.upperBound.equals('*')»
		«f.superType.getAttributeGetRef(module, t, f.name.toLowerCase)»
	«ENDIF»
	'''
	
	def dispatch getAttributeGetRef(Enum  e, Module module, Entity t, String name)'''
	«e.name.toLowerCase»: this.«t.name.toLowerCase».«e.name.toLowerCase»	,
	«e.name.toLowerCase»Item: this.«t.name.toLowerCase».«e.name.toLowerCase»Item,
	'''
	def dispatch getAttributeGetRef(Entity  e, Module module, Entity t, String name)'''
	«name.toLowerCase»Id: this.«t.name.toLowerCase».«name.toLowerCase»Id,
	«name.toLowerCase»Item: this.«t.name.toLowerCase».«name.toLowerCase»Item,
	'''
		
/*******************/	
/* Set Attributes  */

	def dispatch getAttributeSet(EntityTextField      f, Module module, Entity t)'''this.«t.name.toLowerCase».«f.name.toLowerCase» = «t.name.toLowerCase».«f.name.toLowerCase»;'''
	def dispatch getAttributeSet(EntityLongTextField  f, Module module, Entity t)'''this.«t.name.toLowerCase».«f.name.toLowerCase» = «t.name.toLowerCase».«f.name.toLowerCase»;'''
	def dispatch getAttributeSet(EntityDateField      f, Module module, Entity t)'''
	this.«t.name.toLowerCase».«f.name.toLowerCase» = «t.name.toLowerCase».«f.name.toLowerCase»;
	this.«t.name.toLowerCase».«f.name.toLowerCase»Aux = «t.name.toLowerCase».«f.name.toLowerCase»Aux;
	'''
	def dispatch getAttributeSet(EntityImageField     f, Module module, Entity t)'''this.«t.name.toLowerCase».«f.name.toLowerCase» = «t.name.toLowerCase».«f.name.toLowerCase»;'''
	def dispatch getAttributeSet(EntityFileField      f, Module module, Entity t)'''this.«t.name.toLowerCase».«f.name.toLowerCase» = «t.name.toLowerCase».«f.name.toLowerCase»;'''
	def dispatch getAttributeSet(EntityEmailField     f, Module module, Entity t)'''this.«t.name.toLowerCase».«f.name.toLowerCase» = «t.name.toLowerCase».«f.name.toLowerCase»;'''
	def dispatch getAttributeSet(EntityDecimalField   f, Module module, Entity t)'''this.«t.name.toLowerCase».«f.name.toLowerCase» = «t.name.toLowerCase».«f.name.toLowerCase»;'''
	def dispatch getAttributeSet(EntityIntegerField   f, Module module, Entity t)'''this.«t.name.toLowerCase».«f.name.toLowerCase» = «t.name.toLowerCase».«f.name.toLowerCase»;'''
	def dispatch getAttributeSet(EntityCurrencyField  f, Module module, Entity t)'''this.«t.name.toLowerCase».«f.name.toLowerCase» = «t.name.toLowerCase».«f.name.toLowerCase»;'''
	
	def dispatch getAttributeSet(EntityReferenceField e, Module module, Entity t)'''
	«IF !e.upperBound.equals('*')»
		«e.superType.getAttributeSetRef(module, t, e.name.toLowerCase)»
	«ENDIF»
	'''
	
	def dispatch getAttributeSetRef(Enum    e, Module module, Entity t, String name)'''
	this.«t.name.toLowerCase».«e.name.toLowerCase» = «t.name.toLowerCase».«e.name.toLowerCase»;
	this.«t.name.toLowerCase».«e.name.toLowerCase»Item = «t.name.toLowerCase».«e.name.toLowerCase»Item;
	'''
	def dispatch getAttributeSetRef(Entity  e, Module module, Entity t, String name)'''
	this.«t.name.toLowerCase».«name.toLowerCase»Id = «t.name.toLowerCase».«name.toLowerCase»Id;
	this.«t.name.toLowerCase».«name.toLowerCase»Item = «t.name.toLowerCase».«name.toLowerCase»Item;
	'''
	
	/*********************/	
	/* Clear Attributes  */
	def dispatch getAttributeClear(EntityTextField      e, Module module, Entity t)'''this.«t.name.toLowerCase».«e.name.toLowerCase» = null;'''
	def dispatch getAttributeClear(EntityLongTextField  e, Module module, Entity t)'''this.«t.name.toLowerCase».«e.name.toLowerCase» = null;'''
	def dispatch getAttributeClear(EntityDateField      e, Module module, Entity t)'''
	this.«t.name.toLowerCase».«e.name.toLowerCase» = null;
	this.«t.name.toLowerCase».«e.name.toLowerCase»Aux = null;
	'''
	def dispatch getAttributeClear(EntityImageField     e, Module module, Entity t)'''this.«t.name.toLowerCase».«e.name.toLowerCase» = null;'''
	def dispatch getAttributeClear(EntityFileField      e, Module module, Entity t)'''this.«t.name.toLowerCase».«e.name.toLowerCase» = null;'''
	def dispatch getAttributeClear(EntityEmailField     e, Module module, Entity t)'''this.«t.name.toLowerCase».«e.name.toLowerCase» = null;'''
	def dispatch getAttributeClear(EntityDecimalField   e, Module module, Entity t)'''this.«t.name.toLowerCase».«e.name.toLowerCase» = null;'''
	def dispatch getAttributeClear(EntityIntegerField   e, Module module, Entity t)'''this.«t.name.toLowerCase».«e.name.toLowerCase» = null;'''
	def dispatch getAttributeClear(EntityCurrencyField  e, Module module, Entity t)'''this.«t.name.toLowerCase».«e.name.toLowerCase» = null;'''
	
	def dispatch getAttributeClear(EntityReferenceField e, Module module, Entity t)'''
	«IF !e.upperBound.equals('*')»
		«e.superType.getAttributeClearRef(module,t, e.name.toLowerCase)»
	«ENDIF»
	'''
	
	def dispatch getAttributeClearRef(Enum e, Module module, Entity t, String name)'''
	this.«t.name.toLowerCase».«e.name.toLowerCase» = null;
	this.«t.name.toLowerCase».«e.name.toLowerCase»Item = null;
	'''
	def dispatch getAttributeClearRef(Entity e, Module module, Entity t, String name)'''
	this.«t.name.toLowerCase».«name.toLowerCase»Id = null;
	this.«t.name.toLowerCase».«name.toLowerCase»Item = null;
	'''
	
}