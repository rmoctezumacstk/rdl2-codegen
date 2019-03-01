/** PSG Routing **/
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AdminComponent } from './admin.component';
import { AdminDashboardComponent } from './admin-dashboard.component';
import { AuthGuard } from '../_guards';
// import { UsersComponent } from './users/user.component';
import { AfiliadoComponent } from './afiliado/afiliado.component';
import { AfiliadoEditarComponent } from './afiliado-editar/afiliado.component';
import { AfiliadoEliminarComponent } from './afiliado-eliminar/afiliado.component';
import { AfiliadoAdministrarComponent } from './afiliado-administrar/afiliado.component';
//import { AfiliadoComponent } from './afiliado/afiliado.component';

const adminRoutes: Routes = [
  {
    path: '',
    component: AdminComponent,
    canActivate: [AuthGuard],
    children: [

          {
            path: 'afiliado',
            //loadChildren: 'src/app/admin/afiliado/afiliado.psg.module#AfiliadoDemoModule',
            component: AfiliadoComponent
          },

          {
            path: 'afiliado-editar',
            //loadChildren: 'src/app/admin/afiliado/afiliado.psg.module#AfiliadoDemoModule',
            component: AfiliadoEditarComponent
          },

          {
            path: 'afiliado-eliminar',
            //loadChildren: 'src/app/admin/afiliado/afiliado.psg.module#AfiliadoDemoModule',
            component: AfiliadoEliminarComponent
          },

          {
            path: 'afiliado-administrar',
            //loadChildren: 'src/app/admin/afiliado/afiliado.psg.module#AfiliadoDemoModule',
            component: AfiliadoAdministrarComponent
          },
          // Seguridad
          {
            path: 'administracion',
            loadChildren: 'src/app/admin/administracion/administracion.psg.module#AdministracionDemoModule',
          },
          {
            path: 'user',
            loadChildren: 'src/app/admin/user/user.psg.module#UserDemoModule',
          },
          {
            path: 'rol',
            loadChildren: 'src/app/admin/rol/rol.psg.module#RolDemoModule',
          },
          {
            path: 'permission',
            loadChildren: 'src/app/admin/permission/permission.psg.module#PermissionDemoModule',
          },
        ],
      },
];

@NgModule({
  imports: [RouterModule.forChild(adminRoutes)],
  exports: [RouterModule],
})
export class AdminRoutingModule {}
