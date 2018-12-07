package com.softtek.generator.banorte.angular

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

class BanorteGeneratorAngularHtml {

	var banorteGeneratorAngularHtml_Form = new BanorteGeneratorAngularHtml_Form
	var banorteGeneratorAngularHtml_List = new BanorteGeneratorAngularHtml_List
	var banorteGeneratorAngularHtml_Detail = new BanorteGeneratorAngularHtml_Detail

	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				if (p.screen_type === null) {
					fsa.generateFile("banorte/" + p.name.toLowerCase + "/" + p.name.toLowerCase + ".component.html", p.generateHtml(m))
				}
			}
		}
	}
	
	def CharSequence generateHtml(PageContainer p, Module module) '''
		<!-- Modal para cancelar acción en la Forma -->
		<app-modal
		  *ngIf="isActionCanceled"
		  [title]="globales.etiquetasIdioma['cib.general.labels.confirmar']"
		  [message]="
		    globales.etiquetasIdioma['cib.general.labels.confirmacioncalcelar']
		  "
		  [okButton]="globales.etiquetasIdioma['cib.general.buttons.si']"
		  [noOkButton]="globales.etiquetasIdioma['cib.general.buttons.no']"
		  (result)="onCancelConfirmation($event)"
		></app-modal>

		<div class="col-md-12 col-xs-12 col-sm-12 paddingLeft-by-LeftNavBar">
		  <h5 class="border-left-gray-default title-h5-usuarios " *ngIf="modo === 0">{{ globales.etiquetasIdioma["cib.«p.name.toFirstLower».labels.title"] }}</h5>
		  <h5 class="border-left-gray-default title-h5-usuarios " *ngIf="modo === 1">{{ globales.etiquetasIdioma["cib.«p.name.toFirstLower».modificacion.labels.title"] }}</h5>
		
		  <div class="col-md-12">
		    <!--<app-steper [currentStep]="1" [steps]="[1, 2, 3, 4]"></app-steper>-->
		  </div>
		  <br />
		  <br />
		  <div class="alert alert-danger margin-top-50" *ngIf="arrayErrors.length > 0" style="margin-top:30px">
		    <div *ngFor="let error of arrayErrors">
		      <label>{{ error }}</label>
		    </div>
		  </div>
		  «FOR c : p.components»
		    «c.genUIComponent(module)»
		  «ENDFOR»
		</div>
	'''

	/*
	 * genUIComponent
	 */
	def dispatch genUIComponent(FormComponent form, Module module) '''
		«banorteGeneratorAngularHtml_Form.genUIComponent_FormComponent(form, module)»
	'''

	def dispatch genUIComponent(InlineFormComponent form, Module module) '''
	'''
	
	def dispatch genUIComponent(ListComponent list, Module module) '''
		«banorteGeneratorAngularHtml_List.genUIComponent_ListComponent(list, module)»
	'''
	
	def dispatch genUIComponent(DetailComponent detail, Module module) '''
		«banorteGeneratorAngularHtml_Detail.genUIComponent_DetailComponent(detail, module)»
	'''
	
	def dispatch genUIComponent(MessageComponent m, Module module) '''
	Mensaje: «m.name»
	'''
	
	def dispatch genUIComponent(RowComponent row, Module module) '''
	'''
}