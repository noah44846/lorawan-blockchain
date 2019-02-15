import { Injectable } from '@angular/core';

import { LorawanNode } from './lorawan-node';

@Injectable({
    providedIn: 'root'
})
export class LorawanNodeService {
    lorawanNodes: LorawanNode[] = [
        {
            id: 1,
            pos: [
                [ 7.115815, 46.903630 ],
                [ 7.126319, 46.907658 ],
                [ 7.129355, 46.912723 ],
                [ 7.128455, 46.913144 ]
            ]
        },
        {
            id: 2,
            pos: [
                [ 20.413464, -2.245611 ],
                [ 20.747472, -2.423417 ],
                [ 20.234122, -2.435378 ],
                [ 20.128455, -2.422422 ]
            ]
        },
        {
            id: 3,
            pos: [
                [ -32.304500, 12.345232 ],
                [ -32.353555, 12.645432 ],
                [ -32.664363, 12.346343 ],
                [ -32.341234, 12.434234 ]
            ]
        }
    ];

    constructor() {
    }

    getNode(id: number): LorawanNode {
        return this.lorawanNodes.find(lorawanNode => lorawanNode.id === id);
    }

    getNodes(): LorawanNode[] {
        return this.lorawanNodes;
    }
}
