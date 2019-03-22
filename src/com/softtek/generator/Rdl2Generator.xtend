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
import com.softtek.generator.functionalspecs.FunctionalSpecsRDLGenerator
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
import com.softtek.generator.afore.citibanamex.CrudComponentMapperGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentServiceImplGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentServiceGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentModelGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentPaginatorHelperGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentPaginadorGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentSqlGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentH2Generator
import com.softtek.generator.afore.citibanamex.CrudComponentOracleGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentConsultasGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentConstantsGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentControllerGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentJsGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentCatalogoServiceGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentCatalogoServiceImplGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentCatalogoRepositoryGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentCatalogoRepositoryImplGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentServiceGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentJDBCRepositoryGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentJDBCRepositoryImplGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentRepositoryGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentRepositoryImplGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentServiceImplMNGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentServiceMNGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentJsMainGenerator
import com.softtek.generator.afore.citibanamex.CrudComponentControllerMNGenerator
import com.softtek.rdl2.Entity
import java.util.ArrayList
import java.util.List
import java.util.HashSet

class Rdl2Generator extends AbstractGenerator {

	@Inject BashRDLGenerator bashRDLGenerator
	@Inject FunctionalSpecsRDLGenerator functionalSpecsRDLGenerator
	
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
	@Inject CrudComponentMapperGenerator crudComponentMapperGenerator
	@Inject CrudComponentServiceImplGenerator crudComponentServiceImplGenerator
	@Inject CrudComponentServiceGenerator crudComponentServiceGenerator 
	@Inject CrudComponentModelGenerator crudComponentModelGenerator
//	@Inject CrudComponentPaginatorHelperGenerator crudComponentPaginatorHelperGenerator
//	@Inject CrudComponentPaginadorGenerator crudComponentPaginadorGenerator
//	@Inject CrudComponentSqlGenerator crudComponentSqlGenerator
//	@Inject CrudComponentConsultasGenerator crudComponentConsultasGenerator
	@Inject CrudComponentH2Generator crudComponentH2Generator
	@Inject CrudComponentOracleGenerator crudComponentOracleGenerator
	@Inject CrudComponentConstantsGenerator crudComponentConstantsGenerator
	@Inject CrudComponentJsGenerator crudComponentJsGenerator
	@Inject CrudComponentControllerGenerator crudComponentControllerGenerator
	@Inject CrudComponentCatalogoServiceGenerator crudComponentCatalogoServiceGenerator
	@Inject CrudComponentCatalogoServiceImplGenerator crudComponentCatalogoServiceImplGenerator
	@Inject CrudComponentCatalogoRepositoryGenerator crudComponentCatalogoRepositoryGenerator
	@Inject CrudComponentCatalogoRepositoryImplGenerator crudComponentCatalogoRepositoryImplGenerator
	@Inject CrudComponentJDBCRepositoryGenerator crudComponentJDBCRepositoryGenerator
	@Inject CrudComponentJDBCRepositoryImplGenerator crudComponentJDBCRepositoryImplGenerator
	@Inject CrudComponentRepositoryGenerator crudComponentRepositoryGenerator
	@Inject CrudComponentRepositoryImplGenerator crudComponentRepositoryImplGenerator
	@Inject CrudComponentServiceImplMNGenerator crudComponentServiceImplMNGenerator
	@Inject CrudComponentServiceMNGenerator crudComponentServiceMNGenerator
	@Inject CrudComponentControllerMNGenerator crudComponentControllerMNGenerator
	@Inject CrudComponentJsMainGenerator crudComponentJsMainGenerator
	
	
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
		
		// Banamex
		//crudComponentHtmlGenerator.doGenerate(resource, fsa)
//		crudComponentPaginatorHelperGenerator.doGenerate(resource, fsa)
//		crudComponentPaginadorGenerator.doGenerate(resource, fsa)
//		crudComponentSqlGenerator.doGenerate(resource, fsa)
        for(r:resource.resourceSet.resources){
		 crudComponentH2Generator.doGenerate(r,fsa)
		}
		for(r:resource.resourceSet.resources){
		 crudComponentOracleGenerator.doGenerate(r,fsa)
		}
		crudComponentModelGenerator.doGenerate(resource, fsa)
		crudComponentControllerGenerator.doGenerate(resource, fsa)
		crudComponentRepositoryGenerator.doGenerate(resource, fsa)
		crudComponentRepositoryImplGenerator.doGenerate(resource, fsa)
		crudComponentServiceImplGenerator.doGenerate(resource, fsa)
		crudComponentServiceGenerator.doGenerate(resource, fsa)
		crudComponentJsGenerator.doGenerate(resource, fsa)	
		crudComponentHtmlGenerator.doGenerate(resource, fsa)
		crudComponentServiceImplMNGenerator.doGenerate(resource, fsa)
		crudComponentServiceMNGenerator.doGenerate(resource, fsa)
		crudComponentJDBCRepositoryGenerator.doGenerate(resource, fsa)
		crudComponentJDBCRepositoryImplGenerator.doGenerate(resource, fsa)		
		crudComponentMapperGenerator.doGenerate(resource, fsa)
		crudComponentControllerMNGenerator.doGenerate(resource, fsa)	
		crudComponentJsMainGenerator.doGenerate(resource, fsa)	
		
		var accModules = new HashSet()
		
		for (s : resource.allContents.toIterable.filter(typeof(com.softtek.rdl2.System))){
			// Json Server
			jsonServerGenerator.doGenerator(s, fsa)
			
			// Banamex
//			crudComponentConsultasGenerator.doGenerate(s, fsa)
			crudComponentConstantsGenerator.doGenerate(s, fsa)
//			crudComponentMessagesGenerator.doGenerate(s, fsa)
			crudComponentCatalogoServiceGenerator.doGenerate(s, fsa)
			crudComponentCatalogoServiceImplGenerator.doGenerate(s, fsa)
			crudComponentCatalogoRepositoryGenerator.doGenerate(s, fsa)
			crudComponentCatalogoRepositoryImplGenerator.doGenerate(s, fsa)
		}		
		
		for(r:resource.resourceSet.resources){
			screenGenerator.doGenerate(r, fsa)
			tableDataJsonGenerator.doGenerate(r, fsa)
			
			// Clarity Entity
			screenClarityHtmlGenerator.doGenerate(r, fsa)
			screenClarityTsGenerator.doGenerate(r,fsa)
	
		}
		
		
		for (s : resource.allContents.toIterable.filter(typeof(com.softtek.rdl2.System))){
			for (m: s.modules_ref){
			 accModules.add(m.module_ref.name)
		    }
		   bashRDLGenerator.doGenerator(accModules, fsa)
		}
		
	
		for(r:resource.resourceSet.resources){
		 functionalSpecsRDLGenerator.doGeneratorUml(r, fsa)
		}
	}
	
	override afterGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
	}
	
}
