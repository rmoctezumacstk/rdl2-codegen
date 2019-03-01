import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormBuilder, FormGroup, Validators, FormControl, ValidatorFn, FormArray } from '@angular/forms';

// import swal from 'sweetalert2';
import { ValidationService } from '../../../_validation/validation.service';

// import { DireccionService } from '../../direccion/direccion.psg.service';
// import { Direccion } from '../../direccion/direccion.psg.model';	
// import { TipopensionService } from '../../tipopension/tipopension.psg.service';
// import { Tipopension } from '../../tipopension/tipopension.psg.model';	
// import { SolicitudpensionService } from '../../solicitudpension/solicitudpension.psg.service';
// import { Solicitudpension } from '../../solicitudpension/solicitudpension.psg.model';	
// import { BeneficiarioService } from '../../beneficiario/beneficiario.psg.service';
// import { Beneficiario } from '../../beneficiario/beneficiario.psg.model';	
import { RolSend } from '../rol.psg.model-send';
import { RolService } from '../rol.psg.service';

@Component({
  selector: 'clr-alert-not-closable-demo-angular',
  styleUrls: ['../rol.psg.scss'],
  templateUrl: './rol-agregar.psg.html',
})
export class RoleAgregarFormDemo implements OnInit {
	
  rolForm: FormGroup;
  submitted = false;
  public rolSend: RolSend = new RolSend();

  constructor(
    private fb: FormBuilder,
    private validationService: ValidationService,
    private router: Router,
    private route: ActivatedRoute,
    private rolService:RolService
  ) {
    this.rolForm = this.fb.group({
  		name: new FormControl('', Validators.required),
  		description: new FormControl('', Validators.required),
  		enabled: new FormControl('', Validators.required),
    });
  }

  ngOnInit() {
    //this.cargaRoles();
  }

  guardaUser() {
    
    this.submitted = true;

    if (this.rolForm.invalid) {
      
        return;

    } else {
    
         this.rolSend.name = this.rolForm.controls['name'].value;
         this.rolSend.description = this.rolForm.controls['description'].value;
         this.rolSend.enabled = this.rolForm.controls['enabled'].value;
    
      this.rolService.postGuardaRol(this.rolSend).subscribe(res => {
        if (res) {
          // swal('Success...', 'Rol save successfully.', 'success');
          this.router.navigate(['../administrar'], { relativeTo: this.route });
        } else {
          // swal('Error...', 'Rol save unsuccessfully.', 'error');
        }
      });
    }
  }
  
 

}
