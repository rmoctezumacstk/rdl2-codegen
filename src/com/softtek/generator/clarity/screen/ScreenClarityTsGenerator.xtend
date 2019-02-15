package com.softtek.generator.clarity.screen

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.FormComponent
import com.softtek.rdl2.ListComponent
import com.softtek.rdl2.DetailComponent
import com.softtek.rdl2.MessageComponent
import com.softtek.rdl2.UIField
import com.softtek.rdl2.UIDisplay
import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.EntityTextField
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.rdl2.Enum
import com.softtek.rdl2.Entity

import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.rdl2.UILinkFlow
import com.softtek.generator.utils.UIFlowUtils
import com.softtek.rdl2.UIFormRow
import com.softtek.rdl2.RowComponent
import com.softtek.rdl2.ColumnComponent
import org.eclipse.emf.common.util.EList
import com.softtek.rdl2.SizeOption
import com.softtek.rdl2.UIFormContainer
import com.softtek.rdl2.UIFormPanel
import com.softtek.rdl2.UIFormColumn
import com.softtek.rdl2.WidgetAttrEnumType
import com.softtek.rdl2.WidgetAttrEnumTypeSelect
import com.softtek.rdl2.WidgetDisplayResult
import com.softtek.rdl2.WidgetLabel
import com.softtek.rdl2.WidgetHelp
import com.softtek.rdl2.WidgetExposedFilter
import com.softtek.rdl2.WidgetType
import org.apache.commons.lang3.RandomStringUtils
import com.softtek.rdl2.UICommandFlow
import com.softtek.rdl2.UIQueryFlow
import com.softtek.rdl2.InlineFormComponent
import com.softtek.rdl2.UIComponent
import com.softtek.generator.utils.EntityUtils
import com.softtek.rdl2.UITextField
import com.softtek.rdl2.UILongTextField
import com.softtek.rdl2.UIDateField
import com.softtek.rdl2.UIImageField
import com.softtek.rdl2.UIFileField
import com.softtek.rdl2.UIEmailField
import com.softtek.rdl2.UIDecimalField
import com.softtek.rdl2.UIIntegerField
import com.softtek.rdl2.UICurrencyField
import com.softtek.rdl2.OffSetMD

class ScreenClarityTsGenerator {
	
	var entityUtils = new EntityUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	var screenGeneratorAngularTs_Detail = new ScreenGeneratorAngularTs_Detail
	var screenGeneratorAngularTs_Form   = new ScreenGeneratorAngularTs_Form
	var screenGeneratorAngularTs_Inline = new ScreenGeneratorAngularTs_Inline
	var screenGeneratorAngularTs_List   = new ScreenGeneratorAngularTs_List
	var screenGeneratorAngularTs_Message = new ScreenGeneratorAngularTs_Message
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				if (p.screen_type === null) {
					fsa.generateFile("clarity/src/app/admin/"+ m.name.toLowerCase + "/" + p.name.toLowerCase+"/"+p.name.toLowerCase +".psg.ts", p.generateTag(m))
				}
			}
		}
	}
	
	def CharSequence generateTag(PageContainer page, Module module) '''
		/* PSG  «page.name.toLowerCase.toFirstUpper» Ts */
		import { Component, OnInit } from '@angular/core';
		import '@clr/icons/shapes/social-shapes';
		import '@clr/icons/shapes/essential-shapes';
		import { Router, ActivatedRoute } from '@angular/router';
		import swal from 'sweetalert2';
		import { style } from '@angular/animations';
		import { Permission } from '../../../_models/permission';
		import { User } from '../../../_models';
		import { ValidationService } from '../../../_validation/validation.service';   // Agregar
		import { FormBuilder, FormGroup, FormControl, Validators } from '@angular/forms';   // Agregar
		
		@Component({
		  selector: 'clr-«page.name.toLowerCase»-demo-styles',
		  styleUrls: ['../«module.name.toLowerCase».psg.scss'],
		  templateUrl: './«page.name.toLowerCase».psg.html',
		})
		export class «page.name.toLowerCase.toFirstUpper» implements OnInit{
		
		  constructor(
		    private fb: FormBuilder,
		    private validationService: ValidationService,
		    private router: Router,
		    private route: ActivatedRoute
		  ) {});
		  }
		
		ngOnInit() {}	 

	    «FOR c : page.components»
	   		«c.genUIComponent(module, page)»
	    «ENDFOR»

   		«FOR flow : page.links»
   			«flow.genPageFlow»
   		«ENDFOR»
		 
		}

	'''
	
	// Form
	def dispatch genUIComponent(FormComponent form, Module module, PageContainer page) '''
	«screenGeneratorAngularTs_Form.genUIComponent_FormComponent(form, module, page)»	
	'''
	
	// InlineFormComponent
	def dispatch genUIComponent(InlineFormComponent form, Module module, PageContainer page) '''
	«screenGeneratorAngularTs_Inline.genUIComponent_InlineFormComponent(form, module, page)»
	'''
	
	// ListComponent
	def dispatch genUIComponent(ListComponent l, Module module, PageContainer page) '''
	«screenGeneratorAngularTs_List.genUIComponent_ListFormComponent(l, module, page)»
«««	    «FOR h : l.list_elements»
«««			Element«h»
«««		«ENDFOR»
	
«««	Module «module»
«««	Page «page»
«««		public  «page.name.toLowerCase»Array: «page.name.toLowerCase.toFirstUpper»[];
	'''
	
	// DetailComponent
	def dispatch genUIComponent(DetailComponent detail, Module module, PageContainer page) '''
	«screenGeneratorAngularTs_Detail.genUIComponent_DetailComponent(detail, module, page)»
	'''
	
	// MessageComponent
	def dispatch genUIComponent(MessageComponent m, Module module, PageContainer page) '''
	«screenGeneratorAngularTs_Message.genUIComponent_MessageComponent(m, module, page)»
	'''
	
	// RowComponent
	def dispatch genUIComponent(RowComponent row, Module module, PageContainer page) ''''''
	
	
	/*
	 * UILinkCommandQueryFlow
	 */
	def dispatch genPageFlow(UICommandFlow flow) '''
«««    	<button type="submit" class="btn btn-primary" [routerLink]="['../«flow.success_flow.genCommandFlowToContainer.getParentModule.name.toLowerCase»']" ><clr-icon shape="«uiFlowUtils.getFlowIcon(flow, "Font Clarity")»"></clr-icon> «uiFlowUtils.getFlowLabel(flow)»</button>
«««		<submit-button id="«flow.name.toLowerCase»" to="/«flow.success_flow.genCommandFlowToContainer.getParentModule.name.toLowerCase»/«flow.success_flow.genCommandFlowToContainer.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	def dispatch genPageFlow(UIQueryFlow flow) '''
«««    	<button type="submit" class="btn btn-primary" [routerLink]="['../«flow.success_flow.genCommandFlowToContainer.getParentModule.name.toLowerCase»']" ><clr-icon shape="«uiFlowUtils.getFlowIcon(flow, "Font Clarity")»"></clr-icon> «uiFlowUtils.getFlowLabel(flow)»</button>
«««		<submit-button id="«flow.name.toLowerCase»" to="/«flow.success_flow.genCommandFlowToContainer.getParentModule.name.toLowerCase»/«flow.success_flow.genQueryFlowToContainer.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	def dispatch genPageFlow(UILinkFlow flow) '''
«««    	<button type="submit" class="btn btn-primary" [routerLink]="['../«flow.link_to.genCommandFlowToContainer.getParentModule.name.toLowerCase»']" ><clr-icon shape="«uiFlowUtils.getFlowIcon(flow, "Font Clarity")»"></clr-icon> «uiFlowUtils.getFlowLabel(flow)»</button>
«««		<submit-button id="«flow.name.toLowerCase»" to="/«flow.link_to.genCommandFlowToContainer.getParentModule.name.toLowerCase»/«flow.link_to.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''	
	
	/*
	 * ContainerOrComponent
	 */
	def dispatch genQueryFlowToContainer(PageContainer page) {
		return page
	}
	def dispatch genQueryFlowToContainer(UIComponent component) {}
	
	def Module getParentModule(PageContainer page) {
		return page.eContainer as Module
	}
	
	/*
	 * ContainerOrComponent
	 */
	def dispatch genCommandFlowToContainer(PageContainer page, UICommandFlow flow) '''
«««		<submit-button id="«flow.name.toLowerCase»" to="/«page.getParentModule.name.toLowerCase»/«page.name.toLowerCase»/" action="custom" icon="«uiFlowUtils.getFlowIcon(flow, "Font Awesome")»" caption="«uiFlowUtils.getFlowLabel(flow)»" ></submit-button>
	'''
	def dispatch genCommandFlowToContainer(UIComponent component, UICommandFlow flow) ''''''
	
	/*
	 * ContainerOrComponent
	 */
	def dispatch genCommandFlowToContainer(PageContainer page) {
		return page
	}
	def dispatch genCommandFlowToContainer(UIComponent component) {}	
	
}