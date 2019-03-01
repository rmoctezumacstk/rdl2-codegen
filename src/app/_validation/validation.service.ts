import { AbstractControl } from '@angular/forms';
export class ValidationService {
  static getValidatorErrorMessage(validatorName: string, validatorValue?: any) {
    let config = {
      required: 'Este campo es requerido',
      invalidCreditCard: 'Número de tarjeta inválido',
      invalidEmailAddress: 'Formato de email incorrecto',
      //'invalidPassword': 'Invalid password. Password must be at least 6 characters long, and contain a number.',
      //'minlength': `Minimum length ${validatorValue.requiredLength}`
      minlength: `Longitud mínima ${validatorValue.requiredLength}`,
      maxlength: `Longitud máxima ${validatorValue.requiredLength}`,
      invalidSelectValue: 'Valor inválido',
      invalidCheckValue: 'Selecciona uno o todos',
      invalidNumbers: 'Solo se admiten números',
      numberInvalid: 'Números menos a 2,147,483,648',
      invalidPassordUser:
        'Verificar password, debe contener 1 mayúscula, 1 número, mínimo 8 caracteres y caracter especial',
    };
    return config[validatorName];
  }

  static emailValidator(control) {
    let EMAIL_REGEXP = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/;

    if (EMAIL_REGEXP.test(control.value)) {
      return null;
    } else {
      return { invalidEmailAddress: true };
    }
  }

  static passwordValidator(control) {
    let PASSWORD_REGEXP = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

    if (PASSWORD_REGEXP.test(control.value)) {
      return null;
    } else {
      return { invalidPassordUser: true };
    }
  }

  static onlyNumbers(control) {
    let EMAIL_REGEXP = /^[0-9]+$/;

    if (EMAIL_REGEXP.test(control.value)) {
      return null;
    } else {
      return { invalidNumbers: true };
    }
  }

  static numberMinor(control) {
    let number = 2147483648;

    if (control.value <= number) {
      return null;
    } else {
      return { numberInvalid: true };
    }
  }

  /*
    static passwordValidator(control) {
        // {6,100}           - Assert password is between 6 and 100 characters
        // (?=.*[0-9])       - Assert a string has at least one number
        if (control.value.match(/^(?=.*[0-9])[a-zA-Z0-9!@#$%^&*]{6,100}$/)) {
            return null;
        } else {
            return { 'invalidPassword': true };
        }
    }
    */

  static selectValidator(control) {
    if (control.value != -1) {
      return null;
    } else {
      return { invalidSelectValue: true };
    }
  }

  static countrySelectValidator(control) {
    if (control.value != -1) {
      return null;
    } else {
      return { invalidSelectValue: true };
    }
  }

  static checkValidator(control) {
    if (control.value) {
      return null;
    } else {
      return { invalidCheckValue: true };
    }
  }
}
