import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AnyGuard } from './auth/guard';
import { MainComponent } from './main/main.component';

const routes: Routes = [
  {
    path: '',
    pathMatch: 'full',
    redirectTo: 'main'
  },
  {
    path: 'main',
    component: MainComponent,
    canActivate: [ AnyGuard ]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
