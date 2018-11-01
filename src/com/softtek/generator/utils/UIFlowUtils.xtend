package com.softtek.generator.utils

import com.softtek.rdl2.UILinkCommandQueryFlow

class UIFlowUtils {
	
	def getFlowLabel(UILinkCommandQueryFlow flow) {
		return if (flow.link_label !== null) flow.link_label else flow.name
	}
	
	def getFlowState(UILinkCommandQueryFlow flow) {
		return if (flow.type !== null) "" else ""
	}
	
	def getFlowIcon(UILinkCommandQueryFlow flow, String library) {
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
				case "Done": return "fa fa-check"
				case "Cart": return "fa fa-shopping-cart"
				case "Next": return "fa fa-arrow-right"
				case "Previous": return "fa fa-arrow-left"
				case "Pay": return "fa fa-dollar"
				case "Show": return "fa fa-eye"
			}
		}

		if (library == "Material Design Icons") {
			switch flow.icon {
				case "Search": return "Magnify"
				case "Create": return "PlusBoxOutline"
				case "Update": return "Pencil"
				case "Delete": return "Delete"
				case "Save": return "ContentSaveOutline"
				case "Return": return "KeyboardReturn"
				case "OK": return "Check"
				case "Done": return "Check"
				case "Cart": return "ShoppingCartOutline"
				case "Next": return "ArrowRightThick"
				case "Previous": return "ArrowLeftThick"
				case "Pay": return "CurrencyUSD"
				case "Show": return "Eye"
			}
		}
		
		return icon
	}
}