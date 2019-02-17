import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LorawanNodesComponent } from './lorawan-nodes.component';

describe('LorawanNodesComponent', () => {
  let component: LorawanNodesComponent;
  let fixture: ComponentFixture<LorawanNodesComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ LorawanNodesComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LorawanNodesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
