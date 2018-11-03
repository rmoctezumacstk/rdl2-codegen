package com.softtek.generator.vulcan

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.System
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
import com.softtek.generator.utils.EntityFieldUtils
import com.java2s.pluralize.Inflector

class VulcanServerGenerator {
	
	var entityFieldUtils = new EntityFieldUtils
	var inflector = new Inflector
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("vulcan/lib/server/main.js", genMainJs(resource, fsa))
		fsa.generateFile("vulcan/lib/server/seed.js", genSeedJs(resource, fsa))
	}
	
	def CharSequence genMainJs(Resource resource, IFileSystemAccess2 access2) '''
		import "../modules";
		import "./seed";
	'''

	def CharSequence genSeedJs(Resource resource, IFileSystemAccess2 access2) '''
		/*
		*  Seed the database with some dummy content. 
		*/
		
		import { Promise } from "meteor/promise";
		import Users from "meteor/vulcan:users";
		import { createMutator } from "meteor/vulcan:core";
		«FOR System s : resource.allContents.toIterable.filter(typeof(System))»
			«FOR m : s.modules_ref»
				«FOR entity : m.module_ref.elements.filter(typeof(Entity))»
					import «inflector.pluralize(entity.name)» from "../modules/«entity.name.toLowerCase»/collection";
				«ENDFOR»
			«ENDFOR»
		«ENDFOR»
		
		«FOR System s : resource.allContents.toIterable.filter(typeof(System))»
			«FOR m : s.modules_ref»
				«FOR entity : m.module_ref.elements.filter(typeof(Entity))»
					const seedData«entity.name» = [
					  «FOR i : 1..20 SEPARATOR ","»
						  {
						    «FOR field : entity.entity_fields SEPARATOR ","»
						    	«field.genSeedDataField»
						    «ENDFOR»
						  }
					  «ENDFOR»
					];

				«ENDFOR»
			«ENDFOR»
		«ENDFOR»

		
		const createUser = async (username, email) => {
		  const user = {
		    username,
		    email,
		    isDummy: true
		  };
		  return createMutator({
		    collection: Users,
		    document: user,
		    validate: false
		  });
		};
		
		const createDummyUsers = async () => {
		  // eslint-disable-next-line no-console
		  console.log("// inserting dummy users…");
		  return Promise.all([
		    createUser("efuentes", "efuentes@softtek.com"),
		    createUser("javier.perezb", "javier.perezb@softtek.com"),
		    createUser("normaysel.carbajal", "normaysel.carbajal@softtek.com"),
		    createUser("raul.moctezuma", "raul.moctezuma@softtek.com")
		  ]);
		};
		
		// eslint-disable-next-line no-undef
		Vulcan.removeGettingStartedContent = () => {
		  Users.remove({ "profile.isDummy": true });
		  // eslint-disable-next-line no-console
		  console.log("// Getting started content removed");
		};
		
		Meteor.startup(() => {
		  if (Users.find().fetch().length === 0) {
		    Promise.await(createDummyUsers());
		  }
		  const currentUser = Users.findOne(); // just get the first user available


  		  «FOR System s : resource.allContents.toIterable.filter(typeof(System))»
  			  «FOR m : s.modules_ref»
  				  «FOR entity : m.module_ref.elements.filter(typeof(Entity))»
					  if («inflector.pluralize(entity.name)».find().fetch().length === 0) {
					    // eslint-disable-next-line no-console
					    console.log("// creating dummy «entity.name»");
					    Promise.awaitAll(
					      seedData«entity.name».map(document =>
					        createMutator({
					          action: "«entity.name.toLowerCase».create",
					          collection: «inflector.pluralize(entity.name)»,
					          document,
					          currentUser,
					          validate: false
					        })
					      )
					    );
					  }
  
  				«ENDFOR»
  			«ENDFOR»
  		  «ENDFOR»
		});
	'''
	
	/*
	 * EntityField
	 */
	def dispatch genSeedDataField(EntityReferenceField field) '''
		«field.name.toLowerCase»Id: "«entityFieldUtils.fakerDomainData(field)»"
	'''
	def dispatch genSeedDataField(EntityTextField field) '''
		«field.name.toLowerCase»: "«entityFieldUtils.fakerDomainData(field)»"
	'''
	def dispatch genSeedDataField(EntityLongTextField field) '''
		«field.name.toLowerCase»: "«entityFieldUtils.fakerDomainData(field)»"
	'''
	def dispatch genSeedDataField(EntityDateField field) '''
		«field.name.toLowerCase»: "«entityFieldUtils.fakerDomainData(field)»"
	'''
	def dispatch genSeedDataField(EntityImageField field) '''
		«field.name.toLowerCase»: "«entityFieldUtils.fakerDomainData(field)»"
	'''
	def dispatch genSeedDataField(EntityFileField field) '''
		«field.name.toLowerCase»: "«entityFieldUtils.fakerDomainData(field)»"
	'''
	def dispatch genSeedDataField(EntityEmailField field) '''
		«field.name.toLowerCase»: "«entityFieldUtils.fakerDomainData(field)»"
	'''
	def dispatch genSeedDataField(EntityDecimalField field) '''
		«field.name.toLowerCase»: «entityFieldUtils.fakerDomainData(field)»
	'''
	def dispatch genSeedDataField(EntityIntegerField field) '''
		«field.name.toLowerCase»: «entityFieldUtils.fakerDomainData(field)»
	'''
	def dispatch genSeedDataField(EntityCurrencyField field) '''
		«field.name.toLowerCase»: «entityFieldUtils.fakerDomainData(field)»
	'''
	
}