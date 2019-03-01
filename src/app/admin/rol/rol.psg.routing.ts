/* PSG  Rol Routing */
import { ModuleWithProviders } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { RolAdministrarDemo } from './administrar/rol-administrar';
import { RolDemo } from './rol.psg';
import { RolAgregarDemo } from './agregar/rol-agregar';
import { RolEditarDemo } from './editar/rol-editar';
import { RolEliminarDemo } from './eliminar/rol-eliminar';
import { RoleAgregarFormDemo } from './agregar/rol-agregar-form';
import { RolEliminarFormDemo } from './eliminar/rol-eliminar-form';
import { RolEditarFormDemo } from './editar/rol-editar-form';

const ROUTES: Routes = [
  {
    path: '',
    component: RolDemo,
    children: [
      { path: '', redirectTo: 'administrar', component: RolAdministrarDemo },
      {
        path: 'administrar',
        component: RolAdministrarDemo,
      },
      {
        path: 'agregar',
        component: RoleAgregarFormDemo,
      },
      {
        path: 'editar/:id',
        component: RolEditarFormDemo,
      },
      {
        path: 'eliminar/:id',
        component: RolEliminarFormDemo,
      },
    ],
  },
];

export const ROUTING: ModuleWithProviders = RouterModule.forChild(ROUTES);
