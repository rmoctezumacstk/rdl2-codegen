package com.softtek.generator.afore.citibanamex

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity
import com.softtek.generator.utils.EntityUtils
import com.softtek.generator.utils.EntityFieldUtils
import com.softtek.generator.utils.UIFlowUtils
import com.softtek.rdl2.EntityTextField
import com.softtek.rdl2.EntityLongTextField
import com.softtek.rdl2.EntityDateField
import com.softtek.rdl2.EntityImageField
import com.softtek.rdl2.EntityFileField
import com.softtek.rdl2.EntityEmailField
import com.softtek.rdl2.EntityDecimalField
import com.softtek.rdl2.EntityIntegerField
import com.softtek.rdl2.EntityCurrencyField
import com.softtek.rdl2.EntityReferenceField
import com.softtek.rdl2.Enum
import com.softtek.rdl2.EntityDateTimeField
import com.softtek.rdl2.EntityTimeField
import com.softtek.rdl2.EntityBooleanField

class CrudComponentModelGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (e : m.elements.filter(typeof(Entity))) {
				fsa.generateFile("banamex/common/src/main/java/com/aforebanamex/plata/comunes/model/cg/" + e.name.toLowerCase.toFirstUpper + ".java", e.genJavaModel(m))
			}
		}
	}
	
	def CharSequence genJavaModel(Entity e, Module m) '''
	package com.aforebanamex.plata.comunes.model.cg;
	
	import java.io.Serializable;
	import java.util.List;
	import java.util.Date;
	
	import javax.validation.Valid;
	import javax.validation.constraints.Digits;
	import javax.validation.constraints.Size;
	
	import com.aforebanamex.plata.base.model.BaseSerizalizableModel;
	
	«FOR f : e.entity_fields»
	«f.getAttributeImport(e)»
	«ENDFOR» 
	
	public class «e.name.toLowerCase.toFirstUpper» extends BaseSerizalizableModel{
		
		private static final long serialVersionUID = 1L;
		@Digits(integer=16, fraction=0, message="El id«e.name.toLowerCase.toFirstUpper» es incorrecto.")
		private Integer id«e.name.toLowerCase.toFirstUpper»;
		«FOR f : e.entity_fields»
		«f.getAttribute(e)»
		«ENDFOR» 
		
		private Boolean estadoLogico;

		public «e.name.toLowerCase.toFirstUpper»(){}
		
		public «e.name.toLowerCase.toFirstUpper»(Integer id«e.name.toLowerCase.toFirstUpper», 
		«FOR f : e.entity_fields»
		«f.getAttributeConstructor(e)»
		«ENDFOR» 
		Boolean estadoLogico
		) {
			super();
			this.id«e.name.toLowerCase.toFirstUpper» = id«e.name.toLowerCase.toFirstUpper»;
			«FOR f : e.entity_fields»
			«f.getAttributeField(e)»
			«ENDFOR» 
			this.estadoLogico = estadoLogico;
		}
		
		public Integer getId«e.name.toLowerCase.toFirstUpper»() {
			return id«e.name.toLowerCase.toFirstUpper»;
		}
		public void setId«e.name.toLowerCase.toFirstUpper»(Integer id«e.name.toLowerCase.toFirstUpper») {
			this.id«e.name.toLowerCase.toFirstUpper» = id«e.name.toLowerCase.toFirstUpper»;
		}
		
		public Boolean getEstadoLogico() {
			return estadoLogico;
		}
	
		public void setEstadoLogico(Boolean estadoLogico) {
			this.estadoLogico = estadoLogico;
		}	
		
		«FOR f : e.entity_fields»
		«f.getAttributeFieldGet(e)»
		«ENDFOR»

		«FOR f : e.entity_fields»
		«f.getAttributeFieldSet(e)»
		«ENDFOR»
	}
	'''
	
	
	/* Get Attribute */	
	def dispatch getAttribute(EntityTextField f, Entity t)'''
	@Size(min=0,max=99, message="El «f.name.toLowerCase» es incorrecto.")
	private String «f.name.toLowerCase»;
	'''
	def dispatch getAttribute(EntityLongTextField f, Entity t)'''
	@Size(min=0,max=99, message="El «f.name.toLowerCase» es incorrecto.")
	private String «f.name.toLowerCase»;
	'''
	def dispatch getAttribute(EntityDateField f, Entity t)'''
	@Size(min=0,max=99, message="El «f.name.toLowerCase» es incorrecto.")
	private Date «f.name.toLowerCase»;
	'''
	def dispatch getAttribute(EntityDateTimeField f, Entity t)'''
	@Size(min=0,max=99, message="El «f.name.toLowerCase» es incorrecto.")
	private Date «f.name.toLowerCase»;
	'''
	def dispatch getAttribute(EntityTimeField f, Entity t)'''
	@Size(min=0,max=99, message="El «f.name.toLowerCase» es incorrecto.")
	private Date «f.name.toLowerCase»;
	'''
	def dispatch getAttribute(EntityBooleanField f, Entity t)'''
	private Boolean «f.name.toLowerCase»;
	'''
	def dispatch getAttribute(EntityImageField f, Entity t)'''
	@Size(min=0,max=99, message="El «f.name.toLowerCase» es incorrecto.")
	private String «f.name.toLowerCase»;
	'''
	def dispatch getAttribute(EntityFileField f, Entity t)'''
	@Size(min=0,max=99, message="El «f.name.toLowerCase» es incorrecto.")
	private String «f.name.toLowerCase»;	
	'''
	def dispatch getAttribute(EntityEmailField f, Entity t)'''
	@Size(min=0,max=99, message="El «f.name.toLowerCase» es incorrecto.")
	private String «f.name.toLowerCase»;	
	'''
	def dispatch getAttribute(EntityDecimalField f, Entity t)'''
	@Size(min=0,max=99, message="El «f.name.toLowerCase» es incorrecto.")
	private Double «f.name.toLowerCase»;	
	'''
	def dispatch getAttribute(EntityIntegerField f, Entity t)'''
	@Size(min=0,max=99, message="El «f.name.toLowerCase» es incorrecto.")
	private Integer «f.name.toLowerCase»;	
	'''
	def dispatch getAttribute(EntityCurrencyField f, Entity t)'''
	@Size(min=0,max=99, message="El «f.name.toLowerCase» es incorrecto.")
	private Double «f.name.toLowerCase»;	
	'''	
	
	def dispatch getAttribute(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipFieldGetSetOne(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipFieldGetSetOne(Enum e, Entity t, String name) ''' 
	@Valid
	private «e.name.toLowerCase.toFirstUpper» «name.toLowerCase»;
	'''
	
	def dispatch genRelationshipFieldGetSetOne(Entity e, Entity t, String name) ''' 
	@Valid
	private «e.name.toLowerCase.toFirstUpper» «name.toLowerCase»;
	'''
	
	/* Get Attribute Field */
	def dispatch getAttributeField(EntityTextField f, Entity t)'''
	this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	'''
	def dispatch getAttributeField(EntityLongTextField f, Entity t)'''
	this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	'''
	def dispatch getAttributeField(EntityDateField f, Entity t)'''
	this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	'''
	def dispatch getAttributeField(EntityDateTimeField f, Entity t)'''
	this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	'''
	def dispatch getAttributeField(EntityTimeField f, Entity t)'''
	this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	'''
	def dispatch getAttributeField(EntityBooleanField f, Entity t)'''
	this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	'''
	def dispatch getAttributeField(EntityImageField f, Entity t)'''
	this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	'''
	def dispatch getAttributeField(EntityFileField f, Entity t)'''
	this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	'''
	def dispatch getAttributeField(EntityEmailField f, Entity t)'''
	this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	'''
	def dispatch getAttributeField(EntityDecimalField f, Entity t)'''
	this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	'''
	def dispatch getAttributeField(EntityIntegerField f, Entity t)'''
	this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	'''
	def dispatch getAttributeField(EntityCurrencyField f, Entity t)'''
	this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	'''	
	
	def dispatch getAttributeField(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipGetSetOne(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipGetSetOne(Enum e, Entity t, String name) ''' 
	this.«name.toLowerCase» = «name.toLowerCase»;
	'''
	
	def dispatch genRelationshipGetSetOne(Entity e, Entity t, String name) ''' 
	this.«name.toLowerCase» = «name.toLowerCase»;
	'''
	
	/* Get Attribute Get */
	def dispatch getAttributeFieldGet(EntityTextField f, Entity t)'''
	public String get«f.name.toLowerCase.toFirstUpper»() {
		return «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldGet(EntityLongTextField f, Entity t)'''
	public String get«f.name.toLowerCase.toFirstUpper»() {
		return «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldGet(EntityDateField f, Entity t)'''
	public Date get«f.name.toLowerCase.toFirstUpper»() {
		return «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldGet(EntityDateTimeField f, Entity t)'''
	public Date get«f.name.toLowerCase.toFirstUpper»() {
		return «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldGet(EntityTimeField f, Entity t)'''
	public Date get«f.name.toLowerCase.toFirstUpper»() {
		return «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldGet(EntityBooleanField f, Entity t)'''
	public Boolean get«f.name.toLowerCase.toFirstUpper»() {
		return «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldGet(EntityImageField f, Entity t)'''
	public String get«f.name.toLowerCase.toFirstUpper»() {
		return «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldGet(EntityFileField f, Entity t)'''
	public String get«f.name.toLowerCase.toFirstUpper»() {
		return «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldGet(EntityEmailField f, Entity t)'''
	public String get«f.name.toLowerCase.toFirstUpper»() {
		return «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldGet(EntityDecimalField f, Entity t)'''
	public Double get«f.name.toLowerCase.toFirstUpper»() {
		return «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldGet(EntityIntegerField f, Entity t)'''
	public Integer get«f.name.toLowerCase.toFirstUpper»() {
		return «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldGet(EntityCurrencyField f, Entity t)'''
	public Double get«f.name.toLowerCase.toFirstUpper»() {
		return «f.name.toLowerCase»;
	}
	'''	
	
	def dispatch getAttributeFieldGet(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipGetOne(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipGetOne(Enum e, Entity t, String name) ''' 
	public «e.name.toLowerCase.toFirstUpper» get«name.toLowerCase.toFirstUpper»() {
		return «name.toLowerCase»;
	}
	'''
	
	def dispatch genRelationshipGetOne(Entity e, Entity t, String name) ''' 
	public «e.name.toLowerCase.toFirstUpper» get«name.toLowerCase.toFirstUpper»() {
		return «name.toLowerCase»;
	}
	'''		

	/* Get Attribute Set */
	def dispatch getAttributeFieldSet(EntityTextField f, Entity t)'''
	public void set«f.name.toLowerCase.toFirstUpper»(String «f.name.toLowerCase») {
		this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldSet(EntityLongTextField f, Entity t)'''
	public void set«f.name.toLowerCase.toFirstUpper»(String «f.name.toLowerCase») {
		this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldSet(EntityDateField f, Entity t)'''
	public void set«f.name.toLowerCase.toFirstUpper»(Date «f.name.toLowerCase») {
		this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldSet(EntityDateTimeField f, Entity t)'''
	public void set«f.name.toLowerCase.toFirstUpper»(Date «f.name.toLowerCase») {
		this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldSet(EntityTimeField f, Entity t)'''
	public void set«f.name.toLowerCase.toFirstUpper»(Date «f.name.toLowerCase») {
		this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldSet(EntityBooleanField f, Entity t)'''
	public void set«f.name.toLowerCase.toFirstUpper»(Boolean «f.name.toLowerCase») {
		this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldSet(EntityImageField f, Entity t)'''
	public void set«f.name.toLowerCase.toFirstUpper»(String «f.name.toLowerCase») {
		this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldSet(EntityFileField f, Entity t)'''
	public void set«f.name.toLowerCase.toFirstUpper»(String «f.name.toLowerCase») {
		this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldSet(EntityEmailField f, Entity t)'''
	public void set«f.name.toLowerCase.toFirstUpper»(String «f.name.toLowerCase») {
		this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldSet(EntityDecimalField f, Entity t)'''
	public void set«f.name.toLowerCase.toFirstUpper»(Double «f.name.toLowerCase») {
		this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldSet(EntityIntegerField f, Entity t)'''
	public void set«f.name.toLowerCase.toFirstUpper»(Integer «f.name.toLowerCase») {
		this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	}
	'''
	def dispatch getAttributeFieldSet(EntityCurrencyField f, Entity t)'''
	public void set«f.name.toLowerCase.toFirstUpper»(Double «f.name.toLowerCase») {
		this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	}
	'''	
	
	def dispatch getAttributeFieldSet(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.genRelationshipSetOne(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipSetOne(Enum e, Entity t, String name) ''' 
	public void set«name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «name.toLowerCase») {
		this.«name.toLowerCase» = «name.toLowerCase»;
	}
	'''
	
	def dispatch genRelationshipSetOne(Entity e, Entity t, String name) ''' 
	public void set«name.toLowerCase.toFirstUpper»(«e.name.toLowerCase.toFirstUpper» «name.toLowerCase») {
		this.«name.toLowerCase» = «name.toLowerCase»;
	}
	'''
	
	/* Get Attribute Constructor */
	def dispatch getAttributeConstructor(EntityTextField f, Entity t)'''
	String «f.name.toLowerCase»,
	'''
	def dispatch getAttributeConstructor(EntityLongTextField f, Entity t)'''
	String «f.name.toLowerCase»,
	'''
	def dispatch getAttributeConstructor(EntityDateField f, Entity t)'''
	Date «f.name.toLowerCase»,
	'''
	def dispatch getAttributeConstructor(EntityDateTimeField f, Entity t)'''
	Date «f.name.toLowerCase»,
	'''
	def dispatch getAttributeConstructor(EntityTimeField f, Entity t)'''
	Date «f.name.toLowerCase»,
	'''
	def dispatch getAttributeConstructor(EntityBooleanField f, Entity t)'''
	Boolean «f.name.toLowerCase»,
	'''
	def dispatch getAttributeConstructor(EntityImageField f, Entity t)'''
	String «f.name.toLowerCase»,
	'''
	def dispatch getAttributeConstructor(EntityFileField f, Entity t)'''
	String «f.name.toLowerCase»,
	'''
	def dispatch getAttributeConstructor(EntityEmailField f, Entity t)'''
	String «f.name.toLowerCase»,
	'''
	def dispatch getAttributeConstructor(EntityDecimalField f, Entity t)'''
	Double «f.name.toLowerCase»,
	'''
	def dispatch getAttributeConstructor(EntityIntegerField f, Entity t)'''
	Integer «f.name.toLowerCase»,
	'''
	def dispatch getAttributeConstructor(EntityCurrencyField f, Entity t)'''
	Double «f.name.toLowerCase»,
	'''	
	
	def dispatch getAttributeConstructor(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
	«f.superType.genRelationshipConstructor(t, f.name)»		
	«ENDIF»
	'''	
	
	def dispatch genRelationshipConstructor(Enum e, Entity t, String name) ''' 
	«e.name.toLowerCase.toFirstUpper» «name.toLowerCase»,
	'''
	
	def dispatch genRelationshipConstructor(Entity e, Entity t, String name) ''' 
	«e.name.toLowerCase.toFirstUpper» «name.toLowerCase»,
	'''
	
		/* getAttributeImport */
	def dispatch getAttributeImport(EntityTextField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityLongTextField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityDateField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityDateTimeField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityTimeField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityBooleanField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityImageField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityFileField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityEmailField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityDecimalField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityIntegerField f, Entity t)'''
	'''
	def dispatch getAttributeImport(EntityCurrencyField f, Entity t)'''
	'''	
	
	def dispatch getAttributeImport(EntityReferenceField f, Entity t)'''
	«IF  f !== null && !f.upperBound.equals('*')»
		«f.superType.getAttributeRefImport(t, f.name)»
	«ENDIF»
	'''	
	
	def dispatch getAttributeRefImport(Enum e, Entity t, String name) ''' 
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»Enum;
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;
	'''
	
	def dispatch getAttributeRefImport(Entity e, Entity t, String name) ''' 
	import com.aforebanamex.plata.comunes.model.cg.«e.name.toLowerCase.toFirstUpper»;
	'''	
	
}