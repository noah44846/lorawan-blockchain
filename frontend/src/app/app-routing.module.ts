import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { LorawanNodesComponent } from './lorawan-nodes/lorawan-nodes.component';
import { LorawanNodeDetailComponent } from './lorawan-node-detail/lorawan-node-detail.component';

const routes: Routes = [
    { path: '', redirectTo: '/lorawan-nodes', pathMatch: 'full' },
    { path: 'lorawan-nodes', component: LorawanNodesComponent },
    { path: 'detail/:id', component: LorawanNodeDetailComponent }
];

@NgModule({
    imports: [ RouterModule.forRoot(routes) ],
    exports: [ RouterModule ]
})
export class AppRoutingModule {
}
