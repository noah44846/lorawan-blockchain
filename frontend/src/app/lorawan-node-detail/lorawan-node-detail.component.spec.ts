import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LorawanNodeDetailComponent } from './lorawan-node-detail.component';

describe('LorawanNodeDetailComponent', () => {
  let component: LorawanNodeDetailComponent;
  let fixture: ComponentFixture<LorawanNodeDetailComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ LorawanNodeDetailComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LorawanNodeDetailComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
