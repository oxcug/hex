//
//  File.swift
//  
//
//  Created by Caleb Jonas on 7/3/23.
//
#if swift(>=5.9)
import StorageMacros

@attached(peer, names: suffixed(Protocol))
@attached(conformance)
@attached(memberAttribute)
@attached(member, names: named(Conformant), named(_attributeMetadatas(filteredBy:)), named(_migrate(as:)), named(_schemaName))
public macro Schema() = #externalMacro(module: "StorageMacros", type: "SchemaMacro")
#endif
