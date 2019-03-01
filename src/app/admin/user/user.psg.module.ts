/* PSG  User Module */
import { CommonModule } from '@angular/common';
import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { ValidationService } from '../../_validation/validation.service';

import { ROUTING } from './user.psg.routing';
import { UserService } from './user.psg.service';
import { UserDemo } from './user.psg';
import { UserAdministrarDemo } from './administrar/user-administrar';
import { UserAgregarDemo } from './agregar/user-agregar';
import { UserAgregarFormDemo } from './agregar/user-agregar-form';
import { RolService } from '../rol/rol.psg.service';
import { UserEditarFormDemo } from './editar/user-editar-form';
import { UserEliminarFormDemo } from './eliminar/user-eliminar-form';

@NgModule({
  imports: [CommonModule, ROUTING, ReactiveFormsModule, FormsModule],
  declarations: [
    UserDemo,
    UserAdministrarDemo,
    UserAgregarFormDemo,
    UserEditarFormDemo,
    UserEliminarFormDemo
  ],
  exports: [
    UserDemo,
    UserAdministrarDemo,
    UserAgregarFormDemo,
    UserEditarFormDemo,
    UserEliminarFormDemo
  ],
  providers: [ValidationService, UserService, RolService],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
})
export class UserDemoModule {}
