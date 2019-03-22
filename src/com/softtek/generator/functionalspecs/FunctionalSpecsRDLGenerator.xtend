package com.softtek.generator.functionalspecs

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import com.softtek.rdl2.Module
import com.softtek.rdl2.Enum
import com.softtek.rdl2.Entity
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
import com.softtek.rdl2.ConstraintRequired
import com.softtek.rdl2.ConstraintUnique
import com.softtek.rdl2.ConstraintMaxLength
import com.softtek.rdl2.ConstraintMinLength
import com.softtek.rdl2.EnumLiteral
import com.softtek.rdl2.EntityField
import java.util.HashSet
import org.eclipse.emf.ecore.EObject
import com.softtek.rdl2.WidgetDisplayResult
import com.softtek.rdl2.EntityAttr
import com.softtek.rdl2.WidgetExposedFilter
import com.softtek.rdl2.EntityReferenceFieldAttr
import com.softtek.rdl2.EntityLongTextFieldAttr
import com.softtek.rdl2.EntityDateFieldAttr
import com.softtek.rdl2.EntityTextFieldAttr
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.Task
import com.softtek.rdl2.CommandQuery

class FunctionalSpecsRDLGenerator {
	var accChapters = new HashSet<String>()
	def doGeneratorUml(Resource resource, IFileSystemAccess2 fsa) {
		
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			accChapters.add(generateChaptersMainDocumentTex(resource, fsa).toString) 
		}
		
		fsa.generateFile("functional-specs/functional-spec.tex", generateMainDocumentTex(resource,fsa,accChapters))
		fsa.generateFile("functional-specs/title-page.tex", generateTitlePageTex(resource, fsa))
			
		 
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			//for (e : m.elements.filter(typeof(Entity))) {
			fsa.generateFile("functional-specs/domain-model/DOM-" + m.name + "/domain-model.plantuml", m.generateModuleDOMEntityDiagram)
			
			fsa.generateFile("functional-specs/domain-model/DOM-" + m.name + "/domain-model-enum.plantuml", m.generateModuleDOMEnumDiagram)
			fsa.generateFile("functional-specs/domain-model/DOM-" + m.name + ".tex", m.generateModuleDOM)
			fsa.generateFile("functional-specs/use-cases/UC-" + m.name + ".tex", m.generateModuleUC)
			fsa.generateFile("functional-specs/ui-specs/UI-" + m.name + ".tex", m.generateModuleUI)
			m.generateUCDiagrams(fsa)
			//fsa.generateFile("cypress/integration/" + m.name + "-Screenshots.js", m.generateModuleScreenshotUI)
			//}
		}
	}
	

    def CharSequence generateModuleDOMEnumDiagram(Module m) '''
		@startuml
		title «m.name»
		«FOR e : m.elements»
		    «IF e instanceof Enum»
		      «e.genModuleElementDOMClass»
			«ENDIF»
		«ENDFOR»
		@enduml
	'''
	
	def CharSequence generateModuleDOMEntityDiagram(Module m) '''
		@startuml
		title «m.name»
		«FOR e : m.elements»
		   «IF e instanceof Entity»
		     «e.genModuleElementDOMClass»
		   «ENDIF»
		«ENDFOR»
		«var HashSet<String> bidirectionalRelationships = new HashSet()»
		«FOR e : m.elements»
		     «IF e instanceof Entity»
		        «e.genRelationshipsDOMClass(m, bidirectionalRelationships)»
		     «ENDIF»
		«ENDFOR»
		@enduml
	'''
  
	
	def dispatch genModuleElementDOMClass(Enum e) '''
		enum «e.name» <<enum>> {
			«FOR l : e.enum_literals»
				«l.genEnumLiteral»
			«ENDFOR»
		}
	'''
	
	def CharSequence genEnumLiteral(EnumLiteral literal) '''
		«literal.value.replace("(","[").replace(")","]")»
	'''
	
	def dispatch genModuleElementDOMClass(Entity e) '''
		entity «e.name» <<entity>> {
			«FOR f : e.entity_fields»
				«f.genEntityFieldDOM(e)»
			«ENDFOR»
		}
	'''
	
	// Field Description DOM
	def dispatch genEntityFieldDOM(EntityReferenceField field, Entity e) '''
		«field.superType.genRelationshipEnumDOM(e, field)»
	'''
	def dispatch genRelationshipEnumDOM(Enum toEnum, Entity fromEntity, EntityReferenceField fromField) '''
		«fromField.name» : «toEnum.name»
	'''
	
	def dispatch genRelationshipEnumDOM(Entity toEntity, Entity fromEntity, EntityReferenceField fromField) '''
	'''
	
	def dispatch genEntityFieldDOM(EntityTextField field, Entity e) '''
		«nameOrBusinessRuleEntityField(field)»
	'''
	
	def dispatch genEntityFieldDOM(EntityLongTextField field, Entity e) '''
		«nameOrBusinessRuleEntityField(field)»
	'''
	def dispatch genEntityFieldDOM(EntityDateField field, Entity e) '''
		«nameOrBusinessRuleEntityField(field)»
	'''
	
	def dispatch genEntityFieldDOM(EntityImageField field, Entity e) '''
		«nameOrBusinessRuleEntityField(field)»
	'''
	
	def dispatch genEntityFieldDOM(EntityFileField field, Entity e) '''
		«nameOrBusinessRuleEntityField(field)»
	'''
	def dispatch genEntityFieldDOM(EntityEmailField field, Entity e) '''
		«nameOrBusinessRuleEntityField(field)»
	'''
	
	def dispatch genEntityFieldDOM(EntityDecimalField field, Entity e) '''
		«nameOrBusinessRuleEntityField(field)»
	'''
	
	def dispatch genEntityFieldDOM(EntityIntegerField field, Entity e) '''
		«nameOrBusinessRuleEntityField(field)»
	'''
	
	def dispatch genEntityFieldDOM(EntityCurrencyField field, Entity e) '''
		«nameOrBusinessRuleEntityField(field)»
	'''
	
	def dispatch nameOrBusinessRuleEntityField(EntityTextField f){
		for( a : f.attrs){
			if(a.business_rule !== null){
				return ("/" + f.name + " : Text");
			}
		}
		return (f.name + " : Text")
	}
	
	def dispatch nameOrBusinessRuleEntityField(EntityLongTextField f){
		for( a : f.attrs){
			if(a.business_rule !== null){
				return ("/" + f.name + " : LongText");
			}
		}
		return (f.name + " : LongText")
	}
	
	
	def dispatch nameOrBusinessRuleEntityField(EntityDateField f){
		for( a : f.attrs){
			if(a.business_rule !== null){
				return ("/" + f.name + " : Date");
			}
		}
		return (f.name + " : Date")
	}
	
	def dispatch nameOrBusinessRuleEntityField(EntityImageField f){
		for( a : f.attrs){
			if(a.business_rule !== null){
				return ("/" + f.name + " : Image");
			}
		}
		return (f.name + " : Image")
	}
	
	def dispatch nameOrBusinessRuleEntityField(EntityFileField f){
		for( a : f.attrs){
			if(a.business_rule !== null){
				return ("/" + f.name + " : File");
			}
		}
		return (f.name + " : File")
	}
	
	def dispatch nameOrBusinessRuleEntityField(EntityEmailField f){
		for( a : f.attrs){
			if(a.business_rule !== null){
				return ("/" + f.name + " : Email");
			}
		}
		return (f.name + " : Email")
	}
	
	def dispatch nameOrBusinessRuleEntityField(EntityDecimalField f){
		for( a : f.attrs){
			if(a.business_rule !== null){
				return ("/" + f.name + " : Decimal");
			}
		}
		return (f.name + " : Decimal")
	}
	
	def dispatch nameOrBusinessRuleEntityField(EntityIntegerField f){
		for( a : f.attrs){
			if(a.business_rule !== null){
				return ("/" + f.name + " : Integer");
			}
		}
		return (f.name + " : Integer")
	}
	
	def dispatch nameOrBusinessRuleEntityField(EntityCurrencyField f){
		for( a : f.attrs){
			if(a.business_rule !== null){
				return ("/" + f.name + " : Currency");
			}
		}
		return (f.name + " : Currency")
	}
	
	def dispatch genRelationshipsDOMClass(Enum e, Module m, HashSet<String> bidirectionalRelationships) '''
	'''
	
	def dispatch genRelationshipsDOMClass(Entity e, Module m, HashSet<String> bidirectionalRelationships) '''
		«FOR f : e.entity_fields»
		      «IF e instanceof Entity»
			    «f.genEntityRelationshipDOM(e, m, bidirectionalRelationships)»
			  «ENDIF»
		«ENDFOR»
	'''
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
	// Field Relationship DOM
	def dispatch genEntityRelationshipDOM(EntityReferenceField field, Entity e, Module m, HashSet<String> bidirectionalRelationships) '''
		«IF e instanceof Entity»
		  «field.superType.genRelationshipFieldDOM(e, field, m, bidirectionalRelationships)»
		«ENDIF»
	'''
	
	def dispatch genEntityRelationshipDOM(EntityTextField field, Entity e, Module m, HashSet<String> bidirectionalRelationships) '''
	'''
	
	def dispatch genEntityRelationshipDOM(EntityLongTextField field, Entity e, Module m, HashSet<String> bidirectionalRelationships) '''
	'''
	def dispatch genEntityRelationshipDOM(EntityDateField field, Entity e, Module m, HashSet<String> bidirectionalRelationships) '''
	'''
	
	def dispatch genEntityRelationshipDOM(EntityImageField field, Entity e, Module m, HashSet<String> bidirectionalRelationships) '''
	'''
	
	def dispatch genEntityRelationshipDOM(EntityFileField field, Entity e, Module m, HashSet<String> bidirectionalRelationships) '''
	'''
	def dispatch genEntityRelationshipDOM(EntityEmailField field, Entity e, Module m, HashSet<String> bidirectionalRelationships) '''
	'''
	
	def dispatch genEntityRelationshipDOM(EntityDecimalField field, Entity e, Module m, HashSet<String> bidirectionalRelationships) '''
	'''
	
	def dispatch genEntityRelationshipDOM(EntityIntegerField field, Entity e, Module m, HashSet<String> bidirectionalRelationships) '''
	'''
	
	def dispatch genEntityRelationshipDOM(EntityCurrencyField field, Entity e, Module m, HashSet<String> bidirectionalRelationships) '''
	'''
	
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	def dispatch genRelationshipFieldDOM(Enum toEnum, Entity fromEntity, EntityReferenceField fromField, Module m, HashSet<String> bidirectionalRelationships) '''
	'''
	
	def dispatch genRelationshipFieldDOM(Entity toEntity, Entity fromEntity, EntityReferenceField fromField, Module m, HashSet<String> bidirectionalRelationships) '''
		«var EntityReferenceField erfBidirectional = hasBidirectionalRelationship(fromEntity, fromField, m)»
	
		«IF fromField !== null && fromField.lowerBound.intValue >= 0 && fromField.upperBound !== null»
			«IF erfBidirectional !== null && erfBidirectional.lowerBound.intValue >= 0 && erfBidirectional.upperBound !== null»
				«IF !existBidirectionalRelationship(bidirectionalRelationships, fromEntity, fromField, erfBidirectional)»
					«fromEntity.name» "«erfBidirectional.lowerBound»..«erfBidirectional.upperBound» «fromField.opposite.name»" -- "«fromField.lowerBound»..«fromField.upperBound» «fromField.name»" «toEntity.name»
				«ENDIF»
			«ELSE»
				«fromEntity.name» "0..*" --> "«fromField.lowerBound»..«fromField.upperBound» «fromField.name»" «toEntity.name»
			«ENDIF»
		«ELSE»
			«fromEntity.name» "0..*" --> "1 «fromField.name»" «toEntity.name»
		«ENDIF»
	'''
	
	def dispatch existBidirectionalRelationship(HashSet<String> bidirectionalRelationships, Entity fromEntity, EntityReferenceField fromField, EntityReferenceField toField){
		var String entity = fromEntity.name;
		var String field = fromField.superType.getObject().name;
		
		if( bidirectionalRelationships !== null && (bidirectionalRelationships.contains(entity+"."+field+"-"+fromField.name) || bidirectionalRelationships.contains(field+"."+entity+"-"+fromField.name)) ){
			return true;
		}else {
			/* Se almacenan la referencia bidireccional entre las entidades  */
			bidirectionalRelationships.add(entity+"."+field+"-"+fromField.name);
			bidirectionalRelationships.add(field+"."+entity+"-"+toField.name);
			
			return false;
		}
	}
	
	def dispatch hasBidirectionalRelationship(Entity fromEntity, EntityReferenceField fromField, Module m){
		for( e : m.elements ){
			if (e instanceof Entity){ 
			var EntityReferenceField erf = e.searchBidirectionalRelationship(fromEntity, fromField);
			
			if( erf !== null ){
				return erf;	
			}
			}
		}
		
		return null;
	}
	
	
	def dispatch searchBidirectionalRelationship(Enum e, Entity fromEntity, EntityReferenceField fromField){		
		return null;
	}
	
	def dispatch searchBidirectionalRelationship(Entity toEntity, Entity fromEntity, EntityReferenceField fromField){
		var EntityReferenceField erf = null;
		
		if( fromField.superType.getObject().name.equals(toEntity.name) ){
			for( EntityField ef : toEntity.entity_fields ){
				if( Entity.simpleName.equals(ef.fieldType) && ef instanceof EntityReferenceField){
					erf = ef as EntityReferenceField;
					
					if( erf !== null && erf.superType.getObject() !== null && erf.superType.getObject().name.equals(fromEntity.name) && fromField.opposite !== null && fromField.opposite.name.equals(erf.name) ){
						return erf;
					}else{
						erf = null;
					}
				}
			}
		}
		
		return erf;
	}

	def  dispatch getObject(Enum e){}
	
	def  dispatch getObject(Entity e){
		return e;
	}
		
	def	hasBussinessRule(EntityField f) {
	  if (f instanceof EntityTextField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return true
		 	}
		  }
	  if (f instanceof EntityLongTextField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return true
		 	}
		  }
	  if (f instanceof EntityDateField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return true
		 	}
		  }
	  if (f instanceof EntityImageField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return true
		 	}
		  }
	  if (f instanceof EntityFileField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return true
		 	}
		  }
	  if (f instanceof EntityEmailField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return true
		 	}
		  }
	  if (f instanceof EntityDecimalField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return true
		 	}
		  }
	  if (f instanceof EntityIntegerField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return true
		 	}
		  }
	  if (f instanceof EntityCurrencyField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return true
		 	}
		  }
	  if (f instanceof EntityReferenceField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return true
		 	}
		  }	
	 return false;
	}
	
	def	getBussinessRuleInfo(EntityField f) {
	  if (f instanceof EntityTextField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return a.business_rule.code + "&" + a.business_rule.description
		 	}
		  }
	  if (f instanceof EntityLongTextField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return a.business_rule.code + "&" + a.business_rule.description
		 	}
		  }
	  if (f instanceof EntityDateField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return a.business_rule.code + "&" + a.business_rule.description
		 	}
		  }
	  if (f instanceof EntityImageField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return a.business_rule.code + "&" + a.business_rule.description
		 	}
		  }
	  if (f instanceof EntityFileField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return a.business_rule.code + "&" + a.business_rule.description
		 	}
		  }
	  if (f instanceof EntityEmailField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return a.business_rule.code + "&" + a.business_rule.description
		 	}
		  }
	  if (f instanceof EntityDecimalField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return a.business_rule.code + "&" + a.business_rule.description
		 	}
		  }
	  if (f instanceof EntityIntegerField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return a.business_rule.code + "&" + a.business_rule.description
		 	}
		  }
	  if (f instanceof EntityCurrencyField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return a.business_rule.code + "&" + a.business_rule.description
		 	}
		  }
	  if (f instanceof EntityReferenceField)
		  for( a : f.attrs) {
		 	if(a.business_rule !== null){
				return a.business_rule.code + "&" + a.business_rule.description
		 	}
		  }	  	  	  
	 return "&";
	}
	
	def CharSequence generateModuleDOM(Module m) '''
		%% --------------------------------------------------------------------------------------------------
		%% M\'odulo: «m.name»
		%% --------------------------------------------------------------------------------------------------
		\clearpage
		\section{Modelo de Dominio} \label{sec:dom-«m.name.toLowerCase»}
		\begin{figure}[H]
		\begin{center}
			\label{tab:uml-domain-model}
			\includegraphics[width=0.95\textwidth,height=0.70\textheight]{domain-model/DOM-«m.name»/domain-model.png}
			\caption{Diagrama del Modelo de Dominio}
		\end{center}
		\end{figure}
		\begin{figure}[H]
				\begin{center}
					\label{tab:uml-domain-model}
					\includegraphics[width=0.95\textwidth,height=0.70\textheight]{domain-model/DOM-«m.name»/domain-model-enum.png}
					\caption{Diagrama del Modelo de Dominio Enums}
				\end{center}
		\end{figure}
		\begin{table}[H]
					\caption{Campos Calculados con Regla de Negocio}
					\label{tab:entities}
					%\resizebox{\textwidth}{!}{
					\begin{center}
					\begin{tabularx}{0.90\linewidth}{ X X X X}
						\hline
						\textbf{Entidad} & \textbf{Campo} & \textbf{C\'odigo} & \textbf{Descripci\'on} \\
						\hline
						«FOR e : m.elements»
							«IF e instanceof Entity »
							«FOR f : e.entity_fields»
							     «IF hasBussinessRule(f)»
									«e.name.replaceAll("_", "\\\\_")» &«f.name.replaceAll("_", "\\\\_")» &«getBussinessRuleInfo(f)» \\
								«ENDIF»
							«ENDFOR»
							«ENDIF»
						«ENDFOR»
						\hline
					\end{tabularx}
					\end{center}
					%}
		\end{table}
		
		\clearpage
		\section{Descripci\'on de las Entidades de Negocio} \label{sec:dom-entities-«m.name.toLowerCase»}
		
		\begin{table}[H]
			\caption{Entidades del Modelo de Dominio}
			\label{tab:entities}
			%\resizebox{\textwidth}{!}{
			\begin{center}
			\begin{tabularx}{0.90\linewidth}{ X X }
				\hline
				\textbf{Entidad} & \textbf{Descripci\'on} \\
				\hline
				«FOR e : m.elements»
					«e.genModuleElementDOM»
				«ENDFOR»
				\hline
			\end{tabularx}
			\end{center}
			%}
		\end{table}
		\section{Campos por Entidad de Negocio} \label{sec:entity-fields-«m.name.toLowerCase»}
		
		«FOR e : m.elements»
		    «IF e instanceof Entity»
			 «e.genEntityFields»
			«ENDIF»
		«ENDFOR»
	'''
	
	def dispatch genModuleElementDOM(Enum e) '''
	'''

	def dispatch genModuleElementDOM(PageContainer p) '''
	'''
	
	def dispatch genModuleElementDOM(Task t) '''
	'''
	
	def dispatch genModuleElementDOM(CommandQuery c) '''
	'''
	def dispatch genModuleElementDOM(Entity e) '''
		«e.entityName» (\ref{tab:fields-dom-«e.name»}) & «e.entityDescription» \\
	'''
	def dispatch genEntityFields(Enum e) '''
	'''
	def dispatch genEntityFields(Entity e) '''
		\begin{table}[H]
			\caption{Entidad de Negocio «e.entityName»}
			\label{tab:fields-dom-«e.name»}
			%\resizebox{\textwidth}{!}{
			\begin{center}
			\begin{tabularx}{0.90\linewidth}{ X X X X X }
				\hline
				\textbf{Campo} &
				\textbf{Etiqueta} &
				\textbf{Tipo} &
				\textbf{Restricciones} &
				\textbf{Descripci\'on} \\
				\hline
				«FOR f : e.entity_fields»
				«IF !(f instanceof EntityReferenceField)»
					«f.name.replaceAll("_", "\\\\_")» &
					«f.fieldLabel» &
					«f.fieldType» &
					«f.fieldConstraints» &
					«f.fieldDescription» \\
				«ENDIF»
				«ENDFOR»
				\hline
			\end{tabularx}
			\end{center}
			%}
		\end{table}
	'''
	def CharSequence generateModuleUC(Module m) '''
	
		%% --------------------------------------------------------------------------------------------------
		%% CRUD Use Cases List: «m.name»
		%% --------------------------------------------------------------------------------------------------
		%%\clearpage
		\section{Lista de CU del m\'odulo «m.name»} \label{sec:uc-«m.name.toLowerCase»}
	
		«FOR e : m.elements»
		    «IF e instanceof Entity»
		      «e.genModuleListUC(m)»
		    «ENDIF»
		«ENDFOR»
		«FOR e : m.elements»
		   «IF e instanceof Entity»
		   	  «e.genModuleElementUC(m)»
		   «ENDIF»
		«ENDFOR»
	'''
	
	
	def dispatch genModuleListUC(Enum e, Module m) '''
	'''
	
	def dispatch genModuleListUC(Entity e, Module m) '''
		%%\clearpage
		\begin{table}[H]
			\caption{CU para el Mantenimiento de «e.entityName»}
			\label{uc-entity-«e.name.toLowerCase»}
			%\resizebox{\textwidth}{!}{
			\begin{center}
			\begin{tabularx}{0.90\linewidth}{ X X X }
				\hline
				\textbf{Nombre} & \textbf{Descripci\'on} & \textbf{Actores} \\
				\hline
				«IF isSearchInScaffolding(e)»
				CUXX-01. Buscar «e.entityName» & Buscar «e.entityName». & Operador \\
				«ENDIF»
				«IF isAddInScaffolding(e)»
				CUXX-02. Agregar «e.entityName» & Agregar «e.entityName». & Operador \\
				«ENDIF»
				«IF isEditInScaffolding(e)»
				CUXX-03. Editar «e.entityName» & Editar «e.entityName». & Operador \\
				«ENDIF»
				«IF isDeleteInScaffolding(e)»
				CUXX-04. Eliminar «e.entityName» & Eliminar «e.entityName». & Operador \\
				«ENDIF»
				\hline
			\end{tabularx}
			\end{center}
			%}
		\end{table}
		
		\begin{figure}[H]
			\begin{center}
			\label{tab:ucd-entity-«e.name.toLowerCase»}
			\includegraphics[width=0.5\textwidth]{use-cases/diagrams/UCD-«m.name»/«e.name».png}
			\caption{Diagrama de Casos de Uso para Mantenimiento de «e.entityName»}
			\end{center}
		\end{figure}
	'''
	
	
	
	def void generateUCDiagrams(Module module, IFileSystemAccess2 fsa) {
		for (entity : module.elements) {
			if (entity instanceof Entity)
			 entity.genElementUCDiagram(module, fsa)
		}
	}
	
	def dispatch genElementUCDiagram(Enum element, Module module, IFileSystemAccess2 fsa) '''
	'''
	
	def dispatch genElementUCDiagram(Entity entity, Module module, IFileSystemAccess2 fsa) {
		fsa.generateFile("functional-specs/use-cases/diagrams/UCD-" + module.name + "/" + entity.name + ".plantuml", entity.genUCDPlantUML)
	    //Activity Diagrams
		fsa.generateFile("functional-specs/use-cases/diagrams/SearchActivityUCD-" + module.name + "/" + entity.name + ".plantuml", entity.genSearchActivityUCDPlantUML)
	    fsa.generateFile("functional-specs/use-cases/diagrams/CreateActivityUCD-" + module.name + "/" + entity.name + ".plantuml", entity.genCreateActivityUCDPlantUML)
	    fsa.generateFile("functional-specs/use-cases/diagrams/UpdateActivityUCD-" + module.name + "/" + entity.name + ".plantuml", entity.genUpdateActivityUCDPlantUML)
	    fsa.generateFile("functional-specs/use-cases/diagrams/DeleteActivityUCD-" + module.name + "/" + entity.name + ".plantuml", entity.genDeleteActivityUCDPlantUML)
	}
	
	def CharSequence genUCDPlantUML(Entity entity) '''
		@startuml
			left to right direction
			skinparam packageStyle rectangle
			Operador <<persona>> as Actor
			rectangle {
				«IF isAddInScaffolding(entity)»
				(Agregar «entity.entityNameDOM») as CreateUC <<usuario>>
				«ENDIF»
				«IF isEditInScaffolding(entity)»
				(Editar «entity.entityNameDOM») as EditUC <<usuario>>
				«ENDIF»
				«IF isSearchInScaffolding(entity)»
				(Buscar «entity.entityNameDOM») as SearchUC <<usuario>>
				«ENDIF»
				«IF isDeleteInScaffolding(entity)»
				(Eliminar «entity.entityNameDOM») as DeleteUC <<usuario>>
				«ENDIF»
				«IF isAddInScaffolding(entity)»
				Actor -> CreateUC
				«ENDIF»
				«IF isEditInScaffolding(entity)»
				Actor -> EditUC
				«ENDIF»
				Actor -> SearchUC
				«IF isDeleteInScaffolding(entity)»
				Actor --> DeleteUC
				«ENDIF»
				«IF isEditInScaffolding(entity)»
				EditUC .> SearchUC : include
				«ENDIF»
				«IF isDeleteInScaffolding(entity)»
				DeleteUC .> SearchUC : include
				«ENDIF»
			}
		@enduml
	'''
	
	def boolean isSearchInScaffolding(Entity entity){
		if(entity.actions!==null)
		for(a:entity.actions.action){ 
			if (a.eClass.name.trim.equals("ActionSearch") && !a.value.trim.equals("None"))
			  return true
		}
		return false
	}
	
	def boolean isAddInScaffolding(Entity entity){
		if(entity.actions!==null)
		for(a:entity.actions.action){ 
			if (a.eClass.name.trim.equals("ActionAdd") && a.value.trim.equals("true"))
			  return true
		}
		return false
	}
	
	def boolean isEditInScaffolding(Entity entity){
		if(entity.actions!==null)
		for(a:entity.actions.action){ 
			if (a.eClass.name.trim.equals("ActionEdit") && a.value.trim.equals("true"))
			  return true
		}
		return false
	}
	
	def boolean isDeleteInScaffolding(Entity entity){
		if(entity.actions!==null)
		for(a:entity.actions.action){ 
			if (a.eClass.name.trim.equals("ActionDelete") && a.value.trim.equals("true"))
			  return true
		}
		return false
	}
	
	def dispatch genModuleElementUC(Enum e, Module m) '''
	'''
	def dispatch genModuleElementUC(Entity entity, Module m) '''
		%% --------------------------------------------------------------------------------------------------
		%% CRUD Use Cases: «entity.entityName»
		%% --------------------------------------------------------------------------------------------------
		\clearpage
		\section{Administrar «entity.entityName»} \label{sec:cf-uc-admin-«entity.name.toLowerCase»}
		
		«IF isSearchInScaffolding(entity)»
		«entity.genSearchEntityUC(m)»
		«ENDIF»
		«IF isAddInScaffolding(entity)»
		«entity.genCreateEntityUC(m)»
		«ENDIF»
		«IF isEditInScaffolding(entity)»
		«entity.genUpdateEntityUC(m)»
		«ENDIF»
		«IF isDeleteInScaffolding(entity)»
		«entity.genDeleteEntityUC(m)»
		«ENDIF»
	'''
	//We need this extra function because UML doesn´t need to use mapCharToLatex function
	def CharSequence entityNameDOM(Entity entity) {
		var name = entity.name
		if (entity.glossary !== null) {
			name = entity.glossary.glossary_name.label
		}
		return name
	}
	
	def CharSequence entityName(Entity entity) {
		var name = entity.name
		if (entity.glossary !== null) {
			name = entity.glossary.glossary_name.label
		}
		return mapCharToLatex(name)
	}
	
	def CharSequence entityNameActivityDiagram(Entity entity) {
		var name = entity.name
		if (entity.glossary !== null) {
			name = entity.glossary.glossary_name.label
		}
		
		var strenie = name.split('ñ');
		if (strenie.length>1)
		 return name
		else
		 return mapCharToLatex(name)
	}
	
	def CharSequence entityDescription(Entity entity) {
		var description = entity.name
		if (entity.glossary !== null) {
			description = entity.glossary.glossary_description.label
		}
		return mapCharToLatex(description)
	}
	
	
	def CharSequence mapCharToLatex(String s) {
		var str2=""
		var stra = s.split('á');
		if (stra.length>1)
		  str2=stra.join("\\'a")
		else
		  str2=s
		 
		var str3="" 
		var stre = str2.split('é');
		if (stre.length>1)
		  str3=stre.join("\\'e")
		else
		  str3=str2
		  
		var str4="" 
		var stri = str3.split('í');
		if (stri.length>1)
		  str4=stri.join("\\'i")
		else
		  str4=str3
		  
		var str5="" 
		var stro = str4.split('ó');
		if (stro.length>1)
		  str5=stro.join("\\'o")
		else
		  str5=str4
		  
		var str6="" 
		var stru = str5.split('ú');
		if (stru.length>1)
		  str6=stru.join("\\'u")
		else
		  str6=str5
		  
		var str7="" 
		var strenie = str6.split('ñ');
		if (strenie.length>1)
		  str7=strenie.join("\\~n")
		else
		  str7=str6
		  
		return mapUpperCharToLatex(str7)
	
	}
	
	
	def CharSequence mapUpperCharToLatex(String s) {
		var str2=""
		var stra = s.split('Á');
		if (stra.length>1)
		  str2=stra.join("\\'A")
		else
		  str2=s
		 
		var str3="" 
		var stre = str2.split('É');
		if (stre.length>1)
		  str3=stre.join("\\'E")
		else
		  str3=str2
		  
		var str4="" 
		var stri = str3.split('Í');
		if (stri.length>1)
		  str4=stri.join("\\'I")
		else
		  str4=str3
		  
		var str5="" 
		var stro = str4.split('Ó');
		if (stro.length>1)
		  str5=stro.join("\\'O")
		else
		  str5=str4
		  
		var str6="" 
		var stru = str5.split('Ú');
		if (stru.length>1)
		  str6=stru.join("\\'U")
		else
		  str6=str5
		  
		var str7="" 
		var strenie = str6.split('Ñ');
		if (strenie.length>1)
		  str7=strenie.join("\\~N")
		else
		  str7=str6
		  
		return str7.toString
	
	}
	
		def CharSequence getSearchReferenceEntityList(Entity entity) '''
		      \item Se ha registrado informaci\'on de [«getReferenceEntity(entity)»].
	'''
	
	def CharSequence getCreateReferenceEntityList(Entity entity) '''
		 «FOR f : entity.entity_fields»
			  «IF f.fieldType === "Entity" || f.fieldType === "Enum" || isUpperBoundGTOne(f)»
			     «FOR field:f.eCrossReferences»
			     «IF getReferenceEntity(field)!==""»
			       \item Se ha registrado informaci\'on de [«getReferenceEntity(field)»].
			      «ENDIF»
				 «ENDFOR»
			  «ENDIF»			  
		 «ENDFOR»
	'''
	
	def CharSequence getUpdateReferenceEntityList(Entity entity) '''
	  \item Se ha registrado informaci\'on de [«getReferenceEntity(entity)»].
	 «FOR f : entity.entity_fields»
		  «IF f.fieldType === "Entity" || f.fieldType === "Enum" || isUpperBoundGTOne(f)»
		     «FOR field:f.eCrossReferences»
		       «IF getReferenceEntity(field)!==""»
			   \item Se ha registrado informaci\'on de [«getReferenceEntity(field)»].
			   «ENDIF»
			 «ENDFOR»
		  «ENDIF»			  
	 «ENDFOR»
	'''
	
	def CharSequence getDeleteReferenceEntityList(Entity entity) '''
		      \item Se ha registrado informaci\'on de [«getReferenceEntity(entity)»].
	'''
	
	def isUpperBoundGTOne(EntityField ef){
		if (ef instanceof EntityReferenceField)
		{
		  var erf = ef as EntityReferenceField
		  if (erf.upperBound.trim.equals("*"))
		   return true 
		  if (Integer.parseInt(erf.upperBound.trim)>=1)
		   return true
		}
		return false
	}
	
	
	def CharSequence getReferenceEntity(EObject e) {
	  if (e instanceof Entity)
		  {
		   	 var entity= e as Entity
		     return entityName(entity)
		  }
	  if (e instanceof Enum)
		  {
		   	 var enum = e as Enum
		     return enum.name
		  }
	  return "" //e.toString
	}
	
	def CharSequence genSearchActivityUCDPlantUML(Entity entity) '''
		@startuml
		start
		:El Operador captura información en 
		la forma [Criterios de Búsqueda «entity.entityNameDOM»];
		while (Datos incompletos?) is (SI)  
			:El Sistema muestra los campos de la forma 
			[Criterios de Búsqueda «entity.entityNameDOM»] que son obligatorios.;  
			:El Operador captura información en 
			la forma [Criterios de Búsqueda «entity.entityNameDOM»];
		endwhile (NO) 
			:El Sistema obtiene información de acuerdo 
			a los Criterios de Búsqueda seleccionados;
			if (Existe información?) then (SI)    
				:El Sistema muestra la lista 
				[Resultados de Búsqueda «entity.entityNameDOM»];
			else (NO)    
				:El Sistema avisa que no 
				encontró información [«entity.entityNameDOM»];		  
				end  
			endif
		stop
		@enduml

	'''
	
	def CharSequence genCreateActivityUCDPlantUML(Entity entity) '''
		@startuml
		start
		:El Operador captura información 
		en la forma [Agregar «entity.entityNameDOM»];
		while (Datos incompletos?) is (SI)  
			:El Sistema muestra los campos de la forma 
			[Agregar «entity.entityNameDOM»] que son obligatorios;  
			:El Operador captura información en 
			la forma [Agregar «entity.entityNameDOM»];
		endwhile (NO)  
			if (Datos válidos?) then (SI)    
				:El Sistema crea un nuevo registro 
				en la entidad [«entity.entityNameDOM»];  
			else (NO)    
				:El Sistema muestra los campos de la forma 
				[Agregar «entity.entityNameDOM»] que son inválidos e indica la razón;    
				end  
			endif
		stop
		@enduml
		
	'''
	
	def CharSequence genUpdateActivityUCDPlantUML(Entity entity) '''
		@startumlstart
		start
		:El Operador selecciona el registro a modificar;
		:El Sistema obtiene y muestra el detalle en la página [Editar «entity.entityNameDOM»];
		:El Operador modifica información en la forma [Editar «entity.entityNameDOM»];
		while (Datos incompletos?) is (SI)  
			:El Sistema muestra los campos de la forma\n [Editar «entity.entityNameDOM»] que son obligatorios;  
			:El Operador modifica información en la forma [Editar «entity.entityNameDOM»];
		endwhile (NO)  
		
			if (Datos válidos?) then (SI)    
				:El Sistema modifica el registro\n en la entidad [«entity.entityNameDOM»];  
			else (NO)    
				:El Sistema muestra los campos de la forma\n [Editar «entity.entityNameDOM»] que son inválidos e indica la razón;    
				end  
			endif
		stop
		@enduml
		
	'''
	
	def CharSequence genDeleteActivityUCDPlantUML(Entity entity) '''
		@startumlstart
		start
		:El Operador selecciona el registro a eliminar;
		:El Sistema obtiene y muestra el detalle en la página [Eliminar «entity.entityNameDOM»];
		:El Operador confirma la eliminación;	
		if (Es posible eliminar?) then (SI)    		
			:El Sistema elimina el registro\n de la entidad [«entity.entityNameDOM»];  	
		else (NO)    		
			:El Sistema muestra la página\n [Eliminar «entity.entityNameDOM»]\ne indica la razón por la cual no se puede eliminar el registro;    		
			end  	
		endif
		stop
		@enduml

	'''
	
	def CharSequence genSearchEntityUC(Entity entity, Module m) '''
		%% -----
		%% Use Case: Search
		%% -----
		\subsection{CUXX-01. Buscar «entity.entityName»} \label{sec:cu-search-«entity.name»}
		
		\begin{tabular}{ p{3.5cm} p{11.5cm} }
			\textbf{Actores} & Operador\\
			\textbf{Objetivo} & Buscar «entity.entityName».\\
			\textbf{Evento Disparador} & El Operador solicita la p\'agina [Buscar «entity.entityName» (\ref{sec:ui-page-search-«entity.name.toLowerCase»})].\\
			\textbf{Tipo} & Usuario\\
			\textbf{Pre-condiciones} &
				\begin{minipage}[t]{0.6\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
					«getSearchReferenceEntityList(entity)»
				\end{itemize}
				\end{minipage} \\
			\textbf{Post-condiciones} &
				\begin{minipage}[t]{0.6\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
					\item Se ha mostrado una lista de [«entity.entityName»] que cumplieron los criterios solicitados.
				\end{itemize}
				\end{minipage} \\
			\\
		\end{tabular}
		
		\begin{tabular}{ p{15.5cm} }
			\textbf{Escenario Principal} \\
			\begin{enumerate}
				\item El Sistema muestra la p\'agina [Buscar «entity.entityName» (\ref{sec:ui-page-search-«entity.name.toLowerCase»})].
				\item El Operador captura informaci\'on en la forma [Criterios de B\'usqueda (\ref{tab:ui-search-criteria-«entity.name.toLowerCase»-form})].
				\item El Operador elige el comando [Buscar].
				\item El Sistema determina que los datos de la forma [Criterios de B\'usqueda (\ref{tab:ui-search-criteria-«entity.name.toLowerCase»-form})] est\'an completos.
					\begin{enumerate}
						\item Excepci\'on 01: Datos incompletos.
					\end{enumerate}
				\item El Sistema obtiene informaci\'on de acuerdo a los Criterios de B\'usqueda seleccionados.
					\begin{enumerate}
						\item Excepci\'on 02: No se encontr\'o informaci\'on.
					\end{enumerate}
				\item El Sistema muestra la lista [Resultados de B\'usqueda (\ref{tab:ui-search-results-«entity.name.toLowerCase»-form})].
				\item Fin del Caso de Uso.
			\end{enumerate}
		\end{tabular}
		
		\begin{tabular}{ p{15.5cm} }
			\textbf{Excepci\'on 01. Datos incompletos} \\
			\begin{enumerate}
				\item El Sistema determina que los datos de la forma [Criterios de B\'usqueda (\ref{tab:ui-search-criteria-«entity.name.toLowerCase»-form})] est\'an incompletos.
				\item El Sistema muestra los campos de la forma [Criterios de B\'usqueda (\ref{tab:ui-search-criteria-«entity.name.toLowerCase»-form})] que son obligatorios.
				\item Fin de la Excepci\'on.
			\end{enumerate}
		\end{tabular}
		
		\begin{tabular}{ p{15.5cm} }
			\textbf{Excepci\'on 02. No se encontr\'o informaci\'on} \\
			\begin{enumerate}
				\item El Sistema no obtiene informaci\'on de acuerdo a los Criterios de B\'usqueda seleccionados.
				\item El Sistema avisa que no encontr\'o informaci\'on [(\ref{tab:ui-nosearch-«entity.name.toLowerCase»-page})].
				\item Fin de la Excepci\'on.
			\end{enumerate}
		\end{tabular}
		
		\begin{figure}[H]
			\begin{center}
				\label{tab:activity-search-ucd-entity-«entity.name.toLowerCase»}
				\includegraphics[width=0.5\textwidth]{use-cases/diagrams/SearchActivityUCD-«m.name»/«entity.name».png}
				\caption{Diagrama de Actividades para Caso de Uso CUXX-01 Buscar «entity.entityName»}
		\end{center}
		\end{figure}
	'''
	
	def CharSequence genCreateEntityUC(Entity entity, Module m) '''
		%% -----
		%% Use Case: Create
		%% -----
		\clearpage
		\subsection{CUXX-02. Agregar «entity.entityName»} \label{sec:cu-create-«entity.name»}
		
		\begin{tabular}{ p{3.5cm} p{11.5cm} }
			\textbf{Actores} & Operador\\
			\textbf{Objetivo} & Agregar «entity.entityName».\\
			\textbf{Evento Disparador} & El Operador solicita la p\'agina [Agregar «entity.entityName» (\ref{sec:ui-page-create-«entity.name.toLowerCase»})].\\
			\textbf{Tipo} & Usuario\\
			\textbf{Pre-condiciones} &
				\begin{minipage}[t]{0.6\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
					«getCreateReferenceEntityList(entity)»
				\end{itemize}
				\end{minipage} \\
			\textbf{Post-condiciones} &
				\begin{minipage}[t]{0.6\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
					\item Se ha registrado informaci\'on de un [«entity.entityName»] nuevo.
				\end{itemize}
				\end{minipage} \\
			\\
		\end{tabular}
		
		\begin{tabular}{ p{15.5cm} }
			\textbf{Escenario Principal} \\
			\begin{enumerate}
				\item El Sistema muestra la p\'agina [Agregar «entity.entityName» (\ref{sec:ui-page-create-«entity.name.toLowerCase»})].
				\item El Operador captura informaci\'on en la forma [Agregar «entity.entityName» (\ref{tab:ui-create-«entity.name.toLowerCase»-form})].
				\item El Operador elige el comando [Agregar].
				\item El Sistema determina que los datos de la forma [Agregar «entity.entityName» (\ref{tab:ui-create-«entity.name.toLowerCase»-form})] est\'an completos.
					\begin{enumerate}
						\item Excepci\'on 01: Datos incompletos.
					\end{enumerate}
				\item El Sistema determina que los datos de la forma [Agregar «entity.entityName» (\ref{tab:ui-create-«entity.name.toLowerCase»-form})] son v\'alidos.
					\begin{enumerate}
						\item Excepci\'on 02: Datos inv\'alidos.
					\end{enumerate}
				\item El Sistema crea un nuevo registro en la entidad [«entity.entityName»].
				\item Fin del Caso de Uso.
			\end{enumerate}
		\end{tabular}
		
		\begin{tabular}{ p{15.5cm} }
			\textbf{Excepci\'on 01} \\
			\begin{enumerate}
				\item El Sistema determina que los datos de la forma [Agregar «entity.entityName» (\ref{tab:ui-create-«entity.name.toLowerCase»-form})] est\'an incompletos.
				\item El Sistema muestra los campos de la forma [Agregar «entity.entityName» (\ref{tab:ui-create-«entity.name.toLowerCase»-form})] que son obligatorios.
				\item Fin de la Excepci\'on.
			\end{enumerate}
		\end{tabular}
		
		\begin{tabular}{ p{15.5cm} }
			\textbf{Excepci\'on 02} \\
			\begin{enumerate}
				\item El Sistema determina que los datos de la forma [Agregar «entity.entityName» (\ref{tab:ui-create-«entity.name.toLowerCase»-form})] son inv\'alidos.
				\item El Sistema muestra los campos de la forma [Agregar «entity.entityName» (\ref{tab:ui-create-«entity.name.toLowerCase»-form})] que son inv\'alidos e indica la raz\'on.
				\item Fin de la Excepci\'on.
			\end{enumerate}
		\end{tabular}
		
		\begin{figure}[H]
			\begin{center}
				\label{tab:activity-create-ucd-entity-«entity.name.toLowerCase»}
				\includegraphics[width=0.5\textwidth]{use-cases/diagrams/CreateActivityUCD-«m.name»/«entity.name».png}
				\caption{Diagrama de Actividades para Caso de Uso CUXX-02 Agregar «entity.entityName»}	
		    \end{center}
		\end{figure}
				
	'''
	def CharSequence genUpdateEntityUC(Entity entity, Module m) '''
		
		%% -----
		%% Use Case: Update
		%% -----
		\clearpage
		\subsection{CUXX-03. Editar «entity.entityName»} \label{sec:cu-update-«entity.name»}
		
		\begin{tabular}{ p{3.5cm} p{11.5cm} }
			\textbf{Actores} & Operador\\
			\textbf{Objetivo} & Editar «entity.entityName».\\
			\textbf{Evento Disparador} & El Operador solicita la p\'agina [Editar «entity.entityName» (\ref{sec:ui-page-update-«entity.name.toLowerCase»})].\\
			\textbf{Tipo} & Usuario\\
			\textbf{Pre-condiciones} &
				\begin{minipage}[t]{0.6\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
					«getUpdateReferenceEntityList(entity)»
				\end{itemize}
				\end{minipage} \\
			\textbf{Post-condiciones} &
				\begin{minipage}[t]{0.6\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
					\item Se ha actualizado la informaci\'on de [«entity.entityName»].
				\end{itemize}
				\end{minipage} \\
			\\
		\end{tabular}
		
		\begin{tabular}{ p{15.5cm} }
			\textbf{Escenario Principal} \\
			\begin{enumerate}
				\item El Sistema invoca al Caso de Uso [CUXX-01. Buscar «entity.entityName» (\ref{sec:cu-search-«entity.name»})].
				\item El Operador selecciona el comando [Editar].
				\item El Sistema muestra la p\'agina [Editar «entity.entityName» (\ref{sec:ui-page-update-«entity.name.toLowerCase»})].
				\item El Operador modifica informaci\'on en la forma [Editar «entity.entityName» (\ref{tab:ui-update-«entity.name.toLowerCase»-form})].
				\item El Operador elige el comando [Agregar].
				\item El Sistema determina que los datos de la forma [Editar «entity.entityName» (\ref{tab:ui-update-«entity.name.toLowerCase»-form})] est\'an completos.
					\begin{enumerate}
						\item Excepci\'on 01: Datos incompletos.
					\end{enumerate}
				\item El Sistema determina que los datos de la forma [Editar «entity.entityName» (\ref{tab:ui-update-«entity.name.toLowerCase»-form})] son v\'alidos.
					\begin{enumerate}
						\item Excepci\'on 02: Datos inv\'alidos.
					\end{enumerate}
				\item El Sistema modifica el registro en la entidad [«entity.entityName»].
				\item Fin del Caso de Uso.
			\end{enumerate}
		\end{tabular}
		
		\begin{tabular}{ p{15.5cm} }
			\textbf{Excepci\'on 01} \\
			\begin{enumerate}
				\item El Sistema determina que los datos de la forma [Editar «entity.entityName» (\ref{tab:ui-update-«entity.name.toLowerCase»-form})] est\'an incompletos.
				\item El Sistema muestra los campos de la forma [Editar «entity.entityName» (\ref{tab:ui-update-«entity.name.toLowerCase»-form})] que son obligatorios.
				\item Fin de la Excepci\'on.
			\end{enumerate}
		\end{tabular}
		
		\begin{tabular}{ p{15.5cm} }
			\textbf{Excepci\'on 02} \\
			\begin{enumerate}
				\item El Sistema determina que los datos de la forma [Editar «entity.entityName» (\ref{tab:ui-update-«entity.name.toLowerCase»-form})] son inv\'alidos.
				\item El Sistema muestra los campos de la forma [Editar «entity.entityName» (\ref{tab:ui-update-«entity.name.toLowerCase»-form})] que son inv\'alidos e indica la raz\'on.
				\item Fin de la Excepci\'on.
			\end{enumerate}
		\end{tabular}
		
		\begin{figure}[H]
			\begin{center}
			 \label{tab:activity-update-ucd-entity-«entity.name.toLowerCase»}
			 \includegraphics[width=0.5\textwidth]{use-cases/diagrams/UpdateActivityUCD-«m.name»/«entity.name».png}
			 \caption{Diagrama de Actividades para Caso de Uso CUXX-03 Editar «entity.entityName»}
			\end{center}
		\end{figure}
	'''
	
	def CharSequence genDeleteEntityUC(Entity entity, Module m) '''
		
		%% -----
		%% Use Case: Delete
		%% -----
		\clearpage
		\subsection{CUXX-04. Eliminar «entity.entityName»} \label{sec:cu-delete-«entity.name»}
		
		\begin{tabular}{ p{3.5cm} p{11.5cm} }
			\textbf{Actores} & Operador\\
			\textbf{Objetivo} & Eliminar «entity.entityName».\\
			\textbf{Evento Disparador} & El Operador solicita la p\'agina [Eliminar «entity.entityName» (\ref{tab:ui-delete-«entity.name.toLowerCase»-page})].\\
			\textbf{Tipo} & Usuario\\
			\textbf{Pre-condiciones} &
				\begin{minipage}[t]{0.6\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
					«getDeleteReferenceEntityList(entity)»
				\end{itemize}
				\end{minipage} \\
			\textbf{Post-condiciones} &
				\begin{minipage}[t]{0.6\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
					\item Se ha eliminado la informaci\'on de [«entity.entityName»].
				\end{itemize}
				\end{minipage} \\
			\\
		\end{tabular}
		
		\begin{tabular}{ p{15.5cm} }
			\textbf{Escenario Principal} \\
			\begin{enumerate}
				\item El Sistema invoca al Caso de Uso [CUXX-01. Buscar «entity.entityName» (\ref{sec:cu-search-«entity.name»})].
				\item El Operador selecciona el comando [Eliminar].
				\item El Sistema muestra la p\'agina [Eliminar «entity.entityName» (\ref{tab:ui-delete-«entity.name.toLowerCase»-page})].
				\item El Operador elige el comando [Eliminar].
				\item El Sistema elimina el registro de la entidad [«entity.entityName»].
				\item Fin del Caso de Uso.
			\end{enumerate}
			\textbf{Escenario Excepci\'on 01} \\
			\begin{enumerate}
			   \item El Sistema determina que los datos de la forma [Eliminar «entity.entityName» (\ref{tab:ui-delete-«entity.name.toLowerCase»-form})] son v\'alidos.
			   	\begin{enumerate}
			   		\item Excepci\'on 01: No se pudo completar la eliminaci\'on.
			    \end{enumerate}
			   \item Fin del Caso de Uso.
			\end{enumerate}
		\end{tabular}
		
		\begin{figure}[H]
		  \begin{center}
			 \label{tab:activity-delete-ucd-entity-«entity.name.toLowerCase»}
			 \includegraphics[width=0.5\textwidth]{use-cases/diagrams/DeleteActivityUCD-«m.name»/«entity.name».png}
			 \caption{Diagrama de Actividades para Caso de Uso CUXX-04 Eliminar «entity.entityName»}
		  \end{center}
		\end{figure}
		
	'''
	
	def CharSequence generateModuleUI(Module m) '''
		«FOR e : m.elements»
		    «IF e instanceof Entity»
		      «e.genModuleElementUI(m)»
		    «ENDIF»
		«ENDFOR»
	'''
	
	def dispatch genModuleElementUI(Enum e, Module m) '''
	'''
	def dispatch genModuleElementUI(Entity entity, Module m) '''
		
		%% --------------------------------------------------------------------------------------------------
		%% CRUD UI: «entity.entityName»
		%% --------------------------------------------------------------------------------------------------
		%%\clearpage
		\section{Administrar «entity.entityName»} \label{sec:cf-ui-admin-«entity.name.toLowerCase»}
		
		«IF !isSearchInScaffolding(entity)»
		«entity.genAdminEntityUI(m)»
		«ENDIF»
		«IF isSearchInScaffolding(entity)»
		«entity.genSearchEntityUI(m)»
		«ENDIF»
		«IF isAddInScaffolding(entity)»
		\clearpage
		«entity.genCreateEntityUI(m)»
		«ENDIF»
		«IF isEditInScaffolding(entity)»
		\clearpage
		«entity.genUpdateEntityUI(m)»
		«ENDIF»
		«IF isDeleteInScaffolding(entity)»
		\clearpage
		«entity.genDeleteEntityUI(m)»
		«ENDIF»
		
	'''
		///IsExposed
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
	
	
	///IsDisplayResult
		def dispatch isDisplayResultEntityField(EntityReferenceField f){
		var isDisplayResult = false;
		
		for(EntityReferenceFieldAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty){
				isDisplayResult = "true".equals(a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result);
			}
		}
		
		return isDisplayResult;
	}

	def dispatch isDisplayResultEntityField(EntityTextField f){
		var isDisplayResult = false;

		for(EntityTextFieldAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty){
				isDisplayResult = "true".equals(a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result);
			}
		}
		
		return isDisplayResult;
	}

	def dispatch isDisplayResultEntityField(EntityLongTextField f){
		var isDisplayResult = false;
		
		for(EntityLongTextFieldAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty){
				isDisplayResult = "true".equals(a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result);
			}
		}
		
		return isDisplayResult;
	}	

	def dispatch isDisplayResultEntityField(EntityDateField f){
		var isDisplayResult = false;
		
		for(EntityDateFieldAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty){
				isDisplayResult = "true".equals(a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result);
			}
		}
		
		return isDisplayResult;
	}

	def dispatch isDisplayResultEntityField(EntityImageField f){
		var isDisplayResult = false;
		
		for(EntityAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty){
				isDisplayResult = "true".equals(a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result);
			}
		}
		
		return isDisplayResult;
	}

	def dispatch isDisplayResultEntityField(EntityFileField f){
		var isDisplayResult = false;

		for(EntityAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty){
				isDisplayResult = "true".equals(a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result);
			}
		}
		
		return isDisplayResult;
	}

	def dispatch isDisplayResultEntityField(EntityEmailField f){
		var isDisplayResult = false;
		
		for(EntityAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty){
				isDisplayResult = "true".equals(a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result);
			}
		}
		
		return isDisplayResult;
	}

	def dispatch isDisplayResultEntityField(EntityDecimalField f){
		var isDisplayResult = false;
		
		for(EntityAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty){
				isDisplayResult = "true".equals(a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result);
			}
		}
		
		return isDisplayResult;
	}

	def dispatch isDisplayResultEntityField(EntityIntegerField f){
		var isDisplayResult = false;
		
		for(EntityAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty){
				isDisplayResult = "true".equals(a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result);
			}
		}
		
		return isDisplayResult;
	}

	def dispatch isDisplayResultEntityField(EntityCurrencyField f){
		var isDisplayResult = false;
		
		for(EntityAttr a : f.attrs){
			if(a.widget !== null && a.widget.attrs.filter(WidgetDisplayResult) !== null && !a.widget.attrs.filter(WidgetDisplayResult).isEmpty){
				isDisplayResult = "true".equals(a.widget.attrs.filter(WidgetDisplayResult).get(0).display_result);
			}
		}
		
		return isDisplayResult;
	}
	
	def CharSequence genAdminEntityUI(Entity entity, Module m)'''
	  \begin{figure}[H]
        \label{tab:ui-search-«entity.name.toLowerCase»-page}
        \includegraphics[width=0.95\textwidth,height=0.70\textheight]{ui-specs/ui-screenshots/«m.name»-Screenshots.js/«entity.name»-Admin.png}
        \caption{P\'agina Administrar «entity.entityName»}
	  \end{figure}
	'''
	def CharSequence genSearchEntityUI(Entity entity, Module m) '''
		%% -----
		%% User Interface: Search
		%% -----
		\subsection{IUXX-01. Buscar «entity.entityName»} \label{sec:ui-page-search-«entity.name.toLowerCase»}
		
		\textbf{Descripci\'on}: P\'agina para Buscar «entity.entityName».\\
		
		\begin{figure}[H]
			\label{tab:ui-search-«entity.name.toLowerCase»-page}
			\includegraphics[width=0.95\textwidth,height=0.70\textheight]{ui-specs/ui-screenshots/«m.name»-Screenshots.js/«entity.name»-Admin.png}
			\caption{P\'agina Buscar «entity.entityName»}
		\end{figure}
		
		\begin{table}[H]
			\caption{Forma Criterios de B\'usqueda}
			\label{tab:ui-search-criteria-«entity.name.toLowerCase»-form}
			\resizebox{\textwidth}{!}{
			\begin{tabular}{ p{4cm} p{2cm} p{2cm} p{7cm} }
				\hline
				\textbf{Etiqueta} &
				\textbf{Widget} &
				\textbf{Tipo} &
				\textbf{Fuente de Datos} \\
				\hline
				«FOR field : entity.entity_fields»
				«IF isExposedFilterEntityField(field)»
					«field.fieldLabel» &
					«field.fieldWidget» &
					«field.fieldType» &
					«entity.name.replaceAll("_", "\\\\_")».«field.name.replaceAll("_", "\\\\_")» \\
				«ENDIF»
				«ENDFOR»
				\hline
			\end{tabular}
			}
		\end{table}
		
		\begin{table}[H]
			\caption{Lista: Resultados de B\'usqueda}
			\label{tab:ui-search-results-«entity.name.toLowerCase»-form}
			%\resizebox{\textwidth}{!}{
			\begin{tabular}{ p{4cm} p{8cm} }
				\hline
				\textbf{Etiqueta} &
				\textbf{Fuente de Datos} \\
				\hline
				«FOR field : entity.entity_fields»
				«IF isDisplayResultEntityField(field)»
					«field.fieldLabel» &
					«entity.name.replaceAll("_", "\\\\_")».«field.name.replaceAll("_", "\\\\_")» \\
				«ENDIF»
				«ENDFOR»
				\hline
			\end{tabular}
			%}
		\end{table}
		
	'''
	
	def CharSequence genCreateEntityUI(Entity entity, Module m) '''
		%% -----
		%% User Interface: Create
		%% -----
		\subsection{IUXX-02. Agregar «entity.entityName»} \label{sec:ui-page-create-«entity.name.toLowerCase»}
		
		\textbf{Descripci\'on}: P\'agina para Agregar «entity.entityName».\\
		
		\begin{figure}[H]
			\label{tab:ui-create-«entity.name.toLowerCase»-page}
			\includegraphics[width=0.95\textwidth,height=0.70\textheight]{ui-specs/ui-screenshots/«m.name»-Screenshots.js/«entity.name»-Add.png}
			\caption{P\'agina Agregar «entity.entityName»}
		\end{figure}
		
		\begin{table}[H]
			\caption{Forma Agregar «entity.entityName»}
			\label{tab:ui-create-«entity.name.toLowerCase»-form}
			\resizebox{\textwidth}{!}{
			\begin{tabular}{ p{4cm} p{2cm} p{2cm} p{3cm} p{8cm} }
				\hline
				\textbf{Etiqueta} &
				\textbf{Widget} &
				\textbf{Tipo} &
				\textbf{Validaciones} &
				\textbf{Fuente de Datos} \\
				\hline
				«FOR field : entity.entity_fields»
					«field.fieldLabel» &
					«field.fieldWidget» &
					«field.fieldType» &
					«field.fieldConstraints» &
					«entity.name.replaceAll("_", "\\\\_")».«field.name.replaceAll("_", "\\\\_")» \\
				«ENDFOR»
				\hline
			\end{tabular}
			}
		\end{table}
		
	'''
	def CharSequence genUpdateEntityUI(Entity entity, Module m) '''
		%% -----
		%% User Interface: Update
		%% -----
		\subsection{IUXX-03. Editar «entity.entityName»} \label{sec:ui-page-update-«entity.name.toLowerCase»}
		
		\textbf{Descripci\'on}: P\'agina para Editar «entity.entityName».\\
		
		\begin{figure}[H]
			\label{tab:ui-edit-«entity.name.toLowerCase»-page}
			\includegraphics[width=0.95\textwidth,height=0.70\textheight]{ui-specs/ui-screenshots/«m.name»-Screenshots.js/«entity.name»-Edit.png}
			\caption{P\'agina Editar «entity.entityName»}
		\end{figure}
		
		\begin{table}[H]
			\caption{Forma Editar «entity.entityName»}
			\label{tab:ui-update-«entity.name.toLowerCase»-form}
			\resizebox{\textwidth}{!}{
			\begin{tabular}{ p{4cm} p{2cm} p{2cm} p{3cm} p{8cm} }
				\hline
				\textbf{Etiqueta} &
				\textbf{Widget} &
				\textbf{Tipo} &
				\textbf{Validaciones} &
				\textbf{Fuente de Datos} \\
				\hline
				«FOR field : entity.entity_fields»
					«field.fieldLabel» &
					«field.fieldWidget» &
					«field.fieldType» &
					«field.fieldConstraints» &
					«entity.name.replaceAll("_", "\\\\_")».«field.name.replaceAll("_", "\\\\_")» \\
				«ENDFOR»
				\hline
			\end{tabular}
			}
		\end{table}
		
	'''
	def CharSequence genDeleteEntityUI(Entity entity, Module m) '''
		%% -----
		%% User Interface: Delete
		%% -----
		\subsection{IUXX-04. Eliminar «entity.entityName»} \label{sec:ui-page-delete-«entity.name.toLowerCase»}
		
		\textbf{Descripci\'on}: P\'agina para Eliminar «entity.entityName».\\
		
		\begin{figure}[H]
			\label{tab:ui-delete-«entity.name.toLowerCase»-page}
			\includegraphics[width=0.95\textwidth,height=0.70\textheight]{ui-specs/ui-screenshots/«m.name»-Screenshots.js/«entity.name»-Delete.png}
			\caption{P\'agina Eliminar «entity.entityName»}
		\end{figure}
		
		\begin{table}[H]
			\caption{Forma Eliminar «entity.entityName»}
			\label{tab:ui-delete-«entity.name.toLowerCase»-form}
			\resizebox{\textwidth}{!}{
			\begin{tabular}{ p{4cm} p{2cm} p{2cm} p{3cm} p{8cm} }
				\hline
				\textbf{Etiqueta} &
				\textbf{Widget} &
				\textbf{Tipo} &
				\textbf{Validaciones} &
				\textbf{Fuente de Datos} \\
				\hline
				«FOR field : entity.entity_fields»
					«field.fieldLabel» &
					Label &
					«field.fieldType» &
					&
					«entity.name.replaceAll("_", "\\\\_")».«field.name.replaceAll("_", "\\\\_")» \\
				«ENDFOR»
				\hline
			\end{tabular}
			}
		\end{table}
		
	'''
	// Field Description
	def dispatch fieldDescription(EntityReferenceField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_description.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldDescription(EntityTextField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_description.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldDescription(EntityLongTextField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_description.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	def dispatch fieldDescription(EntityDateField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_description.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldDescription(EntityImageField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_description.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldDescription(EntityFileField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_description.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	def dispatch fieldDescription(EntityEmailField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_description.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldDescription(EntityDecimalField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_description.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldDescription(EntityIntegerField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_description.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldDescription(EntityCurrencyField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_description.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	// Field Label
	def dispatch fieldLabel(EntityReferenceField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldLabel(EntityTextField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldLabel(EntityLongTextField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	def dispatch fieldLabel(EntityDateField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldLabel(EntityImageField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldLabel(EntityFileField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	def dispatch fieldLabel(EntityEmailField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldLabel(EntityDecimalField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldLabel(EntityIntegerField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	def dispatch fieldLabel(EntityCurrencyField field) {
		var fieldName = field.name
		for (attr : field.attrs) {
			if (attr.glossary !== null) {
				fieldName = attr.glossary.glossary_name.label
			}
		}
		return mapCharToLatex(fieldName)
	}
	
	
	
	// Field Widget
	def dispatch fieldWidget(EntityReferenceField field) {
		return "Modal"
	}
	
	def dispatch fieldWidget(EntityTextField field) {
		return "TextBox"
	}
	
	def dispatch fieldWidget(EntityLongTextField field) {
		return "TextArea"
	}
	def dispatch fieldWidget(EntityDateField field) {
		return "DatePicker"
	}
	
	def dispatch fieldWidget(EntityImageField field) {
		return "FileSelection"
	}
	
	def dispatch fieldWidget(EntityFileField field) {
		return "FileSelection"
	}
	def dispatch fieldWidget(EntityEmailField field) {
		return "TextBox"
	}
	
	def dispatch fieldWidget(EntityDecimalField field) {
		return "TextBox"
	}
	
	def dispatch fieldWidget(EntityIntegerField field) {
		return "TextBox"
	}
	
	def dispatch fieldWidget(EntityCurrencyField field) {
		return "TextBox"
	}
	
	
	
	// Field Type
	def dispatch fieldType(EntityReferenceField field) {
		return "Entity"
	}
	
	def dispatch fieldType(EntityTextField field) {
		return "Text"
	}
	
	def dispatch fieldType(EntityLongTextField field) {
		return "Long Text"
	}
	def dispatch fieldType(EntityDateField field) {
		return "Date"
	}
	
	def dispatch fieldType(EntityImageField field) {
		return "Image"
	}
	
	def dispatch fieldType(EntityFileField field) {
		return "File"
	}
	def dispatch fieldType(EntityEmailField field) {
		return "Email"
	}
	
	def dispatch fieldType(EntityDecimalField field) {
		return "Decimal"
	}
	
	def dispatch fieldType(EntityIntegerField field) {
		return "Integer"
	}
	
	def dispatch fieldType(EntityCurrencyField field) {
		return "Currency"
	}
	
	
	
	// Field Constraints
	def dispatch fieldConstraints(EntityReferenceField field) '''
		«FOR attr : field.attrs»
			«IF attr.constraint !== null»
				\begin{minipage}[t]{0.2\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
				«FOR constraint : attr.constraint.constraints»
					\item «constraint.fieldTextConstraint»
				«ENDFOR»
				\end{itemize}
				\end{minipage}
			«ENDIF»
		«ENDFOR»
	'''
	
	def dispatch fieldConstraints(EntityTextField field) '''
		«FOR attr : field.attrs»
			«IF attr.constraint !== null»
				\begin{minipage}[t]{0.2\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
				«FOR constraint : attr.constraint.constraints»
					\item «constraint.fieldTextConstraint»
				«ENDFOR»
				\end{itemize}
				\end{minipage}
			«ENDIF»
		«ENDFOR»
	'''
	
	def dispatch fieldConstraints(EntityLongTextField field) '''
		«FOR attr : field.attrs»
			«IF attr.constraint !== null»
				\begin{minipage}[t]{0.2\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
				«FOR constraint : attr.constraint.constraints»
					\item «constraint.fieldTextConstraint»
				«ENDFOR»
				\end{itemize}
				\end{minipage}
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch fieldConstraints(EntityDateField field) '''
		«FOR attr : field.attrs»
			«IF attr.constraint !== null»
				\begin{minipage}[t]{0.2\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
				«FOR constraint : attr.constraint.constraints»
					\item «constraint.fieldTextConstraint»
				«ENDFOR»
				\end{itemize}
				\end{minipage}
			«ENDIF»
		«ENDFOR»
	'''
	
	def dispatch fieldConstraints(EntityImageField field) '''
		«FOR attr : field.attrs»
			«IF attr.constraint !== null»
				\begin{minipage}[t]{0.2\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
				«FOR constraint : attr.constraint.constraints»
					\item «constraint.fieldTextConstraint»
				«ENDFOR»
				\end{itemize}
				\end{minipage}
			«ENDIF»
		«ENDFOR»
	'''
	
	def dispatch fieldConstraints(EntityFileField field) '''
		«FOR attr : field.attrs»
			«IF attr.constraint !== null»
				\begin{minipage}[t]{0.2\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
				«FOR constraint : attr.constraint.constraints»
					\item «constraint.fieldTextConstraint»
				«ENDFOR»
				\end{itemize}
				\end{minipage}
			«ENDIF»
		«ENDFOR»
	'''
	def dispatch fieldConstraints(EntityEmailField field) '''
		«FOR attr : field.attrs»
			«IF attr.constraint !== null»
				\begin{minipage}[t]{0.2\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
				«FOR constraint : attr.constraint.constraints»
					\item «constraint.fieldTextConstraint»
				«ENDFOR»
				\end{itemize}
				\end{minipage}
			«ENDIF»
		«ENDFOR»
	'''
	
	def dispatch fieldConstraints(EntityDecimalField field) '''
		«FOR attr : field.attrs»
			«IF attr.constraint !== null»
				\begin{minipage}[t]{0.2\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
				«FOR constraint : attr.constraint.constraints»
					\item «constraint.fieldTextConstraint»
				«ENDFOR»
				\end{itemize}
				\end{minipage}
			«ENDIF»
		«ENDFOR»
	'''
	
	def dispatch fieldConstraints(EntityIntegerField field) '''
		«FOR attr : field.attrs»
			«IF attr.constraint !== null»
				\begin{minipage}[t]{0.2\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
				«FOR constraint : attr.constraint.constraints»
					\item «constraint.fieldTextConstraint»
				«ENDFOR»
				\end{itemize}
				\end{minipage}
			«ENDIF»
		«ENDFOR»
	'''
	
	def dispatch fieldConstraints(EntityCurrencyField field) '''
		«FOR attr : field.attrs»
			«IF attr.constraint !== null»
				\begin{minipage}[t]{0.2\textwidth}
				\begin{itemize}[noitemsep,nolistsep]
				\setlength{\itemindent}{-.5cm}
				«FOR constraint : attr.constraint.constraints»
					\item «constraint.fieldTextConstraint»
				«ENDFOR»
				\end{itemize}
				\end{minipage}
			«ENDIF»
		«ENDFOR»
	'''
	def CharSequence generateModuleScreenshotUI(Module module) '''
		describe('Screenshot Tester', function() {
			it('Take screenshots from URLS', function() {
				//This turn off uncaught errors 
				Cypress.on('uncaught:exception', (err, runnable) => {
					return false
				})
				
				var URLS = [
				«FOR e : module.elements»
					«e.genScreenshotUrl(module)»
				«ENDFOR»
				];
				URLS.forEach(function(element) {
					cy.visit(element.page)
					cy.reload()
					cy.screenshot(element.title)
				});
			})
		})
	'''
	
	
	def dispatch genScreenshotUrl(Enum e, Module m) '''
	'''
	
	def dispatch genScreenshotUrl(Entity e, Module m) '''
		{page: 'http://localhost:1337/#!/«e.name.toLowerCase»-admin/', title: '«e.name»-Admin'},
		{page: 'http://localhost:1337/#!/«e.name.toLowerCase»-add/', title: '«e.name»-Add'},
		{page: 'http://localhost:1337/#!/«e.name.toLowerCase»-edit/', title: '«e.name»-Edit'},
		{page: 'http://localhost:1337/#!/«e.name.toLowerCase»-delete/', title: '«e.name»-Delete'},
	'''
	// EntityTextConstraint
	def dispatch fieldTextConstraint(ConstraintRequired c) '''
		Required: «c.value»
	'''
	
	def dispatch fieldTextConstraint(ConstraintUnique c) '''
		Unique: «c.value»
	'''
	
	def dispatch fieldTextConstraint(ConstraintMaxLength c) '''
		Max Length: «c.value»
	'''
	
	def dispatch fieldTextConstraint(ConstraintMinLength c) '''
		Min Length: «c.value»
	'''
	
	def CharSequence generateTitlePageTex(Resource resource, IFileSystemAccess2 fsa) '''
		\begin{titlepage}
		    \begin{center}
		        \vspace*{1cm}
		        
		        \Huge
		        \textbf{<Nombre del Proyecto>}
		        
		        \vspace{0.5cm}
		        \LARGE
		        <Nombre del Cliente>
		        
		        \vspace{3cm}
		        
		        \textbf{Especificaci\'on de Requerimientos Funcionales}
		        
		        \vfill
		        
		        \vspace{0.8cm}
		        
		        \includegraphics[width=0.3\textwidth]{img/Softtek_1ink_SMALL.jpg}
		        
		        \Large
		        %Department Name\\
		        %University Name\\
		        %Country\\
		        %Date
		        
		    \end{center}
		\end{titlepage}
	'''
	
	def generateChaptersMainDocumentTex(Resource resource, IFileSystemAccess2 fsa) '''
	«FOR m : resource.allContents.toIterable.filter(typeof(Module))»		
			\chapter{Modelo de Dominio del M\'odulo «m.name»}
			\clearpage
			\input{domain-model/DOM-«m.name».tex}
			
			\chapter{Casos de Uso del M\'odulo «m.name»}
			%\clearpage
			\input{use-cases/UC-«m.name».tex}
			
			\chapter{Especificaci\'on de la Interfaz de Usuario del M\'odulo «m.name»}
			%\clearpage
			%\begin{landscape}
			\input{ui-specs/UI-«m.name».tex}
			%\end{landscape}
		«ENDFOR»
	'''
	
	def CharSequence generateMainDocumentTex(Resource resource, IFileSystemAccess2 fsa, HashSet<String> chapters) '''
		\documentclass[10pt, letterpaper]{report}
		
		%% packages
		\usepackage[utf8]{inputenc}
		\usepackage[T1]{fontenc}
		\usepackage[spanish, mexico]{babel}
		\usepackage{titlesec}
		\usepackage{glossaries}
		\usepackage{graphicx}
		\usepackage{array}
		\usepackage{multirow}
		\usepackage{lscape}
		\usepackage{float}
		\usepackage{enumitem}
		\usepackage{booktabs} % http://ctan.org/pkg/booktabs
		\usepackage{tabularx}
		
		%% page settings
		\usepackage[top=2cm, bottom=1.8cm, left=2.5cm, right=2.5cm]{geometry} % for page border settings
		\usepackage{fancyhdr} % for head and footer options
		
		\usepackage{hyperref}
		\hypersetup{
		    colorlinks=true,
		    linkcolor=blue,
		    filecolor=magenta,      
		    urlcolor=cyan,
		}
		\urlstyle{same}
		
		%% commands
		\newcommand{\tbi}[1]{\textbf{\textit{#1}}}
		
		%% glossary
		\makeglossaries
		
		\begin{document}
		
		\title{Requerimientos Funcionales}
		\author{Softtek}
		\date{}
		
		\input{title-page.tex}
		
		%\maketitle
		
		\pagestyle{plain}
		\tableofcontents
		
		\pagestyle{fancy}
		\fancyhf{}
		\fancyhead[OC]{\leftmark}
		\fancyhead[EC]{\rightmark}
		\cfoot{\thepage}
		«FOR chapter : chapters»
		«chapter»
		«ENDFOR»
		\printglossary
		
		\end{document}
	'''
}