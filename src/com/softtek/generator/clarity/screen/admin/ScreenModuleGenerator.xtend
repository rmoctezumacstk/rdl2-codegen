package com.softtek.generator.clarity.screen.admin

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer

class ScreenModuleGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				if (p.screen_type === null) {
					fsa.generateFile("clarity/src/app/admin/"+ m.name.toLowerCase + "/" + m.name.toLowerCase +".psg.module.ts", p.generateModuleScreen(m))
				}
			}
		}
	}
	
	def CharSequence generateModuleScreen(PageContainer container, Module module) '''
	/* PSG  «module.name.toFirstUpper» Module */
	import { CommonModule } from '@angular/common';
	import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
	import { ClarityModule } from '@clr/angular';
	import { ReactiveFormsModule, FormsModule } from '@angular/forms';
	import { ValidationService } from '../../_validation/validation.service';
	import { HttpModule } from '@angular/http';
	
	import { «module.name.toLowerCase.toFirstUpper»Demo } from './«module.name.toLowerCase».psg';	
	«FOR p : module.elements.filter(typeof(PageContainer))»
	import { «p.name.toLowerCase.toFirstUpper» } from './«p.name.toLowerCase»/«p.name.toLowerCase».psg';
	import { ROUTING } from './«module.name.toLowerCase.toFirstUpper».psg.routing';
	«ENDFOR»
	
	@NgModule({
	  imports: [CommonModule, ClarityModule, ROUTING, HttpModule, ReactiveFormsModule, FormsModule],
	  declarations: [
    	«FOR p : module.elements.filter(typeof(PageContainer))»
    	«p.name.toLowerCase.toFirstUpper»,
    	«ENDFOR»
    	«module.name.toLowerCase.toFirstUpper»Demo
	  ],
	  exports: [
    	«FOR p : module.elements.filter(typeof(PageContainer))»
    	«p.name.toLowerCase.toFirstUpper»,
    	«ENDFOR»
    	«module.name.toLowerCase.toFirstUpper»Demo
	  ],
	  providers: [ValidationService],
	  schemas: [CUSTOM_ELEMENTS_SCHEMA],
	})
	export class «module.name.toLowerCase.toFirstUpper»DemoModule {}
	'''
}