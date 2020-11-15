import Foundation

public struct ModelMigrationBuilder {
    
    public static func build(_ migrations: ModelMigration...) -> Self {
        return .init()
    }
}

public struct AttributeMigration {
    
    public static func attribute(_  valueType: AttributeValueType, named: StaticString, previousName: StaticString? = nil) -> Self {
        .init()
    }
}

public struct ModelMigration {
    
    /// Adds a previous Model definition
    /// - Returns: A new `TableMigration`.
    public static func previous(_ name: StaticString, _ attributes: AttributeMigration...) -> Self {
        return .init()
    }
    
    public static func latest(_ name: StaticString, _ attributes: AttributeMigration...) -> Self {
        return .init()
    }

}
