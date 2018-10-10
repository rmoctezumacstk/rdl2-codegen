package com.softtek.generator.bash

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
//import com.softtek.rdl2.Module

class BashRDLGenerator {
	
	def doGenerator(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("bash/" + "setup.sh", genSetupSh(resource))
		fsa.generateFile("bash/" + "copy.sh", genCopySh(resource))
	}
	

	def CharSequence genSetupSh(Resource resource) '''
		#!/usr/bin/env sh
		
		git clone https://github.com/efuentesp/riot-ui-prototype.git $1
		
		./copy.sh $1
		
		cd $1
		npm install
		npm run dev
	'''

	def CharSequence genCopySh(Resource resource) '''
		#!/usr/bin/env sh
		
		rm -rf $1/src/components/app
		mkdir $1/src/components/app
		
		rm -rf $1/src/tabledata
		mkdir $1/src/tabledata
		
		cp -r ../prototipo/src/components/app/* $1/src/components/app
		cp ../prototipo/src/tabledata.js $1/src
		cp -r ../prototipo/src/tabledata/* $1/src/tabledata
		cp ../prototipo/src/index.js $1/src
		
	'''
	
}