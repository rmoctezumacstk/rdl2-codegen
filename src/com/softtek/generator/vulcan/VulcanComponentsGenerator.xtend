package com.softtek.generator.vulcan

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.FormComponent
import com.softtek.rdl2.InlineFormComponent
import com.softtek.rdl2.ListComponent
import com.softtek.rdl2.DetailComponent
import com.softtek.rdl2.MessageComponent
import com.softtek.rdl2.RowComponent
import com.softtek.rdl2.UICommandFlow
import com.softtek.rdl2.UIQueryFlow
import com.softtek.rdl2.UILinkFlow
import com.softtek.generator.utils.UIFlowUtils

class VulcanComponentsGenerator {
	
	var uiFlowUtils = new UIFlowUtils
	var utils = new VulcanUtils
	
	var formGenerator = new VulcanFormComponentGenerator
	var inlineFormGenerator = new VulcanInlineFormComponentGenerator
	var listGenerator = new VulcanListComponentGenerator
	var listItemGenerator = new VulcanListItemComponentGenerator
	var detailGenerator = new VulcanDetailComponentGenerator
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				fsa.generateFile("vulcan/lib/components/" + m.name.toLowerCase + "/" + p.name.toLowerCase + "/" + p.name + ".jsx", p.genPageContainerJsx)
				for (c : p.components) {
					c.genComponentJsx(p, m, resource, fsa)
				}
			}
		}
	}
	
	def CharSequence genPageContainerJsx(PageContainer page) '''
		import React, { Component } from "react";
		import { withRouter } from "react-router";
		import { Typography, Button } from "@material-ui/core";
		import {
			ArrowLeft,
			«page.genImportPageIcons»
		} from "mdi-material-ui";
		import withStyles from "@material-ui/core/styles/withStyles";
		import {
		  registerComponent,
		  Components,
		  withCurrentUser
		} from "meteor/vulcan:core";
		
		const styles = theme => ({
		  button: {
		    margin: theme.spacing.unit
		  },
		  extendedIcon: {
		    marginRight: theme.spacing.unit
		  },
		  footer: {
		    backgroundColor: theme.palette.background.paper,
		    padding: theme.spacing.unit * 6
		  }
		});
		
		class «page.name» extends Component {
		  render() {
		    const { classes, params, router } = this.props;
		    return (
		      <div>
		        <Typography variant="h4" gutterBottom>
		          «page.page_title»
		        </Typography>
		        
		        «FOR c : page.components»
		        	«c.genPageUIComponent»
		        	<br />
		        «ENDFOR»
		        
		        «FOR l : page.links»
		        	«l.genPageActions»
		        «ENDFOR»
		        «page.genBackButton»
		        
		        <br />
		        <Components.Footer />
		      </div>
		    );
		  }
		}
		registerComponent({
		  name: "«page.name»",
		  component: «page.name»,
		  hocs: [withCurrentUser, withRouter, [withStyles, styles]]
		});
	'''
	
	
	
	def dispatch genPageUIComponent(FormComponent c) '''
		<Components.«c.name» documentId={params.id} />
	'''
	def dispatch genPageUIComponent(InlineFormComponent c) '''
		<Components.«c.name» documentId={params.id} />
	'''
	def dispatch genPageUIComponent(ListComponent c) '''
		<Components.«c.name» documentId={params.id} />
		/*
		<Components.«c.name»
		  terms={{ categoryId: params.id, view: "productsByCategory" }}
		/>
		*/
	'''
	def dispatch genPageUIComponent(DetailComponent c) '''
		<Components.«c.name» documentId={params.id} />
	'''
	def dispatch genPageUIComponent(MessageComponent c) ''''''
	def dispatch genPageUIComponent(RowComponent c) ''''''
	
	
	/*
	 * UILinkCommandQueryFlow
	 */
	def dispatch genPageActions(UICommandFlow flow) '''
	'''
	def dispatch genPageActions(UIQueryFlow flow) '''
	'''
	def dispatch genPageActions(UILinkFlow flow) '''
	    <Button
	      «uiFlowUtils.getFlowButtonStyle(flow, "Material Design Icons")»
	      className={classes.button}
	      onClick={() => {
	        router.push("/«flow.link_to.name.toLowerCase»");
	      }}
	    >
	      <«uiFlowUtils.getFlowIcon(flow, "Material Design Icons")» className={classes.extendedIcon} />
	      «uiFlowUtils.getFlowLabel(flow)»
	    </Button>
	'''


	
	def dispatch genComponentJsx(FormComponent c, PageContainer p, Module m, Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("vulcan/lib/components/" + m.name.toLowerCase + "/" + p.name.toLowerCase + "/" + c.name + ".jsx", formGenerator.genFormComponentJsx(c, p, m))
	}
	def dispatch genComponentJsx(InlineFormComponent c, PageContainer p, Module m, Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("vulcan/lib/components/" + m.name.toLowerCase + "/" + p.name.toLowerCase + "/" + c.name + ".jsx", inlineFormGenerator.genInLineFormComponentJsx(c, p, m))
	}
	def dispatch genComponentJsx(ListComponent c, PageContainer p, Module m, Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("vulcan/lib/components/" + m.name.toLowerCase + "/" + p.name.toLowerCase + "/" + c.name + ".jsx", listGenerator.genListComponentJsx(c, p, m))
		fsa.generateFile("vulcan/lib/components/" + m.name.toLowerCase + "/" + p.name.toLowerCase + "/" + c.name + "Item.jsx", listItemGenerator.genListItemComponentJsx(c, p, m))
	}
	def dispatch genComponentJsx(DetailComponent c, PageContainer p, Module m, Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("vulcan/lib/components/" + m.name.toLowerCase + "/" + p.name.toLowerCase + "/" + c.name + ".jsx", detailGenerator.genDetailComponentJsx(c, p, m))
	}
	def dispatch genComponentJsx(MessageComponent c, PageContainer p, Module m, Resource resource, IFileSystemAccess2 fsa) {}
	def dispatch genComponentJsx(RowComponent c, PageContainer p, Module m, Resource resource, IFileSystemAccess2 fsa) {}
	

	def Module getParentModule(PageContainer page) {
		return page.eContainer as Module
	}
	


	def CharSequence genImportPageIcons(PageContainer container) '''
		«FOR flow : container.links SEPARATOR ","»
			«utils.genActionIcon(flow)»
		«ENDFOR»
	'''	


	def CharSequence genBackButton(PageContainer container) '''
		«IF container.back_button_label !== null»
		    <Button
		      color="primary"
		      className={classes.button}
		      onClick={() => {
		        router.goBack();
		      }}
		    >
		      <ArrowLeft className={classes.extendedIcon} />
		      «container.back_button_label»
		    </Button>
		«ENDIF»
	'''

}