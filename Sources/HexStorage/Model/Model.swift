import Foundation

public protocol RawModel {
    
    var identifier: UUID { get }
    
    var config: Configuration { get }
    
    static func tableName(for config: Configuration) -> String
    
    static func columns(for config: Configuration) -> [AttributeMetadata]
        
    static func migrations() -> ModelMigrationBuilder
}

open class Model: RawModel, Identifiable, Equatable {
    
    public typealias ID = UUID
    
    public static func == (lhs: Model, rhs: Model) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    open class func migrations() -> ModelMigrationBuilder {
        fatalError("Subclass must implement migrations!")
    }
    
    public var id: UUID { identifier }
    
    public private(set) var identifier = UUID()
    
    public var config: Configuration
    
    public required init(for config: Configuration) {
        self.config = config
    }
    
    public static func tableName(for config: Configuration) -> String {
        (config.tableNamePrefix ?? "") + String(describing: Self.self)
    }
    
    public static func column(for config: Configuration, named: String) -> AttributeMetadata? {
        columns(for: config, filterByName: named).first
    }
    
    public static func columns(for config: Configuration) -> [AttributeMetadata] {
        columns(for: config, filterByName: nil)
    }
    
    static func columns(for config: Configuration, filterByName: String? = nil) -> [AttributeMetadata] {
        let mirror = Mirror(reflecting: Self.init(for: config))
        var cols = [AttributeMetadata]()
        
        for child in mirror.children {
            if child.label?.hasPrefix("_") ?? false,
                let name = child.label?.dropFirst(1),
                filterByName == nil || name == filterByName! {
                
                if let out = child.value as? AttributeProtocol {
                    cols.append(out.metadata(with: String(name)))
                }
            }
        }
        
        return cols
    }
}
