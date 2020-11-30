public protocol RawModel {
    
    var identifier: UUID { get }
    
    init()
    
    static var name: StaticString { get }
    
    static func columns() -> [AttributeMetadata]
    
    static func column(named: String) -> AttributeMetadata?
    
    static func migrate<T: RawModel>(using current: ModelMigrationBuilder<T>) -> ModelOperation<T>?
}

open class Model: RawModel, Codable, Identifiable, Equatable {
    
    open class func migrate<T>(using current: ModelMigrationBuilder<T>) -> ModelOperation<T>? where T : RawModel {
        preconditionFailure("Subclass must implement class `migrate` function.")
    }
    
    public typealias ID = UUID
    
    open class var name: StaticString {
        
        preconditionFailure("Sublcass must implement class getter `name`")
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
