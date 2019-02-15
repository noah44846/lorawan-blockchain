import { Component, OnInit } from '@angular/core';

import { LorawanNode } from '../lorawan-node';
import { LorawanNodeService } from '../lorawan-node.service';

@Component({
  selector: 'app-lorawan-nodes',
  templateUrl: './lorawan-nodes.component.html',
  styleUrls: ['./lorawan-nodes.component.css']
})
export class LorawanNodesComponent implements OnInit {
    lorawanNodes: LorawanNode[];

    constructor(private lorawanNodeService: LorawanNodeService) {}

    ngOnInit(): void {
        this.lorawanNodes = this.lorawanNodeService.getNodes();
    }
}
