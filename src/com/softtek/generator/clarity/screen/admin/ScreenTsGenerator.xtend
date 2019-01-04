package com.softtek.generator.clarity.screen.admin

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer

class ScreenTsGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				if (p.screen_type === null) {
					fsa.generateFile("clarity/src/app/admin/"+ m.name.toLowerCase + "/" + m.name.toLowerCase +".psg.ts", p.generateTsScreen(m))
				}
			}
		}
	}
	
	def CharSequence generateTsScreen(PageContainer container, Module module) '''
	/* PSG  «module.name.toFirstUpper» Ts */
	import { Component } from '@angular/core';
	import '@clr/icons/shapes/social-shapes';
	import '@clr/icons/shapes/essential-shapes';
	
	@Component({
	  selector: 'clr-«module.name.toLowerCase»-psg',
	  styleUrls: ['./«module.name.toLowerCase».psg.scss'],
	  templateUrl: './«module.name.toLowerCase».psg.html',
	})
	export class «module.name.toFirstUpper»Demo {}
	'''
}