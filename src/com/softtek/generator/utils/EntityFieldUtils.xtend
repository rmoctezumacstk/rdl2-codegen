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
import com.softtek.rdl2.Enum
import com.softtek.rdl2.Entity
import java.util.Random
import com.github.javafaker.Faker
import java.util.Locale
import java.text.SimpleDateFormat
import java.util.concurrent.TimeUnit
import org.apache.commons.lang3.RandomStringUtils
import java.text.NumberFormat

class EntityFieldUtils {

    Random rand = new Random()
	Faker faker = new Faker(new Locale("es-MX"))
	SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MMM-dd", new Locale("es-MX"))
	SimpleDateFormat timeFormatter = new SimpleDateFormat("h:m:s a", new Locale("es-MX"))
	NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance()
	NumberFormat integerFormatter = NumberFormat.getIntegerInstance()
	NumberFormat numberFormatter = NumberFormat.getNumberInstance()

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
	 * getFieldGlossaryName
	 */
	def dispatch getFieldGlossaryName(EntityReferenceField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryName(EntityTextField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryName(EntityLongTextField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}

	def dispatch getFieldGlossaryName(EntityDateField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryName(EntityImageField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryName(EntityFileField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}

	def dispatch getFieldGlossaryName(EntityEmailField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryName(EntityDecimalField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryName(EntityIntegerField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryName(EntityCurrencyField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}


	/*
	 * getFieldGlossaryDescription
	 */
	def dispatch getFieldGlossaryDescription(EntityReferenceField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryDescription(EntityTextField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryDescription(EntityLongTextField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}

	def dispatch getFieldGlossaryDescription(EntityDateField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryDescription(EntityImageField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryDescription(EntityFileField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}

	def dispatch getFieldGlossaryDescription(EntityEmailField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryDescription(EntityDecimalField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryDescription(EntityIntegerField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
	}
	
	def dispatch getFieldGlossaryDescription(EntityCurrencyField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return fieldName
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




	/*
	 * fakerDomainData
	 */
 	def dispatch fakerDomainData(EntityReferenceField field) {
 		return field.superType.fakerRelationship(field)
 	}
 	
	def dispatch fakerRelationship(Enum toEnum, EntityReferenceField fromField) {
		return toEnum.enum_literals.get(rand.nextInt(toEnum.enum_literals.length)).value
	}
	
	def dispatch fakerRelationship(Entity toEntity, EntityReferenceField fromField) {
		return "YYYYYYYY"
	}
	
	def dispatch fakerDomainData(EntityTextField field) {
		var fieldData = faker.lorem().sentence

		for (attr : field.attrs) {
			if (attr.data_domain !== null) {
				if (attr.data_domain.domain.toString=="Lorem::code5") {
					fieldData = RandomStringUtils.random(5).toUpperCase
				}
				if (attr.data_domain.domain.toString=="Uuid::code8") {
					fieldData = RandomStringUtils.randomAlphanumeric(8)
				}
				if (attr.data_domain.domain.toString=="Code::isbn10") {
					fieldData = faker.code().isbn10
				}
				if (attr.data_domain.domain.toString=="Lorem::paragraph") {
					fieldData = faker.lorem().paragraph
				}
				if (attr.data_domain.domain.toString=="Lorem::longParagraph") {
					fieldData = faker.lorem().paragraph(10)
				}
				if (attr.data_domain.domain.toString=="App::name") {
					fieldData = faker.app().name
				}
				if (attr.data_domain.domain.toString=="Name::fullName") {
					fieldData = faker.name().fullName
				}
				if (attr.data_domain.domain.toString=="Name::firstName") {
					fieldData = faker.name().firstName
				}
				if (attr.data_domain.domain.toString=="Name::lastName") {
					fieldData = faker.name().lastName
				}
				if (attr.data_domain.domain.toString=="Company::logo") {
					fieldData = faker.company().logo
				}
				if (attr.data_domain.domain.toString=="Company::name") {
					fieldData = faker.company().name
				}
				if (attr.data_domain.domain.toString=="Bank::accountNumber") {
					fieldData = faker.code().isbn10
				}
				if (attr.data_domain.domain.toString=="Business::creditCardNumber") {
					fieldData = faker.business().creditCardNumber
				}
				if (attr.data_domain.domain.toString=="Internet::password") {
					fieldData = faker.internet().password
				}
				if (attr.data_domain.domain.toString=="Phone::phoneNumber") {
					fieldData = faker.phoneNumber().phoneNumber
				}
				if (attr.data_domain.domain.toString=="Address::country") {
					fieldData = faker.address().country
				}
				if (attr.data_domain.domain.toString=="Address::state") {
					fieldData = faker.address().state
				}
				if (attr.data_domain.domain.toString=="Address::city") {
					fieldData = faker.address().city
				}
				if (attr.data_domain.domain.toString=="Address::streetAddress") {
					fieldData = faker.address().streetAddress
				}
				if (attr.data_domain.domain.toString=="Address::zipCode") {
					fieldData = faker.address().zipCode
				}
				if (attr.data_domain.domain.toString=="Internet::emailAddress") {
					fieldData = faker.internet().emailAddress
				}
				if (attr.data_domain.domain.toString=="Internet::password") {
					fieldData = faker.internet().password
				}
				if (attr.data_domain.domain.toString=="Boolean::boolean") {
					fieldData = faker.bool().bool.toString
				}
				if (attr.data_domain.domain.toString=="Color::name") {
					fieldData = faker.color().name
				}
				if (attr.data_domain.domain.toString=="Commerce::productName") {
					fieldData = faker.commerce().productName
				}
				if (attr.data_domain.domain.toString=="Commerce::department") {
					fieldData = faker.commerce().department
				}
			}
		}
		
		if(fieldData.length > 100){
			fieldData = fieldData.substring(0, 90)
		}
		
		return fieldData
	}
	
	def dispatch fakerDomainData(EntityLongTextField field) {
		return faker.lorem().paragraph
	}
	
	def dispatch fakerDomainData(EntityDateField field) {
		var fieldData = dateFormatter.format(faker.date().past(800, TimeUnit.DAYS))
		
		for (attr : field.attrs) {
			if (attr.data_domain !== null) {
				if (attr.data_domain.domain.toString=="Date::time") {
					fieldData = timeFormatter.format(faker.date().past(800, TimeUnit.HOURS))
				}
			}
		}

		return fieldData
	}
	
	def dispatch fakerDomainData(EntityImageField field) {
		var image = "https://fakeimg.pl/150x150/?text=Picture&font=lobster"
		
		for (attr : field.attrs) {
			if (attr.data_domain !== null) {
				if (attr.data_domain.domain.toString=="Internet::avatar") {
					image = faker.internet().avatar
				}
			}
		}
		
		return image
	}
	
	def dispatch fakerDomainData(EntityFileField field) {
		return ""
	}
	
	def  dispatch fakerDomainData(EntityEmailField field) {
		return faker.internet().emailAddress
	}
	
	def  dispatch fakerDomainData(EntityDecimalField field) {
		return numberFormatter.format(faker.number().numberBetween(1, 99999))
	}
	
	def  dispatch fakerDomainData(EntityIntegerField field) {
		return integerFormatter.format(faker.number().numberBetween(1, 9999))
	}
	
	def  dispatch fakerDomainData(EntityCurrencyField field) {
		return currencyFormatter.format(faker.number().numberBetween(1, 99999))
	}
}