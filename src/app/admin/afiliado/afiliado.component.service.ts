/* PSG  Afiliado Service */
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { Afiliado } from './afiliado.component.model';

@Injectable()
export class AfiliadoService {
  
  private env: any = environment;
  private token: string;
  
  afiliado = new Afiliado();

  constructor(private http: HttpClient) {}

  postGuardaAfiliado(afiliado) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .post<any>(`${environment.apiUrl}/condominium/afiliado`, afiliado, { headers: headers })
      .pipe(map(res => res));
  }

  getRecuperaAfiliado() {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http.get<any>(`${environment.apiUrl}/condominium/afiliado`, { headers: headers }).pipe(map(res => res));
  }

  getRecuperaAfiliadoPorId(id) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .get<any>(`${environment.apiUrl}/condominium/afiliado/` + id, { headers: headers })
      .pipe(map(res => res));
  }

  deleteAfiliado(id) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .delete<any>(`${environment.apiUrl}/condominium/afiliado/` + id, { headers: headers })
      .pipe(map(res => res));
  }

  updateEditaAfiliado(afiliado, id) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .put<any>(`${environment.apiUrl}/condominium/afiliado/` + id, afiliado, { headers: headers })
      .pipe(map(res => res));
  }

  getRecuperaAfiliadoPorDireccion(id) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .get<any>(`${environment.apiUrl}/condominium/afiliado?direccionId=` + id, { headers: headers })
      .pipe(map(res => res));
  }
  getRecuperaAfiliadoPorTipopension(id) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .get<any>(`${environment.apiUrl}/condominium/afiliado?tipopensionId=` + id, { headers: headers })
      .pipe(map(res => res));
  }
  getRecuperaAfiliadoPorSolicitudpension(id) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .get<any>(`${environment.apiUrl}/condominium/afiliado?solicitudpensionId=` + id, { headers: headers })
      .pipe(map(res => res));
  }
  getRecuperaAfiliadoPorBeneficiario(id) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .get<any>(`${environment.apiUrl}/condominium/afiliado?beneficiarioId=` + id, { headers: headers })
      .pipe(map(res => res));
  }

  resetAfiliado(): Afiliado{

    this.afiliado.nss = null;
    this.afiliado.nombre = null;
    this.afiliado.apellido_paterno = null;
    this.afiliado.apellido_materno = null;
    this.afiliado.genero = null;
    this.afiliado.observaciones = null;
    this.afiliado.fecha_afiliacion = null;
    this.afiliado.foto = null;
    this.afiliado.acta_nacimiento = null;
    this.afiliado.email = null;
    this.afiliado.semanas_cotizadas = null;
    this.afiliado.monto_pension = null;
    this.afiliado.dato_decimal = null;

    return this.afiliado;

  }
  
  getAfiliado(): Afiliado {
    var afiliado: Afiliado = {
      nss: this.afiliado.nss,
      nombre: this.afiliado.nombre,
      apellido_paterno: this.afiliado.apellido_paterno,
      apellido_materno: this.afiliado.apellido_materno,
      genero: this.afiliado.genero,
      observaciones: this.afiliado.observaciones,
      fecha_afiliacion: this.afiliado.fecha_afiliacion,
      foto: this.afiliado.foto,
      acta_nacimiento: this.afiliado.acta_nacimiento,
      email: this.afiliado.email,
      semanas_cotizadas: this.afiliado.semanas_cotizadas,
      monto_pension: this.afiliado.monto_pension,
      dato_decimal: this.afiliado.dato_decimal
    };
    return afiliado;
  }

  setAfiliado(afiliado: Afiliado) {
    this.afiliado.nss = afiliado.nss;
    this.afiliado.nombre = afiliado.nombre;
    this.afiliado.apellido_paterno = afiliado.apellido_paterno;
    this.afiliado.apellido_materno = afiliado.apellido_materno;
    this.afiliado.genero = afiliado.genero;
    this.afiliado.observaciones = afiliado.observaciones;
    this.afiliado.fecha_afiliacion = afiliado.fecha_afiliacion;
    this.afiliado.foto = afiliado.foto;
    this.afiliado.acta_nacimiento = afiliado.acta_nacimiento;
    this.afiliado.email = afiliado.email;
    this.afiliado.semanas_cotizadas = afiliado.semanas_cotizadas;
    this.afiliado.monto_pension = afiliado.monto_pension;
    this.afiliado.dato_decimal = afiliado.dato_decimal;
 
  }


}
