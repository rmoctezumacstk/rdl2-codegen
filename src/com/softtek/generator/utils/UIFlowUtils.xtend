package com.softtek.generator.utils

import com.softtek.rdl2.UILinkFlow

class UIFlowUtils {
	
	def getFlowLabel(UILinkFlow flow) {
		return if (flow.link_label !== null) flow.link_label else flow.name
	}
	
	def getFlowState(UILinkFlow flow) {
		return if (flow.type !== null) "" else ""
	}
	
	def getFlowIcon(UILinkFlow flow, String library) {
		var icon = "?"
		
		if (library == "Font Awesome") {
			switch flow.icon {
				case "Search": return "fa fa-search"
				case "Create": return "fa fa-plus"
				case "Update": return "fa fa-edit"
				case "Delete": return "fa fa-trash"
				case "Save": return "fa fa-save"
				case "Return": return "fa fa-arrow-left"
				case "OK": return "fa fa-check"
			}
		}
		
		return icon
	}
}