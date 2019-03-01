/* PSG  Afiliado Administrar Ts */
import { Component } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { User } from '../../../_models';

import { AdminPermission } from '../administracion.psg.model';
import { PermissionSend } from '../administracion.psg.model-send';
import { PermissionService } from '../../permission/permission.psg.service';

@Component({
  selector: 'clr-administracion-demo-styles',
  styleUrls: ['../administracion.psg.scss'],
  templateUrl: './administracion.psg.html',
})
export class AdministracionAdministrarDemo {
  // Permisos
  token: string;
  user: User;
  adminPermisoList: AdminPermission[];
  permission: PermissionSend;

  constructor(private router: Router, private route: ActivatedRoute, private permissionService: PermissionService) {}

  ngOnInit() {
    this.loadAdminPermiso();
  }

  loadAdminPermiso() {
    this.permissionService.getAllPrivilege().subscribe(
      data => {
        if (data) {
          this.adminPermisoList = data;
          console.log('Los permisos: ', this.adminPermisoList);
        }
      },
      error => {
        // swal('Error...', 'An error occurred while calling the beneficiarios.', 'error');
      }
    );
  }

  saveData(permiso, rol) {
    this.permission = new PermissionSend();
    this.permission.permissionId = permiso.permission.id;
    this.permission.roleId = rol.id;

    if (rol.assigned) {
      this.permissionService.removePermission(this.permission).subscribe(
        data => {
          console.log('Resultado:', data);
        },
        error => {
          // swal('Error...', 'An error occurred while calling the beneficiarios.', 'error');
        }
      );
    } else {
      this.permissionService.assignPermission(this.permission).subscribe(
        data => {
          console.log('Resultado:', data);
        },
        error => {
          // swal('Error...', 'An error occurred while calling the beneficiarios.', 'error');
        }
      );
    }
  }
}
