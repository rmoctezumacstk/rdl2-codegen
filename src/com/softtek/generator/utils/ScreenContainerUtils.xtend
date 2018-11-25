package com.softtek.generator.utils

import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.FormComponent
import com.softtek.rdl2.InlineFormComponent
import com.softtek.rdl2.ListComponent
import com.softtek.rdl2.DetailComponent
import com.softtek.rdl2.MessageComponent
import com.softtek.rdl2.RowComponent
import com.softtek.rdl2.Entity
import java.util.Set
import java.util.HashSet

class ScreenContainerUtils {
	
	def getScreenEntities(PageContainer p) {
		var Set<Entity> entities = new HashSet()
		
		for (c : p.components) {
			if (c.getComponentEntity !== null) {
				//println(c.getComponentEntity)
				entities.add(c.getComponentEntity)
			}
		}
		
		//println(entities)
		return entities
	}
	
	def dispatch getComponentEntity(FormComponent component) {
		return (component.entity)
	}
	def dispatch getComponentEntity(InlineFormComponent component) {
		return component.entity
	}
	def dispatch getComponentEntity(ListComponent component) {
		return component.entity
	}
	def dispatch getComponentEntity(DetailComponent component) {
		return component.entity
	}
	def dispatch getComponentEntity(MessageComponent component) {
		return null
	}
	def dispatch getComponentEntity(RowComponent component) {
		return null
	}
}