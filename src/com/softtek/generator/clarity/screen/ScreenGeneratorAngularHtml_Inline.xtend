package com.softtek.generator.clarity.screen

import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.generator.utils.UIFlowUtils
import com.softtek.rdl2.InlineFormComponent

class ScreenGeneratorAngularHtml_Inline {
	
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def CharSequence genUIComponent_InlineFormComponent(InlineFormComponent form, Module module, PageContainer page) '''
	<!-- inline  -->
	«««	<!--	<simple-admin id="«form.name.toLowerCase»" maxrows="8"/>-->
	'''
	
}