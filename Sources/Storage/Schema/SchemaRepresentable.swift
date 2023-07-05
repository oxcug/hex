///
/// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
/// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

public protocol SchemaRepresentable {
    
    associatedtype Conformant
    
    static var _schemaName: StaticString { get }

    static func _migrate(as current: ModelMigrationBuilder<Self>) -> ModelOperation<Self>?
    
    /// Gathers the metadata for all attributes.
    ///
    /// Metadata holds information for runtime routines to handle things like transformation, typing, or foreign relationships in the RDBMS.
    /// Usually, this is implemented automatically by the `@Schema` macro.
    ///
    /// - Parameter name: If a name is provided, only an attribute with that name will be returned.
    /// - Returns: An array of all attribute metadatas.
    ///
    /// - SeeAlso: The extension function`attributeMetadata(for:)` provides a more ergonomic version of this function when
    ///            accessing a single attribute metadata.
    static func _attributeMetadatas(filteredBy name: String?) -> [AttributeMetadata]
}

public extension SchemaRepresentable {
    
    @inlinable static var schemaName: StaticString { _schemaName }
}

extension SchemaRepresentable {
    
    /// A convenience function using the underlying `SchemaRepresentable.attributeMetadatas(filteredBy:)` function
    /// to gather attribute metadata about a single field in the schema.
    ///
    /// - Parameter attributeNamed: The name of the attribute.
    /// - Returns: If an attribute with the provided name exists, it returns the associated metadata. Otherwise returns `nil`.
    static func attributeMetadata(for attributeNamed: String) -> AttributeMetadata? {
        _attributeMetadatas(filteredBy: attributeNamed).first
    }
    
    static func attributeMetadatas() -> [AttributeMetadata] {
        _attributeMetadatas(filteredBy: nil)
    }
}
