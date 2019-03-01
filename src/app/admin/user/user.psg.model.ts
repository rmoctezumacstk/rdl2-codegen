/* PSG  User Model */
import { DecimalPipe } from '@angular/common';
import { Rol } from '../rol/rol.psg.model';

export class User {
	username: string = null;
	display_name: string = null;
    email: string = null;
    password: string = null;
    enabled: boolean= false;
    roleId: Rol;
}
