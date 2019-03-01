/* PSG  User Routing */
import { ModuleWithProviders } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { UserDemo } from './user.psg';
import { UserAdministrarDemo } from './administrar/user-administrar';
import { UserAgregarFormDemo } from './agregar/user-agregar-form';
import { UserEditarFormDemo } from './editar/user-editar-form';
import { UserEliminarFormDemo } from './eliminar/user-eliminar-form';


const ROUTES: Routes = [
  {
    path: '',
    component: UserDemo,
    children: [
      { path: '', redirectTo: 'administrar', component: UserAdministrarDemo },
      {
        path: 'administrar',
        component: UserAdministrarDemo,
      },
      {
        path: 'agregar',
        component: UserAgregarFormDemo,
      },
      {
        path: 'editar/:id',
        component: UserEditarFormDemo,
      },
      {
        path: 'eliminar/:id',
        component: UserEliminarFormDemo,
      },
    ],
  },
];

export const ROUTING: ModuleWithProviders = RouterModule.forChild(ROUTES);
