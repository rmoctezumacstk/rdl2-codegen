import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormBuilder, FormGroup, Validators, FormControl, ValidatorFn, FormArray } from '@angular/forms';
import { ValidationService } from '../../../_validation/validation.service';

// import { DireccionService } from '../../direccion/direccion.psg.service';
// import { Direccion } from '../../direccion/direccion.psg.model';	
// import { TipopensionService } from '../../tipopension/tipopension.psg.service';
// import { Tipopension } from '../../tipopension/tipopension.psg.model';	
// import { SolicitudpensionService } from '../../solicitudpension/solicitudpension.psg.service';
// import { Solicitudpension } from '../../solicitudpension/solicitudpension.psg.model';	
// import { BeneficiarioService } from '../../beneficiario/beneficiario.psg.service';
// import { Beneficiario } from '../../beneficiario/beneficiario.psg.model';	
import { User } from '../user.psg.model';
import { UserSend } from '../user.psg.model-send';
import { Rol } from '../../rol/rol.psg.model';
import { UserService } from '../user.psg.service';
import { RolService } from '../../rol/rol.psg.service';

@Component({
  selector: 'clr-alert-not-closable-demo-angular',
  styleUrls: ['../user.psg.scss'],
  templateUrl: './user-agregar.psg.html',
})
export class UserAgregarFormDemo implements OnInit {
	
  userForm: FormGroup;
  submitted = false;
  public user: User = new User();
  public userSend: UserSend = new UserSend();
  public rolesArray: Rol [];

  constructor(
    private fb: FormBuilder,
    private validationService: ValidationService,
    private router: Router,
    private route: ActivatedRoute,
    private userService: UserService,
    private rolService:RolService
  ) {
    this.userForm = this.fb.group({
  		username: new FormControl('', Validators.required),
  		display_name: new FormControl('', Validators.required),
  		email: new FormControl('', Validators.required),
  		password: new FormControl('', Validators.required),
  		enabled: new FormControl('', Validators.required),
  		rol: new FormControl('', Validators.required)
    });
  }

  ngOnInit() {
    this.cargaRoles();
  }

  guardaUser() {
    
    this.submitted = true;

    if (this.userForm.invalid) {
      
        return;

    } else {
    
        this.userSend.username = this.userForm.controls['username'].value;
        this.userSend.display_name = this.userForm.controls['display_name'].value;
        this.userSend.email = this.userForm.controls['email'].value;
        this.userSend.password = this.userForm.controls['password'].value;
        this.userSend.enabled = this.userForm.controls['enabled'].value;
        this.userSend.roleId = this.userForm.controls['rol'].value;

        console.log("El objeto es: ", this.userSend);

      this.userService.postGuardaUser(this.userSend).subscribe(res => {
        if (res) {
          // swal('Success...', 'Afiliado save successfully.', 'success');
          this.router.navigate(['../administrar'], { relativeTo: this.route });
        } else {
          // swal('Error...', 'Afiliado save unsuccessfully.', 'error');
        }
      });
    }
  }
  
  cargaRoles() {
  this.rolService.getRecuperaRol().subscribe(
    res => {
      if (res) {
        this.rolesArray = res;
      }
    },
    error => {
      //swal('Error...', 'An error occurred while calling the direccions.', 'error');
    }
  );
}

setClickedRowRole(index, role) {
  //direccioncorreo.checked = !direccioncorreo.checked;
  //if (direccioncorreo.checked) {
    // this.direccionService.setDireccion(direccioncorreo);
	
    // this.afiliadoForm.controls['direccioncorreoId'].setValue(direccioncorreo.id);
    // this.afiliadoForm.controls['direccioncorreoItem'].setValue(direccioncorreo.calle);
  //} else {
    // this.direccionService.clear();
    // this.afiliadoForm.controls['direccioncorreoId'].setValue(null);
    // this.afiliadoForm.controls['direccioncorreoItem'].setValue('');
  //}
}

}
