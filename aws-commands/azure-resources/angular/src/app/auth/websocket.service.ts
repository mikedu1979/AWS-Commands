import { Injectable } from '@angular/core';
import { webSocket, WebSocketSubject } from 'rxjs/webSocket';
import { environment } from '../../environments/environment';
import { TokenHolder } from './token-holder.service';

export interface WebSocketMessage {
    action: string;
    value: string;
}

@Injectable({
  providedIn: 'root'
})
export class WebsocketServiceService {
  subject: WebSocketSubject<WebSocketMessage>;
  constructor(public token: TokenHolder) {
    console.log(`connect to ${environment.webSocketUri}`);
    this.subject = webSocket(`${environment.webSocketUri}?token=${token.Access}`);
    this.subject.subscribe( item => {
      console.log('incoming:', item);
    });
  }
}
