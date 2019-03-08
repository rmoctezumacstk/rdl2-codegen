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

}