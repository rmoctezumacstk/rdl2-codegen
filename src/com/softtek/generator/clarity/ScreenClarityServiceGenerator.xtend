package com.softtek.generator.clarity

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.FormComponent
import com.softtek.rdl2.InlineFormComponent
import com.softtek.rdl2.ListComponent
import com.softtek.rdl2.DetailComponent
import com.softtek.rdl2.MessageComponent
import com.softtek.rdl2.RowComponent
import com.softtek.rdl2.UICommandFlow
import com.softtek.rdl2.UIQueryFlow
import com.softtek.rdl2.UILinkFlow
import com.softtek.rdl2.UIField
import com.softtek.rdl2.UIDisplay
import com.softtek.rdl2.UIFormContainer

class ScreenClarityServiceGenerator {
	
		def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				if (p.screen_type === null) {
					fsa.generateFile("clarity/src/app/admin/"+p.name.toLowerCase+"/"+p.name.toLowerCase +".service.ts", p.generateTs(m))
				}
			}
		}
	}
	
	def CharSequence generateTs(PageContainer p, Module module) '''
	import { Injectable } from '@angular/core';
	import { HttpClient } from '@angular/common/http';
	import { map } from 'rxjs/operators';
	import { environment } from '../../environments/environment';
	
	@Injectable({
	  providedIn: 'root'
	})
	
	export class «p.name»Service {
	
	  constructor(private http: HttpClient) {
	     this.actionUrl = environment.ruta_rest_integrador;
	   }
	
	  	«FOR c : p.components»
		    «c.genUIComponent(module)»
		«ENDFOR»	
	
	
	   
	
	
	}
	'''
	/*
	 * genUIComponent
	 */
	def dispatch genUIComponent(FormComponent form, Module module) '''
	      
	      «FOR field : form.form_elements»
	        «field.genUIFormElement(form)»
	      «ENDFOR»
	      
	      «FOR flow : form.links»
	        «flow.genFormFlow(form)»
	      «ENDFOR»
	      
	'''
	def dispatch genUIComponent(InlineFormComponent form, Module module) '''
	'''
	
	def dispatch genUIComponent(ListComponent list, Module module) '''
«««		«banorteGeneratorAngularTs_List.genUIComponent_ListComponent(list, module)»
	'''
	
	def dispatch genUIComponent(DetailComponent detail, Module module) '''
	'''
	
	def dispatch genUIComponent(MessageComponent m, Module module) '''
	'''
	
	def dispatch genUIComponent(RowComponent row, Module module) '''
	'''
	/*
	 * genUIFormElement
	 */
	def dispatch genUIFormElement(UIField e, FormComponent form) '''
	'''
	def dispatch genUIFormElement(UIDisplay e, FormComponent form) '''
	'''
	def dispatch genUIFormElement(UIFormContainer e, FormComponent form) '''
	'''	
	
	/*
	 * UILinkCommandQueryFlow
	 */
	def dispatch genFormFlow(UICommandFlow flow, FormComponent form) '''
	  
	'''
	def dispatch genFormFlow(UIQueryFlow flow, FormComponent form) '''
	
    '''
    
	def dispatch genFormFlow(UILinkFlow flow, FormComponent form) '''
	
    '''
	
}