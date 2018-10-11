package com.softtek.generator.utils

import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.EntityTextField
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.rdl2.EntityReferenceFieldAttr
import com.softtek.rdl2.EntityTextConstraint
import com.softtek.rdl2.ConstraintRequired
import com.softtek.rdl2.ConstraintUnique
import com.softtek.rdl2.ConstraintMaxLength
import com.softtek.rdl2.ConstraintMinLength
import com.softtek.rdl2.EntityTextFieldAttr
import com.softtek.rdl2.EntityLongTextFieldAttr
import com.softtek.rdl2.EntityDateFieldAttr
import com.softtek.rdl2.EntityAttr

class genEntityField {

	/*
	 * isFieldRequired
	 */
	def dispatch isFieldRequired(EntityReferenceField field) {
		var required = true
		for(EntityReferenceFieldAttr a : field.attrs) {
			if( a.constraint !== null ) {
				for (EntityTextConstraint c : a.constraint.constraints) {
					if (c.entityTextConstraint !== null) {
						if (c.getEntityTextConstraint.toString == "false") {
							required = false
						}						
					}
				}
			}
		}
		
		return required
	}
	
	def dispatch isFieldRequired(EntityTextField field) {
		var required = true
		
		for(EntityTextFieldAttr a : field.attrs) {
			if( a.constraint !== null ) {
				for (EntityTextConstraint c : a.constraint.constraints) {
					if (c.entityTextConstraint !== null) {
						if (c.getEntityTextConstraint.toString == "false") {
							required = false
						}						
					}
				}
			}
		}
		
		return required
	}
	
	def dispatch isFieldRequired(EntityLongTextField field) {
		var required = true
		
		for(EntityLongTextFieldAttr a : field.attrs) {
			if( a.constraint !== null ) {
				for (EntityTextConstraint c : a.constraint.constraints) {
					if (c.entityTextConstraint !== null) {
						if (c.getEntityTextConstraint.toString == "false") {
							required = false
						}						
					}
				}
			}
		}
		
		return required
	}
	
	def dispatch isFieldRequired(EntityDateField field) {
		var required = true
		
		for(EntityDateFieldAttr a : field.attrs) {
			if( a.constraint !== null ) {
				for (EntityTextConstraint c : a.constraint.constraints) {
					if (c.entityTextConstraint !== null) {
						if (c.getEntityTextConstraint.toString == "false") {
							required = false
						}						
					}
				}
			}
		}
		
		return required
	}
	
	def dispatch isFieldRequired(EntityImageField field) {
		var required = true
		
		for(EntityAttr a : field.attrs) {
			if( a.constraint !== null ) {
				for (EntityTextConstraint c : a.constraint.constraints) {
					if (c.entityTextConstraint !== null) {
						if (c.getEntityTextConstraint.toString == "false") {
							required = false
						}						
					}
				}
			}
		}
		
		return required
	}
	
	def dispatch isFieldRequired(EntityFileField field) {
		var required = true
		
		for(EntityAttr a : field.attrs) {
			if( a.constraint !== null ) {
				for (EntityTextConstraint c : a.constraint.constraints) {
					if (c.entityTextConstraint !== null) {
						if (c.getEntityTextConstraint.toString == "false") {
							required = false
						}						
					}
				}
			}
		}
		
		return required
	}
	
	def dispatch isFieldRequired(EntityEmailField field) {
		var required = true
		
		for(EntityAttr a : field.attrs) {
			if( a.constraint !== null ) {
				for (EntityTextConstraint c : a.constraint.constraints) {
					if (c.entityTextConstraint !== null) {
						if (c.getEntityTextConstraint.toString == "false") {
							required = false
						}						
					}
				}
			}
		}
		
		return required
	}
	
	def dispatch isFieldRequired(EntityDecimalField field) {
		var required = true
		
		for(EntityAttr a : field.attrs) {
			if( a.constraint !== null ) {
				for (EntityTextConstraint c : a.constraint.constraints) {
					if (c.entityTextConstraint !== null) {
						if (c.getEntityTextConstraint.toString == "false") {
							required = false
						}						
					}
				}
			}
		}
		
		return required
	}
	
	def dispatch isFieldRequired(EntityIntegerField field) {
		var required = true
		
		for(EntityAttr a : field.attrs) {
			if( a.constraint !== null ) {
				for (EntityTextConstraint c : a.constraint.constraints) {
					if (c.entityTextConstraint !== null) {
						if (c.getEntityTextConstraint.toString == "false") {
							required = false
						}						
					}
				}
			}
		}
		
		return required
	}
	
	def dispatch isFieldRequired(EntityCurrencyField field) {
		var required = true
		
		for(EntityAttr a : field.attrs) {
			if( a.constraint !== null ) {
				for (EntityTextConstraint c : a.constraint.constraints) {
					if (c.entityTextConstraint !== null) {
						if (c.getEntityTextConstraint.toString == "false") {
							required = false
						}						
					}
				}
			}
		}
		
		return required
	}


	/*
	 * Determine Field Constraints
	 */
	def dispatch getEntityTextConstraint(ConstraintRequired constraint) {
		return constraint.value
	}
	
	def dispatch getEntityTextConstraint(ConstraintUnique constraint) {}
	def dispatch getEntityTextConstraint(ConstraintMaxLength constraint) {}
	def dispatch getEntityTextConstraint(ConstraintMinLength constraint) {}

}