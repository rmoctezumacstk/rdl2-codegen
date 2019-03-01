/* PSG  User Edita Ts */
import { Component, OnInit } from '@angular/core';
import { ValidationService } from '../../../_validation/validation.service';
import { FormBuilder, FormGroup, FormControl, Validators, FormArray, ValidatorFn } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { DatePipe } from '@angular/common'; 

import { User }        from '../user.psg.model';
import { UserSend } from '../user.psg.model-send';
import { UserService } from '../user.psg.service';

// import { DireccionService } from '../../direccion/direccion.psg.service';
// import { Direccion } from '../../direccion/direccion.psg.model';	
// import { AfiliadoService } from '../../afiliado/afiliado.psg.service';
// import { Afiliado } from '../../afiliado/afiliado.psg.model';	
// import { TipopensionService } from '../../tipopension/tipopension.psg.service';
// import { Tipopension } from '../../tipopension/tipopension.psg.model';	
// import { SolicitudpensionService } from '../../solicitudpension/solicitudpension.psg.service';
// import { Solicitudpension } from '../../solicitudpension/solicitudpension.psg.model';	
// import { BeneficiarioService } from '../../beneficiario/beneficiario.psg.service';
// import { Beneficiario } from '../../beneficiario/beneficiario.psg.model';	
import { RolService } from '../../rol/rol.psg.service';
import { Rol } from '../../rol/rol.psg.model';
	
@Component({
  selector: 'clr-user-not-closable-psg-angular',
  styleUrls: ['../user.psg.scss'],
  templateUrl: './user-editar.psg.html',
})

export class UserEditarFormDemo implements OnInit {
  
  public userForm: FormGroup;
  public submitted = false;
  public user: User = new User();
  public userSend: UserSend = new UserSend();
  public idUser: string;
  public datePipe = new DatePipe('en-US'); 
  public rolesArray: Rol [];

  constructor(
    private fb: FormBuilder,
    private validationService: ValidationService,
    private router: Router,
    private route: ActivatedRoute,
    private userService: UserService,
    private rolService: RolService
    ) 
  {
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
    this.recuperaUser();
    this.cargaRoles();
  }

  recuperaUser() {
  	
    this.user = this.userService.getUser();
    this.userForm.controls['username'].setValue(this.user.username);
    this.userForm.controls['display_name'].setValue(this.user.display_name);
    this.userForm.controls['email'].setValue(this.user.email);
    this.userForm.controls['enabled'].setValue(this.user.enabled);
    this.userForm.controls['password'].setValue(this.user.password);
    this.userForm.controls['rol'].setValue(this.user.roleId);

  }

  editaUser() {
  	
    this.submitted = true;

    if (this.userForm.invalid) {
      return;
    } else {	

  		 this.route.params.subscribe(params => {
        this.idUser = params['id'];
      }); 
      
    this.userSend.username = this.userForm.controls['username'].value;
    this.userSend.display_name = this.userForm.controls['display_name'].value;
    this.userSend.email = this.userForm.controls['email'].value;
    this.userSend.enabled = this.userForm.controls['enabled'].value;
    this.userSend.password = this.userForm.controls['password'].value;
    this.userSend.roleId = this.userForm.controls['rol'].value;

      this.userService.updateEditaUser(this.userSend, this.idUser).subscribe(res => {
        if (res) {
          // swal('Success...', 'User save successfully.', 'success');
          this.router.navigate(['../../administrar'], { relativeTo: this.route });
        } else {
          // swal('Error...', 'User save unsuccessfully.', 'error');
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

  regresaUser() {
    this.router.navigate(['../../administrar'], { relativeTo: this.route });
  }
  
}
