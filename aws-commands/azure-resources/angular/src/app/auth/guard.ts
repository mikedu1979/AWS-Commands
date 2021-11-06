import { ActivatedRouteSnapshot, CanActivate, Router, RouterStateSnapshot } from "@angular/router";
import { TokenHolder } from "./token-holder.service";
import { environment } from '../../environments/environment';
import { Injectable } from "@angular/core";

class GuardBase implements CanActivate {
    constructor(public token: TokenHolder, public router: Router) {}
    canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot){
        let canAccess = this.check();
        if(canAccess){
            console.log('Can Access!');
            return canAccess;
        }
        else {
            // in case of unauthenticated, go to OAuth2 url
            // try to get the access_token from the query string
            let fragment = route.fragment;
            console.log('fragment', fragment)
            let search = new URLSearchParams(fragment);
            if(search.has('access_token') && search.has('token_type') && search.has('expires_in')){
                search.forEach((value, key)=>{
                    console.log(`${key}:`, value);
                })
                console.log('id_token:', search.get('id_token'));
                // console.log('refresh_token:', search.get('refresh_token'));
                this.token.Access = search.get('access_token');
                this.token.Id = search.get('id_token');
                this.token.Type = search.get('token_type') as any;
                // this.token.Expires = Number(search.get('expires_in') as any) * 1000 + Date.now();
                this.token.JWTVerify();
                //  console.log('route.routeConfig?.path:', route.routeConfig?.path);
                this.router.navigateByUrl(route.routeConfig?.path ? route.routeConfig.path : '');
                return true;
            }
            else {
                let loginUrl = `${environment.authUri}/oauth2/authorize?client_id=${environment.clientId}&response_type=token&redirect_uri=http://localhost:4200&state=STATE`;
                console.log('loginUrl:', loginUrl);
                window.location.href = loginUrl;
                return false;
            }
        }
    }
    check = () => false;
}

@Injectable({providedIn: 'root'})
export class AdminGuard extends GuardBase {
    constructor(public token: TokenHolder, public router: Router) { 
        super(token, router);
    }
    check = () => {
        return this.token.Access && this.token.Expires >= Date.now() && this.token.Groups.indexOf('Administrators') >= 0 ? true : false;
    }
}

@Injectable({providedIn: 'root'})
export class AnyGuard extends GuardBase {
    constructor(public token: TokenHolder, public router: Router) { 
        super(token, router);
    }
    check = () => {
        return this.token.Access && this.token.Expires >= Date.now() ? true : false;
    }
}