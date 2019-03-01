/* PSG  Afiliado Model */
import { DecimalPipe } from '@angular/common';
import { Permission } from './permission.psg.model';
import { Rol } from './rol.psg.model';

export class AdminPermission {
  permission: Permission = null;
  roles: Rol[] = null;
}
