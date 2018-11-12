package com.softtek.generator.vulcan

import com.softtek.rdl2.InlineFormComponent
import com.softtek.rdl2.PageContainer
import com.softtek.rdl2.Module
import com.java2s.pluralize.Inflector

class VulcanInlineFormComponentGenerator {
	
	var inflector = new Inflector
	
	def CharSequence genInLineFormComponentJsx(InlineFormComponent c, PageContainer p, Module m) '''
		import React from "react";
		import {
		  Components,
		  registerComponent,
		  withCurrentUser,
		  getFragment
		} from "meteor/vulcan:core";
		
		import «inflector.pluralize(c.entity.name)» from "../../../modules/«c.entity.name.toLowerCase»/collection";
		
		const «c.name» = ({ currentUser, refetch }) => (
		  <div>
		    {«inflector.pluralize(c.entity.name)».options.mutations.create.check(currentUser) ? (
		      <div
		        style={{
		          marginBottom: "20px",
		          paddingBottom: "20px",
		          borderBottom: "1px solid #ccc"
		        }}
		      >
		        <h4>Insert New Document</h4>
		        <Components.SmartForm
		          collection={«inflector.pluralize(c.entity.name)»}
		          mutationFragment={getFragment("«c.entity.name»ItemFragment")}
		          successCallback={refetch}
		        />
		      </div>
		    ) : null}
		  </div>
		);
		
		registerComponent({
		  name: "«c.name»",
		  component: «c.name»,
		  hocs: [withCurrentUser]
		});
	'''
	
}