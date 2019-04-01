package com.softtek.generator.utils

import com.softtek.rdl2.Entity
import com.softtek.rdl2.Statement
import com.softtek.rdl2.StatementReturn

class EntityUtils {
	
	/*
	 * getEntityName
	 */
	def dispatch getEntityName(Entity e) {
		var name = e.name
		if (e.glossary !== null) {
			name = e.glossary.glossary_name.label
		}
		return name
	}
	
	/*
	 * getEntityDescription
	 */
	def dispatch getEntityDescription(Entity e) {
		var description = ""
		if (e.glossary !== null) {
			description = e.glossary.glossary_description.label
		}
		return description
	}

	/*
	 * getToStringField
	 */
	def dispatch getToStringField(Entity entity) {
		for (m : entity.entity_methods) {
			if (m.name == "toString") {
				for (s : m.def_statements) {
					return s.getReturnStatement
				}
			}
		}
	}

	/*
	 * getReturnStatement
	 */
	def dispatch getReturnStatement(Statement statement) {}	
	def dispatch getReturnStatement(StatementReturn statement) {
		return statement.entityfield
	}
	
	/*
	 * Detects if CRUD operatios are present in a given entity
	 */
	def boolean isSearchInScaffolding(Entity entity){
		if(entity.actions!==null)
		for(a:entity.actions.action){ 
			if (a.eClass.name.trim.equals("ActionSearch") && !a.value.trim.equals("None"))
			  return true
		}
		return false
	}
	
	def boolean isAddInScaffolding(Entity entity){
		if(entity.actions!==null)
		for(a:entity.actions.action){ 
			if (a.eClass.name.trim.equals("ActionAdd") && a.value.trim.equals("true"))
			  return true
		}
		return false
	}
	
	def boolean isEditInScaffolding(Entity entity){
		if(entity.actions!==null)
		for(a:entity.actions.action){ 
			if (a.eClass.name.trim.equals("ActionEdit") && a.value.trim.equals("true"))
			  return true
		}
		return false
	}
	
	def boolean isDeleteInScaffolding(Entity entity){
		if(entity.actions!==null)
		for(a:entity.actions.action){ 
			if (a.eClass.name.trim.equals("ActionDelete") && a.value.trim.equals("true"))
			  return true
		}
		return false
	}

}