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
import com.softtek.rdl2.UIField
import com.softtek.rdl2.UIDisplay
import com.softtek.rdl2.UIFormContainer
import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.EntityTextField
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.rdl2.Entity
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.rdl2.UICommandFlow
import com.softtek.rdl2.UIQueryFlow
import com.softtek.rdl2.UILinkFlow
import com.softtek.rdl2.UIComponent
import com.softtek.generator.utils.UIFlowUtils
import com.softtek.rdl2.UIElement

class VulcanComponentsGenerator {
	
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	
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
		import { Typography } from "@material-ui/core";
		import withStyles from "@material-ui/core/styles/withStyles";
		import {
		  registerComponent,
		  Components,
		  withCurrentUser
		} from "meteor/vulcan:core";
		
		const styles = theme => ({
		  footer: {
		    backgroundColor: theme.palette.background.paper,
		    padding: theme.spacing.unit * 6
		  }
		});
		
		class «page.name» extends Component {
		  render() {
		    const { classes } = this.props;
		    return (
		      <div>
		        <Typography variant="h4" gutterBottom component="h2">
		          «page.page_title»
		        </Typography>
		        
		        «FOR c : page.components»
		        	«c.genPageUIComponent»
		        «ENDFOR»
		        
		        {/* Footer */}
		        <footer className={classes.footer}>
		          <Typography
		            variant="subtitle1"
		            align="center"
		            color="textSecondary"
		            component="p"
		          >
		            Powered by Softtek
		          </Typography>
		        </footer>
		        {/* End footer */}
		      </div>
		    );
		  }
		}
		registerComponent({
		  name: "«page.name»",
		  component: «page.name»,
		  hocs: [withCurrentUser, [withStyles, styles]]
		});
	'''
	
	def dispatch genPageUIComponent(FormComponent c) '''
		<Components.«c.name» />
	'''
	def dispatch genPageUIComponent(InlineFormComponent c) '''
		<Components.«c.name» />
	'''
	def dispatch genPageUIComponent(ListComponent c) '''
		<Components.«c.name» />
	'''
	def dispatch genPageUIComponent(DetailComponent c) '''
		<Components.«c.name» />
	'''
	def dispatch genPageUIComponent(MessageComponent c) ''''''
	def dispatch genPageUIComponent(RowComponent c) ''''''
	
	
	
	def dispatch genComponentJsx(FormComponent c, PageContainer p, Module m, Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("vulcan/lib/components/" + m.name.toLowerCase + "/" + p.name.toLowerCase + "/" + c.name + ".jsx", c.genFormComponentJsx(p, m))
	}
	def dispatch genComponentJsx(InlineFormComponent c, PageContainer p, Module m, Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("vulcan/lib/components/" + m.name.toLowerCase + "/" + p.name.toLowerCase + "/" + c.name + ".jsx", c.genInLineFormComponentJsx(p, m))
	}
	def dispatch genComponentJsx(ListComponent c, PageContainer p, Module m, Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("vulcan/lib/components/" + m.name.toLowerCase + "/" + p.name.toLowerCase + "/" + c.name + ".jsx", c.genListComponentJsx(p, m))
		fsa.generateFile("vulcan/lib/components/" + m.name.toLowerCase + "/" + p.name.toLowerCase + "/" + c.name + "Item.jsx", c.genListItemComponentJsx(p, m))
	}
	def dispatch genComponentJsx(DetailComponent c, PageContainer p, Module m, Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("vulcan/lib/components/" + m.name.toLowerCase + "/" + p.name.toLowerCase + "/" + c.name + ".jsx", c.genDetailComponentJsx(p, m))
	}
	def dispatch genComponentJsx(MessageComponent c, PageContainer p, Module m, Resource resource, IFileSystemAccess2 fsa) {}
	def dispatch genComponentJsx(RowComponent c, PageContainer p, Module m, Resource resource, IFileSystemAccess2 fsa) {}
	
	
	def CharSequence genFormComponentJsx(FormComponent c, PageContainer p, Module m) '''
		import React from "react";
		import {
		  Components,
		  registerComponent,
		  withCurrentUser,
		  getFragment
		} from "meteor/vulcan:core";
		
		import «c.entity.name»Collection from "../../../modules/«c.entity.name.toLowerCase»/collection";
		
		const «c.name» = ({ currentUser, refetch }) => (
		  <div>
		    {«c.name»Collection.options.mutations.create.check(currentUser) ? (
		      <div
		        style={{
		          marginBottom: "20px",
		          paddingBottom: "20px",
		          borderBottom: "1px solid #ccc"
		        }}
		      >
		        <h4>Insert New Document</h4>
		        <Components.SmartForm
		          collection={«c.entity.name»Collection}
		          mutationFragment={getFragment("«c.entity.name»ItemFragment")}
		          successCallback={refetch}
		        />
		      </div>
		    ) : null}
		  </div>
		);
		
		registerComponent({
		  name: "«c.name»",
		  component: «c.name»,
		  hocs: [withCurrentUser]
		});
	'''
	
	def CharSequence genInLineFormComponentJsx(InlineFormComponent c, PageContainer p, Module m) '''
		import React from "react";
		import {
		  Components,
		  registerComponent,
		  withCurrentUser,
		  getFragment
		} from "meteor/vulcan:core";
		
		import «c.entity.name»Collection from "../../../modules/«c.entity.name.toLowerCase»/collection";
		
		const «c.name» = ({ currentUser, refetch }) => (
		  <div>
		    {«c.name»Collection.options.mutations.create.check(currentUser) ? (
		      <div
		        style={{
		          marginBottom: "20px",
		          paddingBottom: "20px",
		          borderBottom: "1px solid #ccc"
		        }}
		      >
		        <h4>Insert New Document</h4>
		        <Components.SmartForm
		          collection={«c.entity.name»Collection}
		          mutationFragment={getFragment("«c.entity.name»ItemFragment")}
		          successCallback={refetch}
		        />
		      </div>
		    ) : null}
		  </div>
		);
		
		registerComponent({
		  name: "«c.name»",
		  component: «c.name»,
		  hocs: [withCurrentUser]
		});
	'''
	
	def CharSequence genListComponentJsx(ListComponent c, PageContainer p, Module m) '''
		import React from "react";
		import { browserHistory } from "react-router";
		import {
		  Paper,
		  Table,
		  TableHead,
		  TableBody,
		  TableRow,
		  TableCell,
		  Button
		} from "@material-ui/core";
		import {
			«c.genImportIcons»
		} from "mdi-material-ui";
		import withStyles from "@material-ui/core/styles/withStyles";
		import {
		  registerComponent,
		  Loading,
		  withMulti,
		  withCurrentUser
		} from "meteor/vulcan:core";
		
		import «c.entity.name»Collection from "../../../modules/«c.entity.name.toLowerCase»/collection";
		
		const styles = theme => ({
		  root: {
		    width: "100%",
		    marginTop: theme.spacing.unit * 3,
		    overflowX: "auto"
		  },
		  table: {
		    minWidth: 700
		  },
		  button: {
		    margin: theme.spacing.unit
		  },
		  extendedIcon: {
		    marginRight: theme.spacing.unit
		  },
		  footer: {
		    backgroundColor: theme.palette.background.paper
		    //padding: theme.spacing.unit * 6
		  }
		});
		
		const «c.name» = ({
		  results = [],
		  currentUser,
		  loading,
		  loadMore,
		  count,
		  totalCount,
		  refetch,
		  classes
		}) => (
		  <div>
		    {loading ? (
		      <Loading />
		    ) : (
		      <Paper className={classes.root}>
		        <Table className={classes.table}>
		          <TableHead>
		            <TableRow>
		              «FOR f : c.list_elements»
		              	«f.genTableHeaderCell»
		              «ENDFOR»
		              «IF c.links.size > 0»
		              	<TableCell />
		              «ENDIF»
		            </TableRow>
		          </TableHead>
		          <TableBody>
		            {results.map(row => {
		              return (
		                <TableRow key={row._id}>
		                  «FOR f : c.list_elements»
		                  	«f.genTableBodyCell»
		                  «ENDFOR»
		                  «IF c.links.size > 0»
		                  <TableCell>
		                  	«FOR f : c.links»
		                  		«f.genTableBodyActions»
		                  	«ENDFOR»
		                  </TableCell>
		                  «ENDIF»
		                </TableRow>
		              );
		            })}
		          </TableBody>
		        </Table>
		      </Paper>
		    )}
		  </div>
		);
		
		const options = {
		  collection: «c.entity.name»Collection,
		  fragmentName: "«c.entity.name»ItemFragment",
		  limit: 12
		};
		
		registerComponent({
		  name: "«c.name»",
		  component: «c.name»,
		  hocs: [withCurrentUser, [withMulti, options], [withStyles, styles]]
		});
	'''
	
	
	/*
	 * UIElement
	 */
	def dispatch genTableHeaderCell(UIField f) {}
	def dispatch genTableHeaderCell(UIDisplay f) {
		f.ui_field.genTableHeaderUIDisplayByListComponent
	}
	def dispatch genTableHeaderCell(UIFormContainer c) {}
	
	
	/*
	 * EntityField
	 */
	def dispatch genTableHeaderUIDisplayByListComponent(EntityReferenceField f) '''
		<TableCell>«entityFieldUtils.getFieldGlossaryName(f)»</TableCell>
	'''
	def dispatch genTableHeaderUIDisplayByListComponent(EntityTextField f) '''
		<TableCell>«entityFieldUtils.getFieldGlossaryName(f)»</TableCell>
	'''
	def dispatch genTableHeaderUIDisplayByListComponent(EntityLongTextField f) '''
		<TableCell>«entityFieldUtils.getFieldGlossaryName(f)»</TableCell>
	'''
	def dispatch genTableHeaderUIDisplayByListComponent(EntityDateField f) '''
		<TableCell>«entityFieldUtils.getFieldGlossaryName(f)»</TableCell>
	'''
	def dispatch genTableHeaderUIDisplayByListComponent(EntityImageField f) '''
		<TableCell>«entityFieldUtils.getFieldGlossaryName(f)»</TableCell>
	'''
	def dispatch genTableHeaderUIDisplayByListComponent(EntityFileField f) '''
		<TableCell>«entityFieldUtils.getFieldGlossaryName(f)»</TableCell>
	'''
	def dispatch genTableHeaderUIDisplayByListComponent(EntityEmailField f) '''
		<TableCell>«entityFieldUtils.getFieldGlossaryName(f)»</TableCell>
	'''
	def dispatch genTableHeaderUIDisplayByListComponent(EntityDecimalField f) '''
		<TableCell numeric>«entityFieldUtils.getFieldGlossaryName(f)»</TableCell>
	'''
	def dispatch genTableHeaderUIDisplayByListComponent(EntityIntegerField f) '''
		<TableCell numeric>«entityFieldUtils.getFieldGlossaryName(f)»</TableCell>
	'''
	def dispatch genTableHeaderUIDisplayByListComponent(EntityCurrencyField f) '''
		<TableCell numeric>«entityFieldUtils.getFieldGlossaryName(f)»</TableCell>
	'''
	
	
	/*
	 * UIElement
	 */
	def dispatch genTableBodyCell(UIField f) {}
	def dispatch genTableBodyCell(UIDisplay f) {
		f.ui_field.genTableBodyUIDisplayByListComponent
	}
	def dispatch genTableBodyCell(UIFormContainer c) {}
	
	
	/*
	 * EntityField
	 */
	def dispatch genTableBodyUIDisplayByListComponent(EntityReferenceField f) '''
      <TableCell>{row.«f.name.toLowerCase»}</TableCell>
	'''
	def dispatch genTableBodyUIDisplayByListComponent(EntityTextField f) '''
		<TableCell>{row.«f.name.toLowerCase»}</TableCell>
	'''
	def dispatch genTableBodyUIDisplayByListComponent(EntityLongTextField f) '''
		<TableCell>{row.«f.name.toLowerCase»}</TableCell>
	'''
	def dispatch genTableBodyUIDisplayByListComponent(EntityDateField f) '''
		<TableCell>{row.«f.name.toLowerCase»}</TableCell>
	'''
	def dispatch genTableBodyUIDisplayByListComponent(EntityImageField f) '''
      <TableCell>
        <img src={row.«f.name.toLowerCase»} width="60px" height="60px" />
      </TableCell>
	'''
	def dispatch genTableBodyUIDisplayByListComponent(EntityFileField f) '''
		<TableCell>{row.«f.name.toLowerCase»}</TableCell>
	'''
	def dispatch genTableBodyUIDisplayByListComponent(EntityEmailField f) '''
		<TableCell>{row.«f.name.toLowerCase»}</TableCell>
	'''
	def dispatch genTableBodyUIDisplayByListComponent(EntityDecimalField f) '''
		<TableCell>{row.«f.name.toLowerCase»}</TableCell>
	'''
	def dispatch genTableBodyUIDisplayByListComponent(EntityIntegerField f) '''
		<TableCell>{row.«f.name.toLowerCase»}</TableCell>
	'''
	def dispatch genTableBodyUIDisplayByListComponent(EntityCurrencyField f) '''
		<TableCell>{row.«f.name.toLowerCase»}</TableCell>
	'''
	

	/*
	 * UILinkCommandQueryFlow
	 */
	def dispatch genTableBodyActions(UICommandFlow flow) '''
		«flow.success_flow.genCommandFlowToContainer(flow)»
	'''
	def dispatch genTableBodyActions(UIQueryFlow flow) '''
		«flow.success_flow.genQueryFlowToContainer(flow)»
	'''
	def dispatch genTableBodyActions(UILinkFlow flow) '''
	    <Button
	      variant="outlined"
	      className={classes.button}
	      onClick={() => {
	        browserHistory.push("/«flow.link_to.name.toLowerCase»");
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
	      variant="outlined"
	      className={classes.button}
	      onClick={() => {
	        browserHistory.push("/«page.name.toLowerCase»");
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
	      variant="outlined"
	      className={classes.button}
	      onClick={() => {
	        browserHistory.push("/«page.name.toLowerCase»");
	      }}
	    >
	      <«uiFlowUtils.getFlowIcon(flow, "Material Design Icons")» className={classes.extendedIcon} />
	      «uiFlowUtils.getFlowLabel(flow)»
	    </Button>
	'''
	def dispatch genQueryFlowToContainer(UIComponent component, UIQueryFlow flow) ''''''
	

	def Module getParentModule(PageContainer page) {
		return page.eContainer as Module
	}
	
	
	def CharSequence genListItemComponentJsx(ListComponent c, PageContainer p, Module m) '''
		import React from "react";
		import { Components, registerComponent } from "meteor/vulcan:core";
		
		const «c.name»Item = ({ «c.entity.name.toLowerCase», currentUser, refetch }) => (
		  <div
		    style={{
		      paddingBottom: "15px",
		      marginBottom: "15px",
		      borderBottom: "1px solid #ccc"
		    }}
		  >
		    {/* document properties */}
			«FOR f : c.list_elements»
				«f.genListItemField(c.entity)»
		    «ENDFOR»
		  </div>
		);
		
		registerComponent({ name: "«c.name»Item", component: «c.name»Item });
	'''
	
	def CharSequence genDetailComponentJsx(DetailComponent c, PageContainer p, Module m) '''
		import React from "react";
		import { browserHistory } from "react-router";
		import { Paper, Typography, Button, Icon } from "@material-ui/core";
		import { Cart, KeyboardReturn } from "mdi-material-ui";
		import { registerComponent, Components, withSingle } from "meteor/vulcan:core";
		import withStyles from "@material-ui/core/styles/withStyles";
		
		import «c.name» from "../../../modules/«c.name»/collection";
		
		const styles = theme => ({
		  root: {
		    ...theme.mixins.gutters(),
		    paddingTop: theme.spacing.unit * 2,
		    paddingBottom: theme.spacing.unit * 2
		  },
		  container: {
		    display: "flex",
		    flexWrap: "wrap"
		  },
		  button: {
		    margin: theme.spacing.unit
		  },
		  leftIcon: {
		    marginRight: theme.spacing.unit
		  },
		  rightIcon: {
		    marginLeft: theme.spacing.unit
		  },
		  footer: {
		    backgroundColor: theme.palette.background.paper,
		    padding: theme.spacing.unit * 6
		  }
		});
		
		function «c.name»(props) {
		  return (
		    <div style={{ margin: "20px auto" }}>
		      <Components.«c.name»Inner documentId={props.params.id} />
		    </div>
		  );
		}
		
		registerComponent({ name: "«c.name»", component: «c.name» });
		
		function «c.name»Inner(props) {
		  const { classes } = props;
		  if (props.loading) {
		    return <Components.Loading />;
		  } else {
		    return (
		      <div>
		        <Paper className={classes.root} elevation={1}>
		          «FOR f : c.list_elements»
		          	«f.genDetailComponentField(c.entity)»
		          «ENDFOR»

				  «FOR f : c.links»
				    «f.genTableBodyActions»
				  «ENDFOR»
		        </Paper>
		
		        {/* Footer */}
		        <footer className={classes.footer}>
		          <Typography
		            variant="subtitle1"
		            align="center"
		            color="textSecondary"
		            component="p"
		          >
		            Powered by Softtek
		          </Typography>
		        </footer>
		        {/* End footer */}
		      </div>
		    );
		  }
		}
		
		const singleOptions = {
		  collection: «c.entity.name»,
		  fragmentName: "«c.name»ItemFragment"
		};
		
		registerComponent({
		  name: "«c.name»Inner",
		  component: «c.name»Inner,
		  hocs: [[withSingle, singleOptions], [withStyles, styles]]
		});
	'''
	
	
	/*
	 * UIElement
	 */
	def dispatch genListItemField(UIField f, Entity entity) ''''''
	def dispatch genListItemField(UIDisplay f, Entity entity) '''
		«f.ui_field.genUIDisplayListItemField(entity)»
	'''
	def dispatch genListItemField(UIFormContainer e, Entity entity) ''''''
	
	/*
	 * EntityField
	 */
	def dispatch genUIDisplayListItemField(EntityReferenceField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityTextField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityLongTextField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityDateField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityImageField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityFileField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityEmailField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityDecimalField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityIntegerField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	def dispatch genUIDisplayListItemField(EntityCurrencyField field, Entity entity) '''
		<p>{«entity.name.toLowerCase».«field.name.toLowerCase»}</p>
	'''
	
	
	/*
	 * UIElement
	 */
	def dispatch genDetailComponentField(UIField f, Entity entity) ''''''
	def dispatch genDetailComponentField(UIDisplay f, Entity entity) '''
		«f.ui_field.genUIDisplayDetailItemField(entity)»
	'''
	def dispatch genDetailComponentField(UIFormContainer e, Entity entity) ''''''
	
	/*
	 * EntityField
	 */
	def dispatch genUIDisplayDetailItemField(EntityReferenceField field, Entity entity) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityTextField field, Entity entity) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityLongTextField field, Entity entity) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityDateField field, Entity entity) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityImageField field, Entity entity) '''
      <img src={props.document.«field.name.toLowerCase»} />
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityFileField field, Entity entity) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityEmailField field, Entity entity) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityDecimalField field, Entity entity) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityIntegerField field, Entity entity) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityCurrencyField field, Entity entity) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	
	
	def CharSequence genImportIcons(ListComponent component) '''
		«FOR flow : component.links SEPARATOR ","»
			«flow.genActionIcon»
		«ENDFOR»
	'''
	
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
}