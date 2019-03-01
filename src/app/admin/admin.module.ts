/** PSG Module **/
import { NgModule, LOCALE_ID } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { AdminComponent } from './admin.component';
import { AdminDashboardComponent } from './admin-dashboard.component';
import { AdminRoutingModule } from './admin-routing.module';
import { HttpClientModule } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { SelectivePreloadingStrategy } from './selective-preloading-strategy';

import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { DataTableModule } from './data-table';

import localeMx from '@angular/common/locales/es-MX';
import { registerLocaleData } from '@angular/common';
registerLocaleData(localeMx, 'es-MX');

// import { DireccionDemoModule } from './direccion/direccion.psg.module';
// import { DireccionService } from './direccion/direccion.psg.service';
// import { AfiliadoDemoModule } from './afiliado/afiliado.psg.module';
// import { AfiliadoService } from './afiliado/afiliado.psg.service';
// import { TipopensionDemoModule } from './tipopension/tipopension.psg.module';
// import { TipopensionService } from './tipopension/tipopension.psg.service';
// import { SolicitudpensionDemoModule } from './solicitudpension/solicitudpension.psg.module';
// import { SolicitudpensionService } from './solicitudpension/solicitudpension.psg.service';
// import { BeneficiarioDemoModule } from './beneficiario/beneficiario.psg.module';
// import { BeneficiarioService } from './beneficiario/beneficiario.psg.service';

import { PermissionDemoModule } from './permission/permission.psg.module';
import { UserDemoModule } from './user/user.psg.module';
import { AdministracionDemoModule } from './administracion/administracion.psg.module';
import { TopNavBarComponent } from './top-nav-bar/top-nav-bar.component';
import { FooterComponent } from './footer/footer.component';

// import { AfiliadoDemoModule } from './afiliado/afiliado.psg.module';
// import { AfiliadoService } from './afiliado/afiliado.psg.service';
import { ControlMessagesComponent } from './control-messages.component';
import { ValidationService } from './validation-service.component';
// import { UsersComponent } from './users/user.component';
import { AfiliadoComponent } from './afiliado/afiliado.component';
import { AfiliadoService } from './afiliado/afiliado.component.service';
import { AfiliadoEditarComponent } from './afiliado-editar/afiliado.component';
import { AfiliadoEliminarComponent } from './afiliado-eliminar/afiliado.component';
import { AfiliadoAdministrarComponent } from './afiliado-administrar/afiliado.component';
// import { ValidationService } from './validation-service.component';
// import { ControlMessagesComponent } from './control-messages.component';
// import { SearchAfiliadoPipe } from './afiliado/afiliado.psg.pipe';



@NgModule({
  imports: [
    DataTableModule,
    AdminRoutingModule,
    CommonModule,
    ReactiveFormsModule,
    FormsModule,
    HttpClientModule,
    // AfiliadoDemoModule,
    PermissionDemoModule,
    UserDemoModule,
    AdministracionDemoModule,
    NgbModule
  ],
  declarations: [
    AdminComponent, 
    AdminDashboardComponent,
    // Menu & Footer
    TopNavBarComponent,
    FooterComponent,
    // Component
    AfiliadoComponent,
    AfiliadoEditarComponent,
    AfiliadoEliminarComponent,
    AfiliadoAdministrarComponent,
    ControlMessagesComponent
  ],
  providers: [
    AfiliadoService,
    SelectivePreloadingStrategy,
    ValidationService,
    [{ provide: LOCALE_ID, useValue: 'es-MX' }],
  ],
})
export class AdminModule {}
