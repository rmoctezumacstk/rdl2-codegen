/* PSG  Rol Administrar Ts */
import { Component } from '@angular/core';
// import '@clr/icons/shapes/social-shapes';
// import '@clr/icons/shapes/essential-shapes';
import { Router, ActivatedRoute } from '@angular/router';
// import swal from 'sweetalert2';
import { style } from '@angular/animations';
import { Permission } from '../../../_models/permission';
import { User } from '../../../_models';


// import { DireccionService } from '../../direccion/direccion.psg.service';
// import { Direccion } from '../../direccion/direccion.psg.model';	
// import { TipopensionService } from '../../tipopension/tipopension.psg.service';
// import { Tipopension } from '../../tipopension/tipopension.psg.model';	
// import { SolicitudpensionService } from '../../solicitudpension/solicitudpension.psg.service';
// import { Solicitudpension } from '../../solicitudpension/solicitudpension.psg.model';	
// import { BeneficiarioService } from '../../beneficiario/beneficiario.psg.service';
// import { Beneficiario } from '../../beneficiario/beneficiario.psg.model';	
import { RolService } from '../rol.psg.service';
import { Rol } from '../rol.psg.model';

@Component({
  selector: 'clr-rol-demo-styles',
  styleUrls: ['../rol.psg.scss'],
  templateUrl: './rol-administrar.psg.html',
})
export class RolAdministrarDemo {
// public direccioncorreo: Direccion;
// public domicilio: Direccion;

  // Permisos
  token: string;
  user: User;
  permissions: Permission[];
  public rolArray: Rol [];

  private rol_update: boolean = false;
  private rol_delete: boolean = false;
  private rol_create: boolean = false;
  private rol_read: boolean = false;

  // Child Entities *
  	private beneficiario_read: boolean = false;
  	private beneficiario_update: boolean = false;
  	private beneficiario_delete: boolean = false;
  	private beneficiario_create: boolean = false;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private rolService: RolService
  ) {}

  ngOnInit() {
    //this.getUser();
    //this.setButtons();
    this.cargaRoles();
  }

  cargaRoles() {
    this.rolService.getRecuperaRol().subscribe(
      res => {
        if (res) {
          console.log("Roles:", res)
          this.rolArray = res;
        }
      },
      error => {
        //swal('Error...', 'An error occurred while calling the direccions.', 'error');
      }
    );
  }

  setClickedRowEditaRol(index, rol) {
    this.rolService.setRol(rol);
    this.router.navigate(['../editar', rol.id], { relativeTo: this.route });
  }

  setClickedRowEliminaRol(index, rol) {
    this.rolService.setRol(rol);
    this.router.navigate(['../eliminar', rol.id], { relativeTo: this.route });
  }

  getRol() {
    this.router.navigate(['../agregar'], { relativeTo: this.route });
  }

}