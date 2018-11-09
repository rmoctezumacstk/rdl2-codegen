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
import com.java2s.pluralize.Inflector
import com.softtek.rdl2.UIFormPanel
import com.softtek.rdl2.UIFormRow
import com.softtek.rdl2.UIFormColumn
import com.softtek.rdl2.SizeOption
import org.eclipse.emf.common.util.EList
import com.softtek.rdl2.UILinkAction

class VulcanComponentsGenerator {
	
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils
	var inflector = new Inflector
	
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
		import { browserHistory } from "react-router";
		import { Typography, Button } from "@material-ui/core";
		import {
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
		    const { classes, params } = this.props;
		    return (
		      <div>
		        <Typography variant="h4" gutterBottom component="h2">
		          «page.page_title»
		        </Typography>
		        
		        «FOR c : page.components»
		        	«c.genPageUIComponent»
		        «ENDFOR»
		        
		        «FOR l : page.links»
		        	«l.genPageActions»
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
		<Components.«c.name» documentId={params.id} />
	'''
	def dispatch genPageUIComponent(InlineFormComponent c) '''
		<Components.«c.name» documentId={params.id} />
	'''
	def dispatch genPageUIComponent(ListComponent c) '''
		<Components.«c.name» documentId={params.id} />
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
	        browserHistory.push("/«flow.link_to.name.toLowerCase»");
	      }}
	    >
	      <«uiFlowUtils.getFlowIcon(flow, "Material Design Icons")» className={classes.extendedIcon} />
	      «uiFlowUtils.getFlowLabel(flow)»
	    </Button>
	'''
	def dispatch genPageActions(UILinkAction flow) '''
		«IF flow.action.toString === "Back"»
		    <Button
		      «uiFlowUtils.getFlowButtonStyle(flow, "Material Design Icons")»
		      className={classes.button}
		      onClick={() => {
		        browserHistory.goBack);
		      }}
		    >
		      <«uiFlowUtils.getFlowIcon(flow, "Material Design Icons")» className={classes.extendedIcon} />
		      «uiFlowUtils.getFlowLabel(flow)»
		    </Button>
	    «ENDIF»
	'''


	
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
		import React, { Component } from "react";
		import gql from "graphql-tag";
		import { withRouter } from "react-router";
		import { browserHistory } from "react-router";
		import {
		  Components,
		  registerComponent,
		  withCurrentUser,
		  withCreate
		} from "meteor/vulcan:core";
		import {
		  Paper,
		  TextField,
		  MenuItem,
		  FormControl,
		  InputLabel,
		  Input,
		  InputAdornment,
		  Button
		} from "@material-ui/core";
		import {
		  Phone,
		  «c.genImportFormIcons»
		} from "mdi-material-ui";
		import { Formik, Form } from "formik";
		import Yup from "yup";
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
		  textField: {
		    marginLeft: theme.spacing.unit,
		    marginRight: theme.spacing.unit
		  },
		  margin: {
		    margin: theme.spacing.unit
		  },
		  swappableView: {
		    width: "98%"
		  },
		  iconSmall: {
		   fontSize: 17
		  }
		});
		
		class «c.name» extends Component {
		  render() {
		    const {
		      currentUser,
		      refetch,
		      classes,
		      theme,
		      createCustomer,
		      router
		    } = this.props;
		
		    const initialValues = {
		      «FOR i : c.form_elements»
		        «i.genFormInitialValues»
		      «ENDFOR»
		    };
		
		    const validationSchema = Yup.object().shape({
		      «FOR i : c.form_elements»
		        «i.genFormValidationSchema»
		      «ENDFOR»
		    });
		
		    handleSubmit = (values, { setSubmitting }) => {
		      //createCustomer({
		      //  data: {
		      //    typeId: "YYY",
		      //    emailaddress: "email.mail.com",
		      //    fullname: "Nombre",
		      //    phonenumber: "Telefono",
		      //    address1: "Direccion 1",
		      //    address2: "Direccion 2",
		      //    city: "Ciudad",
		      //    state: "Estado",
		      //    postalcode: "12345",
		      //    country: "Pais"
		      //  }
		      //}).then(customer => {
		      //  alert(JSON.stringify(customer, null, 2));
		      //  router.push({
		      //    pathname: `/paymentconfirmationscreen/${
		      //      customer.data.createCustomer.data._id
		      //    }`
		      //  });
		      //});
		      setSubmitting(false);
		      setTimeout(() => {
		        alert(JSON.stringify(values, null, 2));
		        setSubmitting(false);
		      }, 1000);
		    };
		
		    return (
		      <Paper className={classes.root} elevation={1}>
		        <Formik
		          initialValues={initialValues}
		          validationSchema={validationSchema}
		          onSubmit={handleSubmit}
		          render={({
		            values,
		            touched,
		            errors,
		            dirty,
		            isSubmitting,
		            handleChange,
		            handleBlur,
		            handleReset
		          }) => (
		            <Form>
		              «FOR f : c.form_elements»
		                «f.genFormFields»
		              «ENDFOR»
		              <br />
		              «FOR l : c.links»
		                «l.genFormActions»
		              «ENDFOR»
		            </Form>
		          )}
		        />
		      </Paper>
		    );
		  }
		}
		
		// const withCreateOptions = {
		//   collection: Customers,
		//   fragment: gql`
		//     fragment CustomerItemFragment on Customer {
		//       _id
		//       createdAt
		//       typeId
		//       emailaddress
		//       fullname
		//       phonenumber
		//       address1
		//       address2
		//       city
		//       state
		//       postalcode
		//       country
		//     }
		//   `
		// };
		
		registerComponent({
		  name: "«c.name»",
		  component: «c.name»,
		  hocs: [
		    withCurrentUser,
		    [withStyles, styles, { withTheme: true }],
		    //[withCreate, withCreateOptions],
		    withRouter
		  ]
		});
	'''
	
	
	/*
	 * UIElement
	 */
	def dispatch genFormInitialValues(UIField element) ''''''
	def dispatch genFormInitialValues(UIDisplay element) '''
		«element.genUIDisplayInitialValues»
	'''
	def dispatch genFormInitialValues(UIFormContainer element) ''''''
	
	/*
	 * UIDisplay
	 */
	def CharSequence genUIDisplayInitialValues(UIDisplay display) '''
		«display.ui_field.genUIDisplayInitialValuesByFormComponent»
	'''

	/*
	 * EntityField
	 */
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityReferenceField f) '''
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityTextField f) '''
		«f.name.toLowerCase»: ""
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityLongTextField f) '''
		«f.name.toLowerCase»: ""
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityDateField f) '''
		«f.name.toLowerCase»: ""
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityImageField f) '''
		«f.name.toLowerCase»: ""
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityFileField f) '''
		«f.name.toLowerCase»: ""
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityEmailField f) '''
		«f.name.toLowerCase»: ""
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityDecimalField f) '''
		«f.name.toLowerCase»: ""
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityIntegerField f) '''
		«f.name.toLowerCase»: ""
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityCurrencyField f) '''
		«f.name.toLowerCase»: ""
	'''


	/*
	 * UIElement
	 */
	def dispatch genFormValidationSchema(UIField element) ''''''
	def dispatch genFormValidationSchema(UIDisplay element) '''
		«element.genUIDisplayValidationSchema»
	'''
	def dispatch genFormValidationSchema(UIFormContainer element) ''''''
	
	/*
	 * UIDisplay
	 */
	def CharSequence genUIDisplayValidationSchema(UIDisplay display) '''
		«display.ui_field.genUIDisplayValidationSchemaByFormComponent»
	'''

	/*
	 * EntityField
	 */
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityReferenceField f) '''
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityTextField f) '''
		«f.name.toLowerCase»: Yup.string()
		.trim()
		.max(64)
		«IF entityFieldUtils.isFieldRequired(f)».required()«ELSE».optional()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityLongTextField f) '''
		«f.name.toLowerCase»: Yup.string()
		.trim()
		.max(255)
		«IF entityFieldUtils.isFieldRequired(f)».required()«ELSE».optional()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityDateField f) '''
		«f.name.toLowerCase»: Yup.date()
		«IF entityFieldUtils.isFieldRequired(f)».required()«ELSE».optional()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityImageField f) '''
		«f.name.toLowerCase»: Yup.string()
		.trim()
		.max(255)
		«IF entityFieldUtils.isFieldRequired(f)».required()«ELSE».optional()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityFileField f) '''
		«f.name.toLowerCase»: Yup.string()
		.trim()
		.max(255)
		«IF entityFieldUtils.isFieldRequired(f)».required()«ELSE».optional()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityEmailField f) '''
		«f.name.toLowerCase»: Yup.string()
		.trim()
		.email()
		.max(64)
		«IF entityFieldUtils.isFieldRequired(f)».required()«ELSE».optional()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityDecimalField f) '''
		«f.name.toLowerCase»: Yup.number()
		«IF entityFieldUtils.isFieldRequired(f)».required()«ELSE».optional()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityIntegerField f) '''
		«f.name.toLowerCase»: Yup.number()
		.integer()
		«IF entityFieldUtils.isFieldRequired(f)».required()«ELSE».optional()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityCurrencyField f) '''
		«f.name.toLowerCase»: Yup.number()
		«IF entityFieldUtils.isFieldRequired(f)».required()«ELSE».optional()«ENDIF»,
	'''


	/*
	 * UIElement
	 */
	def dispatch genFormFields(UIField element) ''''''
	def dispatch genFormFields(UIDisplay element) '''
		«element.genUIDisplayFormField»
	'''
	def dispatch genFormFields(UIFormContainer element) ''''''
	
	/*
	 * UIDisplay
	 */
	def CharSequence genUIDisplayFormField(UIDisplay display) '''
		«display.ui_field.genUIDisplayFormFieldByFormComponent»
	'''

	/*
	 * EntityField
	 */
	def dispatch genUIDisplayFormFieldByFormComponent(EntityReferenceField f) '''
      {/* <TextField
        id="select"
        name="select"
        select
        label="Select"
        className={classes.textField}
        SelectProps={{
          MenuProps: {
            className: classes.menu
          }
        }}
        margin="normal"
        fullWidth
        required
        onChange={handleChange}
        onBlur={handleBlur}
        value={values.select}
        error={errors.select && touched.select && true}
      >
        <MenuItem key="1" value="Value 1">
          Option 1
        </MenuItem>
        <MenuItem key="2" value="Value 2">
          Option 2
        </MenuItem>
      </TextField> */}
	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityTextField f) '''
      <TextField
        id="«f.name.toLowerCase»"
        name="«f.name.toLowerCase»"
        label="«entityFieldUtils.getFieldGlossaryName(f)»"
        className={classes.textField}
        margin="normal"
        fullWidth
        «IF entityFieldUtils.isFieldRequired(f)»required«ENDIF»
        onChange={handleChange}
        onBlur={handleBlur}
        value={values.«f.name.toLowerCase»}
        error={errors.«f.name.toLowerCase» && touched.«f.name.toLowerCase» && true}
      />
	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityLongTextField f) '''
      <TextField
        id="«f.name.toLowerCase»"
        name="«f.name.toLowerCase»"
        label="«entityFieldUtils.getFieldGlossaryName(f)»"
        multiline
        rows="3"
        className={classes.textField}
        margin="normal"
        fullWidth
        «IF entityFieldUtils.isFieldRequired(f)»required«ENDIF»
        onChange={handleChange}
        onBlur={handleBlur}
        value={values.«f.name.toLowerCase»}
        error={errors.«f.name.toLowerCase» && touched.«f.name.toLowerCase» && true}
      />
	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityDateField f) '''

	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityImageField f) '''

	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityFileField f) '''

	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityEmailField f) '''
      <FormControl fullWidth className={classes.margin}>
        <InputLabel htmlFor="«f.name.toLowerCase»">«entityFieldUtils.getFieldGlossaryName(f)»</InputLabel>
        <Input
          id="«f.name.toLowerCase»"
          name="«f.name.toLowerCase»"
          type="number"
          «IF entityFieldUtils.isFieldRequired(f)»required«ENDIF»
          startAdornment={
            <InputAdornment position="start">
              <Phone className={classes.iconSmall} />
            </InputAdornment>
          }
          onChange={handleChange}
          onBlur={handleBlur}
          value={values.«f.name.toLowerCase»}
          error={
            errors.«f.name.toLowerCase» && touched.«f.name.toLowerCase» && true
          }
        />
      </FormControl>
	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityDecimalField f) '''
      <TextField
        id="«f.name.toLowerCase»"
        name="«f.name.toLowerCase»"
        label="«entityFieldUtils.getFieldGlossaryName(f)»"
        className={classes.textField}
        margin="normal"
        fullWidth
        «IF entityFieldUtils.isFieldRequired(f)»required«ENDIF»
        onChange={handleChange}
        onBlur={handleBlur}
        value={values.«f.name.toLowerCase»}
        error={errors.«f.name.toLowerCase» && touched.«f.name.toLowerCase» && true}
      />
	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityIntegerField f) '''
      <TextField
        id="«f.name.toLowerCase»"
        name="«f.name.toLowerCase»"
        label="«entityFieldUtils.getFieldGlossaryName(f)»"
        className={classes.textField}
        margin="normal"
        fullWidth
        «IF entityFieldUtils.isFieldRequired(f)»required«ENDIF»
        onChange={handleChange}
        onBlur={handleBlur}
        value={values.«f.name.toLowerCase»}
        error={errors.«f.name.toLowerCase» && touched.«f.name.toLowerCase» && true}
      />
	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityCurrencyField f) '''
      <FormControl fullWidth className={classes.margin}>
        <InputLabel htmlFor="«f.name.toLowerCase»">«entityFieldUtils.getFieldGlossaryName(f)»</InputLabel>
        <Input
          id="«f.name.toLowerCase»"
          name="«f.name.toLowerCase»"
          type="number"
          «IF entityFieldUtils.isFieldRequired(f)»required«ENDIF»
          startAdornment={
            <InputAdornment position="start">$</InputAdornment>
          }
          onChange={handleChange}
          onBlur={handleBlur}
          value={values.«f.name.toLowerCase»}
          error={
            errors.«f.name.toLowerCase» && touched.«f.name.toLowerCase» && true
          }
        />
      </FormControl>
	'''

	/*
	 * UILinkCommandQueryFlow
	 */
	def dispatch genFormActions(UICommandFlow flow) '''
      <Button
        «uiFlowUtils.getFlowButtonStyle(flow, "Material Design Icons")»
        className={classes.button}
        type="submit"
        disabled={isSubmitting}
      >
        <«uiFlowUtils.getFlowIcon(flow, "Material Design Icons")» className={classes.extendedIcon} />
        «uiFlowUtils.getFlowLabel(flow)»
      </Button>
	'''
	def dispatch genFormActions(UIQueryFlow flow) '''
      <Button
        «uiFlowUtils.getFlowButtonStyle(flow, "Material Design Icons")»
        className={classes.button}
        type="submit"
        disabled={isSubmitting}
      >
        <«uiFlowUtils.getFlowIcon(flow, "Material Design Icons")» className={classes.extendedIcon} />
        «uiFlowUtils.getFlowLabel(flow)»
      </Button>
	'''
	def dispatch genFormActions(UILinkFlow flow) '''
	    <Button
	      «uiFlowUtils.getFlowButtonStyle(flow, "Material Design Icons")»
	      className={classes.button}
	      onClick={() => {
	      	router.push({
	      	  pathname: `/«flow.link_to.name.toLowerCase»`
	      	});
	      }}
	    >
	      <«uiFlowUtils.getFlowIcon(flow, "Material Design Icons")» className={classes.extendedIcon} />
	      «uiFlowUtils.getFlowLabel(flow)»
	    </Button>
	'''
	def dispatch genFormActions(UILinkAction flow) '''
		«IF flow.action.toString === "Back"»
		    <Button
		      «uiFlowUtils.getFlowButtonStyle(flow, "Material Design Icons")»
		      className={classes.button}
		      onClick={() => {
		        browserHistory.goBack);
		      }}
		    >
		      <«uiFlowUtils.getFlowIcon(flow, "Material Design Icons")» className={classes.extendedIcon} />
		      «uiFlowUtils.getFlowLabel(flow)»
		    </Button>
	    «ENDIF»
		«IF flow.action.toString === "Reset"»
			<Button
			  «uiFlowUtils.getFlowButtonStyle(flow, "Material Design Icons")»
			  className={classes.button}
			  onClick={handleReset}
			  disabled={!dirty || isSubmitting}
			>
			  <«uiFlowUtils.getFlowIcon(flow, "Material Design Icons")» className={classes.extendedIcon} />
			  «uiFlowUtils.getFlowLabel(flow)»
			</Button>
	    «ENDIF»
	'''


	
	def CharSequence genInLineFormComponentJsx(InlineFormComponent c, PageContainer p, Module m) '''
		import React from "react";
		import {
		  Components,
		  registerComponent,
		  withCurrentUser,
		  getFragment
		} from "meteor/vulcan:core";
		
		import «inflector.pluralize(c.entity.name)» from "../../../modules/«c.entity.name.toLowerCase»/collection";
		
		const «c.name» = ({ currentUser, refetch }) => (
		  <div>
		    {«inflector.pluralize(c.entity.name)».options.mutations.create.check(currentUser) ? (
		      <div
		        style={{
		          marginBottom: "20px",
		          paddingBottom: "20px",
		          borderBottom: "1px solid #ccc"
		        }}
		      >
		        <h4>Insert New Document</h4>
		        <Components.SmartForm
		          collection={«inflector.pluralize(c.entity.name)»}
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
		import NumberFormat from "react-number-format";
		import {
			«c.genImportListIcons»
		} from "mdi-material-ui";
		import withStyles from "@material-ui/core/styles/withStyles";
		import {
		  registerComponent,
		  Loading,
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
		  collection: «inflector.pluralize(c.entity.name)»,
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
	      «uiFlowUtils.getFlowButtonStyle(flow, "Material Design Icons")»
	      className={classes.button}
	      onClick={() => {
	        browserHistory.push("/«flow.link_to.name.toLowerCase»/" + row._id);
	      }}
	    >
	      <«uiFlowUtils.getFlowIcon(flow, "Material Design Icons")» className={classes.extendedIcon} />
	      «uiFlowUtils.getFlowLabel(flow)»
	    </Button>
	'''
	def dispatch genTableBodyActions(UILinkAction flow) ''''''

	/*
	 * ContainerOrComponent
	 */
	def dispatch genCommandFlowToContainer(PageContainer page, UICommandFlow flow) '''
	    <Button
	      «uiFlowUtils.getFlowButtonStyle(flow, "Material Design Icons")»
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
	      «uiFlowUtils.getFlowButtonStyle(flow, "Material Design Icons")»
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
		import { Paper, Typography, Button, Grid } from "@material-ui/core";
		import NumberFormat from "react-number-format";
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
		  const { classes } = props;
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
				    «f.genTableBodyActions»
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
	def dispatch genDetailComponentField(UIField f) ''''''
	def dispatch genDetailComponentField(UIDisplay f) '''
		«f.ui_field.genUIDisplayDetailItemField»
	'''
	def dispatch genDetailComponentField(UIFormContainer e) '''
		«e.genUIFormContainer»
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
	def dispatch genUIFormContainer(UIFormPanel panel) '''
	'''
	def dispatch genUIFormContainer(UIFormRow row) '''
		<Grid container>
			«FOR c : row.columns»
				«c.genUIFormColumn»
			«ENDFOR»
		</Grid>
	'''
	
	/*
	 * UIFormColumn
	 */
	def CharSequence genUIFormColumn(UIFormColumn column) '''
		<Grid item«column.sizes.genGridBreakPoints»>
			«FOR e : column.elements»
				«e.genDetailComponentField»
			«ENDFOR»
		</Grid>
	'''


	def CharSequence genImportPageIcons(PageContainer container) '''
		«FOR flow : container.links SEPARATOR ","»
			«flow.genActionIcon»
		«ENDFOR»
	'''
	
	def CharSequence genImportListIcons(ListComponent component) '''
		«FOR flow : component.links SEPARATOR ","»
			«flow.genActionIcon»
		«ENDFOR»
	'''
	
	def CharSequence genImportDetailIcons(DetailComponent component) '''
		«FOR flow : component.links SEPARATOR ","»
			«flow.genActionIcon»
		«ENDFOR»
	'''

	def CharSequence genImportFormIcons(FormComponent component) '''
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
	def dispatch genActionIcon(UILinkAction flow) '''
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
	
	
}