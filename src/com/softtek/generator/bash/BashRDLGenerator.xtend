package com.softtek.generator.bash

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import com.softtek.rdl2.Module
import com.softtek.rdl2.Entity
import com.softtek.rdl2.ModuleRef
import java.util.ArrayList
import java.util.HashSet

//import com.softtek.rdl2.Module

class BashRDLGenerator {
	
	def doGenerator(HashSet<String> accModules , IFileSystemAccess2 fsa) {
		fsa.generateFile("bash/" + "setup.sh", genSetupSh())
		fsa.generateFile("bash/" + "copy.sh", genCopySh())
		fsa.generateFile("bash/" + "gendoc.sh", genDocSh(accModules))
	}
	

	def CharSequence genSetupSh() '''
        #!/usr/bin/env sh
		
		git clone https://github.com/efuentesp/riot-ui-prototype.git $1
		
		#mkdir $1/src-gen
		#mkdir $1/bash
		
		#cp /c/@Programs/mapencoding.sh mapencoding.sh
		
		mkdir $1/functional-specs
		mkdir $1/functional-specs/img
		mkdir $1/technical-specs
		./copy.sh $1
		
		cd $1
		npm install
		npm run dev
		
	'''

	def CharSequence genCopySh() '''
		#!/usr/bin/env sh
		
		rm -rf $1/src/components/app
		mkdir $1/src/components/app
		
		rm -rf $1/src/tabledata
		mkdir $1/src/tabledata
		
		cp -r ../prototipo/src/components/app/* $1/src/components/app
		cp ../prototipo/src/tabledata.js $1/src
		cp -r ../prototipo/src/tabledata/* $1/src/tabledata
		cp ../prototipo/src/index.js $1/src
		
		
		cp -r ../functional-specs/* $1/functional-specs/.
		cp $1/src/img/* $1/functional-specs/img
		
		cp ../functional-specs/title-page.tex $1/functional-specs
		cp ../functional-specs/title-page-en.tex $1/functional-specs
		
		#cp -r ../technical-specs/* $1/technical-specs/.
		
	'''
	
	def CharSequence genDocSh(HashSet<String> accModules) '''
		#!/usr/bin/env sh
		«FOR m : accModules»
			java -jar /c/@Programs/plantuml.jar -charset UTF-8 $1/functional-specs/domain-model/DOM-«m»/*.plantuml
			java -jar /c/@Programs/plantuml.jar -charset UTF-8 $1/functional-specs/use-cases/diagrams/UCD-«m»/*.plantuml
			
			#java -jar /c/@Programs/plantuml.jar -charset UTF-8 $1/technical-specs/uml/object-model/OM-«m»/*.plantuml
			#java -jar /c/@Programs/plantuml.jar -charset UTF-8 $1/technical-specs/uml/sequence-diagrams/SD-«m»/*.plantuml
			java -jar /c/@Programs/plantuml.jar -charset UTF-8 $1/functional-specs/use-cases/diagrams/SearchActivityUCD-«m»/*.plantuml
			java -jar /c/@Programs/plantuml.jar -charset UTF-8 $1/functional-specs/use-cases/diagrams/CreateActivityUCD-«m»/*.plantuml
			java -jar /c/@Programs/plantuml.jar -charset UTF-8 $1/functional-specs/use-cases/diagrams/DeleteActivityUCD-«m»/*.plantuml
			java -jar /c/@Programs/plantuml.jar -charset UTF-8 $1/functional-specs/use-cases/diagrams/UpdateActivityUCD-«m»/*.plantuml
		«ENDFOR»
		
		cd $1/functional-specs	
		pdflatex -quiet --synctex=1 "functional-spec.tex"
		pdflatex -quiet --synctex=1 "functional-spec.tex"

	'''
	
}