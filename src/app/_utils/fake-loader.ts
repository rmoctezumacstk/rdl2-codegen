import { Directive, Input, OnInit, TemplateRef, ViewContainerRef } from '@angular/core';

const LATENCY = 2000;

@Directive({ selector: '[clrFakeLoader]' })
export class FakeLoader implements OnInit {
  constructor(private template: TemplateRef<any>, private container: ViewContainerRef) {}

  @Input('clrFakeLoader') fake: boolean;

  ngOnInit() {
    if (this.fake) {
      // this.loading.loadingState = ClrLoadingState.LOADING;
      setTimeout(() => {
        this.load();
        // this.loading.loadingState = ClrLoadingState.DEFAULT;
      }, LATENCY);
    } else {
      this.load();
    }
  }

  private load() {
    this.container.createEmbeddedView(this.template);
  }
}
