public protocol RawModel: Codable {
    
    init()
    
    static var name: StaticString { get }
    
    static func columns<M: RawModel>() -> [AttributeMetadata<M>]
    
    static func column<M: RawModel>(named: String) -> AttributeMetadata<M>?
    
    static func migrate<M: RawModel>(using current: ModelMigrationBuilder<M>) -> ModelOperation<M>?
}

open class Model: RawModel, Codable {
    
    open class func migrate<T>(using current: ModelMigrationBuilder<T>) -> ModelOperation<T>? where T : RawModel {
        preconditionFailure("Subclass must implement class `migrate` function.")
    }
    
    public typealias ID = UUID
    
    open class var name: StaticString {
        
        preconditionFailure("Sublcass must implement class getter `name`")
    }
    
    public required init() {
        
    }
    
    public static func column<M>(named: String) -> AttributeMetadata<M>? where M : RawModel {
        return columns(filterByName: named)
    }
    
    public static func columns<M: RawModel>() -> [AttributeMetadata<M>] {
        return columns<M>(filterByName: nil)
    }
    
    public static func column(named: String) -> AttributeMetadata<Self>? {
        return columns(filterByName: named).first
    }
    
    static func columns<M: RawModel>(filterByName: String? = nil) -> [AttributeMetadata<M>] {
        let mirror = Mirror(reflecting: Self.init())
        var cols = [AttributeMetadata]()
        
        for child in mirror.children {
            if child.label?.hasPrefix("_") ?? false,
                let name = child.label?.dropFirst(1),
                filterByName == nil || name == filterByName! {
                
                if let out = child.value as? AttributeProtocol, let md = out.metadata(with: mirror, descendent: child) {
                    cols.append(md)
                }
            }
        }
        
        return cols
    }
}
