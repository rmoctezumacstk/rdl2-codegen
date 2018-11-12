package com.softtek.generator.vulcan

import com.softtek.rdl2.DetailComponent
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.Module
import com.java2s.pluralize.Inflector
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
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.rdl2.UIFormPanel
import com.softtek.rdl2.UIFormRow
import com.softtek.rdl2.UIFormColumn
import com.softtek.generator.utils.UIFlowUtils

class VulcanDetailComponentGenerator {

	var inflector = new Inflector
	var utils = new VulcanUtils
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils

	def CharSequence genDetailComponentJsx(DetailComponent c, PageContainer p, Module m) '''
		import React from "react";
		import { withRouter } from "react-router";
		import NumberFormat from "react-number-format";
		import { Paper, Typography, Button, Grid } from "@material-ui/core";
		import { 
		  «c.genImportDetailIcons»
		} from "mdi-material-ui";
		import { registerComponent, Components, withSingle } from "meteor/vulcan:core";
		import withStyles from "@material-ui/core/styles/withStyles";
		
		import «inflector.pluralize(c.entity.name)» from "../../../modules/«c.entity.name.toLowerCase»/collection";
		
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
		  extendedIcon: {
		    marginRight: theme.spacing.unit
		  },
		  footer: {
		    backgroundColor: theme.palette.background.paper,
		    padding: theme.spacing.unit * 6
		  }
		});
		
		function «c.name»(props) {
		  return (
		    <div style={{ margin: "20px auto" }}>
		      <Components.«c.name»Inner documentId={props.documentId} />
		    </div>
		  );
		}
		
		registerComponent({ name: "«c.name»", component: «c.name» });
		
		function «c.name»Inner(props) {
		  const { classes, router } = props;
		  if (props.loading) {
		    return <Components.Loading />;
		  } else {
		    return (
		      <div>
		        <Paper className={classes.root} elevation={1}>
		          «FOR f : c.list_elements»
		          	«f.genDetailComponentField»
		          «ENDFOR»

				  «FOR f : c.links»
				    «utils.genComponentActions(f)»
				  «ENDFOR»
		        </Paper>
		      </div>
		    );
		  }
		}
		
		const singleOptions = {
		  collection: «inflector.pluralize(c.entity.name)»,
		  fragmentName: "«c.entity.name»ItemFragment"
		};
		
		registerComponent({
		  name: "«c.name»Inner",
		  component: «c.name»Inner,
		  hocs: [[withSingle, singleOptions], withRouter, [withStyles, styles]]
		});
	'''

	def CharSequence genImportDetailIcons(DetailComponent component) '''
		«FOR flow : component.links SEPARATOR ","»
			«utils.genActionIcon(flow)»
		«ENDFOR»
	'''


	/*
	 * UIElement
	 */
	def dispatch genDetailComponentField(UIField f) ''''''
	def dispatch genDetailComponentField(UIDisplay f) '''
		«f.ui_field.genUIDisplayDetailItemField»
	'''
	def dispatch genDetailComponentField(UIFormContainer e) '''
		«e.genUIDetailsContainer»
	'''
	
	/*
	 * EntityField
	 */
	def dispatch genUIDisplayDetailItemField(EntityReferenceField field) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityTextField field) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityLongTextField field) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityDateField field) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityImageField field) '''
      <img src={props.document.«field.name.toLowerCase»} />
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityFileField field) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityEmailField field) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        {props.document.«field.name.toLowerCase»}
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityDecimalField field) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        <NumberFormat
          value={props.document.«field.name.toLowerCase»}
          displayType={"text"}
          thousandSeparator={true}
        />
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityIntegerField field) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        <NumberFormat
          value={props.document.«field.name.toLowerCase»}
          displayType={"text"}
          thousandSeparator={true}
        />
      </Typography>
      <br />
	'''
	def dispatch genUIDisplayDetailItemField(EntityCurrencyField field) '''
      <Typography variant="caption" color="textSecondary" gutterBottom>
        «entityFieldUtils.getFieldGlossaryName(field)»
      </Typography>
      <Typography variant="body1" gutterBottom>
        <NumberFormat
          value={props.document.«field.name.toLowerCase»}
          displayType={"text"}
          thousandSeparator={true}
          prefix={"$"}
        />
      </Typography>
      <br />
	'''



	/*
	 * UIFormContainer
	 */
	def dispatch genUIDetailsContainer(UIFormPanel panel) '''
		<Typography variant="h6" gutterBottom>
		  Customer Information
		</Typography>
		<Divider />
		«FOR e : panel.elements»
			«e.genDetailComponentField»
		«ENDFOR»
	'''
	def dispatch genUIDetailsContainer(UIFormRow row) '''
		<Grid container>
			«FOR c : row.columns»
				«c.genUIDetailsColumn»
			«ENDFOR»
		</Grid>
	'''

	/*
	 * UIFormColumn
	 */
	def CharSequence genUIDetailsColumn(UIFormColumn column) '''
		<Grid item«utils.genGridBreakPoints(column.sizes)»>
			«FOR e : column.elements»
				«e.genDetailComponentField»
			«ENDFOR»
		</Grid>
	'''
}