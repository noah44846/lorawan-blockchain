import { Component, OnInit } from '@angular/core';

import { Map, View, Feature, PluggableMap } from 'ol';
import { addLayers } from 'ol/Map'
import { Tile as TileLayer, Vector as VectorLayer } from 'ol/layer';
import { OSM, Vector as VectorSource } from 'ol/source';
import { Point, MultiPoint, LineString } from 'ol/geom';
import { Projection } from 'ol/proj';

import { LorawanNode } from './lorawan-node';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css']
})

export class AppComponent implements OnInit {
    lorawanNode1: LorawanNode = {
        id: 1,
        pos: [
            [7.115815, 46.903630],
            [7.126319, 46.907658],
            [7.129355, 46.912723],
            [7.128455, 46.913144]
        ]
    };

    ngOnInit() {

    }
}
