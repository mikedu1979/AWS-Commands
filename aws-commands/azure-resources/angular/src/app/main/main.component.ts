import { Component, OnInit } from '@angular/core';
import { WebsocketServiceService } from '../auth/websocket.service';

@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements OnInit {

  constructor(public websocket: WebsocketServiceService) {
    
   }

  ngOnInit(): void {
    console.log('send message');
    this.websocket.subject.next({
      action: 'echo',
      value: 'message'
    });
  }

}
