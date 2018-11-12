package com.softtek.generator.vulcan

import com.softtek.rdl2.UICommandFlow
import com.softtek.rdl2.UIQueryFlow
import com.softtek.rdl2.UILinkFlow
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.UIComponent
import com.softtek.generator.utils.UIFlowUtils
import com.softtek.rdl2.SizeOption
import org.eclipse.emf.common.util.EList

class VulcanUtils {

	var uiFlowUtils = new UIFlowUtils

	/*
	 * UILinkCommandQueryFlow
	 */
	def dispatch genActionIcon(UICommandFlow flow) '''
		«flow.success_flow.genIconCommandFlow(flow)»
	'''
	def dispatch genActionIcon(UIQueryFlow flow) '''
		«flow.success_flow.genIconQueryFlow(flow)»
	'''
	def dispatch genActionIcon(UILinkFlow flow) '''
	    «uiFlowUtils.getFlowIcon(flow, "Material Design Icons")»
	'''

	/*
	 * ContainerOrComponent
	 */
	def dispatch genIconCommandFlow(PageContainer page, UICommandFlow flow) '''
	    «uiFlowUtils.getFlowIcon(flow, "Material Design Icons")»
	'''
	def dispatch genIconCommandFlow(UIComponent component, UICommandFlow flow) ''''''


	/*
	 * ContainerOrComponent
	 */
	def dispatch genIconQueryFlow(PageContainer page, UIQueryFlow flow) '''
	    «uiFlowUtils.getFlowIcon(flow, "Material Design Icons")»
	'''
	def dispatch genIconQueryFlow(UIComponent component, UIQueryFlow flow) ''''''
	
	
	
	def genGridBreakPoints(EList<SizeOption> list) {
		var grid_breakpoints = ""
		for (size : list) {
			grid_breakpoints = grid_breakpoints + " " + size.getGridBreakpoint
			//col_class = col_class + "col-" + size.sizeop + " "
			//if (size.offset !== null) {
			//	var offset = size.offset as OffSetMD
			//	col_class = col_class + "col-" + offset.sizeop + " "
			//}
			//if (size.centermargin !== null) {
			//	col_class = col_class + "center-margin "
			//}
		}
		return grid_breakpoints
	}
	
	def getGetGridBreakpoint(SizeOption size) {
		var breakpoint = ""
		
		if (size.sizeop !== null) {
			var sizeop = size.sizeop.toString
			var gridBreakpoint = sizeop.substring(0, sizeop.indexOf("-"))
			var gridSize = sizeop.substring(3)
			
			breakpoint = gridBreakpoint + "={" + gridSize + "} "
		}

		return breakpoint
	}





	/*
	 * UILinkCommandQueryFlow
	 */
	def dispatch genComponentActions(UICommandFlow flow) '''
		«flow.success_flow.genCommandFlowToContainer(flow)»
	'''
	def dispatch genComponentActions(UIQueryFlow flow) '''
		«flow.success_flow.genQueryFlowToContainer(flow)»
	'''
	def dispatch genComponentActions(UILinkFlow flow) '''
	    <Button
	      «uiFlowUtils.getFlowButtonStyle(flow, "Material Design Icons")»
	      className={classes.button}
	      onClick={() => {
	        router.push("/«flow.link_to.name.toLowerCase»/" + row._id);
	      }}
	    >
	      <«uiFlowUtils.getFlowIcon(flow, "Material Design Icons")» className={classes.extendedIcon} />
	      «uiFlowUtils.getFlowLabel(flow)»
	    </Button>
	'''
	
	
	
	/*
	 * ContainerOrComponent
	 */
	def dispatch genCommandFlowToContainer(PageContainer page, UICommandFlow flow) '''
	    <Button
	      «uiFlowUtils.getFlowButtonStyle(flow, "Material Design Icons")»
	      className={classes.button}
	      onClick={() => {
	        router.push("/«page.name.toLowerCase»");
	      }}
	    >
	      <«uiFlowUtils.getFlowIcon(flow, "Material Design Icons")» className={classes.extendedIcon} />
	      «uiFlowUtils.getFlowLabel(flow)»
	    </Button>
	'''
	def dispatch genCommandFlowToContainer(UIComponent component, UICommandFlow flow) ''''''


	/*
	 * ContainerOrComponent
	 */
	def dispatch genQueryFlowToContainer(PageContainer page, UIQueryFlow flow) '''
	    <Button
	      «uiFlowUtils.getFlowButtonStyle(flow, "Material Design Icons")»
	      className={classes.button}
	      onClick={() => {
	        router.push("/«page.name.toLowerCase»");
	      }}
	    >
	      <«uiFlowUtils.getFlowIcon(flow, "Material Design Icons")» className={classes.extendedIcon} />
	      «uiFlowUtils.getFlowLabel(flow)»
	    </Button>
	'''
	def dispatch genQueryFlowToContainer(UIComponent component, UIQueryFlow flow) ''''''
}