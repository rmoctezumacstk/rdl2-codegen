import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormBuilder, FormGroup, Validators, FormControl, ValidatorFn, FormArray } from '@angular/forms';

import { PermissionSend } from '../permission.psg.model-send';
import { PermissionService } from '../permission.psg.service';

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

@Component({
  selector: 'clr-alert-not-closable-demo-angular',
  styleUrls: ['../permission.psg.scss'],
  templateUrl: './permission-agregar.psg.html',
})
export class PermissionAgregarFormDemo implements OnInit {
  permissionForm: FormGroup;
  submitted = false;
  // permissionSend: PermissionSend;

  constructor(
    private fb: FormBuilder,
    private validationService: ValidationService,
    private router: Router,
    private route: ActivatedRoute,
    private permissionService: PermissionService
  ) {
    this.permissionForm = this.fb.group({
      code: new FormControl('', Validators.required),
      description: new FormControl('', Validators.required),
    });
  }

  ngOnInit() {}

  guardaPermission() {
    this.submitted = true;

    if (this.permissionForm.invalid) {
      return;
    } else {
      // this.permissionSend.code = this.permissionForm.controls['code'].value;
      // this.permissionSend.description = this.permissionForm.controls['description'].value;

      this.permissionService.postGuardaPermission(null).subscribe(res => {
        if (res) {
          // swal('Success...', 'Afiliado save successfully.', 'success');
          this.router.navigate(['../administrar'], { relativeTo: this.route });
        } else {
          // swal('Error...', 'Afiliado save unsuccessfully.', 'error');
        }
      });
    }
  }
}
