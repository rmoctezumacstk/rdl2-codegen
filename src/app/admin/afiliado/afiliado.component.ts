import { Component, OnInit } from '@angular/core';
import { NgbModal, ModalDismissReasons } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';

// Validacion
import { ValidationService } from '../validation-service.component';

// Entity
import { AfiliadoService } from './afiliado.component.service';
import { Afiliado } from './afiliado.component.model';

// Alert
import {Subject} from 'rxjs';
import {debounceTime} from 'rxjs/operators';

@Component({
  selector: 'app-afiliado',
  templateUrl: './afiliado.component.html',
  styleUrls: ['./afiliado.component.css']
})
export class AfiliadoComponent implements OnInit {

  // Form
  afiliadoForm: any;
  beneficiarioForm: any;

  // Entity
  afiliado: Afiliado = new Afiliado;

  // Alert
  staticAlertClosed = false;
  successMessage: string;
  errorMessage: string;
  private _success = new Subject  <string>();
  private _error = new Subject<string>();

  // Modal
  closeResult: string;

  constructor(private modalService: NgbModal, 
              private formBuilder: FormBuilder,
              private router: Router,
              private route: ActivatedRoute,
              private afiliadoService: AfiliadoService) {

    this.afiliadoForm = this.formBuilder.group({
      'nss': ['', Validators.required],
      'nombre': ['', Validators.required],
      'apellido_paterno': ['', Validators.required],
      'apellido_materno': ['', Validators.required],
      'grupo': ['', Validators.required],
      'beneficiario': ['', Validators.required],
      'observaciones': ['', Validators.required],
      'fecha_afiliacion': ['', Validators.required],
      'foto': ['', Validators.required],
      'acta_nacimiento': ['', Validators.required],
      'email': ['', [Validators.required, ValidationService.emailValidator]],
      //'email': ['', Validators.required],
      'semanas_cotizadas' : ['', Validators.required],
      'monto_pension' : ['', Validators.required],
      'dato_decimal' : ['', Validators.required]
      // 'idSistema' : ['', Validators.required]
      
    });

    this.beneficiarioForm = this.formBuilder.group({
      'archivo': ['', Validators.required],
      'proceso': ['', Validators.required]
      
    });

   }

  
  ngOnInit() {

    // Inicializadores
    setTimeout(() => this.staticAlertClosed = true, 20000);

    this._success.subscribe((message) => this.successMessage = message);
    this._success.pipe(
      debounceTime(5000)
    ).subscribe(() => this.successMessage = null);

    this._error.subscribe((message) => this.errorMessage = message);
    this._error.pipe(
      debounceTime(5000)
    ).subscribe(() => this.errorMessage = null);

  }

  open(content) {
    this.modalService.open(content, {ariaLabelledBy: 'modal-basic-title'}).result.then((result) => {
      this.closeResult = `Closed with: ${result}`;
    }, (reason) => {
      this.closeResult = `Dismissed ${this.getDismissReason(reason)}`;
    });
  }

  private getDismissReason(reason: any): string {
    if (reason === ModalDismissReasons.ESC) {
      return 'by pressing ESC';
    } else if (reason === ModalDismissReasons.BACKDROP_CLICK) {
      return 'by clicking on a backdrop';
    } else {
      return  `with: ${reason}`;
    }
  }

  saveAfiliado() {

    console.log("Saved");
    this.afiliado.nss                   = this.afiliadoForm.value.nss;
    this.afiliado.nombre                = this.afiliadoForm.value.nombre;
    this.afiliado.apellido_paterno      = this.afiliadoForm.value.apellido_paterno;
    this.afiliado.apellido_materno      = this.afiliadoForm.value.apellido_materno;
    this.afiliado.genero                = this.afiliadoForm.value.genero;
    this.afiliado.observaciones         = this.afiliadoForm.value.observaciones;
    this.afiliado.fecha_afiliacion      = this.afiliadoForm.value.fecha_afiliacion;
    this.afiliado.foto                  = this.afiliadoForm.value.foto;
    this.afiliado.acta_nacimiento       = this.afiliadoForm.value.acta_nacimiento;
    this.afiliado.email                 = this.afiliadoForm.value.email;
    this.afiliado.semanas_cotizadas     = this.afiliadoForm.value.semanas_cotizadas;
    this.afiliado.monto_pension         = this.afiliadoForm.value.monto_pension;
    this.afiliado.dato_decimal          = this.afiliadoForm.value.dato_decimal;

    this.afiliadoService.postGuardaAfiliado(this.afiliado).subscribe(
      res => {
        if (res) {
          
           this._success.next(`Registro guardado exitosamente`);

            // this.router.navigate(['../agregar'], { relativeTo: this.route });
        }
      },
      error => {
        //this._error.next(`Registro no ha sido guardado exitosamente`);
        //this.router.navigate(['../editar'], { relativeTo: this.route });
      }
    );

  }

}
