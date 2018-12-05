package com.softtek.generator.bash

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
//import com.softtek.rdl2.Module

class BashRDLGenerator {
	
	def doGenerator(Resource resource, IFileSystemAccess2 fsa) {
		fsa.generateFile("bash/" + "setup.sh", genSetupSh(resource))
		fsa.generateFile("bash/" + "copy.sh", genCopySh(resource))
		fsa.generateFile("bash/" + "copy-prototype.sh", genCopyPrototypeSh(resource))
	}
	

	def CharSequence genSetupSh(Resource resource) '''
		#!/usr/bin/env sh
		
		mkdir $1
		
		git clone https://github.com/efuentesp/riot-ui-prototype.git $1/prototype
		
		sh copy.sh $1
		
		#cd $1
		#npm install
		#npm run dev
	'''

	def CharSequence genCopySh(Resource resource) '''
		#!/usr/bin/env sh
		
		sh copy-prototype.sh $1
	'''

	def CharSequence genCopyPrototypeSh(Resource resource) '''
		#!/usr/bin/env sh
		
		dir=$1"/prototype"
		
		rm -rf $dir/src/components/app
		mkdir $dir/src/components/app
		
		rm -rf $dir/src/tabledata
		mkdir $dir/src/tabledata
		
		cp -r ../prototipo/src/components/app/* $dir/src/components/app
		cp ../prototipo/src/tabledata.js $dir/src
		cp -r ../prototipo/src/tabledata/* $dir/src/tabledata
		cp ../prototipo/src/index.js $dir/src
	'''	
}