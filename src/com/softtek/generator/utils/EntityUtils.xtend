package com.softtek.generator.utils

import com.softtek.rdl2.Entity

class EntityUtils {
	
	def static getEntityName(Entity e) {
		var name = e.name
		if (e.glossary !== null) {
			name = e.glossary.glossary_name.label
		}
		return name
	}
	
	def static getEntityDescription(Entity e) {
		var description = ""
		if (e.glossary !== null) {
			description = e.glossary.glossary_description.label
		}
		return description
	}
	
}