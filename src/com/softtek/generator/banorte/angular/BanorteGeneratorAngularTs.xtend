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
import com.softtek.rdl2.EntityBooleanField
import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.UILinkCommandQueryFlow
import com.softtek.generator.utils.ScreenContainerUtils
import com.softtek.rdl2.UIField
import com.softtek.rdl2.UIDisplay
import com.softtek.rdl2.UIFormContainer
import com.softtek.rdl2.EntityTextField
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.rdl2.UIFormPanel
import com.softtek.rdl2.UIFormRow

class BanorteGeneratorAngularTs {
	
	var screenContainerUtils = new ScreenContainerUtils()
	var banorteGeneratorAngularTs_Form = new BanorteGeneratorAngularTs_Form
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				if (p.screen_type === null) {
					fsa.generateFile("banorte/" + p.name.toLowerCase + "/" + p.name.toLowerCase + ".component.ts", p.generateTs(m))
				}
			}
		}
	}
	
	def CharSequence generateTs(PageContainer p, Module module) '''
		import { Component, OnInit, OnDestroy, Output, EventEmitter, Input } from "@angular/core";
		import { Router, NavigationEnd, NavigationCancel } from "@angular/router";
		import { WSSecurityService } from "../../services/wssecurity.service";
		import { environment } from "../../../environments/environment";
		import { WsprivilegiosService } from "../../services/wsprivilegios.service";
		import { WscatalogoService } from "../../services/wscatalogo.service";
		import { GlobalesService } from "../../globales.service";
		
		// Models
		import { User } from '../../model/user';
		
		// Imports Services
		«p.genServiceDeclarations»
		
		// Models
«««		«p.genModelsDeclaration»
		
		@Component({
		  selector: "app-«p.name.toLowerCase»",
		  templateUrl: "./«p.name.toLowerCase».component.html",
		  styleUrls: ["./«p.name.toLowerCase».component.css"]
		})
		
		export class «p.name»Component implements OnInit, OnDestroy {
		  @Input() modo = 0;
		  navigationSubscription;
		  // TODO -- Cambiar a usuario administrador
		  administrador = "Usuario en duro";
		  arrayErrors = [];
		  isActionCanceled = false;
		  editable = true;
		  
		  // Aditional variables
		  		
«««		  «p.genModelsInitialization»	
		  «p.genMessageEvents»
		
		  constructor(
		    private router: Router,
		    private WSSecurityService: WSSecurityService,
		    private WscatalogoService: WscatalogoService,
		    private wsPrivilegios: WsprivilegiosService,
		    public globales: GlobalesService,
		    «p.genDefServiceConstructor»
		  ) {
		    this.inicializarParametros();
		  }
		  
		  ruta_imagenes = environment.ruta_imagenes;
		  «p.genLocalVariableInitialization»
		  «p.genSwitchEventHandling»
		
		  ngOnInit(): void {
		    this.WSSecurityService.pruebaObtenerDatos();
		    «p.genOnInitSwitches»
		    if (!this.WSSecurityService.WSValidacionServicioUsuario(1)) {
		      console.log("El usuario NO tiene acceso al servicio");
		    } else {
		      console.log("El usuario SI tiene acceso al servicio");
		    }
		    if (this.modo !== 0) {
		      console.log("Si entra");
		      this.userData.currentMessage.subscribe(user => {
		        console.log(user);
		        this.model = user;
		      });
		    }
		  }
		  
		  // Inicializa
		  inicializarParametros() {
		    // Inicializar parámetros cada vez que se entre a la pantalla
		    console.log("«p.name»Component: Inicializando parámetros");
		    // TODO: Por cada referencia a un Enum o Entity
		    this.WscatalogoService.listaCatalogo("cat_perfiles").subscribe(respTemp => {
		      console.log(respTemp);
		      for (const perfil of respTemp["Response"]["Data"][0]) {
		        if (perfil.perfilInterno === 0) {
		          this.lstPerfiles.push(perfil);
		        }
		      }
		    });
		    this.WscatalogoService.listaCatalogo("cat_lenguaje").subscribe(respTemp => {
		      this.lstLenguajes = respTemp["Response"]["Data"][0];
		    });
		  }
		
		// Forma
	  	«FOR c : p.components»
		    «c.genUIComponent(module)»
		«ENDFOR»		
		
		  
		  ngOnDestroy(): void {
		    if (this.navigationSubscription) {
		      this.navigationSubscription.unsubscribe();
		    }
		  }
		
		  cancelAction() {
		    this.isActionCanceled = true;
		  }
		
«««		// Cancelar button modal
«««		confirmacionModal(event) {
«««		    this.modalBn = false;
«««		    
«««		    if (event) {
«««		      this.router.navigate(['/', 'Home']);
«««		    } else {
«««		      this.isActionCanceled = false;
«««		    }
«««		}
		
«««		  requiereSoftToken() {
«««		    this.arrayErrors = [];
«««		    let locPerfil;
«««		    let requiereSoftToken = false;
«««		    const privilegios = [];
«««		    for (const perfil of this.lstPerfiles) {
«««		      if (perfil.idPerfil === this.model.perfil) {
«««		        locPerfil = perfil;
«««		        break;
«««		      }
«««		    }
«««		    for (const privilegio of locPerfil.privilegios) {
«««		      privilegios.push(privilegio.idPrivilegio);
«««		      console.log("aplica soft token");
«««		      console.log(privilegio.aplicaSofteToken);
«««		      if (
«««		        privilegio.aplicaSofteToken &&
«««		        (this.model.movil1 === "" && this.model.movil2 === "")
«««		      ) {
«««		        requiereSoftToken = true;
«««		        this.model.softTokenMovil1 = true;
«««		        this.model.softTokenMovil2 = false;
«««		      }
«««		    }
«««		    if (requiereSoftToken) {
«««		      this.arrayErrors.push(
«««		        "El perfil incluye privilegios que requieren soft token, es requerido un número de teléfono móvil"
«««		      );
«««		    }
«««		    this.model.privilegios = privilegios;
«««		    return !requiereSoftToken;
«««		  }
		
		  onCancelConfirmation(event) {
		    this.isActionCanceled = false;
		    if (event) {
		      // si confirma
		    }
		  }
		
		}
	'''
	
	/*
	 * genUIComponent
	 */
	def dispatch genUIComponent(FormComponent form, Module module) '''
		«banorteGeneratorAngularTs_Form.genUIComponent_FormComponent(form, module)»
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
	

	def CharSequence genServiceDeclarations(PageContainer container) '''
		«FOR e : screenContainerUtils.getScreenEntities(container)»
			import { «e.name»Service } from "../../services/«e.name.toFirstLower».service";
		«ENDFOR»
	'''

	def CharSequence genModelsDeclaration(PageContainer container) '''
		«FOR e : screenContainerUtils.getScreenEntities(container)»
			import { «e.name» } from "../../model/«e.name.toFirstLower»";
		«ENDFOR»
	'''


	def CharSequence genModelsInitialization(PageContainer container) '''
		«FOR e : screenContainerUtils.getScreenEntities(container)»
			model = new «e.name»(
				«FOR field : e.entity_fields SEPARATOR ","»
					«field.name.toFirstLower»: ""
				«ENDFOR»
			);
		«ENDFOR»
	'''
	
	
	def CharSequence genMessageEvents(PageContainer container) '''
		«FOR c : container.components.filter(typeof(FormComponent))»
			«IF c.entity !== null»
				@Output() «c.name.toFirstLower»MessageEvent = new EventEmitter<«c.entity.name»>();
			«ENDIF»
		«ENDFOR»
	'''
	
	def CharSequence genDefServiceConstructor(PageContainer container) '''
		«FOR e : screenContainerUtils.getScreenEntities(container) SEPARATOR ","»
			private «e.name.toFirstLower»Service: «e.name»Service
		«ENDFOR»
	'''


	def CharSequence genLocalVariableInitialization(PageContainer container) '''
		«FOR c : container.components.filter(typeof(FormComponent))»
			«FOR f : c.form_elements»
				«f.genUIElementLocalVarInit»
			«ENDFOR»
		«ENDFOR»
	'''
	
	/*
	 * UIElement
	 */
	def dispatch genUIElementLocalVarInit(UIField element) '''
	'''
	def dispatch genUIElementLocalVarInit(UIDisplay element) '''
		«element.ui_field.genUIDisplayLocalVarInit»
	'''
	def dispatch genUIElementLocalVarInit(UIFormContainer element) '''
		«element.genUIFormContainerLocalVarInit»
	'''

	/*
	 * EntityField
	 */
	def dispatch genUIDisplayLocalVarInit(EntityReferenceField field) '''
		«field.name.toFirstLower» = [];
	'''
	def dispatch genUIDisplayLocalVarInit(EntityTextField field) '''
	'''
	def dispatch genUIDisplayLocalVarInit(EntityLongTextField field) '''
	'''
	def dispatch genUIDisplayLocalVarInit(EntityDateField field) '''
	'''
	def dispatch genUIDisplayLocalVarInit(EntityImageField field) '''
	'''
	def dispatch genUIDisplayLocalVarInit(EntityFileField field) '''
	'''
	def dispatch genUIDisplayLocalVarInit(EntityEmailField field) '''
	'''
	def dispatch genUIDisplayLocalVarInit(EntityDecimalField field) '''
	'''
	def dispatch genUIDisplayLocalVarInit(EntityIntegerField field) '''
	'''
	def dispatch genUIDisplayLocalVarInit(EntityCurrencyField field) '''
	'''
	def dispatch genUIDisplayLocalVarInit(EntityBooleanField field) '''
		«field.name.toFirstLower» = 0;
	'''

	/*
	 * UIFormContainer
	 */
	def dispatch genUIFormContainerLocalVarInit(UIFormPanel container) '''
	'''
	def dispatch genUIFormContainerLocalVarInit(UIFormRow container) '''
		«FOR column : container.columns»
			«FOR e : column.elements»
				«e.genUIElementLocalVarInit»
			«ENDFOR»
		«ENDFOR»
	'''


	def CharSequence genSwitchEventHandling(PageContainer container) '''
		«FOR c : container.components.filter(typeof(FormComponent))»
			«FOR f : c.form_elements»
				«f.genUIElementSwitchEventHandling»
			«ENDFOR»
		«ENDFOR»
	'''

	/*
	 * UIElement
	 */
	def dispatch genUIElementSwitchEventHandling(UIField element) '''
	'''
	def dispatch genUIElementSwitchEventHandling(UIDisplay element) '''
		«element.ui_field.genUIDisplaySwitchEventHandling»
	'''
	def dispatch genUIElementSwitchEventHandling(UIFormContainer element) '''
		«element.genUIFormContainerSwitchEventHandling»
	'''

	/*
	 * EntityField
	 */
	def dispatch genUIDisplaySwitchEventHandling(EntityReferenceField field) '''
	'''
	def dispatch genUIDisplaySwitchEventHandling(EntityTextField field) '''
	'''
	def dispatch genUIDisplaySwitchEventHandling(EntityLongTextField field) '''
	'''
	def dispatch genUIDisplaySwitchEventHandling(EntityDateField field) '''
	'''
	def dispatch genUIDisplaySwitchEventHandling(EntityImageField field) '''
	'''
	def dispatch genUIDisplaySwitchEventHandling(EntityFileField field) '''
	'''
	def dispatch genUIDisplaySwitchEventHandling(EntityEmailField field) '''
	'''
	def dispatch genUIDisplaySwitchEventHandling(EntityDecimalField field) '''
	'''
	def dispatch genUIDisplaySwitchEventHandling(EntityIntegerField field) '''
	'''
	def dispatch genUIDisplaySwitchEventHandling(EntityCurrencyField field) '''
	'''
	def dispatch genUIDisplaySwitchEventHandling(EntityBooleanField field) '''
	  onClick«field.name»(estatus: number) {
	    this.«field.name.toFirstLower» = estatus;
	    this.model.«field.name.toFirstLower» = estatus === 1;
	  }
	'''

	/*
	 * UIFormContainer
	 */
	def dispatch genUIFormContainerSwitchEventHandling(UIFormPanel container) '''
	'''
	def dispatch genUIFormContainerSwitchEventHandling(UIFormRow container) '''
		«FOR column : container.columns»
			«FOR e : column.elements»
				«e.genUIElementSwitchEventHandling»
			«ENDFOR»
		«ENDFOR»
	'''


	def CharSequence genOnInitSwitches(PageContainer container) '''
		«FOR c : container.components.filter(typeof(FormComponent))»
			«FOR f : c.form_elements»
				«f.genUIElementOnInitSwitches»
			«ENDFOR»
		«ENDFOR»
	'''

	/*
	 * UIElement
	 */
	def dispatch genUIElementOnInitSwitches(UIField element) '''
	'''
	def dispatch genUIElementOnInitSwitches(UIDisplay element) '''
		«element.ui_field.genUIDisplayOnInitSwitches»
	'''
	def dispatch genUIElementOnInitSwitches(UIFormContainer element) '''
		«element.genUIFormContainerOnInitSwitches»
	'''

	/*
	 * EntityField
	 */
	def dispatch genUIDisplayOnInitSwitches(EntityReferenceField field) '''
	'''
	def dispatch genUIDisplayOnInitSwitches(EntityTextField field) '''
	'''
	def dispatch genUIDisplayOnInitSwitches(EntityLongTextField field) '''
	'''
	def dispatch genUIDisplayOnInitSwitches(EntityDateField field) '''
	'''
	def dispatch genUIDisplayOnInitSwitches(EntityImageField field) '''
	'''
	def dispatch genUIDisplayOnInitSwitches(EntityFileField field) '''
	'''
	def dispatch genUIDisplayOnInitSwitches(EntityEmailField field) '''
	'''
	def dispatch genUIDisplayOnInitSwitches(EntityDecimalField field) '''
	'''
	def dispatch genUIDisplayOnInitSwitches(EntityIntegerField field) '''
	'''
	def dispatch genUIDisplayOnInitSwitches(EntityCurrencyField field) '''
	'''
	def dispatch genUIDisplayOnInitSwitches(EntityBooleanField field) '''
		this.model.«field.name.toFirstLower» = false;
	'''

	/*
	 * UIFormContainer
	 */
	def dispatch genUIFormContainerOnInitSwitches(UIFormPanel container) '''
	'''
	def dispatch genUIFormContainerOnInitSwitches(UIFormRow container) '''
		«FOR column : container.columns»
			«FOR e : column.elements»
				«e.genUIElementOnInitSwitches»
			«ENDFOR»
		«ENDFOR»
	'''

	def CharSequence genNonPrimaryActionHandling(PageContainer container) '''
		«FOR c : container.components.filter(typeof(FormComponent))»
			«FOR f : c.form_elements.filter(typeof(UILinkCommandQueryFlow))»
				«IF f.state.toString !== "Primary"»
					onClick«f.name»() {
					  // Your code for handling this event goes here...
					}
				«ENDIF»
			«ENDFOR»
		«ENDFOR»
	'''

	/*
	 * UIComponent
	 */
	def dispatch getComponentEntity(FormComponent component) {
		return component.entity
	}
	def dispatch getComponentEntity(InlineFormComponent component) {
		return component.entity
	}
	def dispatch getComponentEntity(ListComponent component) {
		return component.entity
	}
	def dispatch getComponentEntity(DetailComponent component) {
		return component.entity
	}
	def dispatch getComponentEntity(MessageComponent component) {
		return null
	}
	def dispatch getComponentEntity(RowComponent component) {
		return null
	}
	
}