import { Injectable } from '@angular/core';
import { Router, CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private router: Router) {}
  token: string = '';

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['access_token'];

    if (this.token) {
      return true;
    }
    // if (localStorage.getItem('currentUser')) {
    //   // logged in so return true
    //   return true;
    // }

    // not logged in so redirect to login page with the return url
    this.router.navigate(['/login'], { queryParams: { returnUrl: state.url } });
    return false;
  }
}
