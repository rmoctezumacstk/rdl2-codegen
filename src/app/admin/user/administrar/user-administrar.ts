/* PSG  User Administrar Ts */
import { Component } from '@angular/core';
// import '@clr/icons/shapes/social-shapes';
// import '@clr/icons/shapes/essential-shapes';
import { Router, ActivatedRoute } from '@angular/router';
import { style } from '@angular/animations';
import { Permission } from '../../../_models/permission';
import { UserService } from '../user.psg.service';

// import { DireccionService } from '../../direccion/direccion.psg.service';
// import { Direccion } from '../../direccion/direccion.psg.model';	
// import { TipopensionService } from '../../tipopension/tipopension.psg.service';
// import { Tipopension } from '../../tipopension/tipopension.psg.model';	
// import { SolicitudpensionService } from '../../solicitudpension/solicitudpension.psg.service';
// import { Solicitudpension } from '../../solicitudpension/solicitudpension.psg.model';	
// import { BeneficiarioService } from '../../beneficiario/beneficiario.psg.service';
// import { Beneficiario } from '../../beneficiario/beneficiario.psg.model';	
import { User } from '../user.psg.model';

@Component({
  selector: 'clr-user-demo-styles',
  styleUrls: ['../user.psg.scss'],
  templateUrl: './user-administrar.psg.html',
})
export class UserAdministrarDemo {

  // Permisos
  token: string;
  permissions: Permission[];
  public userArray: User;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
	  private userService: UserService
  ) {}

  ngOnInit() {
    //this.getUser();
    //this.setButtons();
    this.cargaUser();
  }

  cargaUser() {
    this.userService.getRecuperaUser().subscribe(
      res => {
        if (res) {
          this.userArray = res;
        }
      },
      error => {
        // swal('Error...', 'An error occurred while calling the user.', 'error');
      }
    );
  }

  setClickedRowEditaUser(index, user) {
    this.userService.setUser(user);
    this.router.navigate(['../editar', user.id], { relativeTo: this.route });
  }

  setClickedRowEliminaUser(index, user) {
    this.userService.setUser(user);
    this.router.navigate(['../eliminar', user.id], { relativeTo: this.route });
  }

  getUser() {
    this.router.navigate(['../agregar'], { relativeTo: this.route });
  }
  	
  // getUser() {
  //   var obj = JSON.parse(localStorage.getItem('currentUser'));
  //   this.token = obj['access_token'];
  //   this.permissions = obj['permissions'];
  //   this.user = obj['user'];
  // }

}
