import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';

import { Coordinate, Feature, Map, View } from 'ol';
import { addLayers } from 'ol/Map';
import { Tile as TileLayer, Vector as VectorLayer } from 'ol/layer';
import { OSM, Vector as VectorSource } from 'ol/source';
import { LineString, Point } from 'ol/geom';
import { fromLonLat, Projection } from 'ol/proj';

import { LorawanNode } from '../lorawan-node';
import { LorawanNodeService } from '../lorawan-node.service';

@Component({
    selector: 'app-lorawan-node-detail',
    templateUrl: './lorawan-node-detail.component.html',
    styleUrls: ['./lorawan-node-detail.component.css']
})
export class LorawanNodeDetailComponent implements OnInit {
    lorawanNode: LorawanNode;

    map: any;

    constructor(
        private route: ActivatedRoute,
        private location: Location,
        private lorawanNodeService: LorawanNodeService
    ) {}

    ngOnInit() {
        this.getLorawanNode();
        this.mapInit(this.lorawanNode.posArr);
    }

    getLorawanNode(): void {
        const id = +this.route.snapshot.paramMap.get('id');
        this.lorawanNode = this.lorawanNodeService.getNode(id);
    }

    goBack(): void {
        this.location.back();
    }

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
}
