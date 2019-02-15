import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { LorawanNodeDetailComponent } from './lorawan-node-detail/lorawan-node-detail.component';
import { AppRoutingModule } from './app-routing.module';
import { LorawanNodesComponent } from './lorawan-nodes/lorawan-nodes.component';

@NgModule({
    declarations: [
        AppComponent,
        LorawanNodeDetailComponent,
        LorawanNodesComponent
    ],
    imports: [
        BrowserModule,
        AppRoutingModule,

    ],
    providers: [],
    bootstrap: [AppComponent]
})
export class AppModule {
}
