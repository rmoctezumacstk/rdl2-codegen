package com.softtek.generator.jsonserver

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Enum
import com.softtek.rdl2.Entity
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
import com.softtek.rdl2.EntityTextFieldAttr
import com.softtek.rdl2.EntityLongTextFieldAttr
import com.softtek.rdl2.EntityDateFieldAttr
import com.softtek.rdl2.EntityAttr
import com.softtek.rdl2.ConstraintRequired
import com.softtek.rdl2.ConstraintUnique
import com.softtek.rdl2.ConstraintMaxLength
import com.softtek.rdl2.ConstraintMinLength
import com.github.javafaker.Faker
import java.text.SimpleDateFormat
import java.util.Locale
import java.util.concurrent.TimeUnit
import org.apache.commons.lang3.RandomStringUtils
import java.util.Random

class JsonServerGenerator {

	Random rand = new Random()
	Faker faker = new Faker(new Locale("es-MX"))
	SimpleDateFormat formatter = formatter = new SimpleDateFormat("yyyy-MMM-dd", new Locale("es-MX"))

	def doGenerator(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("json-server/server.js", genServerJs(resource, fsa))
		
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			m.generateCodeByModule(fsa)
		}
	}
	
	def void generateCodeByModule(Module module, IFileSystemAccess2 fsa) {
		fsa.generateFile("json-server/database/" + module.name.toLowerCase + "/entities.json", module.genDatabaseJson)
				
		for (entity : module.elements.filter(Entity)) {
			entity.genSchemaByAbstractElement(module, fsa)
		}
	}
	
	def CharSequence genDatabaseJson(Module module) '''
		{
			«FOR entity : module.elements.filter(Entity) SEPARATOR ','»
				«entity.genDbEntityJson»
			«ENDFOR»
		}
	'''
	
	def dispatch genDbEntityJson(Enum e) ''''''
	
	def dispatch genDbEntityJson(Entity e) '''
		"«e.name.toLowerCase»": [
			«FOR i : 1..1 SEPARATOR ','»
				{
					"id": "«RandomStringUtils.randomAlphanumeric(8)»",
					«FOR f : e.entity_fields»
						«f.genDbFieldJson(e)»
					«ENDFOR»
				}
			«ENDFOR»
		]
	'''
	
	def dispatch genDbFieldJson(EntityReferenceField field, Entity e) '''
		«field.superType.genDbRelationshipJson(field, e)»
	'''
	
	
	def dispatch genDbRelationshipJson(Enum toEnum, EntityReferenceField fromField, Entity fromEntity) '''
		"«fromField.name.toLowerCase»": "«fromField.fakerDomainData(fromEntity)»",
	'''
	
	def dispatch genDbRelationshipJson(Entity toEntity, EntityReferenceField fromField, Entity fromEntity) '''
		«IF fromField.upperBound == "1"»
			"«fromField.name.toLowerCase»Id": "«fromField.fakerDomainData(fromEntity)»",
		«ENDIF»
	'''
	
	
	def dispatch genDbFieldJson(EntityTextField field, Entity e) '''
		"«field.name.toLowerCase»": "«field.fakerDomainData(e)»",
	'''

	def dispatch genDbFieldJson(EntityLongTextField field, Entity e) '''
		"«field.name.toLowerCase»": "«field.fakerDomainData(e)»",
	'''
	
	def dispatch genDbFieldJson(EntityDateField field, Entity e) '''
		"«field.name.toLowerCase»": «field.fakerDomainData(e)»,
	'''

	def dispatch genDbFieldJson(EntityImageField field, Entity e) '''
		"«field.name.toLowerCase»": "«field.fakerDomainData(e)»",
	'''
	
	def dispatch genDbFieldJson(EntityFileField field, Entity e) '''
		"«field.name.toLowerCase»": "«field.fakerDomainData(e)»",
	'''

	def dispatch genDbFieldJson(EntityEmailField field, Entity e) '''
		"«field.name.toLowerCase»": "«field.fakerDomainData(e)»",
	'''
	
	def dispatch genDbFieldJson(EntityDecimalField field, Entity e) '''
		"«field.name.toLowerCase»": «field.fakerDomainData(e)»,
	'''	

	def dispatch genDbFieldJson(EntityIntegerField field, Entity e) '''
		"«field.name.toLowerCase»": «field.fakerDomainData(e)»,
	'''
	
	def dispatch genDbFieldJson(EntityCurrencyField field, Entity e) '''
		"«field.name.toLowerCase»": «field.fakerDomainData(e)»,
	'''
	
	
	def dispatch genSchemaByAbstractElement(Entity entity, Module module, IFileSystemAccess2 fsa) {
		fsa.generateFile("json-server/schemas/entities/" + module.name.toLowerCase + "/" + entity.name.toLowerCase + ".js", entity.genSchemaByEntity)
	}


	def CharSequence genSchemaByEntity(Entity entity) '''
		const joi = require("joi");
		
		module.exports = joi.object().keys({
			«FOR field : entity.entity_fields»
				«field.genSchemaByField»
			«ENDFOR»
		});
	'''


	
	def dispatch genSchemaByField(EntityReferenceField field) '''
		«field.superType.genEnumEntity(field)»
	'''
	
	def dispatch genEnumEntity(Enum e, EntityReferenceField field) '''
		«field.name.toLowerCase»: joi
			.string()
			.valid(
				«FOR l: e.enum_literals SEPARATOR ","»
					"«l.key»"
				«ENDFOR»
			)
			«field.isRequiredOrOptional»
			«IF field.isFieldRequired»
				.required(),
			«ELSE»
				.optional(),
			«ENDIF»
	'''
	
	def CharSequence getIsRequiredOrOptional(EntityReferenceField field) '''
	'''
	
	def dispatch genEnumEntity(Entity e, EntityReferenceField field) '''
		«IF field.upperBound == "1"»
			«field.name.toLowerCase»Id: joi
				.string()
				.trim()
				.token()
				«IF field.isFieldRequired»
					.required(),
				«ELSE»
					.optional(),
				«ENDIF»
		«ENDIF»
	'''

	
	def dispatch genSchemaByField(EntityTextField field) '''
		«field.name.toLowerCase»: joi
			.string()
			.trim()
			.max(64)
			«IF field.isFieldRequired»
				.required(),
			«ELSE»
				.optional(),
			«ENDIF»
	'''
	
	def dispatch genSchemaByField(EntityLongTextField field) '''
		«field.name.toLowerCase»: joi
			.string()
			.trim()
			.max(255)
			«IF field.isFieldRequired»
				.required(),
			«ELSE»
				.optional(),
			«ENDIF»
	'''
	
	def dispatch genSchemaByField(EntityDateField field) '''
		«field.name.toLowerCase»: joi
			.date()
			.timestamp()
			«IF field.isFieldRequired»
				.required(),
			«ELSE»
				.optional(),
			«ENDIF»
	'''
	
	def dispatch genSchemaByField(EntityImageField field) '''
		«field.name.toLowerCase»: joi
			.string()
			.trim()
			.max(255)
			«IF field.isFieldRequired»
				.required(),
			«ELSE»
				.optional(),
			«ENDIF»
	'''
	
	def dispatch genSchemaByField(EntityFileField field) '''
		«field.name.toLowerCase»: joi
			.string()
			.trim()
			.max(255)
			«IF field.isFieldRequired»
				.required(),
			«ELSE»
				.optional(),
			«ENDIF»
	'''
	
	def dispatch genSchemaByField(EntityEmailField field) '''
		«field.name.toLowerCase»: joi
			.string()
			.trim()
			.email()
			.max(64)
			«IF field.isFieldRequired»
				.required(),
			«ELSE»
				.optional(),
			«ENDIF»
	'''
	
	def dispatch genSchemaByField(EntityDecimalField field) '''
		«field.name.toLowerCase»: joi
			.number()
			«IF field.isFieldRequired»
				.required(),
			«ELSE»
				.optional(),
			«ENDIF»
	'''
	
	def dispatch genSchemaByField(EntityIntegerField field) '''
		«field.name.toLowerCase»: joi
			.number()
			.integer()
			«IF field.isFieldRequired»
				.required(),
			«ELSE»
				.optional(),
			«ENDIF»
	'''
	
	def dispatch genSchemaByField(EntityCurrencyField field) '''
		«field.name.toLowerCase»: joi
			.number()
			«IF field.isFieldRequired»
				.required(),
			«ELSE»
				.optional(),
			«ENDIF»
	'''

/*
 * Determine if a field is required
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
	
	
	/*
	 * Faker Data
	 */
 	def dispatch fakerDomainData(EntityReferenceField field, Entity e) {
 		return field.superType.fakerRelationship(e, field)
 	}
 	
	def dispatch fakerRelationship(Enum toEnum, Entity fromEntity, EntityReferenceField fromField) {
		return toEnum.enum_literals.get(rand.nextInt(toEnum.enum_literals.length)).key
	}
	
	def dispatch fakerRelationship(Entity toEntity, Entity fromEntity, EntityReferenceField fromField) {
		return "YYYYYYYY"
	}
	
	def dispatch fakerDomainData(EntityTextField field, Entity e) {
		return field.fieldTextDomainData
	}
	
	def dispatch fakerDomainData(EntityLongTextField field, Entity e) {
		return faker.lorem().characters(1, 255, true)
	}
	
	def dispatch fakerDomainData(EntityDateField field, Entity e) {
		//return formatter.format(faker.date().past(800, TimeUnit.DAYS))
		return faker.date().past(800, TimeUnit.DAYS).getTime()
	}
	
	def dispatch fakerDomainData(EntityImageField field, Entity e) {
		return faker.internet().avatar
	}
	
	def dispatch fakerDomainData(EntityFileField field, Entity e) {
		return ""
	}
	
	def dispatch fakerDomainData(EntityEmailField field, Entity e) {
		return faker.internet().emailAddress
	}
	
	def dispatch fakerDomainData(EntityDecimalField field, Entity e) {
		return faker.number().randomNumber
	}
	
	def dispatch fakerDomainData(EntityIntegerField field, Entity e) {
		return faker.number().numberBetween(1, 1000000)
	}
	
	def dispatch fakerDomainData(EntityCurrencyField field, Entity e) {
		return "$"+faker.number().randomNumber
	}
	
	def CharSequence fieldTextDomainData(EntityTextField field) {
		var fieldData = faker.lorem().characters(1, 64, true)
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
			}
		}
		return fieldData
	}
	
	/*
	 * server.js
	 */
	def CharSequence genServerJs(Resource resource, IFileSystemAccess2 fsa) '''
		const fs = require("fs");
		const bodyParser = require("body-parser");
		const jsonServer = require("json-server");
		const jwt = require("jsonwebtoken");
		const _ = require("lodash");
		const lodashId = require("lodash-id");
		const url = require("url");
		const low = require("lowdb");
		const FileSync = require("lowdb/adapters/FileSync");
		
		const server = jsonServer.create();
		«FOR m : resource.allContents.toIterable.filter(typeof(Module))»
			const router_«m.name.toLowerCase» = jsonServer.router("./database/«m.name.toLowerCase»/entities.json");
			const bizdb_«m.name.toLowerCase» = JSON.parse(fs.readFileSync("./database/«m.name.toLowerCase»/entities.json", "UTF-8"));
		«ENDFOR»
		const router_auth = jsonServer.router("./database/auth.json");
		const authdb = JSON.parse(fs.readFileSync("./database/auth.json", "UTF-8"));
		
		const adapter = new FileSync("./database/auth.json");
		const db = low(adapter);
		
		const user_schema = require("./schemas/auth/users");
		const role_schema = require("./schemas/auth/roles");
		const permission_schema = require("./schemas/auth/permissions");
		const permission_assignment_schema = require("./schemas/auth/permission_assignment");
		
		«FOR m : resource.allContents.toIterable.filter(typeof(Module))»
			«FOR e : m.elements»
«««				«e.genEntityJoiSchema(m)»
«e»
			«ENDFOR»
		«ENDFOR»
		
		server.use(bodyParser.urlencoded({ extended: true }));
		server.use(bodyParser.json());
		server.use(jsonServer.defaults());
		
		const SECRET_KEY = "123456789";
		
		const expiresIn = "1h";
		
		_.mixin(lodashId);
		
		// Create a token from a payload
		function createToken(payload) {
			return jwt.sign(payload, SECRET_KEY, { expiresIn });
		}
		
		// Verify the token
		function verifyToken(token) {
			return jwt.verify(
				token,
				SECRET_KEY,
				(err, decode) => (decode !== undefined ? decode : err)
			);
		}
		
		// Check if the user exists in database
		function isAuthenticated({ email, password }) {
			return (
				authdb.users.findIndex(
					user => user.email === email && user.password === password
				) !== -1
			);
		}
		
		function findUserProfile(email) {
			var permissions = [];
			const user = _.find(authdb.users, u => u.email === email);
			const role = _.find(authdb.roles, r => r.id === user.roleId);
			const permission_assignment = _.filter(
				authdb.permission_assignment,
				a => a.roleId === user.roleId
			);
			permission_assignment.forEach(pa => {
				permissions.push(_.find(authdb.permissions, p => p.id === pa.permissionId));
			});
			const user_profile = {
				user: {
					username: user.username,
					display_name: user.display_name,
					email: user.email,
					user_enabled: user.enabled,
					role: role.name,
					role_enabled: role.enabled
				},
				permissions
			};
		
			return user_profile;
		}
		
		function isPermissionFound(token, permission) {
			const permission_found = _.find(
				token.permissions,
				p => p.code === permission
			);
			return typeof permission_found == "undefined" ? false : true;
		}
		
		function hasAuthority(resource, operation, user_profile) {
			const permission = resource + ":" + operation;
			const all_operations = resource + ":*";
			const superuser = "*:*";
			
			//console.log(permission);
			
			if (!isPermissionFound(user_profile, permission)) {
				if (!isPermissionFound(user_profile, all_operations)) {
					if (!isPermissionFound(user_profile, superuser)) {
						return false;
					}
				}
			}
			return true;
		}
		
		server.post("/api/v1/auth/login", (req, res) => {
			const { email, password } = req.body;
			if (isAuthenticated({ email, password }) === false) {
				res
					.status(401)
					.json({ status: 401, message: "Error: Incorrect email or password" });
				return;
			}
			const user_profile = findUserProfile(email);
			const access_token = createToken(user_profile.user);
			res.status(200).json({ access_token });
		});
		
		server.get("/api/v1/auth/profile", (req, res) => {
		  if (
		    req.headers.authorization === undefined ||
		    req.headers.authorization.split(" ")[0] !== "Bearer"
		  ) {
		    res.status(400).json({
		      status: 400,
		      message: "Error: Access token is missing or invalid"
		    });
		    return;
		  }
		
		  try {
		    const decoded_token = verifyToken(req.headers.authorization.split(" ")[1]);
		
		    const user_profile = findUserProfile(decoded_token.email);
		    res
		      .status(200)
		      .json({ user: user_profile.user, permissions: user_profile.permissions });
		  } catch (err) {
		    res
		      .status(401)
		      .json({ status: 401, message: "Error: Access token is revoked", error: err });
		  }
		});
		
		server.use(/^(?!\/auth).*$/, (req, res, next) => {
		  if (
		    req.headers.authorization === undefined ||
		    req.headers.authorization.split(" ")[0] !== "Bearer"
		  ) {
		    res.status(400).json({
		      status: 400,
		      message: "Error: Access token is missing or invalid"
		    });
		    return;
		  }
		  try {
		    let resources = [];
		    const decoded_token = verifyToken(req.headers.authorization.split(" ")[1]);
		    const url_path = req._parsedUrl.path;
		    const adr = `http://${req.headers.host}${url_path}`;
		
		    let q = url.parse(adr, true);
		
		    const auth_entities = Object.keys(authdb);
		    let entities = auth_entities;
		    «FOR m : resource.allContents.toIterable.filter(typeof(Module))»
		      const biz_entities_«m.name.toLowerCase» = Object.keys(bizdb_«m.name.toLowerCase»);
		      entities = _.union(entities, biz_entities_«m.name.toLowerCase»);
		    «ENDFOR»

		    const pathname_tokens = q.pathname.split("/");
		    resources = _.intersection(entities, pathname_tokens);
		
		    if (q.query._embed !== undefined) {
		      resources.push(q.query._embed.toUpperCase());
		    }
		
		    if (q.query._expand !== undefined) {
		      resources.push(q.query._expand.toUpperCase());
		    }
		
		    const user_profile = findUserProfile(decoded_token.email);
		
		    let operation;
		    switch (req.method) {
		      case "GET":
		        operation = "READ";
		        break;
		      case "POST":
		        operation = "CREATE";
		        break;
		      case "PUT":
		        operation = "UPDATE";
		        break;
		      case "PATCH":
		        operation = "UPDATE";
		        break;
		      case "DELETE":
		        operation = "DELETE";
		        break;
		      default:
		        operation = "UNKNOWN";
		    }
		
		    resources.forEach(r => {
		      if (!hasAuthority(r.toUpperCase(), operation, user_profile)) {
		        res.status(404).json({
		          status: 404,
		          message: `You don't have permission (${r.toUpperCase()}:${operation})`
		        });
		        return;
		      }
		    });
		
		    let error_messages = [];
		
		    let validation_result = { error: null, value: null };
		    if (req.method === "POST" || req.method === "PUT") {
		      switch (resources[0]) {
		        case "users":
		          validation_result = user_schema.validate(req.body);
		          if (validation_result.error === null) {
		            const role = _.find(authdb.roles, r => r.id === req.body.roleId);
		            if (role === undefined) {
		              error_messages.push(
		                `Role id "${req.body.roleId}" doesn't exist.`
		              );
		              res.status(400).json({
		                status: 400,
		                message: error_messages
		              });
		              return;
		            }
		          }
		          break;
		
		        case "roles":
		          validation_result = role_schema.validate(req.body);
		          break;
		
		        case "permissions":
		          validation_result = permission_schema.validate(req.body);
		          break;
		
		        case "permission_assignment":
		          validation_result = permission_assignment_schema.validate(req.body);
		          if (validation_result.error === null) {
		            const role = _.find(authdb.roles, r => r.id === req.body.roleId);
		            if (role === undefined) {
		              error_messages.push(
		                `Role id "${req.body.roleId}" doesn't exist.`
		              );
		              res.status(400).json({
		                status: 400,
		                message: error_messages
		              });
		              return;
		            }
		            const permission = _.find(
		              authdb.permissions,
		              p => p.id === req.body.permissionId
		            );
		            if (permission === undefined) {
		              error_messages.push(
		                `Permission id "${req.body.permissionId}" doesn't exist.`
		              );
		              res.status(400).json({
		                status: 400,
		                message: error_messages
		              });
		              return;
		            }
		          }
		          break;
		          
				«FOR m : resource.allContents.toIterable.filter(typeof(Module))»
					«FOR e : m.elements»
«««						«e.genEntityJoiValidate(m)»
«e»
					«ENDFOR»
					
				«ENDFOR»
		      }
		    }
		
		    if (validation_result.error !== null) {
		      validation_result.error.details.forEach(err => {
		        error_messages.push(err.message);
		      });
		      console.log(error_messages);
		
		      res.status(400).json({
		        status: 400,
		        message: error_messages
		      });
		      return;
		    }
		
		    next();
		  } catch (err) {
		    res
		      .status(401)
		      .json({ status: 401, message: "Error: Access token is revoked", error: err });
		  }
		});
				
		server.get("/api/v1/auth/roles/:roleId/permissions", (req, res) => {
		  let permissions = [];
		  const permission_assignment = _.filter(
		    authdb.permission_assignment,
		    a => a.roleId.toString() === req.params.roleId.toString()
		  );
		  permission_assignment.forEach(pa => {
		    permissions.push(_.find(authdb.permissions, p => p.id === pa.permissionId));
		  });
		  res.status(200).json({ permissions });
		});
		
		function updateRoleAssignemt(i, r) {
		  r.forEach(role => {
		    role.assigned = i;
		  });
		  return r;
		}
		
		function updateRoles(pID) {
		  let roles = [];
		  authdb.roles.forEach(r => {
		    let assign = false;
		    let roleId = r.id;
		    let k = 0;
		    while (k < authdb.permission_assignment.length) {
		      if (
		        authdb.permission_assignment[k].roleId === roleId &&
		        authdb.permission_assignment[k].permissionId === pID
		      ) {
		        k = authdb.permission_assignment.length;
		        assign = true;
		      }
		      k++;
		    }
		    roles.push({
		      id: r.id,
		      name: r.name,
		      description: r.description,
		      assigned: assign
		    });
		  });
		  return roles;
		}
		
		server.get("/api/v1/auth/permissionsvsroles", (req, res) => {
		  let permissionsvsroles = [];
		
		  authdb.permissions.forEach(p => {
		    const split_permission = p.code.split(":");
		    let permission = {
		      permission: {
		        id: p.id,
		        resource: split_permission[0],
		        action: split_permission[1],
		        scope: split_permission[2] === undefined ? "*" : split_permission[2],
		        description: p.description
		      },
		      roles: updateRoles(p.id)
		    };
		    permissionsvsroles.push(permission);
		  });
		
		  res.status(200).json(permissionsvsroles);
		});
		
		server.post("/api/v1/auth/assign_role_permission", (req, res) => {
		  let error_messages = [];
		  let validation_result = { error: null, value: null };
		
		  validation_result = permission_assignment_schema.validate(req.body);
		  if (validation_result.error === null) {
		    const role = _.find(authdb.roles, r => r.id === req.body.roleId);
		    if (role === undefined) {
		      error_messages.push(`Role id "${req.body.roleId}" doesn't exist.`);
		      res.status(400).json({
		        status: 400,
		        message: error_messages
		      });
		      return;
		    }
		    const permission = _.find(
		      authdb.permissions,
		      p => p.id === req.body.permissionId
		    );
		    if (permission === undefined) {
		      error_messages.push(
		        `Permission id "${req.body.permissionId}" doesn't exist.`
		      );
		      res.status(400).json({
		        status: 400,
		        message: error_messages
		      });
		      return;
		    }
		  }
		
		  const permission_assignment = _.find(
		    authdb.permission_assignment,
		    a =>
		      a.roleId.toString() === req.body.roleId.toString() &&
		      a.permissionId.toString() === req.body.permissionId.toString()
		  );
		
		  if (permission_assignment === undefined) {
		    db.get("permission_assignment")
		      .push({ roleId: req.body.roleId, permissionId: req.body.permissionId })
		      .write();
		  }
		
		  res.status(200).json();
		});
		
		server.post("/api/v1/auth/remove_role_permission", (req, res) => {
		  let error_messages = [];
		  let validation_result = { error: null, value: null };
		
		  validation_result = permission_assignment_schema.validate(req.body);
		  if (validation_result.error === null) {
		    const role = _.find(authdb.roles, r => r.id === req.body.roleId);
		    if (role === undefined) {
		      error_messages.push(`Role id "${req.body.roleId}" doesn't exist.`);
		      res.status(400).json({
		        status: 400,
		        message: error_messages
		      });
		      return;
		    }
		    const permission = _.find(
		      authdb.permissions,
		      p => p.id === req.body.permissionId
		    );
		    if (permission === undefined) {
		      error_messages.push(
		        `Permission id "${req.body.permissionId}" doesn't exist.`
		      );
		      res.status(400).json({
		        status: 400,
		        message: error_messages
		      });
		      return;
		    }
		  }
		
		  const permission_assignment = _.find(
		    authdb.permission_assignment,
		    a =>
		      a.roleId.toString() === req.body.roleId.toString() &&
		      a.permissionId.toString() === req.body.permissionId.toString()
		  );
		
		  if (permission_assignment !== undefined) {
		    db.get("permission_assignment")
		      .remove({ roleId: req.body.roleId, permissionId: req.body.permissionId })
		      .write();
		
		    res.status(200).json();
		  } else {
		    res.status(404).json({
		      status: 404,
		      message: `Role "${req.body.roleId}" doesn't have assigned Permission "${
		        req.body.permissionId
		      }".`
		    });
		  }
		});
		
		server.use("/api/v1/auth", router_auth);
		«FOR m : resource.allContents.toIterable.filter(typeof(Module))»
			server.use("/api/v1/«m.name.toLowerCase»", router_«m.name.toLowerCase»);
		«ENDFOR»
		
		server.listen(3000, () => {
		  console.log("Run Auth API Server (port: 3000)");
		});
	'''
	
	def dispatch genEntityJoiSchema(Enum e, Module m) ''''''
	
	def dispatch genEntityJoiSchema(Entity e, Module m) '''
		const «e.name.toLowerCase»_schema = require("./schemas/entities/«m.name.toLowerCase»/«e.name.toLowerCase»");
	'''

	
	def dispatch genEntityJoiValidate(Enum e, Module m) ''''''
	
	def dispatch genEntityJoiValidate(Entity e, Module m) '''
		case "«e.name.toLowerCase»":
			validation_result = «e.name.toLowerCase»_schema.validate(req.body);
			«FOR f : e.entity_fields»
				«f.genIntegrityValidation(e, m)»
			«ENDFOR»
			break;
	'''
	
	/*
	 * genIntegrityValidation
	 */
	def dispatch genIntegrityValidation(EntityReferenceField field, Entity e, Module m) '''
		«field.superType.genRelationshipIntegrityValidation(field, e, m)»
	'''
	
	def dispatch genRelationshipIntegrityValidation(Enum toEnum, EntityReferenceField fromField, Entity fromEntity, Module m) '''
	'''
	
	def dispatch genRelationshipIntegrityValidation(Entity toEntity, EntityReferenceField fromField, Entity fromEntity, Module m) '''
	  «IF fromField.upperBound == "1"»
	      const «fromEntity.name.toLowerCase»_«fromField.name.toLowerCase» = _.find(
	        bizdb_«m.name.toLowerCase».«toEntity.name.toLowerCase»,
	        e => e.id === req.body.«fromField.name.toLowerCase»Id
	      );
	      if («fromEntity.name.toLowerCase»_«fromField.name.toLowerCase» === undefined) {
	        error_messages.push(
	          `«fromField.name» id "${req.body.«fromField.name.toLowerCase»Id}" doesn't exist.`
	        );
	        res.status(400).json({
	          status: 400,
	          message: error_messages
	        });
	        return;
	      }
      «ENDIF»
	'''
	
	def dispatch genIntegrityValidation(EntityTextField field, Entity e, Module m) '''
	'''
	
	def dispatch genIntegrityValidation(EntityLongTextField field, Entity e, Module m) '''
	'''
	
	def dispatch genIntegrityValidation(EntityDateField field, Entity e, Module m) '''
	'''
	
	def dispatch genIntegrityValidation(EntityImageField field, Entity e, Module m) '''
	'''
	
	def dispatch genIntegrityValidation(EntityFileField field, Entity e, Module m) '''
	'''
	
	def dispatch genIntegrityValidation(EntityEmailField field, Entity e, Module m) '''
	'''
	
	def dispatch genIntegrityValidation(EntityDecimalField field, Entity e, Module m) '''
	'''
	
	def dispatch genIntegrityValidation(EntityIntegerField field, Entity e, Module m) '''
	'''
	
	def dispatch genIntegrityValidation(EntityCurrencyField field, Entity e, Module m) '''
	'''
}