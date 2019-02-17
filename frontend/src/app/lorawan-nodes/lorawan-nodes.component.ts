import { Component, OnInit } from '@angular/core';

import { LorawanNodeService } from '../lorawan-node.service';

@Component({
  selector: 'app-lorawan-nodes',
  templateUrl: './lorawan-nodes.component.html',
  styleUrls: ['./lorawan-nodes.component.css']
})
export class LorawanNodesComponent implements OnInit {
    lorawanNodeIds: number[];

    constructor(private lorawanNodeService: LorawanNodeService) {}

    ngOnInit(): void {
        this.lorawanNodeIds = this.lorawanNodeService.getNodeIds();
    }
}
