/*
 * generated by Xtext 2.12.0
 */
package com.softtek.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import javax.inject.Inject
import com.softtek.generator.bash.BashRDLGenerator
import com.softtek.generator.uiprototype.ScreenGenerator
import com.softtek.generator.uiprototype.AppTagGenerator
import com.softtek.generator.uiprototype.IndexJsGenerator
import com.softtek.generator.uiprototype.TableDataJsGenerator
import com.softtek.generator.uiprototype.TableDataJsonGenerator
import com.softtek.generator.clarity.AdminHtmlClarityGenerator
import com.softtek.generator.clarity.AdminRoutingClarityGenerator
import com.softtek.generator.clarity.AdminModuleClarityGenerator
import com.softtek.generator.clarity.AdminTsClarityGenerator
import com.softtek.generator.clarity.screen.ScreenClarityHtmlGenerator
import com.softtek.generator.clarity.screen.ScreenClarityTsGenerator
import com.softtek.generator.clarity.screen.admin.ScreenTsGenerator
import com.softtek.generator.clarity.screen.admin.ScreenRoutingGenerator
import com.softtek.generator.clarity.screen.admin.ScreenCssGenerator
import com.softtek.generator.clarity.screen.admin.ScreenModuleGenerator
import com.softtek.generator.clarity.screen.admin.ScreenServiceGenerator
import com.softtek.generator.clarity.screen.admin.ScreenModelGenerator
import com.softtek.generator.clarity.screen.admin.ScreenHtmlGenerator
import com.softtek.generator.jsonserver.JsonServerGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentHtmlGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentMessagesGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentIntegrationGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentIntegrationImplGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentServiceImplGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentServiceGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentModelGenerator

class Rdl2Generator extends AbstractGenerator {

	@Inject BashRDLGenerator bashRDLGenerator
	
	@Inject IndexJsGenerator indexJsGenerator
	@Inject AppTagGenerator appTagGenerator
	@Inject TableDataJsGenerator tableDataJsGenerator
	@Inject ScreenGenerator screenGenerator
	@Inject TableDataJsonGenerator tableDataJsonGenerator
	
	// Clarity Screen Entity
	@Inject ScreenClarityHtmlGenerator screenClarityHtmlGenerator
	@Inject ScreenClarityTsGenerator screenClarityTsGenerator
	
	// Clarity Screen Admin
	@Inject ScreenTsGenerator screenTsGenerator
	@Inject ScreenRoutingGenerator screenRoutingGenerator
	@Inject ScreenCssGenerator screenCssGenerator
	@Inject ScreenModuleGenerator screenModuleGenerator
	@Inject ScreenServiceGenerator screenServiceGenerator
	@Inject ScreenModelGenerator screenModelGenerator
	@Inject ScreenHtmlGenerator screenHtmlGenerator
	
	// Clarity Admin
	@Inject AdminHtmlClarityGenerator adminHtmlClarityGenerator
	@Inject AdminRoutingClarityGenerator adminRoutingClarityGenerator
	@Inject AdminModuleClarityGenerator adminModuleClarityGenerator
	@Inject AdminTsClarityGenerator adminTsClarityGenerator
	
	// Json Server
	@Inject JsonServerGenerator jsonServerGenerator
	
	// Banamex
	@Inject CrudComponentHtmlGenerator crudComponentHtmlGenerator
	@Inject CrudComponentMessagesGenerator crudComponentMessagesGenerator
	@Inject CrudComponentIntegrationGenerator crudComponentIntegrationGenerator
	@Inject CrudComponentIntegrationImplGenerator crudComponentIntegrationImplGenerator
	@Inject CrudComponentServiceImplGenerator crudComponentServiceImplGenerator
	@Inject CrudComponentServiceGenerator crudComponentServiceGenerator 
	@Inject CrudComponentModelGenerator crudComponentModelGenerator
	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		indexJsGenerator.doGenerate(resource, fsa)
		appTagGenerator.doGenerate(resource, fsa)
		tableDataJsGenerator.doGenerate(resource, fsa)
		
		// Clarity Admin Global
		adminHtmlClarityGenerator.doGenerate(resource, fsa)
		adminModuleClarityGenerator.doGenerate(resource, fsa)
		adminRoutingClarityGenerator.doGenerate(resource, fsa)
		adminTsClarityGenerator.doGenerate(resource, fsa)
		
		// Clarity Admin Entity
		screenTsGenerator.doGenerate(resource, fsa)
		screenRoutingGenerator.doGenerate(resource, fsa)
		screenCssGenerator.doGenerate(resource, fsa)
		screenModuleGenerator.doGenerate(resource, fsa)
		screenServiceGenerator.doGenerate(resource, fsa)
		screenModelGenerator.doGenerate(resource, fsa)
		screenHtmlGenerator.doGenerate(resource, fsa)
		
		for (s : resource.allContents.toIterable.filter(typeof(com.softtek.rdl2.System))){
			jsonServerGenerator.doGenerator(s, fsa)
		}
		
		crudComponentHtmlGenerator.doGenerate(resource, fsa)
		crudComponentMessagesGenerator.doGenerate(resource, fsa)
		crudComponentIntegrationGenerator.doGenerate(resource, fsa)
		crudComponentIntegrationImplGenerator.doGenerate(resource, fsa)
		crudComponentServiceImplGenerator.doGenerate(resource, fsa)
		crudComponentServiceGenerator.doGenerate(resource, fsa)
		crudComponentModelGenerator.doGenerate(resource, fsa)
		
		for(r:resource.resourceSet.resources){
			screenGenerator.doGenerate(r, fsa)
			tableDataJsonGenerator.doGenerate(r, fsa)
			
			// Clarity Entity
			screenClarityHtmlGenerator.doGenerate(r, fsa)
			screenClarityTsGenerator.doGenerate(r,fsa)
	
		}
		
		bashRDLGenerator.doGenerator(resource, fsa)
	}
	
	override afterGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
	}
	
}
