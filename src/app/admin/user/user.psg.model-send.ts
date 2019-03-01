/* PSG  User Model */
import { DecimalPipe } from '@angular/common';

export class UserSend {
		
	username: string = null;
	display_name: string = null;
    email: string = null;
    password: string = null;
    enabled: boolean= false;
	roleId: string = null;
}
