import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { LorawanNodeDetailComponent } from './lorawan-node-detail/lorawan-node-detail.component';

@NgModule({
    declarations: [
        AppComponent,
        LorawanNodeDetailComponent
    ],
    imports: [
        BrowserModule,

    ],
    providers: [],
    bootstrap: [AppComponent]
})
export class AppModule {
}
