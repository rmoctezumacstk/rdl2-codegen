import { Component, OnInit } from '@angular/core';
import { DataTableResource } from '../data-table';
import persons from './data-table-demo-data';
import { User } from 'src/app/_models';
import { Permission } from 'src/app/_models/permission';
import { Router, ActivatedRoute } from '@angular/router';
import { AfiliadoService } from '../afiliado/afiliado.component.service';
import { Afiliado } from '../afiliado/afiliado.component.model';


@Component({
  selector: 'app-user',
  templateUrl: './user.component.html',
  styleUrls: ['./user.component.css']
})
export class AfiliadoAdministrarComponent implements OnInit {

    // Permisos
    token: string;
    user: User;
    permissions: Permission[];

    afiliadoArray: Afiliado[];
    afiliado: Afiliado;
  
    private afiliado_update: boolean = false;
    private afiliado_delete: boolean = false;
    private afiliado_create: boolean = false;
    private afiliado_read: boolean = false;

    constructor(
      private router: Router,
      private route: ActivatedRoute,
      private afiliadoService: AfiliadoService,
  
    ) {
      this.itemResource.count().then(count => this.itemCount = count);
    }

  ngOnInit() {
    this.getUser();
    this.setButtons();
    this.cargaAfiliado();

    
  }

  itemResource = new DataTableResource(persons);
  // itemResource = null;
  items = [];
  itemCount = 0;

  

  cargaAfiliado() {
    this.afiliadoService.getRecuperaAfiliado().subscribe(
      res => {
        if (res) {
          this.afiliadoArray = res;

          console.log('Afiliado: ', this.afiliadoArray);
          // this.itemResource = new DataTableResource(persons);
          // this.itemResource.count().then(count => this.itemCount = count);
        }
      },
      error => {
        // swal('Error...', 'An error occurred while calling the beneficiario.', 'error');
      }
    );
  }


  reloadItems(params) {
       this.itemResource.query(params).then(items => this.items = items);
  }


  rowClick(rowEvent) {
      console.log('Clicked: ' + rowEvent.row.item.name);
  }

  rowDoubleClick(rowEvent) {
      alert('Double clicked: ' + rowEvent.row.item.name);
  }

  rowTooltip(item) { return item.jobTitle; }


  getUser() {
    var obj = JSON.parse(localStorage.getItem('currentUser'));
    this.token = obj['access_token'];
    this.permissions = obj['permissions'];
    this.user = obj['user'];
  }

  setButtons() {
    this.permissions.forEach(element => {
      if (element.code == '*:*') {
        this.afiliado_create = true;
        this.afiliado_delete = true;
        this.afiliado_update = true;
        this.afiliado_read = true;
      }

      if (element.code == 'afiliado:UPDATE') {
        this.afiliado_update = true;
      }

      if (element.code == 'afiliado:DELETE') {
        this.afiliado_delete = true;
      }

      if (element.code == 'afiliado:READ') {
        this.afiliado_read = true;
      }

      if (element.code == 'afiliado:CREATE') {
        this.afiliado_create = true;
      }

      if (element.code == 'afiliado:*') {
        this.afiliado_update = true;
        this.afiliado_create = true;
        this.afiliado_delete = true;
        this.afiliado_read = true;
      }
    });
  }
}
