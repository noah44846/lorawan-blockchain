import { Component, OnInit, Input } from '@angular/core';

import { Map, View, Feature, Coordinate } from 'ol';
import { addLayers } from 'ol/Map'
import { Tile as TileLayer, Vector as VectorLayer } from 'ol/layer';
import { OSM, Vector as VectorSource } from 'ol/source';
import { Point, LineString } from 'ol/geom';
import { Projection, fromLonLat } from 'ol/proj';

import { LorawanNode } from '../lorawan-node';

@Component({
    selector: 'app-lorawan-node-detail',
    templateUrl: './lorawan-node-detail.component.html',
    styleUrls: ['./lorawan-node-detail.component.css']
})
export class LorawanNodeDetailComponent implements OnInit {
    @Input() lorawanNode: LorawanNode;

    map: any;

    mapInit(pos: Coordinate[]) {
        const lastPos = pos[pos.length - 1];
        const line = new LineString(pos);
        const point = new Point(lastPos);

        line.transform('EPSG:4326', 'EPSG:900913');
        point.transform('EPSG:4326', 'EPSG:900913');

        const PointFeature = new Feature({
            geometry: point,
            name: 'Point'
        });
        const lineFeature = new Feature({
            geometry: line,
            name: 'line'
        });

        this.map = new Map({
            target: 'map',
            layers: [
                new TileLayer({
                    source: new OSM()
                }),
                new VectorLayer({
                    source: new VectorSource({
                        features: [
                            lineFeature,
                            PointFeature
                        ]
                    })
                })
            ],
            view: new View({
                center: fromLonLat(lastPos),
                zoom: 15
            })
        });
    }

    ngOnInit() {
        this.mapInit(this.lorawanNode.pos);
    }

}
