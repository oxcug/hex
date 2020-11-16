import Foundation

public struct ModelSchema {
    
    var isLatest: Bool
    
    var name: StaticString
    
    var attributes: [AttributeMigration]
    
    /// Defines a previous schema version of the Model that can be used to migrate from either another previous version or  to the latest version.
    /// - Parameters:
    ///   - name: The previous name of the model.
    ///   - attributes: The complete collection of attributes for this version of the Model.
    /// - Returns: A new `ModelMigration`.
    public static func previous(_ name: StaticString, _ attributes: AttributeMigration...) -> Self {
        return Self(isLatest: false, name: name, attributes: attributes)
    }
    
    /// Defines the most up to date version of the Model's schema.
    /// - Parameters:
    ///   - name: The current name of the model.
    ///   - attributes: The complete collection of attributes for the current version of this model.
    /// - Returns: A `ModelMigration` representing the most recent version of a model.
    public static func latest(_ name: StaticString, _ attributes: AttributeMigration...) -> Self {
        return Self(isLatest: true, name: name, attributes: attributes)
    }

}
