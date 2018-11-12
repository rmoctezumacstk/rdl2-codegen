package com.softtek.generator.vulcan

import com.softtek.rdl2.ListComponent
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.Module
import com.softtek.rdl2.UIField
import com.softtek.rdl2.Entity
import com.softtek.rdl2.UIDisplay
import com.softtek.rdl2.UIFormContainer
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

class VulcanListItemComponentGenerator {

	def CharSequence genListItemComponentJsx(ListComponent c, PageContainer p, Module m) '''
		import React from "react";
		import { Components, registerComponent } from "meteor/vulcan:core";
		
		const «c.name»Item = ({ «c.entity.name.toLowerCase», currentUser, refetch }) => (
		  <div
		    style={{
		      paddingBottom: "15px",
		      marginBottom: "15px",
		      borderBottom: "1px solid #ccc"
		    }}
		  >
		    {/* document properties */}
			«FOR f : c.list_elements»
				«f.genListItemField(c.entity)»
		    «ENDFOR»
		  </div>
		);
		
		registerComponent({ name: "«c.name»Item", component: «c.name»Item });
	'''


	/*
	 * UIElement
	 */
	def dispatch genListItemField(UIField f, Entity entity) ''''''
	def dispatch genListItemField(UIDisplay f, Entity entity) '''
		«f.ui_field.genUIDisplayListItemField(entity)»
	'''
	def dispatch genListItemField(UIFormContainer e, Entity entity) ''''''
	
	/*
	 * EntityField
	 */
	def dispatch genUIDisplayListItemField(EntityReferenceField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityTextField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityLongTextField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityDateField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityImageField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityFileField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityEmailField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityDecimalField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityIntegerField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityCurrencyField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''

}