import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { SelectivePreloadingStrategy } from './selective-preloading-strategy';

@Component({
  template: `
  <div style="height:600px">
    <div class="page-title" style="background: #F7F7F7;">
    <div class="title_left">
      <h3>Home</h3>
    </div>
  </div>
  </div>
  `,
})
export class AdminDashboardComponent implements OnInit {
  sessionId: Observable<string>;
  token: Observable<string>;
  modules: string[];

  constructor(private route: ActivatedRoute, private preloadStrategy: SelectivePreloadingStrategy) {
    this.modules = preloadStrategy.preloadedModules;
  }

  ngOnInit() {
    // Capture the session ID if available
    this.sessionId = this.route.queryParamMap.pipe(map(params => params.get('session_id') || 'None'));

    // Capture the fragment if available
    this.token = this.route.fragment.pipe(map(fragment => fragment || 'None'));
  }
}
