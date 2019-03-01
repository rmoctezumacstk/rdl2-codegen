import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';

import { FakeLoader } from './fake-loader';

@NgModule({ imports: [CommonModule], declarations: [FakeLoader], exports: [FakeLoader] })
export class UtilsDemoModule {}
