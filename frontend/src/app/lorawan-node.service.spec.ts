import { TestBed } from '@angular/core/testing';

import { LorawanNodeService } from './lorawan-node.service';

describe('LorawanNodeService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: LorawanNodeService = TestBed.get(LorawanNodeService);
    expect(service).toBeTruthy();
  });
});
