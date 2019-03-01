/* PSG  User Service */
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from '../../../environments/environment';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { User } from './user.psg.model';

@Injectable()
export class UserService {
  private env: any = environment;
  private token: string;
  user = new User();
  
  constructor(private http: HttpClient) {}

postGuardaUser(user) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http.post<any>(`${environment.apiUrl}/auth/users`, user, { headers: headers }).pipe(map(res => res));
  }

  getRecuperaUser() {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http.get<any>(`${environment.apiUrl}/auth/users`, { headers: headers }).pipe(map(res => res));
  }

  getRecuperaUserPorId(id) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http.get<any>(`${environment.apiUrl}/auth/users/` + id, { headers: headers }).pipe(map(res => res));
  }

  deleteUser(id) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http.delete<any>(`${environment.apiUrl}/auth/users/` + id, { headers: headers }).pipe(map(res => res));
  }

  updateEditaUser(user, id) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['token'];
    let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
    return this.http
      .put<any>(`${environment.apiUrl}/auth/users/` + id, user, { headers: headers })
      .pipe(map(res => res));
  }
  
getRecuperaUserPorDireccion(id){
  var obj = JSON.parse(localStorage.getItem('currentUser'));
  this.token = obj['token'];
  let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  return this.http.get<any>(`${environment.apiUrl}/auth/users?direccionId=`+ id, { headers: headers }).pipe(map(res => res));    
}		
getRecuperaUserPorTipopension(id){
  var obj = JSON.parse(localStorage.getItem('currentUser'));
  this.token = obj['token'];
  let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  return this.http.get<any>(`${environment.apiUrl}/auth/users?tipopensionId=`+ id, { headers: headers }).pipe(map(res => res));    
}		
getRecuperaUserPorSolicitudpension(id){
  var obj = JSON.parse(localStorage.getItem('currentUser'));
  this.token = obj['token'];
  let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  return this.http.get<any>(`${environment.apiUrl}/auth/users?solicitudpensionId=`+ id, { headers: headers }).pipe(map(res => res));    
}		
getRecuperaUserPorBeneficiario(id){
  var obj = JSON.parse(localStorage.getItem('currentUser'));
  this.token = obj['token'];
  let headers = new HttpHeaders().set('Authorization', 'Bearer ' + this.token);
  return this.http.get<any>(`${environment.apiUrl}/auth/users?beneficiarioId=`+ id, { headers: headers }).pipe(map(res => res));    
}		

  resetUser(): User {
    this.clear();
    return this.user;
  }

  getUser(): User {
    var user: User = {
  		username: this.user.username,
  		display_name: this.user.display_name,
  		email: this.user.email,
  		password: this.user.password,
  		enabled: this.user.enabled	,
  		roleId: this.user.roleId
    };
    return user;
  }

  setUser(user: User) {
  		this.user.username = user.username;
  		this.user.display_name = user.display_name;
  		this.user.email = user.email;
  		this.user.password = user.password;
  		this.user.enabled = user.enabled;
  		this.user.roleId = user.roleId;
  }

  clear() {
this.user.username = null;
this.user.display_name = null;
this.user.email = null;
this.user.password = null;
this.user.enabled = null;
this.user.roleId = null;
  }
}
