package com.softtek.generator.uiprototype

import com.softtek.rdl2.AbstractElement
import com.softtek.rdl2.ConstraintMaxLength
import com.softtek.rdl2.ConstraintMinLength
import com.softtek.rdl2.ConstraintRequired
import com.softtek.rdl2.ConstraintUnique
import com.softtek.rdl2.Entity
import com.softtek.rdl2.EntityAttr
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityDateFieldAttr
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityLongTextFieldAttr
import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.EntityReferenceFieldAttr
import com.softtek.rdl2.EntityTextField
import com.softtek.rdl2.EntityTextFieldAttr
import com.softtek.rdl2.Enum
import com.softtek.rdl2.EnumLiteral
import com.softtek.rdl2.Model
import com.softtek.rdl2.WidgetExposedFilter
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.ActionAdd
import com.softtek.rdl2.ActionEdit
import com.softtek.rdl2.ActionDelete
import com.softtek.rdl2.ActionSearch
import com.softtek.rdl2.WidgetTypeSelect
import com.softtek.rdl2.WidgetType
import com.softtek.rdl2.StatementReturn
import com.softtek.rdl2.MethodDeclaration
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.Task

class EntityComponentRDLGenerator {
	/* El numero de columnas debe ser un multiplo de 12 */
	var numColumnas = 2;
	var anchoColumn = 12/numColumnas;
	var TRUE = "true";
	var SEARCH_SIMPLE = "Simple";
	var SEARCH_COMPLEX = "Complex";
	var SEARCH_NONE = "None";
	
	def doGeneratorEntity(Resource resource, IFileSystemAccess2 fsa) {
	
	var model  = resource.contents.head as Model
	    if (model.module!==null)
		for (AbstractElement a : model.module.elements){
			a.genAbstractElement(model,fsa)			
		}
	}
	
	def dispatch genAbstractElement(Enum t, Model model, IFileSystemAccess2 fsa) ''''''
	
	def dispatch genAbstractElement(PageContainer t, Model model, IFileSystemAccess2 fsa) ''''''
	
	def dispatch genAbstractElement(Task t, Model model, IFileSystemAccess2 fsa) ''''''
	
	def dispatch genAbstractElement(Entity t, Model model, IFileSystemAccess2 fsa) '''
		«IF generateAddTag(t)»
			«fsa.generateFile('''prototipo/src/components/app/«t.name.toLowerCase»/«t.name.toLowerCase»-add.tag''', t.genApiAdd(model, fsa, false).gen(model))»
		«ENDIF»
		
		«IF generateEditTag(t)»
			«fsa.generateFile('''prototipo/src/components/app/«t.name.toLowerCase»/«t.name.toLowerCase»-edit.tag''', t.genApiEdit(model, fsa, false).gen(model))»
		«ENDIF»
		
		«IF generateDeleteTag(t)»
			«fsa.generateFile('''prototipo/src/components/app/«t.name.toLowerCase»/«t.name.toLowerCase»-delete.tag''', t.genApiDelete(model, fsa, true).gen(model))»
		«ENDIF»		
		
		«IF generateSearchTag(t)»
			«fsa.generateFile('''prototipo/src/components/app/«t.name.toLowerCase»/«t.name.toLowerCase»-form.tag''', t.genApiForm(model, fsa, false).gen(model))»
		«ENDIF»
	'''

	def dispatch generateAddTag(Entity t){
		var generate = false;
		
		if( t.actions !== null && !t.actions.action.filter(ActionAdd).isNullOrEmpty ){
			generate = TRUE.equals(t.actions.action.filter(ActionAdd).get(0).value);
		}
		
		return generate;
	}
	
	def dispatch generateEditTag(Entity t){
		var generate = false;
		
		if( t.actions !== null && !t.actions.action.filter(ActionEdit).isNullOrEmpty ){
			generate = TRUE.equals(t.actions.action.filter(ActionEdit).get(0).value);
		}
		
		return generate;
	}
	
	def dispatch generateDeleteTag(Entity t){
		var generate = false;
		
		if( t.actions !== null && !t.actions.action.filter(ActionDelete).isNullOrEmpty ){
			generate = TRUE.equals(t.actions.action.filter(ActionDelete).get(0).value);
		}
		
		return generate;
	}

	def dispatch generateSearchTag(Entity t){
		var generate = false;
		
		if( t.actions !== null && !t.actions.action.filter(ActionSearch).isNullOrEmpty ){
			generate = SEARCH_SIMPLE.equals(t.actions.action.filter(ActionSearch).get(0).value) || SEARCH_COMPLEX.equals(t.actions.action.filter(ActionSearch).get(0).value);
		}
		
		return generate;
	}
	
	
	def dispatch genApiAdd(Entity t, Model model, IFileSystemAccess2 fsa, Boolean disabled) '''
	«var contador = 1»
	
	<«t.name.toLowerCase»-add>
		«IF t.glossary !== null && t.glossary.glossary_name !== null && !t.glossary.glossary_name.label.isNullOrEmpty»
		<page id="«t.name.toLowerCase»-add" title="Agregar «t.glossary.glossary_name.label.toFirstUpper»">
		«ELSE»
		<page id="«t.name.toLowerCase»-add" title="Agregar «t.name.toFirstUpper»">
		«ENDIF»
			<formbox title="Datos de «t.name.toFirstUpper»" icon="fa fa-check-circle-o" action="create" return="«t.name.toFirstLower»-admin">
				«FOR EntityField f : t.entity_fields»
					«IF contador % numColumnas == 1»
					<div class="row">
					«ENDIF»
						«f.genEntityField(model, fsa, t, disabled, true)»
					«IF contador % numColumnas == 0 || contador == t.entity_fields.size»
					</div>
					«ENDIF»
					
					<p hidden>«contador++»</p>
				«ENDFOR»
			</formbox>
		</page>
	</«t.name.toLowerCase»-add>	
	'''
	
	def dispatch genApiEdit(Entity t, Model model, IFileSystemAccess2 fsa, Boolean disabled) '''
	«var contador = 1»
	
	<«t.name.toLowerCase»-edit>
		«IF t.glossary !== null && t.glossary.glossary_name !== null && !t.glossary.glossary_name.label.isNullOrEmpty»
		<page id="«t.name.toLowerCase»-edit" title="Editar «t.glossary.glossary_name.label.toFirstUpper»">
		«ELSE»
		<page id="«t.name.toLowerCase»-edit" title="Editar «t.name.toFirstUpper»">
		«ENDIF»	
			<formbox title="Datos de «t.name.toFirstUpper»" icon="fa fa-check-circle-o" action="update" return="«t.name.toFirstLower»-admin">
				«FOR EntityField f : t.entity_fields»
					«IF contador % numColumnas == 1»
					<div class="row">
					«ENDIF»
						«f.genEntityField(model, fsa, t, disabled, true)»
					«IF contador % numColumnas == 0 || contador == t.entity_fields.size»
					</div>
					«ENDIF»
					
					<p hidden>«contador++»</p>
				«ENDFOR»
			</formbox>
		</page>
	</«t.name.toLowerCase»-edit>
	'''
	
	def dispatch genApiDelete(Entity t, Model model, IFileSystemAccess2 fsa, Boolean disabled) '''
	«var contador = 1»
	
	<«t.name.toLowerCase»-delete>
		«IF t.glossary !== null && t.glossary.glossary_name !== null && !t.glossary.glossary_name.label.isNullOrEmpty»
		<page id="«t.name.toLowerCase»-delete" title="Eliminar «t.glossary.glossary_name.label.toFirstUpper»">
		«ELSE»
		<page id="«t.name.toLowerCase»-delete" title="Eliminar «t.name.toFirstUpper»">
		«ENDIF»	
			<formbox title="Datos de «t.name.toFirstUpper»" icon="fa fa-check-circle-o" action="delete" return="«t.name.toFirstLower»-admin">
				«FOR EntityField f : t.entity_fields»
					«IF contador % numColumnas == 1»
					<div class="row">
					«ENDIF»
						«f.genEntityField(model, fsa, t, disabled, true)»
					«IF contador % numColumnas == 0 || contador == t.entity_fields.size»
					</div>
					«ENDIF»
					
					<p hidden>«contador++»</p>
				«ENDFOR»
			</formbox>
		</page>
	</«t.name.toLowerCase»-delete>
	'''
	
	

	def dispatch genApiForm(Entity t, Model model, IFileSystemAccess2 fsa, Boolean disabled) '''
	«var numCamposEntity = t.entity_fields.size»
	«var contador = 1»
	
	<«t.name.toLowerCase»-form>
	
		«IF SEARCH_COMPLEX.equals(t.actions.action.filter(ActionSearch).get(0).value)»
			«FOR EntityField f : t.entity_fields»
				«var isExposed = isExposedFilterEntityField(f)»
	
				«IF isExposed»
					«IF contador % numColumnas == 1»
						<div class="row">
					«ENDIF»
						«f.genEntityField(model, fsa, t, disabled, false)»
					«IF contador % numColumnas == 0 || contador == numCamposEntity»
						</div>
					«ENDIF»
	
					<p hidden>«contador++»</p>
				«ENDIF»	
			«ENDFOR»
		«ELSE»
			<div class="row">
				<div class="col-md-12">
					<div class="col-md-11"  style="padding-left: 0px; padding-right: 0px;">
						<input type="text" class="form-control" placeholder="Criterios de busqueda..." name="busquedaAfiliado" [(ngModel)]="busquedaAfiliado">
					</div>
					<div class="col-md-1" style="padding-left: 0px;">
						<submit-button action="search"></submit-button>
				    </div>
				</div>
			</div>
			
		«ENDIF»
	</«t.name.toLowerCase»-form>
	'''
	
	def getFieldIndex(Entity entity){
        var returnfield="";
        for ( c:entity.eContents()) {
    	  if (c.eClass().getName().contains("MethodDeclaration")) {
    		var m = c as MethodDeclaration
    		if (m.name=="toString"){
    			var s = m.def_statements.get(0) as StatementReturn
    			returnfield = s.entityfield.name
    		   
    		}
    	  }
        }
        
        var index=0;
        for ( c:entity.eContents()) {
        	//println(c.eClass().getName())
    	  if (c.eClass().getName().contains("Field")) {
    		var f = c as EntityField
    		 //println(f.name)
    		 //println(returnfield)
    		if (f.name==returnfield){
    			return index
    		}
    		index=index+1;
    	  }
        }
	}
	
	def isModalBox(EntityReferenceField r){
		var existswidget=false;
		for (EntityReferenceFieldAttr a : r.attrs){
			if (a.eContents.get(0).eClass.name==="WidgetEnum"){
				existswidget=true
				if (a.eContents.get(0).eContents.filter(WidgetTypeSelect).length===0
				    &&	a.eContents.get(0).eContents.filter(WidgetType).length===0) {
				    	 return true
				    }
			
		   }
		}
		if (existswidget==false) 
		  return true 
		else
		  return false
	}
	
	def dispatch getOptionSelectAuto(Entity f,EntityReferenceField r)'''
	«FOR EntityReferenceFieldAttr a : r.attrs »
								«IF a.widget !== null && a.widget.attrs.filter(WidgetType) !== null && !a.widget.attrs.filter(WidgetType).isEmpty»
									«IF a.widget.attrs.filter(WidgetType).get(0).type.trim.equals("Autocomplete") && r.upperBound.trim.equals("1")»
									  <select-auto id="«f.name»" type="select" placeholder="«r.attrs.filter(EntityReferenceFieldAttr).get(0).glossary.glossary_description.label»" data="«f.name.toLowerCase»-results" required=true fieldindex="«getFieldIndex(f)»">
									    
									  </select-auto>
									«ENDIF»
									«IF a.widget.attrs.filter(WidgetType).get(0).type.trim.equals("Option") && r.upperBound.trim.equals("1")»
									  <select-box id="«f.name»" type="option" placeholder="«r.attrs.filter(EntityReferenceFieldAttr).get(0).glossary.glossary_description.label»" data="«f.name.toLowerCase»-results" required=true fieldindex="«getFieldIndex(f)»">
									  </select-box>
									«ENDIF»
								«ENDIF»
								
								«IF a.widget !== null && a.widget.attrs.filter(WidgetTypeSelect) !== null && !a.widget.attrs.filter(WidgetTypeSelect).isEmpty»
									«IF a.widget.attrs.filter(WidgetTypeSelect).get(0).type.trim.equals("SelectList") && r.upperBound.trim.equals("1")»
									  <select-box id="«f.name»" type="select" placeholder="«r.attrs.filter(EntityReferenceFieldAttr).get(0).glossary.glossary_description.label»" data="«f.name.toLowerCase»-results" required=true fieldindex="«getFieldIndex(f)»">
									  </select-box>
									«ENDIF»
								«ENDIF»
	«ENDFOR»
	'''
	
	/* nuevo - ancho columnas */
	def dispatch genEntitySuperType(Entity f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, EntityReferenceField r, Boolean validateFieldRequired)'''
		«IF r.upperBound == "1"»
		«IF f.equals(r.superType)»
			<div class="col-md-«anchoColumn»">
			«var requerido = isRequiredAttrb(r)»
			«IF isModalBox(r)»
						«IF isEntityFieldWithGlossary(r).toString.trim.equals("true")»
							«IF validateFieldRequired && (requerido === null || requerido.toString.isEmpty || (requerido !== null && !requerido.toString.trim.isEmpty && requerido.toString.trim.equals("true")))»
								<label class="control-label">«r.attrs.filter(EntityReferenceFieldAttr).get(0).glossary.glossary_name.label»<font color="red"> *</font></label>
							«ELSE»
								<label class="control-label">«r.attrs.filter(EntityReferenceFieldAttr).get(0).glossary.glossary_name.label»</label>
			            	«ENDIF»
						«ELSEIF isEntityFieldWithOutGlossaryWithConstraint(r).toString.trim.equals("true")»
							«IF validateFieldRequired && (requerido === null || requerido.toString.isEmpty || (requerido !== null && !requerido.toString.trim.isEmpty && requerido.toString.trim.equals("true")))»
								<label class="control-label">«f.name.toFirstUpper»<font color="red"> *</font></label>
							«ELSE»
								<label class="control-label">«f.name.toFirstUpper»</label>
							«ENDIF»
						«ELSE»
							<label class="control-label">«f.name.toFirstUpper»</label>
						«ENDIF»
			 «ENDIF»
			 <div class="form-group">
			 <!-- Modal -->
			  «IF isEntityFieldWithGlossary(r).toString.trim.equals("true")»
				«IF disabled»
					<small id="searchboxsample" required=false>«r.attrs.filter(EntityReferenceFieldAttr).get(0).glossary.glossary_description.label»</small>
				«ELSE»	
				    «IF !isModalBox(r)»
				    «getOptionSelectAuto(f, r)»	
				    «ELSE»
				    <search-box id="searchboxsample" link="«r.name»modal" caption="«f.name.toFirstUpper»" placeholder="«r.attrs.filter(EntityReferenceFieldAttr).get(0).glossary.glossary_description.label»" />
				    <modal-box id="«r.name»modal"  data="«f.name.toLowerCase»-results" title="Seleccionar «f.name.toFirstUpper» " action="select-one" pagination="true"/>
        		    «ENDIF»
        		«ENDIF»
        	  «ELSE»
        		«IF disabled»
        			<small id="searchboxsample" required=false>«f.name.toFirstUpper»</small>
        		«ELSE»	
        		    «IF !isModalBox(r)»
        		    «getOptionSelectAuto(f, r)»	
        		    «ELSE»
        		    <search-box id="searchboxsample" link="«r.name»modal" caption="«f.name.toFirstUpper»" placeholder="«f.name.toFirstUpper»" />
        		    <modal-box id="«r.name»modal"  data="«f.name.toLowerCase»-results" title="Seleccionar «f.name.toFirstUpper» " action="select-one" pagination="true"/>
        		    «ENDIF»
        		«ENDIF»
	          «ENDIF»
			 </div>
	        </div>
		«ENDIF»
		«ENDIF»
	'''
	
	/* nuevo - ancho columna */
	def dispatch genEntitySuperType(Enum f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, EntityReferenceField r, Boolean validateFieldRequired)'''
      «IF f.equals(r.superType)»
	      <div class="col-md-«anchoColumn»">
	      «var requerido = isRequiredAttrb(r)»
	      
	      «IF disabled»
	      	«IF isEntityFieldWithGlossary(r).toString.trim.equals("true")»
	      		«IF !f.enum_literals.isEmpty»
	      		<outputtext id="«f.name»" label="«r.attrs.filter(EntityReferenceFieldAttr).get(0).glossary.glossary_name.label»" value="«f.enum_literals.get(0).value»" />
	      		«ELSE»
	      		<outputtext id="«f.name»" label="«r.attrs.filter(EntityReferenceFieldAttr).get(0).glossary.glossary_name.label»" value="Seleccione una opcion" />
	      		«ENDIF»
	      	«ELSE»
	      		<outputtext id="«f.name»" label="«f.name»" value="«f.name»" />
	      	«ENDIF»
	      «ELSE»	      
		      «IF isEntityFieldWithGlossary(r).toString.trim.equals("true")»
		      	«IF validateFieldRequired && requerido !== null && !requerido.toString.trim.isEmpty && requerido.toString.trim.equals("true")»
			  		<select-box id="«r.name»" type="select" placeholder="«r.attrs.filter(EntityReferenceFieldAttr).get(0).glossary.glossary_name.label»" required=«requerido»>
			  	«ELSE»
			  		<select-box id="«r.name»" type="select" placeholder="«r.attrs.filter(EntityReferenceFieldAttr).get(0).glossary.glossary_name.label»" required=false>
			  	«ENDIF»
			  «ELSEIF isEntityFieldWithOutGlossaryWithConstraint(r).toString.trim.equals("true")»
			    «IF validateFieldRequired && requerido !== null && !requerido.toString.trim.isEmpty && requerido.toString.trim.equals("true")»
			    	<select-box id="«r.name»" type="select" placeholder="«f.name»" required=«requerido»>
			    «ELSE»
			    	<select-box id="«r.name»" type="select" placeholder="«f.name»" required=false>
			    «ENDIF»
			  «ELSE»
			  	«IF validateFieldRequired»
				  	<select-box id="«r.name»" type="select" placeholder="«f.name»" required=true>
				«ELSE»
					<select-box id="«r.name»" type="select" placeholder="«f.name»" required=false>
				«ENDIF»  	
			  «ENDIF»
	
				«FOR EnumLiteral e: f.enum_literals»
					<option-box id="«r.name + '-'+ e.key»" label="«e.value»" />
				«ENDFOR»
			  	</select-box>
		  «ENDIF»
		  </div>
      «ENDIF»
	'''
		
//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_
	
	
	/* nuevo - ancho columna */
	def dispatch genEntitySuperTypeDefault(Entity f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, EntityReferenceField r, Boolean validateFieldRequired)'''
	«IF r.upperBound == "1"»
	«IF f.equals(r.superType)»
		<div class="col-md-«anchoColumn»">
		«IF validateFieldRequired»
			<label class="control-label">«f.name.toFirstUpper»<font color="red"> *</font></label>
		«ELSE»
			<label class="control-label">«f.name.toFirstUpper»</label>
		«ENDIF»
		<div class="form-group">
		«IF disabled»
			<small id="searchboxsample" required=false>Seleccionar «f.name.toFirstUpper»</small>
		«ELSE»
			<!-- Modal -->
			<search-box id="searchboxsample" link="«r.name»modal" caption="«f.name.toFirstUpper»" placeholder="«f.name.toFirstUpper»" />
			<modal-box id="«r.name»modal"  data="«f.name.toLowerCase»-results" title="Seleccionar «f.name.toFirstUpper» " action="select-multi" pagination="true"/>
		«ENDIF»
		</div>
		</div>
    «ENDIF»
    «ENDIF»
	'''
	
	/* nuevo - ancho columna */
	def dispatch genEntitySuperTypeDefault(Enum f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, EntityReferenceField r, Boolean validateFieldRequired)'''
      «IF f.equals(r.superType)»
	      <div class="col-md-«anchoColumn»">
	      «IF disabled»
	      	«IF !f.enum_literals.empty»
	      	<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.enum_literals.get(0).value»" />
	      	«ELSE»
	      	<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="Seleccione una opcion" />
	      	«ENDIF»
	      «ELSE»
		      «IF validateFieldRequired»
			  	<select-box id="«r.name»" type="select" placeholder="«f.name.toFirstUpper»" required=true>
			  «ELSE»
			  	<select-box id="«r.name»" type="select" placeholder="«f.name.toFirstUpper»" required=false>
			  «ENDIF»  
			  	«FOR EnumLiteral e: f.enum_literals»
			  		<option-box id="«r.name + '-' + e.key»" label="«e.value»" />
			    «ENDFOR»
			  </select-box>
		  «ENDIF»
		  </div>
      «ENDIF»
	'''	
//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_	
	
	def dispatch genEntityField(EntityReferenceField f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, Boolean pantallaVisible)'''
		«var visibleField = isVisibleEntityField(f).toString»
		
		«IF pantallaVisible || (visibleField !== null && !visibleField.toString.trim.isEmpty && visibleField.toString.trim.equals("true"))»
			«IF f.attrs.size > 0»
				«««------------------------- codigo original -------------------------------
				«FOR AbstractElement a : model.module.elements»
					«a.genEntitySuperType(model, fsa, t, disabled, f, pantallaVisible)»
				«ENDFOR»
				«««-------------------------------------------------------------------------
			«ELSE»
				«FOR AbstractElement a : model.module.elements»
					«a.genEntitySuperTypeDefault(model, fsa, t, disabled, f, pantallaVisible)»
				«ENDFOR»
			«ENDIF»
		«ENDIF»
	'''

	def isEntityFieldWithGlossary(EntityReferenceField f)'''
		«FOR EntityReferenceFieldAttr a : f.attrs »
			«IF a.glossary !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isEntityFieldWithOutGlossaryWithConstraint(EntityReferenceField f)'''
		«FOR EntityReferenceFieldAttr a : f.attrs »
			«IF a.constraint !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isVisibleEntityField(EntityReferenceField f)'''
		«FOR EntityReferenceFieldAttr a : f.attrs »
			«IF a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty»
				«a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isRequiredAttrb(EntityReferenceField f)'''
		«FOR EntityReferenceFieldAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintRequired) !== null && !a.constraint.constraints.filter(ConstraintRequired).isEmpty »
					«a.constraint.constraints.filter(ConstraintRequired).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''

	/**
	 * Con la variable "validateFieldRequired" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */		
	def dispatch genEntityField(EntityTextField f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, Boolean pantallaVisible) '''
		«var visibleField = isVisibleEntityField(f)»
		«IF pantallaVisible || (visibleField !== null && !visibleField.toString.trim.isEmpty && visibleField.toString.trim.equals("true"))»
			<div class="col-md-«anchoColumn»">	
			«IF f.attrs.size > 0 »
				«IF isEntityFieldWithGlossary(f).toString.trim.equals("true")»
					«FOR EntityTextFieldAttr a : f.attrs »
						«a.genTextEntityAttr(f, t, disabled, pantallaVisible)»
					«ENDFOR»
				«ELSEIF isEntityFieldWithOutGlossaryWithConstraint(f).toString.trim.equals("true")»
					«var requerido = isRiquiredAttrb(f)»
					«var minLength = getMinLengthAttb(f)»
					«var maxLength = getMaxLengthAttb(f)»
					
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
					«ELSE»					
						«IF pantallaVisible && requerido !== null && !requerido.toString.trim.isEmpty»
							«IF minLength !== null && !minLength.toString.trim.isEmpty»
								«IF maxLength !== null && !maxLength.toString.trim.isEmpty»
									<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=«requerido» disabled=«disabled» minsize=«minLength» maxsize=«maxLength» />
								«ELSE»
									<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=«requerido» disabled=«disabled» minsize=«minLength» />
								«ENDIF»
							«ELSE»
								«IF maxLength !== null && !maxLength.toString.trim.isEmpty»
									<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=«requerido» disabled=«disabled» maxsize=«maxLength» />
								«ELSE»
									<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=«requerido» disabled=«disabled» />
								«ENDIF»
							«ENDIF»
						«ELSE»
							«IF minLength !== null && !minLength.toString.trim.isEmpty»
								«IF maxLength !== null && !maxLength.toString.trim.isEmpty»
									«IF pantallaVisible»
										<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» minsize=«minLength» maxsize=«maxLength» />
									«ELSE»
										<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» minsize=«minLength» maxsize=«maxLength» />
									«ENDIF»
								«ELSE»
									«IF pantallaVisible»
										<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» minsize=«minLength» />
									«ELSE»
										<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» minsize=«minLength» />
									«ENDIF»
								«ENDIF»
							«ELSE»
								«IF maxLength !== null && !maxLength.toString.trim.isEmpty»
									«IF pantallaVisible»
										<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» maxsize=«maxLength» />
									«ELSE»
										<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» maxsize=«maxLength» />
									«ENDIF»
								«ELSE»
									«IF pantallaVisible»
										<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» />
									«ELSE»
										<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» />
									«ENDIF»
								«ENDIF»
							«ENDIF»	
						«ENDIF»
					«ENDIF»
				«ELSE»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
					«ELSE»
						«IF pantallaVisible»
							<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» />
						«ELSE»
							<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» />
						«ENDIF»
					«ENDIF»
				«ENDIF»
			«ELSE»
				«IF disabled»
					<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
				«ELSE»	
					«IF pantallaVisible»	
						<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» />
					«ELSE»
						<inputbox id="«f.name»" type="text" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» />
					«ENDIF»
				«ENDIF»
			«ENDIF»
			</div>
		«ENDIF»
	'''
	
	def isEntityFieldWithGlossary(EntityTextField f)'''
		«FOR EntityTextFieldAttr a : f.attrs »
			«IF a.glossary !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isEntityFieldWithOutGlossaryWithConstraint(EntityTextField f)'''
		«FOR EntityTextFieldAttr a : f.attrs »
			«IF a.constraint !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isVisibleEntityField(EntityTextField f)'''
		«FOR EntityTextFieldAttr a : f.attrs »
			«IF a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty»
				«a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter»
			«ENDIF»
		«ENDFOR»
	'''
	
	/**
	 * Con la variable "validateFieldRequired" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */	
	def genTextEntityAttr(EntityTextFieldAttr a, EntityTextField f, Entity t, Boolean disabled, Boolean validateFieldRequired)'''
		«IF a.glossary !== null»
			«var requerido = isRiquiredAttrb(f)»
			«var minLength = getMinLengthAttb(f)»
			«var maxLength = getMaxLengthAttb(f)»
			
			«IF disabled»
				<outputtext id="«f.name»" label="«a.glossary.glossary_name.label»" value="«a.glossary.glossary_description.label»" />
			«ELSE»
				«IF validateFieldRequired && requerido !== null && !requerido.toString.trim.isEmpty»
					«IF minLength !== null && !minLength.toString.trim.isEmpty»
						«IF maxLength !== null && !maxLength.toString.trim.isEmpty»
							<inputbox id="«f.name»" type="text" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=«requerido» disabled=«disabled» minsize=«minLength» maxsize=«maxLength» />
						«ELSE»
							<inputbox id="«f.name»" type="text" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=«requerido» disabled=«disabled» minsize=«minLength» />
						«ENDIF»
					«ELSE»
						«IF maxLength !== null && !maxLength.toString.trim.isEmpty»
							<inputbox id="«f.name»" type="text" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=«requerido» disabled=«disabled» maxsize=«maxLength» />
						«ELSE»
							<inputbox id="«f.name»" type="text" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=«requerido» disabled=«disabled» />
						«ENDIF»	
					«ENDIF»
				«ELSE»
					«IF minLength !== null && !minLength.toString.trim.isEmpty»
						«IF maxLength !== null && !maxLength.toString.trim.isEmpty»
							«IF validateFieldRequired»
								<inputbox id="«f.name»" type="text" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=true disabled=«disabled» minsize=«minLength» maxsize=«maxLength» />
							«ELSE»
								<inputbox id="«f.name»" type="text" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» minsize=«minLength» maxsize=«maxLength» />
							«ENDIF»
						«ELSE»
							«IF validateFieldRequired»
								<inputbox id="«f.name»" type="text" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=true disabled=«disabled» minsize=«minLength» />
							«ELSE»
								<inputbox id="«f.name»" type="text" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» minsize=«minLength» />
							«ENDIF»
						«ENDIF»
					«ELSE»
						«IF maxLength !== null && !maxLength.toString.trim.isEmpty»
							«IF validateFieldRequired»
								<inputbox id="«f.name»" type="text" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=true disabled=«disabled» maxsize=«maxLength» />
							«ELSE»
								<inputbox id="«f.name»" type="text" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» maxsize=«maxLength» />
							«ENDIF»
						«ELSE»
							«IF validateFieldRequired»
								<inputbox id="«f.name»" type="text" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=true disabled=«disabled» />
							«ELSE»
								<inputbox id="«f.name»" type="text" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» />
							«ENDIF»
						«ENDIF»
					«ENDIF»
				«ENDIF»
			«ENDIF»
		«ENDIF»		
	'''
	
	def isRiquiredAttrb(EntityTextField f)'''
		«FOR EntityTextFieldAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintRequired) !== null && !a.constraint.constraints.filter(ConstraintRequired).isEmpty »
					«a.constraint.constraints.filter(ConstraintRequired).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''
	
	def getMinLengthAttb(EntityTextField f)'''
		«FOR EntityTextFieldAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintMinLength) !== null && !a.constraint.constraints.filter(ConstraintMinLength).isEmpty »
					«a.constraint.constraints.filter(ConstraintMinLength).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''	

	def getMaxLengthAttb(EntityTextField f)'''
		«FOR EntityTextFieldAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintMaxLength) !== null && !a.constraint.constraints.filter(ConstraintMaxLength).isEmpty »
					«a.constraint.constraints.filter(ConstraintMaxLength).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''	
	
	/**
	 * Con la variable "pantallaVisible" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */	
	def dispatch genEntityField( EntityLongTextField f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, Boolean pantallaVisible) '''
		«var visibleField = isVisibleEntityField(f)»		
		«IF pantallaVisible || (visibleField !== null && !visibleField.toString.trim.isEmpty && visibleField.toString.trim.equals("true"))»
			<div class="col-md-«anchoColumn»">
			«IF f.attrs.size > 0»
				«IF isEntityFieldWithGlossary(f).toString.trim.equals("true")»		
					«FOR EntityLongTextFieldAttr a : f.attrs »	
						«a.genLongTextEntityAttr(f, disabled, pantallaVisible)»
					«ENDFOR»
				«ELSEIF isEntityFieldWithOutGlossaryWithConstraint(f).toString.trim.equals("true")»
					«var requerido = isRequiredAttrb(f)»
					«var minLength = getMinLengthAttb(f)»
					«var maxLength = getMaxLengthAttb(f)»
					
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="Ingresa tus comentarios" />
					«ELSE»
						«IF requerido !== null && !requerido.toString.trim.isEmpty»
							«IF minLength !== null && !minLength.toString.trim.isEmpty»
								«IF maxLength !== null && !maxLength.toString.trim.isEmpty»	
									«IF pantallaVisible»
										<inputbox id="«f.name»" type="textarea" label="«f.name.toFirstUpper»" value="" placeholder="Ingresa tus comentarios" required=«requerido» disabled=«disabled» minsize=«minLength» maxsize=«maxLength» lines=5 />
									«ELSE»
										<inputbox id="«f.name»" type="textarea" label="«f.name.toFirstUpper»" value="" placeholder="Ingresa tus comentarios" required=false disabled=«disabled» minsize=«minLength» maxsize=«maxLength» lines=5 />
									«ENDIF»
								«ELSE»
									«IF pantallaVisible»
										<inputbox id="«f.name»" type="textarea" label="«f.name.toFirstUpper»" value="" placeholder="Ingresa tus comentarios" required=«requerido» disabled=«disabled» minsize=«minLength» />
									«ELSE»
										<inputbox id="«f.name»" type="textarea" label="«f.name.toFirstUpper»" value="" placeholder="Ingresa tus comentarios" required=false disabled=«disabled» minsize=«minLength» />
									«ENDIF»
								«ENDIF»
							«ENDIF»			
						«ELSE»
							«IF minLength !== null && !minLength.toString.trim.isEmpty»
								«IF maxLength !== null && !maxLength.toString.trim.isEmpty»
									«IF pantallaVisible»
										<inputbox id="«f.name»" type="textarea" label="«f.name.toFirstUpper»" value="" placeholder="Ingresa tus comentarios" required=true disabled=«disabled» minsize=«minLength» maxsize=«maxLength» />
									«ELSE»
										<inputbox id="«f.name»" type="textarea" label="«f.name.toFirstUpper»" value="" placeholder="Ingresa tus comentarios" required=false disabled=«disabled» minsize=«minLength» maxsize=«maxLength» />
									«ENDIF»
								«ELSE»
									«IF pantallaVisible»
										<inputbox id="«f.name»" type="textarea" label="«f.name.toFirstUpper»" value="" placeholder="Ingresa tus comentarios" required=true disabled=«disabled» minsize=«minLength» />
									«ELSE»
										<inputbox id="«f.name»" type="textarea" label="«f.name.toFirstUpper»" value="" placeholder="Ingresa tus comentarios" required=false disabled=«disabled» minsize=«minLength» />
									«ENDIF»
								«ENDIF»
							«ENDIF»	
						«ENDIF»
					«ENDIF»	
				«ELSE»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="Ingresa tus comentarios" />
					«ELSE»
						«IF pantallaVisible»
							<inputbox id="«f.name»" type="textarea" label="«f.name.toFirstUpper»" value="" placeholder="Ingresa tus comentarios" required=true disabled=«disabled» />
						«ELSE»
							<inputbox id="«f.name»" type="textarea" label="«f.name.toFirstUpper»" value="" placeholder="Ingresa tus comentarios" required=false disabled=«disabled» />
						«ENDIF»
					«ENDIF»
				«ENDIF»
			«ELSE»
				«IF disabled»
					<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="Ingresa tus comentarios" />
				«ELSE»
					«IF pantallaVisible»
						<inputbox id="«f.name»" type="textarea" label="«f.name.toFirstUpper»" value="" placeholder="Ingresa tus comentarios" required=true disabled=«disabled» />
					«ELSE»
						<inputbox id="«f.name»" type="textarea" label="«f.name.toFirstUpper»" value="" placeholder="Ingresa tus comentarios" required=false disabled=«disabled» />
					«ENDIF»
				«ENDIF»
			«ENDIF»
			</div>
		«ENDIF»			
	'''
	
	/**
	 * Con la variable "omitRequired" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */
	def genLongTextEntityAttr(EntityLongTextFieldAttr a, EntityLongTextField f, Boolean disabled, Boolean validateFieldRequired)'''
		«IF a.glossary !== null»
			«var requerido = isRequiredAttrb(f)»
			«var minLength = getMinLengthAttb(f)»
			«var maxLength = getMaxLengthAttb(f)»
			
			«IF disabled»
				<outputtext id="«f.name»" label="«a.glossary.glossary_name.label»" value="«a.glossary.glossary_description.label»" />
			«ELSE»
				«IF requerido !== null && !requerido.toString.trim.isEmpty»
					«IF minLength !== null && !minLength.toString.trim.isEmpty»
						«IF maxLength !== null && !maxLength.toString.trim.isEmpty»			
							«IF validateFieldRequired»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=«requerido» disabled=«disabled» minsize=«minLength» maxsize=«maxLength» lines=5 />
							«ELSE»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» minsize=«minLength» maxsize=«maxLength» lines=5 />
							«ENDIF»
						«ELSE»	
							«IF validateFieldRequired»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=«requerido» disabled=«disabled» minsize=«minLength» />
							«ELSE»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» minsize=«minLength» />
							«ENDIF»
						«ENDIF»
					«ELSE»
						«IF maxLength !== null && !maxLength.toString.trim.isEmpty»		
							«IF validateFieldRequired»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=«requerido» disabled=«disabled» maxsize=«maxLength» />
							«ELSE»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» maxsize=«maxLength» />
							«ENDIF»
						«ELSE»	
							«IF validateFieldRequired»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=«requerido» disabled=«disabled» />
							«ELSE»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» />
							«ENDIF»
						«ENDIF»
					«ENDIF»			
				«ELSE»
					«IF minLength !== null && !minLength.toString.trim.isEmpty»
						«IF maxLength !== null && !maxLength.toString.trim.isEmpty»		
							«IF validateFieldRequired»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=true disabled=«disabled» minsize=«minLength» maxsize=«maxLength» />
							«ELSE»		
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» minsize=«minLength» maxsize=«maxLength» />
							«ENDIF»
						«ELSE»
							«IF validateFieldRequired»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=true disabled=«disabled» minsize=«minLength» />
							«ELSE»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» minsize=«minLength» />
							«ENDIF»	
						«ENDIF»
					«ELSE»
						«IF maxLength !== null && !maxLength.toString.trim.isEmpty»
							«IF validateFieldRequired»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=true disabled=«disabled» maxsize=«maxLength» />
							«ELSE»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» maxsize=«maxLength» />
							«ENDIF»
						«ELSE»
							«IF validateFieldRequired»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=true disabled=«disabled» />
							«ELSE»
								<inputbox id="«f.name»" type="textarea" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» />
							«ENDIF»
						«ENDIF»
					«ENDIF»		
				«ENDIF»
			«ENDIF»
		«ENDIF»		
	'''
	
	def isEntityFieldWithGlossary(EntityLongTextField f)'''
		«FOR EntityLongTextFieldAttr a : f.attrs »
			«IF a.glossary !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isEntityFieldWithOutGlossaryWithConstraint(EntityLongTextField f)'''
		«FOR EntityLongTextFieldAttr a : f.attrs »
			«IF a.constraint !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''	
	
	def isVisibleEntityField(EntityLongTextField f)'''
		«FOR EntityLongTextFieldAttr a : f.attrs »
			«IF a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty»
				«a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter»
			«ENDIF»
		«ENDFOR»
	'''	
	
	def isRequiredAttrb(EntityLongTextField f)'''
		«FOR EntityLongTextFieldAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintRequired) !== null && !a.constraint.constraints.filter(ConstraintRequired).isEmpty»
					«a.constraint.constraints.filter(ConstraintRequired).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''	
	
	def getMinLengthAttb(EntityLongTextField f)'''
		«FOR EntityLongTextFieldAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintMinLength) !== null && !a.constraint.constraints.filter(ConstraintMinLength).isEmpty »
					«a.constraint.constraints.filter(ConstraintMinLength).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''	

	def getMaxLengthAttb(EntityLongTextField f)'''
		«FOR EntityLongTextFieldAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintMaxLength) !== null && !a.constraint.constraints.filter(ConstraintMaxLength).isEmpty »
					«a.constraint.constraints.filter(ConstraintMaxLength).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''	
	
	/**
	 * Con la variable "pantallaVisible" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */		
	def dispatch genEntityField( EntityDateField f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, Boolean pantallaVisible) '''
		«var visibleField = isVisibleEntityField(f)»
		«IF pantallaVisible || (visibleField !== null && !visibleField.toString.trim.isEmpty && visibleField.toString.trim.equals("true"))»
			<div class="col-md-«anchoColumn»">
			«IF f.attrs.size > 0»
				«IF isEntityFieldWithGlossary(f).toString.trim.equals("true")»	
					«FOR EntityDateFieldAttr a : f.attrs »	
						«a.genDateEntityAttr(f, disabled, pantallaVisible)»
					«ENDFOR»			
				«ELSEIF isEntityFieldWithOutGlossaryWithConstraint(f).toString.trim.equals("true")»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name»" value="«f.name»" />
					«ELSE»
						«IF pantallaVisible»
							«var requerido = isRiquiredAttrb(f)»
							«IF requerido !== null && !requerido.toString.trim.isEmpty»
								<date-picker id="«f.name»" type= "date" label="«f.name»" placeholder="«f.name»" required=«requerido» disabled=«disabled» />
							«ELSE»
								<date-picker id="«f.name»" type= "date" label="«f.name»" placeholder="«f.name»" required=true disabled=«disabled» />
							«ENDIF»	
						«ELSE»
							<date-picker id="«f.name»" type= "date" label="«f.name»" placeholder="«f.name»" required=false disabled=«disabled» />
						«ENDIF»
					«ENDIF»
				«ELSE»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name»" value="«f.name»" />
					«ELSE»
						«IF pantallaVisible»
							<date-picker id="«f.name»" type= "date" label="«f.name»" placeholder="«f.name»" required=true disabled=«disabled» />	
						«ELSE»
							<date-picker id="«f.name»" type= "date" label="«f.name»" placeholder="«f.name»" required=false disabled=«disabled» />	
						«ENDIF»
					«ENDIF»
				«ENDIF»
			«ELSE»
				«IF disabled»
					<outputtext id="«f.name»" label="«f.name»" value="«f.name»" />
				«ELSE»
					«IF pantallaVisible»
						<date-picker id="«f.name»" type= "date" label="«f.name»" placeholder="«f.name»" required=true disabled=«disabled» />
					«ELSE»
						<date-picker id="«f.name»" type= "date" label="«f.name»" placeholder="«f.name»" required=false disabled=«disabled» />
					«ENDIF»
				«ENDIF»
			«ENDIF»
			</div>
		«ENDIF»
	'''

	/**
	 * Con la variable "validateFieldRequired" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */
	def genDateEntityAttr(EntityDateFieldAttr a, EntityDateField f, Boolean disabled, Boolean validateFieldRequired)'''
		«IF a.glossary !== null»
			«IF disabled»
				<outputtext id="«f.name»" label="«a.glossary.glossary_name.label»" value="«a.glossary.glossary_description.label»" />
			«ELSE»
				«IF validateFieldRequired»
					«var requerido = isRiquiredAttrb(f)»
					«IF requerido !== null && !requerido.toString.trim.isEmpty»
						<date-picker id="«f.name»" type= "date" label="«a.glossary.glossary_name.label»" placeholder="«a.glossary.glossary_description.label»" required=«requerido» disabled=«disabled» />
					«ELSE»
						<date-picker id="«f.name»" type= "date" label="«a.glossary.glossary_name.label»" placeholder="«a.glossary.glossary_description.label»" required=true disabled=«disabled» />
					«ENDIF»			
				«ELSE»
					<date-picker id="«f.name»" type= "date" label="«a.glossary.glossary_name.label»" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» />			
				«ENDIF»
			«ENDIF»
		«ENDIF»		
	'''
	
	def isEntityFieldWithGlossary(EntityDateField f)'''
		«FOR EntityDateFieldAttr a : f.attrs »
			«IF a.glossary !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isEntityFieldWithOutGlossaryWithConstraint(EntityDateField f)'''
		«FOR EntityDateFieldAttr a : f.attrs »
			«IF a.constraint !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isVisibleEntityField(EntityDateField f)'''
		«FOR EntityDateFieldAttr a : f.attrs »
			«IF a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty»
				«a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter»
			«ENDIF»
		«ENDFOR»
	'''

	def isRiquiredAttrb(EntityDateField f)'''
		«FOR EntityDateFieldAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintRequired) !== null && !a.constraint.constraints.filter(ConstraintRequired).isEmpty»
					«a.constraint.constraints.filter(ConstraintRequired).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''
		
	/**
	 * Con la variable "pantallaVisible" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */	
	def dispatch genEntityField( EntityImageField f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, Boolean pantallaVisible) '''
		«var visibleField = isVisibleEntityField(f)»
		«IF pantallaVisible || (visibleField !== null && !visibleField.toString.trim.isEmpty && visibleField.toString.trim.equals("true"))»
			<div class="col-md-«anchoColumn»">
			«IF f.attrs.size > 0»
				«IF isEntityFieldWithGlossary(f).toString.trim.equals("true")»	
					«FOR EntityAttr a : f.attrs »	
						«a.genImageEntityAttr(f, disabled, pantallaVisible)»
					«ENDFOR»			
				«ELSEIF isEntityFieldWithOutGlossaryWithConstraint(f).toString.trim.equals("true")»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper»" />
					«ELSE»
						«IF pantallaVisible»
							«var requerido = isRiquiredAttrb(f)»
							«IF requerido !== null && !requerido.toString.trim.isEmpty»
								<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="jpg, png, bmp" required=«requerido» disabled=«disabled» />
							«ELSE»
								<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="jpg, png, bmp" required=true disabled=«disabled» />
							«ENDIF»	
						«ELSE»
							<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="jpg, png, bmp" required=false disabled=«disabled» />
						«ENDIF»
					«ENDIF»
				«ELSE»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper»" />
					«ELSE»
						«IF pantallaVisible»
							<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="jpg, png, bmp" required=true disabled=«disabled» />	
						«ELSE»
							<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="jpg, png, bmp" required=false disabled=«disabled» />	
						«ENDIF»
					«ENDIF»	
				«ENDIF»
			«ELSE»	
				«IF disabled»
					<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper»" />
				«ELSE»	
					«IF pantallaVisible»
						<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="jpg, png, bmp" required=true disabled=«disabled» />
					«ELSE»
						<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="jpg, png, bmp" required=false disabled=«disabled» />
					«ENDIF»
				«ENDIF»	
			«ENDIF»
			</div>
		«ENDIF»
	'''
	
	/**
	 * Con la variable "validateFieldRequired" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */
	def genImageEntityAttr(EntityAttr a, EntityImageField f, Boolean disabled, Boolean validateFieldRequired)'''
		«IF a.glossary !== null»
			«IF disabled»
				<outputtext id="«f.name»" label="«a.glossary.glossary_name.label»" value="«a.glossary.glossary_name.label»" />
			«ELSE»
				«IF validateFieldRequired»
					«var requerido = isRiquiredAttrb(f)»
					«IF requerido !== null && !requerido.toString.trim.isEmpty»
						<attach-photo id="«f.name»" label="«a.glossary.glossary_name.label»" height="200" width="400" maxsizemb="7" filetypes="jpg, png, bmp" required=«requerido» disabled=«disabled» />
					«ELSE»
						<attach-photo id="«f.name»" label="«a.glossary.glossary_name.label»" height="200" width="400" maxsizemb="7" filetypes="jpg, png, bmp" required=true disabled=«disabled» />
					«ENDIF»
				«ELSE»
					<attach-photo id="«f.name»" label="«a.glossary.glossary_name.label»" height="200" width="400" maxsizemb="7" filetypes="jpg, png, bmp" required=false disabled=«disabled» />
				«ENDIF»
			«ENDIF»
		«ENDIF»
	'''
	
	def isEntityFieldWithGlossary(EntityImageField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.glossary !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isEntityFieldWithOutGlossaryWithConstraint(EntityImageField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.constraint !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isVisibleEntityField(EntityImageField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty»
				«a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter»
			«ENDIF»
		«ENDFOR»
	'''
		
	def isRiquiredAttrb(EntityImageField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintRequired) !== null && !a.constraint.constraints.filter(ConstraintRequired).isEmpty»
					«a.constraint.constraints.filter(ConstraintRequired).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''		
	
	/**
	 * Con la variable "pantallaVisible" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */
	def dispatch genEntityField( EntityFileField f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, Boolean pantallaVisible) '''
		«var visibleField = isVisibleEntityField(f)»
		«IF pantallaVisible || (visibleField !== null && !visibleField.toString.trim.isEmpty && visibleField.toString.trim.equals("true"))»
			<div class="col-md-«anchoColumn»">
			«IF f.attrs.size > 0»	
				«IF isEntityFieldWithGlossary(f).toString.trim.equals("true")»	
					«FOR EntityAttr a : f.attrs »	
						«a.genFileEntityAttr(f, disabled, pantallaVisible)»
					«ENDFOR»
				«ELSEIF isEntityFieldWithOutGlossaryWithConstraint(f).toString.trim.equals("true")»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper»" />
					«ELSE»
						«IF pantallaVisible»
							«var requerido = isRiquiredAttrb(f)»
							«IF requerido !== null && !requerido.toString.trim.isEmpty»
								<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="docx, pdf, txt" required=«requerido» disabled=«disabled» />
							«ELSE»
								<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="docx, pdf, txt" required=true disabled=«disabled» />
							«ENDIF»
						«ELSE»
							<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="docx, pdf, txt" required=false disabled=«disabled» />
						«ENDIF»
					«ENDIF»	
				«ELSE»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper»" />
					«ELSE»
						«IF pantallaVisible»
							<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="docx, pdf, txt" required=true disabled=«disabled» />
						«ELSE»
							<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="docx, pdf, txt" required=false disabled=«disabled» />
						«ENDIF»
					«ENDIF»	
				«ENDIF»
			«ELSE»
				«IF disabled»
					<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper»" />
				«ELSE»
					«IF pantallaVisible»
						<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="docx, pdf, txt" required=true disabled=«disabled» />
					«ELSE»
						<attach-photo id="«f.name»" label="«f.name.toFirstUpper»" height="200" width="400" maxsizemb="7" filetypes="docx, pdf, txt" required=false disabled=«disabled» />
					«ENDIF»
				«ENDIF»	
			«ENDIF»
			</div>
		«ENDIF»
	'''
	
	/**
	 * Con la variable "validateFieldRequired" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */
	def genFileEntityAttr(EntityAttr a, EntityFileField f, Boolean disabled, Boolean validateFieldRequired)'''
		«IF a.glossary !== null»
			«IF disabled»
				<outputtext id="«f.name»" label="«a.glossary.glossary_name.label»" value="«a.glossary.glossary_name.label»" />
			«ELSE»
				«IF validateFieldRequired»
					«var requerido = isRiquiredAttrb(f)»
					«IF requerido !== null && !requerido.toString.trim.isEmpty»
						<attach-photo id="«f.name»" label="«a.glossary.glossary_name.label»" height="200" width="400" maxsizemb="7" filetypes="docx, pdf, txt" required=«requerido» disabled=«disabled» />
					«ELSE»
						<attach-photo id="«f.name»" label="«a.glossary.glossary_name.label»" height="200" width="400" maxsizemb="7" filetypes="docx, pdf, txt" required=true disabled=«disabled» />
					«ENDIF»			
				«ELSE»
					<attach-photo id="«f.name»" label="«a.glossary.glossary_name.label»" height="200" width="400" maxsizemb="7" filetypes="docx, pdf, txt" required=false disabled=«disabled» />
				«ENDIF»
			«ENDIF»
		«ENDIF»
	'''
	
	def isEntityFieldWithGlossary(EntityFileField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.glossary !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isEntityFieldWithOutGlossaryWithConstraint(EntityFileField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.constraint !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''	
	
	def isVisibleEntityField(EntityFileField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty»
				«a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter»
			«ENDIF»
		«ENDFOR»
	'''
		
	def isRiquiredAttrb(EntityFileField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintRequired) !== null && !a.constraint.constraints.filter(ConstraintRequired).isEmpty»
					«a.constraint.constraints.filter(ConstraintRequired).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''
	
	/**
	 * Con la variable "pantallaVisible" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */	
	def dispatch genEntityField( EntityEmailField f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, Boolean pantallaVisible) '''
		«var visibleField = isVisibleEntityField(f)»
		«IF pantallaVisible || (visibleField !== null && !visibleField.toString.trim.isEmpty && visibleField.toString.trim.equals("true"))»	
			<div class="col-md-«anchoColumn»">	
			«IF f.attrs.size > 0»	
				«IF isEntityFieldWithGlossary(f).toString.trim.equals("true")»	
					«FOR EntityAttr a : f.attrs »	
						«a.genEmailEntityAttr(f, disabled, pantallaVisible)»
					«ENDFOR»
				«ELSEIF isEntityFieldWithOutGlossaryWithConstraint(f).toString.trim.equals("true")»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
					«ELSE»
						«IF pantallaVisible»
							«var requerido = isRiquiredAttrb(f)»
							«IF requerido !== null && !requerido.toString.trim.isEmpty»
								<inputbox id="«f.name»" type="email" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=«requerido» disabled=«disabled» minsize=3 maxsize=100 />
							«ELSE»
								<inputbox id="«f.name»" type="email" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» minsize=3 maxsize=100 />
							«ENDIF»
						«ELSE»
							<inputbox id="«f.name»" type="email" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» minsize=3 maxsize=100 />
						«ENDIF»
					«ENDIF»
				«ELSE»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
					«ELSE»
						«IF pantallaVisible»
							<inputbox id="«f.name»" type="email" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» minsize=3 maxsize=100 />
						«ELSE»
							<inputbox id="«f.name»" type="email" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» minsize=3 maxsize=100 />
						«ENDIF»
					«ENDIF»
				«ENDIF»
			«ELSE»
				«IF disabled»
					<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
				«ELSE»		
					«IF pantallaVisible»
						<inputbox id="«f.name»" type="email" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» minsize=3 maxsize=100 />
					«ELSE»
						<inputbox id="«f.name»" type="email" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» minsize=3 maxsize=100 />
					«ENDIF»
				«ENDIF»	
			«ENDIF»
			</div>
		«ENDIF»
	'''
	
	/**
	 * Con la variable "validateFieldRequired" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */
	def genEmailEntityAttr(EntityAttr a, EntityEmailField f, Boolean disabled, Boolean validateFieldRequired)'''
		«IF a.glossary !== null»
			«IF disabled»
				<outputtext id="«f.name»" label="«a.glossary.glossary_name.label»" value="«a.glossary.glossary_description.label»" />
			«ELSE»
				«IF validateFieldRequired»
					«var requerido = isRiquiredAttrb(f)»
					«IF requerido !== null && !requerido.toString.trim.isEmpty»
						<inputbox id="«f.name»" type="email" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=«requerido» disabled=«disabled» minsize=3 maxsize=100 />
					«ELSE»
						<inputbox id="«f.name»" type="email" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=true disabled=«disabled» minsize=3 maxsize=100 />
					«ENDIF»		
				«ELSE»
					<inputbox id="«f.name»" type="email" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» minsize=3 maxsize=100 />
				«ENDIF»
			«ENDIF»
		«ENDIF»
	'''

	def isEntityFieldWithGlossary(EntityEmailField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.glossary !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isEntityFieldWithOutGlossaryWithConstraint(EntityEmailField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.constraint !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''

	def isVisibleEntityField(EntityEmailField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty»
				«a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter»
			«ENDIF»
		«ENDFOR»
	'''
		
	def isRiquiredAttrb(EntityEmailField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintRequired) !== null && !a.constraint.constraints.filter(ConstraintRequired).isEmpty»
					«a.constraint.constraints.filter(ConstraintRequired).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''
	
	/**
	 * Con la variable "pantallaVisible" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */	
	def dispatch genEntityField( EntityDecimalField f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, Boolean pantallaVisible) '''
		«var visibleField = isVisibleEntityField(f)»
		«IF pantallaVisible || (visibleField !== null && !visibleField.toString.trim.isEmpty && visibleField.toString.trim.equals("true"))»	
			<div class="col-md-«anchoColumn»">	
			«IF f.attrs.size > 0»	
				«IF isEntityFieldWithGlossary(f).toString.trim.equals("true")»	
					«FOR EntityAttr a : f.attrs »	
						«a.genDecimalEntityAttr(f, disabled, pantallaVisible)»
					«ENDFOR»
				«ELSEIF isEntityFieldWithOutGlossaryWithConstraint(f).toString.trim.equals("true")»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
					«ELSE»
						«IF pantallaVisible»
							«var requerido = isRiquiredAttrb(f)»
							«IF requerido !== null && !requerido.toString.trim.isEmpty»
								<inputbox id="«f.name»" type="float" step="any" label="«f.name.toFirstUpper»" value="0.00" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=«requerido» disabled=«disabled» min=0.50 max=8.00 />
							«ELSE»
								<inputbox id="«f.name»" type="float" step="any" label="«f.name.toFirstUpper»" value="0.00" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» min=0.50 max=8.00 />
							«ENDIF»
						«ELSE»
							<inputbox id="«f.name»" type="float" step="any" label="«f.name.toFirstUpper»" value="0.00" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» min=0.50 max=8.00 />
						«ENDIF»
					«ENDIF»	
				«ELSE»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
					«ELSE»
						«IF pantallaVisible»
							<inputbox id="«f.name»" type="float" step="any" label="«f.name.toFirstUpper»" value="0.00" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» min=0.50 max=8.00 />
						«ELSE»
							<inputbox id="«f.name»" type="float" step="any" label="«f.name.toFirstUpper»" value="0.00" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» min=0.50 max=8.00 />
						«ENDIF»
					«ENDIF»	
				«ENDIF»
			«ELSE»	
				«IF disabled»
					<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
				«ELSE»
					«IF pantallaVisible»
						<inputbox id="«f.name»" type="float" step="any" label="«f.name.toFirstUpper»" value="0.00" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» min=0.50 max=8.00 />
					«ELSE»	
						<inputbox id="«f.name»" type="float" step="any" label="«f.name.toFirstUpper»" value="0.00" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» min=0.50 max=8.00 />
					«ENDIF»
				«ENDIF»
			«ENDIF»
			</div>
		«ENDIF»
	'''
	
	/**
	 * Con la variable "validateFieldRequired" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */
	def genDecimalEntityAttr(EntityAttr a, EntityDecimalField f, Boolean disabled, Boolean validateFieldRequired)'''
		«IF a.glossary !== null»
			«IF disabled»
				<outputtext id="«f.name»" label="«a.glossary.glossary_name.label»" value="«a.glossary.glossary_description.label»" />
			«ELSE»
				«IF validateFieldRequired»
					«var requerido = isRiquiredAttrb(f)»
					«IF requerido !== null && !requerido.toString.trim.isEmpty»
						<inputbox id="«f.name»" type="float" step="any" label="«a.glossary.glossary_name.label»" value="0.00" precision=2 placeholder="«a.glossary.glossary_description.label»" required=«requerido» disabled=«disabled» min=0.50 max=8.00 />
					«ELSE»
						<inputbox id="«f.name»" type="float" step="any" label="«a.glossary.glossary_name.label»" value="0.00" precision=2 placeholder="«a.glossary.glossary_description.label»" required=true disabled=«disabled» min=0.50 max=8.00 />
					«ENDIF»
				«ELSE»
					<inputbox id="«f.name»" type="float" step="any" label="«a.glossary.glossary_name.label»" value="0.00" precision=2 placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» min=0.50 max=8.00 />
				«ENDIF»
			«ENDIF»	
		«ENDIF»
	'''
	
	def isEntityFieldWithGlossary(EntityDecimalField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.glossary !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isEntityFieldWithOutGlossaryWithConstraint(EntityDecimalField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.constraint !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isVisibleEntityField(EntityDecimalField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty»
				«a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter»
			«ENDIF»
		«ENDFOR»
	'''
		
	def isRiquiredAttrb(EntityDecimalField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintRequired) !== null && !a.constraint.constraints.filter(ConstraintRequired).isEmpty»
					«a.constraint.constraints.filter(ConstraintRequired).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''
	
	/**
	 * Con la variable "pantallaVisible" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.	
	 */
	def dispatch genEntityField( EntityIntegerField f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, Boolean pantallaVisible) '''
		«var visibleField = isVisibleEntityField(f)»
		«IF pantallaVisible || (visibleField !== null && !visibleField.toString.trim.isEmpty && visibleField.toString.trim.equals("true"))»
			<div class="col-md-«anchoColumn»">			
			«IF f.attrs.size > 0»	
				«IF isEntityFieldWithGlossary(f).toString.trim.equals("true")»	
					«FOR EntityAttr a : f.attrs »	
						«a.genIntegerEntityAttr(f, disabled, pantallaVisible)»
					«ENDFOR»
				«ELSEIF isEntityFieldWithOutGlossaryWithConstraint(f).toString.trim.equals("true")»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
					«ELSE»
						«IF pantallaVisible»
							«var requerido = isRiquiredAttrb(f)»
							«IF requerido !== null && !requerido.toString.trim.isEmpty»
								<inputbox id="«f.name»" type="number" pattern="[0-9]" onkeypress="return event.charCode >= 48 && event.charCode <= 57" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=«requerido» disabled=«disabled» minsize=3 maxsize=100 />
							«ELSE»
								<inputbox id="«f.name»" type="number" pattern="[0-9]" onkeypress="return event.charCode >= 48 && event.charCode <= 57" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» minsize=3 maxsize=100 />
							«ENDIF»
						«ELSE»
							<inputbox id="«f.name»" type="number" pattern="[0-9]" onkeypress="return event.charCode >= 48 && event.charCode <= 57" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» minsize=3 maxsize=100 />
						«ENDIF»
					«ENDIF»	
				«ELSE»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
					«ELSE»
						«IF pantallaVisible»
							<inputbox id="«f.name»" type="number" pattern="[0-9]" onkeypress="return event.charCode >= 48 && event.charCode <= 57" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» minsize=3 maxsize=100 />
						«ELSE»
							<inputbox id="«f.name»" type="number" pattern="[0-9]" onkeypress="return event.charCode >= 48 && event.charCode <= 57" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» minsize=3 maxsize=100 />
						«ENDIF»
					«ENDIF»	
				«ENDIF»							
			«ELSE»		
				«IF disabled»
					<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
				«ELSE»
					«IF pantallaVisible»
						<inputbox id="«f.name»" type="number" pattern="[0-9]" onkeypress="return event.charCode >= 48 && event.charCode <= 57" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» minsize=3 maxsize=100 />
					«ELSE»
						<inputbox id="«f.name»" type="number" pattern="[0-9]" onkeypress="return event.charCode >= 48 && event.charCode <= 57" label="«f.name.toFirstUpper»" value="" placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» minsize=3 maxsize=100 />
					«ENDIF»
				«ENDIF»
			«ENDIF»
			</div>
		«ENDIF»
	'''
	
	/**
	 * Con la variable "validateFieldRequired" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */
	def genIntegerEntityAttr(EntityAttr a, EntityIntegerField f, Boolean disabled, Boolean validateFieldRequired)'''
		«IF a.glossary !== null»
			«IF disabled»
				<outputtext id="«f.name»" label="«a.glossary.glossary_name.label»" value="«a.glossary.glossary_description.label»" />
			«ELSE»
				«IF validateFieldRequired»
					«var requerido = isRiquiredAttrb(f)»
					«IF requerido !== null && !requerido.toString.trim.isEmpty»
						<inputbox id="«f.name»" type="number" pattern="[0-9]" onkeypress="return event.charCode >= 48 && event.charCode <= 57" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=«requerido» disabled=«disabled» minsize=3 maxsize=100 />
					«ELSE»
						<inputbox id="«f.name»" type="number" pattern="[0-9]" onkeypress="return event.charCode >= 48 && event.charCode <= 57" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=true disabled=«disabled» minsize=3 maxsize=100 />
					«ENDIF»		
				«ELSE»
					<inputbox id="«f.name»" type="number" pattern="[0-9]" onkeypress="return event.charCode >= 48 && event.charCode <= 57" label="«a.glossary.glossary_name.label»" value="" placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» minsize=3 maxsize=100 />
				«ENDIF»
			«ENDIF»
		«ENDIF»
	'''
	
	def isEntityFieldWithGlossary(EntityIntegerField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.glossary !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isEntityFieldWithOutGlossaryWithConstraint(EntityIntegerField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.constraint !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isVisibleEntityField(EntityIntegerField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty»
				«a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter»
			«ENDIF»
		«ENDFOR»
	'''
		
	def isRiquiredAttrb(EntityIntegerField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintRequired) !== null && !a.constraint.constraints.filter(ConstraintRequired).isEmpty»
					«a.constraint.constraints.filter(ConstraintRequired).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''
	
	/**
	 * Con la variable "pantallaVisible" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */
	def dispatch genEntityField( EntityCurrencyField f, Model model, IFileSystemAccess2 fsa, Entity t, Boolean disabled, Boolean pantallaVisible) '''
		«var visibleField = isVisibleEntityField(f)»
		«IF pantallaVisible || (visibleField !== null && !visibleField.toString.trim.isEmpty && visibleField.toString.trim.equals("true"))»	
			<div class="col-md-«anchoColumn»">
			
			«IF f.attrs.size > 0»	
				«IF isEntityFieldWithGlossary(f).toString.trim.equals("true")»	
					«FOR EntityAttr a : f.attrs »	
						«a.genIntegerEntityAttr(f, disabled, pantallaVisible)»
					«ENDFOR»
				«ELSEIF isEntityFieldWithOutGlossaryWithConstraint(f).toString.trim.equals("true")»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
					«ELSE»
						«IF pantallaVisible»
							«var requerido = isRiquiredAttrb(f)»
							«IF requerido !== null && !requerido.toString.trim.isEmpty»
								<inputbox id="«f.name»" type="currency" label="«f.name.toFirstUpper»" value="" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=«requerido» disabled=«disabled» min=1.00 max=1000000.00 />
							«ELSE»
								<inputbox id="«f.name»" type="currency" label="«f.name.toFirstUpper»" value="" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» min=1.00 max=1000000.00 />
							«ENDIF»					
						«ELSE»
							<inputbox id="«f.name»" type="currency" label="«f.name.toFirstUpper»" value="" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» min=1.00 max=1000000.00 />
						«ENDIF»
					«ENDIF»
				«ELSE»
					«IF disabled»
						<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
					«ELSE»
						«IF pantallaVisible»
							<inputbox id="«f.name»" type="currency" label="«f.name.toFirstUpper»" value="" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» min=1.00 max=1000000.00 />
						«ELSE»
							<inputbox id="«f.name»" type="currency" label="«f.name.toFirstUpper»" value="" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» min=1.00 max=1000000.00 />
						«ENDIF»
					«ENDIF»	
				«ENDIF»							
			«ELSE»
				«IF disabled»
					<outputtext id="«f.name»" label="«f.name.toFirstUpper»" value="«f.name.toFirstUpper» del «t.name»" />
				«ELSE»
					«IF pantallaVisible»
						<inputbox id="«f.name»" type="currency" label="«f.name.toFirstUpper»" value="" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=true disabled=«disabled» min=1.00 max=1000000.00 />
					«ELSE»
						<inputbox id="«f.name»" type="currency" label="«f.name.toFirstUpper»" value="" precision=2 placeholder="«f.name.toFirstUpper» del «t.name»" required=false disabled=«disabled» min=1.00 max=1000000.00 />
					«ENDIF»
				«ENDIF»
			«ENDIF»
			</div>
		«ENDIF»
	'''

	/**
	 * Con la variable "validateFieldRequired" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios.
	 * Con la variable "disabled" se valida si se trata de la pantalla delete, en cuyo caso todos los campos se muestran como label's.
	 */	
	def genIntegerEntityAttr(EntityAttr a, EntityCurrencyField f, Boolean disabled, Boolean validateFieldRequired)'''
		«IF a.glossary !== null»
			«IF disabled»
				<outputtext id="«f.name»" label="«a.glossary.glossary_name.label»" value="«a.glossary.glossary_description.label»" />
			«ELSE»
				<!-- Con la variable "pantallaVisible" se VALIDA SI SE TRATA DE LA SECCION CRITERIOS DE BUSQUEDA, en cuyo caso los campos no son obligatorios -->
				«IF validateFieldRequired»
					«var requerido = isRiquiredAttrb(f)»
					«IF requerido !== null && !requerido.toString.trim.isEmpty»
						<inputbox id="«f.name»" type="currency" label="«a.glossary.glossary_name.label»" value="" precision=2 placeholder="«a.glossary.glossary_description.label»" required=«requerido» disabled=«disabled» min=1.00 max=1000000.00 />
					«ELSE»
						<inputbox id="«f.name»" type="currency" label="«a.glossary.glossary_name.label»" value="" precision=2 placeholder="«a.glossary.glossary_description.label»" required=true disabled=«disabled» min=1.00 max=1000000.00 />
					«ENDIF»		
				«ELSE»
					<inputbox id="«f.name»" type="currency" label="«a.glossary.glossary_name.label»" value="" precision=2 placeholder="«a.glossary.glossary_description.label»" required=false disabled=«disabled» min=1.00 max=1000000.00 />
				«ENDIF»
			«ENDIF»
		«ENDIF»
	'''
	
	def isEntityFieldWithGlossary(EntityCurrencyField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.glossary !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isEntityFieldWithOutGlossaryWithConstraint(EntityCurrencyField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.constraint !== null»
				«true»
			«ENDIF»
		«ENDFOR»
	'''
	
	def isVisibleEntityField(EntityCurrencyField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty»
				«a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter»
			«ENDIF»
		«ENDFOR»
	'''
		
	def isRiquiredAttrb(EntityCurrencyField f)'''
		«FOR EntityAttr a : f.attrs »
			«IF a.constraint !== null»
				«IF a.constraint.constraints.filter(ConstraintRequired) !== null && !a.constraint.constraints.filter(ConstraintRequired).isEmpty»
					«a.constraint.constraints.filter(ConstraintRequired).get(0).value»
				«ENDIF»
			«ENDIF»
		«ENDFOR»		
	'''	
	
//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
	def dispatch isExposedFilterEntityField(EntityReferenceField f){
		var isExposed = false;
		
		for(EntityReferenceFieldAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty){
				isExposed = "true".equals(a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter); 
			}
		}
		
		return isExposed;
	}

	def dispatch isExposedFilterEntityField(EntityTextField f){
		var isExposed = false;

		for(EntityTextFieldAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty){
				isExposed = "true".equals(a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter);
			}
		}
		
		return isExposed;
	}

	def dispatch isExposedFilterEntityField(EntityLongTextField f){
		var isExposed = false;
		
		for(EntityLongTextFieldAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty){
				isExposed = "true".equals(a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter);
			}
		}
		
		return isExposed;
	}	

	def dispatch isExposedFilterEntityField(EntityDateField f){
		var isExposed = false;
		
		for(EntityDateFieldAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty){
				isExposed = "true".equals(a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter);
			}
		}
		
		return isExposed;
	}

	def dispatch isExposedFilterEntityField(EntityImageField f){
		var isExposed = false;
		
		for(EntityAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty){
				isExposed = "true".equals(a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter);
			}
		}
		
		return isExposed;
	}

	def dispatch isExposedFilterEntityField(EntityFileField f){
		var isExposed = false;

		for(EntityAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty){
				isExposed = "true".equals(a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter);
			}
		}
		
		return isExposed;
	}

	def dispatch isExposedFilterEntityField(EntityEmailField f){
		var isExposed = false;
		
		for(EntityAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty){
				isExposed = "true".equals(a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter);
			}
		}
		
		return isExposed;
	}

	def dispatch isExposedFilterEntityField(EntityDecimalField f){
		var isExposed = false;
		
		for(EntityAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty){
				isExposed = "true".equals(a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter);
			}
		}
		
		return isExposed;
	}

	def dispatch isExposedFilterEntityField(EntityIntegerField f){
		var isExposed = false;
		
		for(EntityAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty){
				isExposed = "true".equals(a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter);
			}
		}
		
		return isExposed;
	}

	def dispatch isExposedFilterEntityField(EntityCurrencyField f){
		var isExposed = false;
		
		for(EntityAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetExposedFilter) !== null && !a.widget.attrs.filter(WidgetExposedFilter).isEmpty){
				isExposed = "true".equals(a.widget.attrs.filter(WidgetExposedFilter).get(0).exposed_filter);
			}
		}
		
		return isExposed;
	}
	
//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/	
		
	def dispatch genEntityTextConstraint(ConstraintRequired b)'''
		<p style="color: lime">«b.value»</p>
		«b.value»
	'''

	def dispatch genEntityTextConstraint(ConstraintUnique b)'''
		ConstraintUnique
	'''

	def dispatch genEntityTextConstraint(ConstraintMaxLength b)'''
		ConstraintMaxLength
	'''

	def dispatch genEntityTextConstraint(ConstraintMinLength b)'''
		ConstraintMinLength
	'''

	
	def gen(CharSequence body, Model model) '''
		«body»
	'''

	def static toUpperCase(String it){
	  toUpperCase
	}
	
	def static toLowerCase(String it){
	  toLowerCase
	}
}
