public struct ModelSchema {
    
    var isLatest: Bool
    
    var name: String
    
    var attributes: [AttributeSchema]
    
    /// Defines a previous schema version of the Model that can be used to migrate from either another previous version or  to the latest version.
    /// - Parameters:
    ///   - name: The previous name of the model.
    ///   - attributes: The complete collection of attributes for this version of the Model.
    /// - Returns: A new `ModelMigration`.
    public static func previous(_ name: StaticString, _ attributes: AttributeSchema...) -> Self {
        return Self(isLatest: false, name: String(describing: name), attributes: attributes)
    }
    
    /// Defines the most up to date version of the Model's schema.
    /// - Parameters:
    ///   - name: The latest name of the model.
    ///   - attributes: The complete collection of attributes for the current version of this model.
    /// - Returns: A `ModelMigration` representing the most recent version of a model.
    public static func latest(_ name: StaticString, _ attributes: AttributeSchema...) -> Self {
        return Self(isLatest: true, name: String(describing: name), attributes: attributes)
    }

}

extension ModelSchema: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return  lhs.isLatest == rhs.isLatest &&
                lhs.name == rhs.name &&
                lhs.attributes == rhs.attributes
    }
}

extension ModelSchema {
    
    public static func - (lhs: Self, rhs: Self) -> [PartialKeyPath<Self>] {
        var differences = [PartialKeyPath<Self>]()
        
        if lhs.isLatest != rhs.isLatest {
            differences.append(\Self.isLatest)
        }
        
        if lhs.name != rhs.name {
            differences.append(\Self.name)
        }
        
        if lhs.attributes != rhs.attributes {
            differences.append(\Self.attributes)
        }
        
        return differences
    }
}
