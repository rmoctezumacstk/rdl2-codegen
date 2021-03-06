package com.softtek.generator.clarity.screen.admin

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.PageContainer

class ScreenCssGenerator {
	
	def doGenerate(Resource resource, IFileSystemAccess2 fsa) {
		for (m : resource.allContents.toIterable.filter(typeof(Module))) {
			for (p : m.elements.filter(typeof(PageContainer))) {
				if (p.screen_type === null) {
					fsa.generateFile("clarity/src/app/admin/"+ m.name.toLowerCase + "/" + m.name.toLowerCase +".psg.scss", p.generateCssScreen(m))
				}
			}
		}
	}
	
	def CharSequence generateCssScreen(PageContainer container, Module module) '''
	/* PSG  «module.name.toFirstUpper» SCSS */
	.clr-example {
	  .card {
	    max-width: 600px;
	  }
	}
	
	.clr-col-1,
	.clr-col-2,
	.clr-col-3,
	.clr-col-4,
	.clr-col-5,
	.clr-col-6,
	.clr-col-7,
	.clr-col-8,
	.clr-col-9,
	.clr-col-10,
	.clr-col-11,
	.clr-col-12,
	.clr-col,
	.clr-col-auto,
	.clr-col-sm-1,
	.clr-col-sm-2,
	.clr-col-sm-3,
	.clr-col-sm-4,
	.clr-col-sm-5,
	.clr-col-sm-6,
	.clr-col-sm-7,
	.clr-col-sm-8,
	.clr-col-sm-9,
	.clr-col-sm-10,
	.clr-col-sm-11,
	.clr-col-sm-12,
	.clr-col-sm,
	.clr-col-sm-auto,
	.clr-col-md-1,
	.clr-col-md-2,
	.clr-col-md-3,
	.clr-col-md-4,
	.clr-col-md-5,
	.clr-col-md-6,
	.clr-col-md-7,
	.clr-col-md-8,
	.clr-col-md-9,
	.clr-col-md-10,
	.clr-col-md-11,
	.clr-col-md-12,
	.clr-col-md,
	.clr-col-md-auto,
	.clr-col-lg-1,
	.clr-col-lg-2,
	.clr-col-lg-3,
	.clr-col-lg-4,
	.clr-col-lg-5,
	.clr-col-lg-6,
	.clr-col-lg-7,
	.clr-col-lg-8,
	.clr-col-lg-9,
	.clr-col-lg-10,
	.clr-col-lg-11,
	.clr-col-lg-12,
	.clr-col-lg,
	.clr-col-lg-auto,
	.clr-col-xl-1,
	.clr-col-xl-2,
	.clr-col-xl-3,
	.clr-col-xl-4,
	.clr-col-xl-5,
	.clr-col-xl-6,
	.clr-col-xl-7,
	.clr-col-xl-8,
	.clr-col-xl-9,
	.clr-col-xl-10,
	.clr-col-xl-11,
	.clr-col-xl-12,
	.clr-col-xl,
	.clr-col-xl-auto {
	  width: 100%;
	  min-height: 1px;
	  padding: 0px !important;
	}
	
	.date-container {
	  width: 100% !important;
	  display: inline-flex !important;
	  align-items: center !important;
	  white-space: nowrap !important;
	}
	
	.data-container {
	  width: 95% !important;
	  display: inline-flex !important;
	  align-items: center !important;
	  white-space: nowrap !important;
	}
	
	.line-list {
	  border-bottom: 1px solid #eee;
	  width: 100%;
	}
	
	.required {
	  color: #ff0000;
	}
	
	.swal2-container:not(.swal2-top):not(.swal2-top-start):not(.swal2-top-end):not(.swal2-top-left):not(.swal2-top-right):not(.swal2-center-start):not(.swal2-center-end):not(.swal2-center-left):not(.swal2-center-right):not(.swal2-bottom):not(.swal2-bottom-start):not(.swal2-bottom-end):not(.swal2-bottom-left):not(.swal2-bottom-right):not(.swal2-grow-fullscreen)
	  > .swal2-modal {
	  margin: auto;
	  font-size: 10px;
	}
	
	.swal2-popup .swal2-modal .swal2-show {
	  margin: auto;
	  font-size: 10px;
	}
	'''
}