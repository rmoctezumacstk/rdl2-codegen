import { Component } from '@angular/core';
import { FormGroup, FormBuilder, FormControl, Validators } from '@angular/forms';
import { ValidationService } from '../../../_validation/validation.service';
import { Router, ActivatedRoute } from '@angular/router';
import { DatePipe } from '@angular/common'; 

import { User }        from '../user.psg.model';
import { UserService } from '../user.psg.service';
import { Rol } from '../../rol/rol.psg.model';
import { RolService } from '../../rol/rol.psg.service';

@Component({
  selector: 'clr-user-angular',
  styleUrls: ['../user.psg.scss'],
  templateUrl: './user-eliminar.psg.html',
})
export class UserEliminarFormDemo {
  userForm: FormGroup;
  submitted = false;
  public user: User = new User();
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
  ) {
    this.userForm = this.fb.group({
    username: new FormControl({value: '', disabled: true}),
    display_name: new FormControl({value: '', disabled: true}),
    email: new FormControl({value: '', disabled: true}),
    enabled: new FormControl({value: '', disabled: true}),
    rol: new FormControl({value: '', disabled: true}),
    password: new FormControl({value: '', disabled: true})
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

  eliminaUser() {
    this.submitted = true;

    this.route.params.subscribe(params => {
      this.idUser = params['id'];
    }); 

    // swal({
    //   title: 'Are you sure?',
    //   text: 'You will not be able to recover this ordensimplificada!',
    //   type: 'warning',
    //   showCancelButton: true,
    //   confirmButtonColor: '#DD6B55',
    //   confirmButtonText: 'Yes, delete it!',
    //   cancelButtonText: 'No, cancel!',
    // }).then(isConfirm => {
    //   if (isConfirm.value) {
    //     this.userService.deleteUser(this.idUser).subscribe(
    //       res => {
    //         if (res) {
    //           // swal('Success...', 'User item has been deleted successfully.', 'success');
    //           this.router.navigate(['../../administrar'], { relativeTo: this.route });
    //         } else {
    //           // swal('Error...', 'User save unsuccessfully.', 'error');
    //         }
    //       },
    //       error => {
    //         if (error.status == 500) {
    //           // swal(
    //           //   'Warning...',
    //           //   'User no se puede eliminar debido a que esta asociado con otra entidad.',
    //           //   'warning'
    //           // );
    //         }
    //       }
    //     );
    //   } else {
    //     //swal("Cancelled", "Ordensimplificada deleted unsuccessfully", "error");
    //   }
    // });
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
