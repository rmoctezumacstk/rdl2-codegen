import { Component } from '@angular/core';
import { FormGroup, FormBuilder, FormControl, Validators } from '@angular/forms';
import { ValidationService } from '../../../_validation/validation.service';
import { Router, ActivatedRoute } from '@angular/router';
// import swal from 'sweetalert2';
import { DatePipe } from '@angular/common'; 

import { Rol } from '../../rol/rol.psg.model';
import { RolService } from '../../rol/rol.psg.service';

@Component({
  selector: 'clr-rol-angular',
  styleUrls: ['../rol.psg.scss'],
  templateUrl: './rol-eliminar.psg.html',
})
export class RolEliminarFormDemo {
  rolForm: FormGroup;
  submitted = false;
  public idRol: string;	
  public datePipe = new DatePipe('en-US'); 	
  public rolesArray: Rol [];
  public rol: Rol;
  
  constructor(
    private fb: FormBuilder,
    private validationService: ValidationService,
    private router: Router,
    private route: ActivatedRoute,
    private rolService: RolService
  ) {
    this.rolForm = this.fb.group({
    name: new FormControl({value: '', disabled: true}),
    description: new FormControl({value: '', disabled: true}),
    enabled: new FormControl({value: '', disabled: true}),
    });
  }

  ngOnInit() {
    this.recuperaUser();
  }

  recuperaUser() {
    this.rol = this.rolService.getRol();
    this.rolForm.controls['name'].setValue(this.rol.name);
    this.rolForm.controls['description'].setValue(this.rol.description);
    this.rolForm.controls['enabled'].setValue(this.rol.enabled);
  }

  eliminaRol() {
    this.submitted = true;
    this.route.params.subscribe(params => {
      this.idRol = params['id'];
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
    //     this.rolService.deleteRol(this.idRol).subscribe(
    //       res => {
    //         if (res) {
    //           swal('Success...', 'User item has been deleted successfully.', 'success');
    //           this.router.navigate(['../../administrar'], { relativeTo: this.route });
    //         } else {
    //           swal('Error...', 'User save unsuccessfully.', 'error');
    //         }
    //       },
    //       error => {
    //         if (error.status == 500) {
    //           swal(
    //             'Warning...',
    //             'User no se puede eliminar debido a que esta asociado con otra entidad.',
    //             'warning'
    //           );
    //         }
    //       }
    //     );
    //   } else {
    //     //swal("Cancelled", "Ordensimplificada deleted unsuccessfully", "error");
    //   }
    // });
  }

  regresaRol() {
    this.router.navigate(['../../administrar'], { relativeTo: this.route });
  }
}
