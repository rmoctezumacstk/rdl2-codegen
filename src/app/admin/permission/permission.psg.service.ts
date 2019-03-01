/* PSG  Afiliado Service */
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from '../../../environments/environment';
import { HttpHeaders, HttpClient } from '@angular/common/http';

@Injectable()
export class PermissionService {
  private env: any = environment;
  private token: string;

  constructor(private http: HttpClient) {}

  getAllPrivilege() {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .get<any>(`${environment.apiUrl}/auth/permissionsvsroles`, { headers: headers })
      .pipe(map(res => res));
  }

  removePermission(permission) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .post<any>(`${environment.apiUrl}/auth/remove_role_permission`, permission, { headers: headers })
      .pipe(map(res => res));
  }

  assignPermission(permission) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .post<any>(`${environment.apiUrl}/auth/assign_role_permission`, permission, { headers: headers })
      .pipe(map(res => res));
  }

  getAllPermission() {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http.get<any>(`${environment.apiUrl}/auth/permissions`, { headers: headers }).pipe(map(res => res));
  }

  postGuardaPermission(permission) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .post<any>(`${environment.apiUrl}/auth/permissions`, permission, { headers: headers })
      .pipe(map(res => res));
  }

  //   getRecuperaAfiliado() {
  //     var obj = JSON.parse(localStorage.getItem('currentUser'));
  //     this.token = obj['token'];
  //     let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  //     return this.http.get<any>(`${environment.apiUrl}/pensiones/afiliado`, { headers: headers }).pipe(map(res => res));
  //   }

  //   getRecuperaAfiliadoPorId(id) {
  //     var obj = JSON.parse(localStorage.getItem('currentUser'));
  //     this.token = obj['token'];
  //     let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  //     return this.http.get<any>(`${environment.apiUrl}/pensiones/afiliado/` + id, { headers: headers }).pipe(map(res => res));
  //   }

  //   deleteAfiliado(id) {
  //     var obj = JSON.parse(localStorage.getItem('currentUser'));
  //     this.token = obj['token'];
  //     let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  //     return this.http.delete<any>(`${environment.apiUrl}/pensiones/afiliado/` + id, { headers: headers }).pipe(map(res => res));
  //   }

  //   updateEditaAfiliado(afiliado, id) {
  //     var obj = JSON.parse(localStorage.getItem('currentUser'));
  //     this.token = obj['token'];
  //     let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  //     return this.http
  //       .put<any>(`${environment.apiUrl}/pensiones/afiliado/` + id, afiliado, { headers: headers })
  //       .pipe(map(res => res));
  //   }

  // getRecuperaAfiliadoPorDireccion(id){
  //   var obj = JSON.parse(localStorage.getItem('currentUser'));
  //   this.token = obj['token'];
  //   let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  //   return this.http.get<any>(`${environment.apiUrl}/pensiones/afiliado?direccionId=`+ id, { headers: headers }).pipe(map(res => res));
  // }
  // getRecuperaAfiliadoPorTipopension(id){
  //   var obj = JSON.parse(localStorage.getItem('currentUser'));
  //   this.token = obj['token'];
  //   let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  //   return this.http.get<any>(`${environment.apiUrl}/pensiones/afiliado?tipopensionId=`+ id, { headers: headers }).pipe(map(res => res));
  // }
  // getRecuperaAfiliadoPorSolicitudpension(id){
  //   var obj = JSON.parse(localStorage.getItem('currentUser'));
  //   this.token = obj['token'];
  //   let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  //   return this.http.get<any>(`${environment.apiUrl}/pensiones/afiliado?solicitudpensionId=`+ id, { headers: headers }).pipe(map(res => res));
  // }
  // getRecuperaAfiliadoPorBeneficiario(id){
  //   var obj = JSON.parse(localStorage.getItem('currentUser'));
  //   this.token = obj['token'];
  //   let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  //   return this.http.get<any>(`${environment.apiUrl}/pensiones/afiliado?beneficiarioId=`+ id, { headers: headers }).pipe(map(res => res));
  // }

  //   resetAfiliado(): Afiliado {
  //     this.clear();
  //     return this.afiliado;
  //   }

  //   getAfiliado(): Afiliado {
  //     var afiliado: Afiliado = {
  //   		nss: this.afiliado.nss,
  //   		nombre: this.afiliado.nombre,
  //   		apellido_paterno: this.afiliado.apellido_paterno,
  //   		apellido_materno: this.afiliado.apellido_materno,
  //   		genero: this.afiliado.genero	,
  //   		generoItem: this.afiliado.generoItem,
  //   		observaciones: this.afiliado.observaciones,
  //   		fecha_afiliacion: this.afiliado.fecha_afiliacion,
  //   		fecha_afiliacionAux: this.afiliado.fecha_afiliacionAux,
  //   		foto: this.afiliado.foto,
  //   		acta_nacimiento: this.afiliado.acta_nacimiento,
  //   		correo: this.afiliado.correo,
  //   		semanas_cotizadas: this.afiliado.semanas_cotizadas,
  //   		numero: this.afiliado.numero,
  //   		direccioncorreoId: this.afiliado.direccioncorreoId,
  //   		direccioncorreoItem: this.afiliado.direccioncorreoItem,
  //   		domicilioId: this.afiliado.domicilioId,
  //   		domicilioItem: this.afiliado.domicilioItem,
  //     };
  //     return afiliado;
  //   }

  //   setAfiliado(afiliado: Afiliado) {
  //   		this.afiliado.nss = afiliado.nss;
  //   		this.afiliado.nombre = afiliado.nombre;
  //   		this.afiliado.apellido_paterno = afiliado.apellido_paterno;
  //   		this.afiliado.apellido_materno = afiliado.apellido_materno;
  //   		this.afiliado.genero = afiliado.genero;
  //   		this.afiliado.generoItem = afiliado.generoItem;
  //   		this.afiliado.observaciones = afiliado.observaciones;
  //   		this.afiliado.fecha_afiliacion = afiliado.fecha_afiliacion;
  //   		this.afiliado.fecha_afiliacionAux = afiliado.fecha_afiliacionAux;
  //   		this.afiliado.foto = afiliado.foto;
  //   		this.afiliado.acta_nacimiento = afiliado.acta_nacimiento;
  //   		this.afiliado.correo = afiliado.correo;
  //   		this.afiliado.semanas_cotizadas = afiliado.semanas_cotizadas;
  //   		this.afiliado.numero = afiliado.numero;
  //   		this.afiliado.direccioncorreoId = afiliado.direccioncorreoId;
  //   		this.afiliado.direccioncorreoItem = afiliado.direccioncorreoItem;
  //   		this.afiliado.domicilioId = afiliado.domicilioId;
  //   		this.afiliado.domicilioItem = afiliado.domicilioItem;
  //   }

  //   clear() {
  // this.afiliado.nss = null;
  // this.afiliado.nombre = null;
  // this.afiliado.apellido_paterno = null;
  // this.afiliado.apellido_materno = null;
  // this.afiliado.genero = null;
  // this.afiliado.generoItem = null;
  // this.afiliado.observaciones = null;
  // this.afiliado.fecha_afiliacion = null;
  // this.afiliado.fecha_afiliacionAux = null;
  // this.afiliado.foto = null;
  // this.afiliado.acta_nacimiento = null;
  // this.afiliado.correo = null;
  // this.afiliado.semanas_cotizadas = null;
  // this.afiliado.numero = null;
  // this.afiliado.direccioncorreoId = null;
  // this.afiliado.direccioncorreoItem = null;
  // this.afiliado.domicilioId = null;
  // this.afiliado.domicilioItem = null;
  //   }
}
