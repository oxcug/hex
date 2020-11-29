public protocol RawModel {
    
    var identifier: UUID { get }
    
    init()
    
    static var name: StaticString { get }
    
    static func columns() -> [AttributeMetadata]
    
    static func column(named: String) -> AttributeMetadata?
    
    static func migrate(using current: ModelMigrationBuilder) -> AnyModelOperation?
}

open class Model: RawModel, Codable, Identifiable, Equatable {
    
    public typealias ID = UUID
    
    open class var name: StaticString {
        
        preconditionFailure("Sublcass must implement class getter `name`")
    }
    
    open class func migrate(using current: ModelMigrationBuilder) -> AnyModelOperation? {
        preconditionFailure("Sublcass must implement function `migrate(using:)`")
    }
    
    public static func == (lhs: Model, rhs: Model) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public var id: UUID { identifier }
    
    public private(set) var identifier = UUID()
    
    public required init() {
        
    }
    
    public static func columns() -> [AttributeMetadata] {
        columns(filterByName: nil)
    }
    
    public static func column(named: String) -> AttributeMetadata? {
        columns(filterByName: named).first
    }
    
    static func columns(filterByName: String? = nil) -> [AttributeMetadata] {
        let mirror = Mirror(reflecting: Self.init())
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
