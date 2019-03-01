// import { Link1Component } from './link1/link1.component';
// import { Link2Component } from './link2/link2.component';
// import { Link3Component } from './link3/link3.component';
// import { Routes } from '@angular/router';
// import { UserComponent } from './user/user.component';
// import { ModalComponent } from './modal/modal.component';
// import { DropdownComponent } from './dropdown/dropdown.component';
// import { AfiliadoComponent } from './afiliado/afiliado.component';
// import { BeneficiarioComponent } from './beneficiario/beneficiario.component';

// export const appRoutes: Routes = [
//     {path: 'link1', component: Link1Component },
//     {path: 'link2', component: Link2Component },
//     {path: 'link3', component: Link3Component },
//     {path: 'user', component: UserComponent },
//     {path: 'modal', component: ModalComponent},
//     {path: 'dropdown', component: DropdownComponent},
//     {path: 'afiliado', component: AfiliadoComponent},
//     {path: 'beneficiario', component: BeneficiarioComponent}

// ]

import { ModuleWithProviders } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { AuthGuard } from './_guards';
import { LoginComponent } from './login/login.demo';
import { RegisterComponent } from './register';
import { AdminComponent } from './admin/admin.component';
// import { UserComponent } from './user/user.component';

export const APP_ROUTES: Routes = [

  {
    path: 'admin',
    loadChildren: 'src/app/admin/admin.module#AdminModule',
    canActivate: [AuthGuard],
  },

  // { path: 'user', component: UserComponent },
  { path: 'register', component: RegisterComponent },
  { path: '**', redirectTo: '', component: LoginComponent },

];

export const ROUTING: ModuleWithProviders = RouterModule.forRoot(APP_ROUTES);

