/* PSG  Afiliado Routing */
import { ModuleWithProviders } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PermissionDemo } from './permission.psg';
import { PermissionAdministrarDemo } from './administrar/permission-administrar';

const ROUTES: Routes = [
  {
    path: '',
    component: PermissionDemo,
    children: [
      { path: '', redirectTo: 'administrar', component: PermissionAdministrarDemo },
      {
        path: 'administrar',
        component: PermissionAdministrarDemo,
      },
    ],
  },
];

export const ROUTING: ModuleWithProviders = RouterModule.forChild(ROUTES);
