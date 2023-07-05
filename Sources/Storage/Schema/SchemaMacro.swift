//
//  File.swift
//  
//
//  Created by Caleb Jonas on 7/3/23.
//

import StorageMacros

@attached(conformance)
@attached(memberAttribute)
@attached(member, names: named(_attributeMetadatas(filteredBy:)), named(_migrate(as:)), named(_schemaName))
public macro Schema() = #externalMacro(module: "StorageMacros", type: "SchemaMacro")
