package com.softtek.generator.banorte.angular

import com.softtek.rdl2.FormComponent
import com.softtek.rdl2.Module
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.rdl2.UICommandFlow
import com.softtek.rdl2.UIQueryFlow
import com.softtek.rdl2.UILinkFlow
import com.softtek.rdl2.UIField
import com.softtek.rdl2.UIDisplay
import com.softtek.rdl2.UIFormContainer

class BanorteGeneratorAngularTs_Form {
	
	var entityFieldUtils = new EntityFieldUtils
	
	def CharSequence genUIComponent_FormComponent(FormComponent form, Module module) '''
	 
	     onSubmit«form.name»() {
	         // Handle this event...
	         
	       //if (this.requiereSoftToken()) {
	       //  for (const perfil of this.lstPerfiles) {
	       //    if (this.model.perfil === perfil.idPerfil) {
	       //      this.model.categoria = perfil["perfilInterno"];
	       //    }
	       //  }
	       //  this.model.id = this.model.email;
	       //  this.messageEvent.emit(this.model);
	       //}
	     }
	 
	 
      «FOR field : form.form_elements»
        «field.genUIFormElement(form)»
      «ENDFOR»
      
      «FOR flow : form.links»
        «flow.genFormFlow(form)»
      «ENDFOR»
	 
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
	  onClick«flow.name»(){
	  	
	  }  
	'''
	def dispatch genFormFlow(UIQueryFlow flow, FormComponent form) '''
	  onClick«flow.name»(){
	  	
	  }
    '''
    
	def dispatch genFormFlow(UILinkFlow flow, FormComponent form) '''
	  onClick«flow.name»(){
	  	
	  }
	
    '''	
	
}