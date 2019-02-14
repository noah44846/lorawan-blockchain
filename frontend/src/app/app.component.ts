import { Component, OnInit } from '@angular/core';

import { Map, View, Feature } from 'ol';
import { Tile as TileLayer, Vector as VectorLayer } from 'ol/layer';
import { OSM, Vector as VectorSource } from 'ol/source';
import { Point } from 'ol/geom';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css']
})

export class AppComponent implements OnInit {
    lat = 51.678418;
    lng = 7.809007;

    map: any;

    ngOnInit() {
        // const pointFeature = new Feature(new Point([46.804868, 7.160815]));

        this.map = new Map({
            target: 'map',
            layers: [
                new TileLayer({
                    source: new OSM()
                }),
                // new VectorLayer({
                //     source: new VectorSource({
                //         features: [pointFeature]
                //     })
                // })
            ],
            view: new View({
                center: [0, 0],
                zoom: 2
            })
        });
    }
}
