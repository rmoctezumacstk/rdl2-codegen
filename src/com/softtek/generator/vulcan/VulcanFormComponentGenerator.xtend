package com.softtek.generator.vulcan

import com.softtek.rdl2.FormComponent
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
import com.softtek.rdl2.UICommandFlow
import com.softtek.rdl2.UIQueryFlow
import com.softtek.rdl2.UILinkFlow

class VulcanFormComponentGenerator {

	var inflector = new Inflector
	var utils = new VulcanUtils()
	var entityFieldUtils = new EntityFieldUtils
	var uiFlowUtils = new UIFlowUtils

	def CharSequence genFormComponentJsx(FormComponent c, PageContainer p, Module m) '''
		import React, { Component } from "react";
		import MomentUtils from "@date-io/moment";
		import gql from "graphql-tag";
		import { withRouter } from "react-router";
		import {
		  Components,
		  registerComponent,
		  withCurrentUser,
		  withCreate
		} from "meteor/vulcan:core";
		import {
		  Paper,
		  TextField,
		  Typography,
		  Divider,
		  MenuItem,
		  FormControl,
		  InputLabel,
		  Input,
		  InputAdornment,
		  Button
		} from "@material-ui/core";
		import { MuiPickersUtilsProvider, DatePicker } from "material-ui-pickers";
		import {
		  Phone,
		  At,
		  ArrowLeft,
		  ArrowRight,
		  Calendar,
		  Undo,
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
		  button: {
		    margin: theme.spacing.unit
		  },
		  margin: {
		    margin: theme.spacing.unit
		  },
		  swappableView: {
		    width: "98%"
		  },
		  iconSmall: {
		   fontSize: 17
		  },
		  extendedIcon: {
		    marginRight: theme.spacing.unit
		  },
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
		        «IF c.form_title !== null»
		        <Typography variant="h6" gutterBottom>
		          «c.form_title»
		        </Typography>
		        <Divider />
		        <br/>
		        «ENDIF»
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
		                <br />
		                <br />
		              «ENDFOR»
		              <br />
		              «FOR l : c.links»
		                «l.genFormActions»
		              «ENDFOR»
		              «c.genResetButton»
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
	
	def CharSequence genImportFormIcons(FormComponent component) '''
		«FOR flow : component.links SEPARATOR ","»
			«utils.genActionIcon(flow)»
		«ENDFOR»
	'''


	/*
	 * UIElement
	 */
	def dispatch genFormInitialValues(UIField element) ''''''
	def dispatch genFormInitialValues(UIDisplay element) '''
		«element.genUIDisplayInitialValues»
	'''
	def dispatch genFormInitialValues(UIFormContainer element) '''
		«element.genUIFormInitialValuesContainer»
	'''


	/*
	 * UIFormContainer
	 */
	def dispatch genUIFormInitialValuesContainer(UIFormPanel panel) '''
		«FOR e : panel.elements»
			«e.genFormInitialValues»
		«ENDFOR»
	'''
	def dispatch genUIFormInitialValuesContainer(UIFormRow row) '''
		«FOR c : row.columns»
			«c.genUIFormInitialValuesColumn»
		«ENDFOR»
	'''
	
	/*
	 * UIFormColumn
	 */
	def CharSequence genUIFormInitialValuesColumn(UIFormColumn column) '''
		<Grid item«utils.genGridBreakPoints(column.sizes)»>
			«FOR e : column.elements»
				«e.genFormInitialValues»
			«ENDFOR»
		</Grid>
	'''


	
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
		«f.name.toLowerCase»: "",
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityLongTextField f) '''
		«f.name.toLowerCase»: "",
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityDateField f) '''
		«f.name.toLowerCase»: "",
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityImageField f) '''
		«f.name.toLowerCase»: "",
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityFileField f) '''
		«f.name.toLowerCase»: "",
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityEmailField f) '''
		«f.name.toLowerCase»: "",
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityDecimalField f) '''
		«f.name.toLowerCase»: "",
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityIntegerField f) '''
		«f.name.toLowerCase»: "",
	'''
	def dispatch genUIDisplayInitialValuesByFormComponent(EntityCurrencyField f) '''
		«f.name.toLowerCase»: "",
	'''


	/*
	 * UIElement
	 */
	def dispatch genFormValidationSchema(UIField element) ''''''
	def dispatch genFormValidationSchema(UIDisplay element) '''
		«element.genUIDisplayValidationSchema»
	'''
	def dispatch genFormValidationSchema(UIFormContainer element) '''
		«element.genUIFormValidationSchemaContainer»
	'''


	/*
	 * UIFormContainer
	 */
	def dispatch genUIFormValidationSchemaContainer(UIFormPanel panel) '''
		«FOR e : panel.elements»
			«e.genFormValidationSchema»
		«ENDFOR»
	'''
	def dispatch genUIFormValidationSchemaContainer(UIFormRow row) '''
		«FOR c : row.columns»
			«c.genUIFormValidationSchemaColumn»
		«ENDFOR»
	'''
	
	/*
	 * UIFormColumn
	 */
	def CharSequence genUIFormValidationSchemaColumn(UIFormColumn column) '''
		<Grid item«utils.genGridBreakPoints(column.sizes)»>
			«FOR e : column.elements»
				«e.genFormValidationSchema»
			«ENDFOR»
		</Grid>
	'''
	

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
		«IF entityFieldUtils.isFieldRequired(f)».required()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityLongTextField f) '''
		«f.name.toLowerCase»: Yup.string()
		.trim()
		.max(255)
		«IF entityFieldUtils.isFieldRequired(f)».required()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityDateField f) '''
		«f.name.toLowerCase»: Yup.date()
		«IF entityFieldUtils.isFieldRequired(f)».required()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityImageField f) '''
		«f.name.toLowerCase»: Yup.string()
		.trim()
		.max(255)
		«IF entityFieldUtils.isFieldRequired(f)».required()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityFileField f) '''
		«f.name.toLowerCase»: Yup.string()
		.trim()
		.max(255)
		«IF entityFieldUtils.isFieldRequired(f)».required()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityEmailField f) '''
		«f.name.toLowerCase»: Yup.string()
		.trim()
		.email()
		.max(64)
		«IF entityFieldUtils.isFieldRequired(f)».required()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityDecimalField f) '''
		«f.name.toLowerCase»: Yup.number()
		«IF entityFieldUtils.isFieldRequired(f)».required()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityIntegerField f) '''
		«f.name.toLowerCase»: Yup.number()
		.integer()
		«IF entityFieldUtils.isFieldRequired(f)».required()«ENDIF»,
	'''
	def dispatch genUIDisplayValidationSchemaByFormComponent(EntityCurrencyField f) '''
		«f.name.toLowerCase»: Yup.number()
		«IF entityFieldUtils.isFieldRequired(f)».required()«ENDIF»,
	'''



	/*
	 * UIElement
	 */
	def dispatch genFormFields(UIField element) ''''''
	def dispatch genFormFields(UIDisplay element) '''
		«element.genUIDisplayFormField»
	'''
	def dispatch genFormFields(UIFormContainer element) '''
		«element.genUIFormContainer»
	'''
	
	/*
	 * UIDisplay
	 */
	def CharSequence genUIDisplayFormField(UIDisplay display) '''
		«display.ui_field.genUIDisplayFormFieldByFormComponent»
	'''


	/*
	 * UIFormContainer
	 */
	def dispatch genUIFormContainer(UIFormPanel panel) '''
		«IF panel.title !== null»
			<Typography variant="h6" gutterBottom>
			  «panel.title»
			</Typography>
			<Divider />
		«ENDIF»
		«FOR e : panel.elements»
			«e.genFormFields»
		«ENDFOR»
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
		<Grid item«utils.genGridBreakPoints(column.sizes)»>
			«FOR e : column.elements»
				«e.genFormFields»
			«ENDFOR»
		</Grid>
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
        helperText={errors.select}
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
        helperText={errors.«f.name.toLowerCase»}
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
        helperText={errors.«f.name.toLowerCase»}
      />
	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityDateField f) '''
      { /*
      <MuiPickersUtilsProvider utils={MomentUtils}>
        <DatePicker
          id="«f.name.toLowerCase»"
          name="«f.name.toLowerCase»"
          label="«entityFieldUtils.getFieldGlossaryName(f)»"
          className={classes.textField}
          margin="normal"
          format="YYYY/MM/DD"
          fullWidth
          required
          showTodayButton
          leftArrowIcon={<ArrowLeft />}
          rightArrowIcon={<ArrowRight />}
          keyboard
          keyboardIcon={<Calendar />}
          onChange={handleChange}
          onBlur={handleBlur}
          value={values.«f.name.toLowerCase»}
          error={
            errors.expirationdate && touched.expirationdate && true
          }
          helperText={errors.expirationdate}
        />
      </MuiPickersUtilsProvider>
      */ }
      
      <TextField
        id="«f.name.toLowerCase»"
        name="«f.name.toLowerCase»"
        label="«entityFieldUtils.getFieldGlossaryName(f)»"
        type="date"
        className={classes.textField}
        margin="normal"
        fullWidth
        «IF entityFieldUtils.isFieldRequired(f)»required«ENDIF»
        onChange={handleChange}
        onBlur={handleBlur}
        value={values.«f.name.toLowerCase»}
        InputLabelProps={{
          shrink: true,
        }}
        error={errors.«f.name.toLowerCase» && touched.«f.name.toLowerCase» && true}
        helperText={errors.«f.name.toLowerCase»}
      />
	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityImageField f) '''

	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityFileField f) '''

	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityEmailField f) '''
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
        helperText={errors.«f.name.toLowerCase»}
      />
      { /*
      <FormControl fullWidth className={classes.margin}>
        <InputLabel htmlFor="«f.name.toLowerCase»">«entityFieldUtils.getFieldGlossaryName(f)»</InputLabel>
        <Input
          id="«f.name.toLowerCase»"
          name="«f.name.toLowerCase»"
          type="number"
          «IF entityFieldUtils.isFieldRequired(f)»required«ENDIF»
          startAdornment={
            <InputAdornment position="start">
              <At className={classes.iconSmall} />
            </InputAdornment>
          }
          onChange={handleChange}
          onBlur={handleBlur}
          value={values.«f.name.toLowerCase»}
          error={
            errors.«f.name.toLowerCase» && touched.«f.name.toLowerCase» && true
          }
          helperText={errors.«f.name.toLowerCase»}
        />
      </FormControl>
      */ }
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
        helperText={errors.«f.name.toLowerCase»}
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
        helperText={errors.«f.name.toLowerCase»}
      />
	'''
	def dispatch genUIDisplayFormFieldByFormComponent(EntityCurrencyField f) '''
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
        helperText={errors.«f.name.toLowerCase»}
      />
      { /*
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
          helperText={errors.«f.name.toLowerCase»}
        />
      </FormControl>
      */ }
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
	
	def CharSequence genResetButton(FormComponent form) '''
		«IF form.reset_button_label !== null»
		    <Button
		      variant="outlined"
		      className={classes.button}
		      onClick={handleReset}
		      disabled={!dirty || isSubmitting}
		    >
		      <Undo className={classes.extendedIcon} />
		      «form.reset_button_label»
		    </Button>
		«ENDIF»
	'''
}