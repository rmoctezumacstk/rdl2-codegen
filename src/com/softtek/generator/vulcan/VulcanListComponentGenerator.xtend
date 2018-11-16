package com.softtek.generator.vulcan

import com.softtek.rdl2.ListComponent
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
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.generator.utils.EntityFieldUtils

class VulcanListComponentGenerator {

	var utils = new VulcanUtils
	var inflector = new Inflector
	var entityFieldUtils = new EntityFieldUtils

	def CharSequence genListComponentJsx(ListComponent c, PageContainer p, Module m) '''
		import React from "react";
		import NumberFormat from "react-number-format";
		import { withRouter } from "react-router";
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
			«c.genImportListIcons»
		} from "mdi-material-ui";
		import withStyles from "@material-ui/core/styles/withStyles";
		import {
		  Components,
		  registerComponent,
		  withMulti,
		  withCurrentUser
		} from "meteor/vulcan:core";
		
		import «inflector.pluralize(c.entity.name)» from "../../../modules/«c.entity.name.toLowerCase»/collection";
		
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
		  loadMore: {
		    textAlign: "center"
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
		  classes,
		  router
		}) => (
		  <div>
		    {loading ? (
		      <Components.Loading />
		    ) : (
			  <div>
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
			                  		«utils.genComponentActions(f)»
			                  	«ENDFOR»
			                  </TableCell>
			                  «ENDIF»
			                </TableRow>
			              );
			            })}
			          </TableBody>
			        </Table>
			      </Paper>
			      
			      {/* load more */}
			      {totalCount > results.length && (
			        <div className={classes.loadMore}>
			          <Button
			            variant="outlined"
			            color="primary"
			            className={classes.button}
			            onClick={e => {
			              e.preventDefault();
			              loadMore();
			            }}
			          >
			            Load More ({count}/{totalCount})
			          </Button>
			        </div>
			      )}
			  </div>
		    )}
		  </div>
		);
		
		const options = {
		  collection: «inflector.pluralize(c.entity.name)»,
		  fragmentName: "«c.entity.name»ItemFragment",
		  limit: 12
		};
		
		registerComponent({
		  name: "«c.name»",
		  component: «c.name»,
		  hocs: [withCurrentUser, withRouter, [withMulti, options], [withStyles, styles]]
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
      <TableCell>{row.«f.name.toLowerCase»Id}</TableCell>
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
		<TableCell numeric>
			<NumberFormat
			  value={row.«f.name.toLowerCase»}
			  displayType={"text"}
			  thousandSeparator={true}
			/>
		</TableCell>
	'''
	def dispatch genTableBodyUIDisplayByListComponent(EntityIntegerField f) '''
		<TableCell numeric>
			<NumberFormat
			  value={row.«f.name.toLowerCase»}
			  displayType={"text"}
			  thousandSeparator={true}
			/>
		</TableCell>
	'''
	def dispatch genTableBodyUIDisplayByListComponent(EntityCurrencyField f) '''
		<TableCell numeric>
			<NumberFormat
			  value={row.«f.name.toLowerCase»}
			  displayType={"text"}
			  thousandSeparator={true}
			  prefix={"$"}
			/>
		</TableCell>
	'''

	def CharSequence genImportListIcons(ListComponent component) '''
		«FOR flow : component.links SEPARATOR ","»
			«utils.genActionIcon(flow)»
		«ENDFOR»
	'''
}