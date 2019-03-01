/* PSG  User Edita Ts */
import { Component, OnInit } from '@angular/core';
import { ValidationService } from '../../../_validation/validation.service';
import { FormBuilder, FormGroup, FormControl, Validators, FormArray, ValidatorFn } from '@angular/forms';
// import swal from 'sweetalert2';
import { Router, ActivatedRoute } from '@angular/router';
import { DatePipe } from '@angular/common'; 

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
import { RolSend } from '../rol.psg.model-send';
	
@Component({
  selector: 'clr-rol-not-closable-psg-angular',
  styleUrls: ['../rol.psg.scss'],
  templateUrl: './rol-editar.psg.html',
})

export class RolEditarFormDemo implements OnInit {
  
  public rolForm: FormGroup;
  public submitted = false;
  public idRol: string;
  public datePipe = new DatePipe('en-US'); 
  public rolesArray: Rol [];
  public rolSend: RolSend = new RolSend();
  public rol: Rol;


  constructor(
    private fb: FormBuilder,
    private validationService: ValidationService,
    private router: Router,
    private route: ActivatedRoute,
    private rolService: RolService
    ) 
  {
    this.rolForm = this.fb.group({
  		name: new FormControl('', Validators.required),
  		description: new FormControl('', Validators.required),
  		enabled: new FormControl('', Validators.required),
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

  editaRol() {
  	
    this.submitted = true;

    if (this.rolForm.invalid) {
      return;
    } else {	

  		 this.route.params.subscribe(params => {
        this.idRol = params['id'];
      }); 
      
    this.rolSend.name = this.rolForm.controls['name'].value;
    this.rolSend.description = this.rolForm.controls['description'].value;
    this.rolSend.enabled = this.rolForm.controls['enabled'].value;

      this.rolService.updateEditaRol(this.rolSend, this.idRol).subscribe(res => {
        if (res) {
          // swal('Success...', 'User save successfully.', 'success');
          this.router.navigate(['../../administrar'], { relativeTo: this.route });
        } else {
          // swal('Error...', 'User save unsuccessfully.', 'error');
        }
      });
      
    }
  }

  regresaRol() {
    this.router.navigate(['../../administrar'], { relativeTo: this.route });
  }
  
}
