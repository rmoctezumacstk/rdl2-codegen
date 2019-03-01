/* PSG  Rol Service */
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { Rol } from './rol.psg.model';
import { environment } from '../../../environments/environment';
import { HttpHeaders, HttpClient } from '@angular/common/http';

@Injectable()
export class RolService {
  private env: any = environment;
  private token: string;
  rol = new Rol();
  
  constructor(private http: HttpClient) {}

postGuardaRol(rol) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http.post<any>(`${environment.apiUrl}/auth/roles`, rol, { headers: headers }).pipe(map(res => res));
  }

  getRecuperaRol() {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http.get<any>(`${environment.apiUrl}/auth/roles`, { headers: headers }).pipe(map(res => res));
  }

  getRecuperaRolPorId(id) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http.get<any>(`${environment.apiUrl}/auth/roles/` + id, { headers: headers }).pipe(map(res => res));
  }

  deleteRol(id) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http.delete<any>(`${environment.apiUrl}/auth/roles/` + id, { headers: headers }).pipe(map(res => res));
  }

  updateEditaRol(rol, id) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .put<any>(`${environment.apiUrl}/auth/roles/` + id, rol, { headers: headers })
      .pipe(map(res => res));
  }
  
getRecuperaRolPorDireccion(id){
  var obj = JSON.parse(localStorage.getItem('currentUser'));
  this.token = obj['token'];
  let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  return this.http.get<any>(`${environment.apiUrl}/auth/roles?direccionId=`+ id, { headers: headers }).pipe(map(res => res));    
}		
getRecuperaRolPorTipopension(id){
  var obj = JSON.parse(localStorage.getItem('currentUser'));
  this.token = obj['token'];
  let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  return this.http.get<any>(`${environment.apiUrl}/auth/roles?tipopensionId=`+ id, { headers: headers }).pipe(map(res => res));    
}		
getRecuperaRolPorSolicitudpension(id){
  var obj = JSON.parse(localStorage.getItem('currentUser'));
  this.token = obj['token'];
  let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  return this.http.get<any>(`${environment.apiUrl}/auth/roles?solicitudpensionId=`+ id, { headers: headers }).pipe(map(res => res));    
}		
getRecuperaRolPorBeneficiario(id){
  var obj = JSON.parse(localStorage.getItem('currentUser'));
  this.token = obj['token'];
  let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  return this.http.get<any>(`${environment.apiUrl}/auth/roles?beneficiarioId=`+ id, { headers: headers }).pipe(map(res => res));    
}		

  resetRol(): Rol {
    this.clear();
    return this.rol;
  }

  getRol(): Rol {
    var rol: Rol = {
  		name: this.rol.name,
  		description: this.rol.description,
  		enabled: this.rol.enabled
    };
    return rol;
  }

  setRol(rol: Rol) {
  		this.rol.name = rol.name;
  		this.rol.description = rol.description;
  		this.rol.enabled = rol.enabled;
  }

  clear() {
    this.rol.name = null;
    this.rol.description = null;
    this.rol.enabled = null;
  }
}
