import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { Routes, RouterModule } from '@angular/router';
//import { appRoutes } from './app.routing';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';

import { AppComponent } from './app.component';
// import { TopNavBarComponent } from './top-nav-bar/top-nav-bar.component';
// import { Link1Component } from './link1/link1.component';
// import { Link2Component } from './link2/link2.component';
// import { Link3Component } from './link3/link3.component';

// import { DataTableModule } from './data-table';
import { CommonModule } from '@angular/common';
// import { UserComponent } from './user/user.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
// import { ModalComponent } from './modal/modal.component';
// import { DropdownComponent } from './dropdown/dropdown.component';
// import { FooterComponent } from './footer/footer.component';
// import { AfiliadoComponent } from './afiliado/afiliado.component';
// import { BeneficiarioComponent } from './beneficiario/beneficiario.component';
// import { AfiliadoService } from './afiliado/afiliado.component.service';

import { ROUTING } from './app.routing';
import { RegisterComponent } from './register';
import { LoginComponent } from './login/login.demo';
import { AuthGuard } from './_guards';
import { AlertService, AuthenticationService, UserService } from './_services';
import { JwtInterceptor, ErrorInterceptor } from './_helpers';

@NgModule({
  declarations: [
    // AppComponent,
    // TopNavBarComponent,
    // Link1Component,
    // Link2Component,
    // Link3Component,
    // UserComponent,
    // ModalComponent,
    // DropdownComponent,
    // FooterComponent,
    // ControlMessagesComponent,
    // AfiliadoComponent,
    // BeneficiarioComponent
    AppComponent,
    RegisterComponent,
    LoginComponent,
    // UserComponent
  ],
  imports: [
    NgbModule,
    BrowserModule,
    FormsModule,
    CommonModule, 
    // DataTableModule,
    HttpClientModule,
    ReactiveFormsModule,
    ROUTING
    //RouterModule.forRoot(appRoutes)
  ],
  providers: [
    AuthGuard,
    AlertService,
    AuthenticationService,
    UserService,
    { provide: HTTP_INTERCEPTORS, useClass: JwtInterceptor, multi: true },
    { provide: HTTP_INTERCEPTORS, useClass: ErrorInterceptor, multi: true },
    // ValidationService,
    // AfiliadoService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
