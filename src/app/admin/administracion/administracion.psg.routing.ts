/* PSG  Afiliado Routing */
import { ModuleWithProviders } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AdministracionDemo } from './administracion.psg';
import { AdministracionAdministrarDemo } from './administrar/administracion-administrar';

const ROUTES: Routes = [
  {
    path: '',
    component: AdministracionDemo,
    children: [
      { path: '', redirectTo: 'administrar', component: AdministracionAdministrarDemo },
      {
        path: 'administrar',
        component: AdministracionAdministrarDemo,
      },
    ],
  },
];

export const ROUTING: ModuleWithProviders = RouterModule.forChild(ROUTES);
