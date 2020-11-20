public protocol RawModel {
    
    var identifier: UUID { get }
    
    var config: Configuration { get }
    
    static var name: StaticString { get }
    
    static func columns(for config: Configuration) -> [AttributeMetadata]
        
    static func migrate(using current: ModelMigrationBuilder) -> ModelOperation?
}

open class Model: RawModel, Identifiable, Equatable {
    
    public typealias ID = UUID
    
    open class var name: StaticString {
        fatalError("Sublcass must implement function `tableName(for:)`")
    }
    
    open class func migrate(using current: ModelMigrationBuilder) -> ModelOperation? {
        fatalError("Sublcass must implement function `migrate(using:)`")
    }
    
    public static func == (lhs: Model, rhs: Model) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public var id: UUID { identifier }
    
    public private(set) var identifier = UUID()
    
    public var config: Configuration
    
    public required init(for config: Configuration) {
        self.config = config
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
