package com.softtek.generator.vulcan

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
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
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.ListComponent
import com.softtek.rdl2.UIField
import com.softtek.rdl2.UIDisplay
import com.softtek.rdl2.UIFormContainer
import com.softtek.rdl2.DetailComponent

class VulcanModulesGenerator {
	
	var entityFieldUtils = new EntityFieldUtils
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("vulcan/lib/modules/" + e.name.toLowerCase + "/collection.js", e.genCollectionJs)
				fsa.generateFile("vulcan/lib/modules/" + e.name.toLowerCase + "/fragments.js", e.genFragmentsJsByEntity)
				fsa.generateFile("vulcan/lib/modules/" + e.name.toLowerCase + "/permissions.js", e.genPermissionsJs)
				fsa.generateFile("vulcan/lib/modules/" + e.name.toLowerCase + "/schema.js", e.genSchemaJs)
			}
			//for (p : m.elements.filter(typeof(PageContainer))) {
			//	for (list : p.components.filter(typeof(ListComponent))) {
			//		fsa.generateFile("vulcan/lib/modules/" + list.entity.name.toLowerCase + "/fragments.js", list.genFragmentsJsByListComponent)
			//	}
			//	for (detail : p.components.filter(typeof(DetailComponent))) {
			//		fsa.generateFile("vulcan/lib/modules/" + detail.entity.name.toLowerCase + "/fragments.js", detail.genFragmentsJsByDetailComponent)
			//	}
			//}
		}
	}
	
	
	def CharSequence genCollectionJs(Entity entity) '''
		import {
		  createCollection,
		  getDefaultResolvers,
		  getDefaultMutations
		} from "meteor/vulcan:core";
		import schema from "./schema.js";
		import "./fragments.js";
		import "./permissions.js";
		
		const «entity.name»Collection = createCollection({
		  collectionName: "«entity.name»Collection",
		  typeName: "«entity.name»",
		  schema,
		  resolvers: getDefaultResolvers({ typeName: "«entity.name»" }),
		  mutations: getDefaultMutations({ typeName: "«entity.name»" })
		});
		
		«entity.name»Collection.addDefaultView(terms => {
		  return {
		    options: { sort: { createdAt: -1 } }
		  };
		});
		
		export default «entity.name»Collection;
	'''
	
	def CharSequence genFragmentsJsByEntity(Entity entity) '''
		import { registerFragment } from "meteor/vulcan:core";
		
		registerFragment(`
		   fragment «entity.name»ItemFragment on «entity.name» {
		     _id
		     createdAt
		     «FOR f : entity.entity_fields»
		     	«f.name.toLowerCase»
		     «ENDFOR»
		   }
		`);
	'''
	
	def CharSequence genFragmentsJsByListComponent(ListComponent c) '''
		import { registerFragment } from "meteor/vulcan:core";
		
		registerFragment(`
		   fragment «c.name»ItemFragment on «c.entity.name» {
		     _id
		     createdAt
		     «FOR f : c.list_elements»
		     	«f.genFragmentFieldByListComponent»
		     «ENDFOR»
		   }
		`);
	'''

	def CharSequence genFragmentsJsByDetailComponent(DetailComponent c) '''
		import { registerFragment } from "meteor/vulcan:core";
		
		registerFragment(`
		   fragment «c.name»ItemFragment on «c.entity.name» {
		     _id
		     createdAt
		     «FOR f : c.list_elements»
		     	«f.genFragmentFieldByListComponent»
		     «ENDFOR»
		   }
		`);
	'''
	

	/*
	 * UIElement
	 */
	def dispatch genFragmentFieldByListComponent(UIField f) {}
	def dispatch genFragmentFieldByListComponent(UIDisplay f) {
		f.ui_field.genFragmentUIDisplayByListComponent
	}
	def dispatch genFragmentFieldByListComponent(UIFormContainer c) {}
	
	
	/*
	 * EntityField
	 */
	def dispatch genFragmentUIDisplayByListComponent(EntityReferenceField f) '''
		«f.name.toLowerCase»
	'''
	def dispatch genFragmentUIDisplayByListComponent(EntityTextField f) '''
		«f.name.toLowerCase»
	'''
	def dispatch genFragmentUIDisplayByListComponent(EntityLongTextField f) '''
		«f.name.toLowerCase»
	'''
	def dispatch genFragmentUIDisplayByListComponent(EntityDateField f) '''
		«f.name.toLowerCase»
	'''
	def dispatch genFragmentUIDisplayByListComponent(EntityImageField f) '''
		«f.name.toLowerCase»
	'''
	def dispatch genFragmentUIDisplayByListComponent(EntityFileField f) '''
		«f.name.toLowerCase»
	'''
	def dispatch genFragmentUIDisplayByListComponent(EntityEmailField f) '''
		«f.name.toLowerCase»
	'''
	def dispatch genFragmentUIDisplayByListComponent(EntityDecimalField f) '''
		«f.name.toLowerCase»
	'''
	def dispatch genFragmentUIDisplayByListComponent(EntityIntegerField f) '''
		«f.name.toLowerCase»
	'''
	def dispatch genFragmentUIDisplayByListComponent(EntityCurrencyField f) '''
		«f.name.toLowerCase»
	'''
	
	
	def CharSequence genPermissionsJs(Entity entity) '''
		import Users from "meteor/vulcan:users";
		
		Users.groups.members.can([
		  '«entity.name.toLowerCase».create',
		  '«entity.name.toLowerCase».update.own',
		  '«entity.name.toLowerCase».delete.own',
		]);
		
		Users.groups.admins.can([
		  '«entity.name.toLowerCase».update.all',
		  '«entity.name.toLowerCase».delete.all',
		]);
	'''
	
	def CharSequence genSchemaJs(Entity entity) '''
		const schema = {
		  _id: {
		    type: String,
		    optional: true,
		    canRead: ["guests"],
		  },
		  createdAt: {
		    type: Date,
		    optional: true,
		    canRead: ["guests"],
		    onCreate: ({ newDocument, currentUser}) => {
		      return new Date();
		    }
		  },
		  // userId: {
		  //   type: String,
		  //   optional: true,
		  //   canRead: ["guests"],
		  //   resolveAs: {
		  //     fieldName: "user,
		  //     type: "User",
		  //     resolver: (movie, args, context) => {
		  //       return context.Users.findOne({ _id: movie.userId }, { fields: context.Users.getViewableFields(context.currentUser, context.Users) });
		  //     },
		  //     addOriginalField: true
		  //   }
		  // },
		  
		  «FOR f : entity.entity_fields»
		  	«f.genSchemaField»
		  «ENDFOR»
		};
		
		export default schema;
	'''
	
	/*
	 * EntityField
	 */
	def dispatch genSchemaField(EntityReferenceField field) '''
	  «field.name.toLowerCase» : {
	    label: "«entityFieldUtils.getFieldGlossaryName(field)»" ,
	    type: String,
	    optional: «IF entityFieldUtils.isFieldRequired(field)»false«ELSE»true«ENDIF»,
	    //placeholder: "«entityFieldUtils.getFieldGlossaryDescription(field)»",
	    canRead: ["guests"],
	    canCreate: ["members"],
	    canUpdate: ["members"],
	    //searchable: true, // make field searchable
	  },
	'''
	def dispatch genSchemaField(EntityTextField field) '''
	  «field.name.toLowerCase» : {
	    label: "«entityFieldUtils.getFieldGlossaryName(field)»" ,
	    type: String,
	    optional: «IF entityFieldUtils.isFieldRequired(field)»false«ELSE»true«ENDIF»,
	    //input: "text",
	    //placeholder: "«entityFieldUtils.getFieldGlossaryDescription(field)»",
	    canRead: ["guests"],
	    canCreate: ["members"],
	    canUpdate: ["members"],
	    //searchable: true, // make field searchable
	  },
	'''
	def dispatch genSchemaField(EntityLongTextField field) '''
	  «field.name.toLowerCase» : {
	    label: "«entityFieldUtils.getFieldGlossaryName(field)»" ,
	    type: String,
	    optional: «IF entityFieldUtils.isFieldRequired(field)»false«ELSE»true«ENDIF»,
	    //input: "textarea",
	    //placeholder: "«entityFieldUtils.getFieldGlossaryDescription(field)»",
	    canRead: ["guests"],
	    canCreate: ["members"],
	    canUpdate: ["members"],
	    //searchable: true, // make field searchable
	  },
	'''
	def dispatch genSchemaField(EntityDateField field) '''
	  «field.name.toLowerCase» : {
	    label: "«entityFieldUtils.getFieldGlossaryName(field)»" ,
	    type: Date,
	    optional: «IF entityFieldUtils.isFieldRequired(field)»false«ELSE»true«ENDIF»,
	    //input: "datetime",
	    //placeholder: "«entityFieldUtils.getFieldGlossaryDescription(field)»",
	    canRead: ["guests"],
	    canCreate: ["members"],
	    canUpdate: ["members"],
	    //searchable: true, // make field searchable
	  },
	'''
	def dispatch genSchemaField(EntityImageField field) '''
	  «field.name.toLowerCase» : {
	    label: "«entityFieldUtils.getFieldGlossaryName(field)»" ,
	    type: String,
	    optional: «IF entityFieldUtils.isFieldRequired(field)»false«ELSE»true«ENDIF»,
	    //placeholder: "«entityFieldUtils.getFieldGlossaryDescription(field)»",
	    canRead: ["guests"],
	    canCreate: ["members"],
	    canUpdate: ["members"],
	  },
	'''
	def dispatch genSchemaField(EntityFileField field) '''
	  «field.name.toLowerCase» : {
	    label: "«entityFieldUtils.getFieldGlossaryName(field)»" ,
	    type: String,
	    optional: «IF entityFieldUtils.isFieldRequired(field)»false«ELSE»true«ENDIF»,
	    //input: "text",
	    //placeholder: "«entityFieldUtils.getFieldGlossaryDescription(field)»",
	    canRead: ["guests"],
	    canCreate: ["members"],
	    canUpdate: ["members"],
	  },
	'''
	def dispatch genSchemaField(EntityEmailField field) '''
	  «field.name.toLowerCase» : {
	    label: "«entityFieldUtils.getFieldGlossaryName(field)»" ,
	    type: String,
	    optional: «IF entityFieldUtils.isFieldRequired(field)»false«ELSE»true«ENDIF»,
	    //input: "text",
	    //placeholder: "«entityFieldUtils.getFieldGlossaryDescription(field)»",
	    canRead: ["guests"],
	    canCreate: ["members"],
	    canUpdate: ["members"],
	    //searchable: true, // make field searchable
	  },
	'''
	def dispatch genSchemaField(EntityDecimalField field) '''
	  «field.name.toLowerCase» : {
	    label: "«entityFieldUtils.getFieldGlossaryName(field)»" ,
	    type: Number,
	    optional: «IF entityFieldUtils.isFieldRequired(field)»false«ELSE»true«ENDIF»,
	    //input: "text",
	    //placeholder: "«entityFieldUtils.getFieldGlossaryDescription(field)»",
	    canRead: ["guests"],
	    canCreate: ["members"],
	    canUpdate: ["members"],
	    //searchable: true, // make field searchable
	  },
	'''
	def dispatch genSchemaField(EntityIntegerField field) '''
	  «field.name.toLowerCase» : {
	    label: "«entityFieldUtils.getFieldGlossaryName(field)»" ,
	    type: Number,
	    optional: «IF entityFieldUtils.isFieldRequired(field)»false«ELSE»true«ENDIF»,
	    //input: "text",
	    //placeholder: "«entityFieldUtils.getFieldGlossaryDescription(field)»",
	    canRead: ["guests"],
	    canCreate: ["members"],
	    canUpdate: ["members"],
	    //searchable: true, // make field searchable
	  },
	'''
	def dispatch genSchemaField(EntityCurrencyField field) '''
	  «field.name.toLowerCase» : {
	    label: "«entityFieldUtils.getFieldGlossaryName(field)»" ,
	    type: Number,
	    optional: «IF entityFieldUtils.isFieldRequired(field)»false«ELSE»true«ENDIF»,
	    //input: "text",
	    //placeholder: "«entityFieldUtils.getFieldGlossaryDescription(field)»",
	    canRead: ["guests"],
	    canCreate: ["members"],
	    canUpdate: ["members"],
	    //searchable: true, // make field searchable
	  },
	'''
	
}