//
//  File.swift
//  
//
//  Created by Caleb Jonas on 7/3/23.
//
#if swift(>=5.9)
@attached(peer, names: suffixed(Protocol))
@attached(extension, conformances: SchemaRepresentable)
@attached(memberAttribute)
@attached(member, names: named(Conformant), named(_attributeMetadatas(filteredBy:)), named(_migrate(as:)), named(_schemaName), named(model))
public macro Schema() = #externalMacro(module: "StorageMacros", type: "SchemaMacro")
#endif
