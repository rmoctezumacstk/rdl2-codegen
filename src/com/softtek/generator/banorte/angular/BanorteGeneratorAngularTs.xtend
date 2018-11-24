package com.softtek.generator.banorte.angular

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.UIComponent
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

class BanorteGeneratorAngularTs {
	
	var screenContainerUtils = new ScreenContainerUtils()
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				if (p.screen_type === null) {
					fsa.generateFile("banorte/" + m.name.toFirstLower + "/" + p.name.toFirstLower + "/" + p.name.toFirstLower + ".component.ts", p.generateTs(m))
				}
			}
		}
	}
	
	def CharSequence generateTs(PageContainer p, Module module) '''
		import {
		  Component,
		  OnInit,
		  OnDestroy,
		  Output,
		  EventEmitter,
		  Input
		} from "@angular/core";
		import { Router, NavigationEnd, NavigationCancel } from "@angular/router";
		import { WSSecurityService } from "../../services/wssecurity.service";
		import { environment } from "../../../environments/environment";
		import { WsprivilegiosService } from "../../services/wsprivilegios.service";
		«p.genServiceDeclarations»
		import { WscatalogoService } from "../../services/wscatalogo.service";
		import { GlobalesService } from "../../globales.service";
		«p.genModelsDeclaration»
		
		@Component({
		  selector: "app-«p.name.toFirstLower»",
		  templateUrl: "./«p.name.toFirstLower».component.html",
		  styleUrls: ["./«p.name.toFirstLower».component.css"]
		})
		export class «p.name»Component implements OnInit, OnDestroy {
		  @Input() modo = 0;
		  navigationSubscription;
		  // TODO -- Cambiar a usuario administrador
		  administrador = "Usuario en duro";
		  arrayErrors = [];
		  
		  isActionCanceled = false;
		  
		  editable = true;
		  «p.genModelsInitialization»
		
		  @Output() messageEvent = new EventEmitter<User>();
		
		  constructor(
		    private router: Router,
		    // TODO: Incluir servicios por entidad
		    private userData: UserdataService,
		    private WSSecurityService: WSSecurityService,
		    private WscatalogoService: WscatalogoService,
		    private wsPrivilegios: WsprivilegiosService,
		    public globales: GlobalesService
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
		
		  onSubmit() {
		    if (this.validaPerfil()) {
		      for (const perfil of this.lstPerfiles) {
		        if (this.model.perfil === perfil.idPerfil) {
		          this.model.categoria = perfil["perfilInterno"];
		        }
		      }
		      this.model.id = this.model.email;
		      this.messageEvent.emit(this.model);
		    }
		  }
		  
		  ngOnDestroy(): void {
		    if (this.navigationSubscription) {
		      this.navigationSubscription.unsubscribe();
		    }
		  }
		
		  cancelAction() {
		    this.isActionCanceled = true;
		  }
		
		  validaPerfil() {
		    this.arrayErrors = [];
		    let locPerfil;
		    let requiereSoftToken = false;
		    const privilegios = [];
		    for (const perfil of this.lstPerfiles) {
		      if (perfil.idPerfil === this.model.perfil) {
		        locPerfil = perfil;
		        break;
		      }
		    }
		    for (const privilegio of locPerfil.privilegios) {
		      privilegios.push(privilegio.idPrivilegio);
		      console.log("aplica soft token");
		      console.log(privilegio.aplicaSofteToken);
		      if (
		        privilegio.aplicaSofteToken &&
		        (this.model.movil1 === "" && this.model.movil2 === "")
		      ) {
		        requiereSoftToken = true;
		        this.model.softTokenMovil1 = true;
		        this.model.softTokenMovil2 = false;
		      }
		    }
		    if (requiereSoftToken) {
		      this.arrayErrors.push(
		        "El perfil incluye privilegios que requieren soft token, es requerido un número de teléfono móvil"
		      );
		    }
		    this.model.privilegios = privilegios;
		    return !requiereSoftToken;
		  }
		
		  onCancelConfirmation(event) {
		    this.isActionCanceled = false;
		    if (event) {
		      // si confirma
		    }
		  }
		
		  //validaEstatus() {
		  //  if (
		  //    this.modo === 1 &&
		  //    (this.model.estatus === "S" || this.model.estatus === "B")
		  //  ) {
		  //    this.editable = false;
		  //  }
		  //}
		}
	'''
	

	def CharSequence genServiceDeclarations(PageContainer container) '''
		«FOR e : screenContainerUtils.getScreenEntities(container)»
			import { «e.name»dataService } from "../../services/«e.name.toFirstLower»data.service";
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

	def CharSequence genLocalVariableInitialization(PageContainer container) '''
		«FOR c : container.components.filter(typeof(FormComponent))»
			«FOR s : c.form_elements.filter(typeof(EntityBooleanField))»
				«s.name.toFirstLower» = 0;
			«ENDFOR»
			«FOR s : c.form_elements.filter(typeof(EntityReferenceField))»
				«s.name.toFirstLower» = [];
			«ENDFOR»
		«ENDFOR»
	'''


	def CharSequence genSwitchEventHandling(PageContainer container) '''
		«FOR c : container.components.filter(typeof(FormComponent))»
			«FOR s : c.form_elements.filter(typeof(EntityBooleanField))»
			  onClick«s.name»(estatus: number) {
			    this.«s.name.toFirstLower» = estatus;
			    this.model.«s.name.toFirstLower» = estatus === 1;
			  }
			«ENDFOR»
		«ENDFOR»
	'''

	def CharSequence genOnInitSwitches(PageContainer container) '''
		«FOR c : container.components.filter(typeof(FormComponent))»
			«FOR s : c.form_elements.filter(typeof(EntityBooleanField))»
				this.model.«s.name.toFirstLower» = false;
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