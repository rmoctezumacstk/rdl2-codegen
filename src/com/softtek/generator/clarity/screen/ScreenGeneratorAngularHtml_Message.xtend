package com.softtek.generator.clarity.screen

import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.generator.utils.UIFlowUtils
import com.softtek.rdl2.MessageComponent
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer

class ScreenGeneratorAngularHtml_Message {
	
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
	def CharSequence genUIComponent_MessageComponent(MessageComponent m, Module module, PageContainer page) '''
	«««		<div style="overflow: auto">
	«««			«m.msgtext»
	«««		</div>
	'''
}