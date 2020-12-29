#if os(WASI)
import SwiftFoundation
#else
import Foundation
#endif

public protocol RawModel: Codable {
    
    init()
    
    static var name: StaticString { get }
    
    static func columns() -> [AttributeMetadata]
    
    static func column(named: String) -> AttributeMetadata?
    
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
    
    public static func columns() -> [AttributeMetadata] {
        return columns(filterByName: nil)
    }
    
    public static func column(named: String) -> AttributeMetadata? {
        return columns(filterByName: named).first
    }
    
    private static func columns(filterByName: String? = nil) -> [AttributeMetadata] {
        let mirror = Mirror(reflecting: Self())
        var cols = [AttributeMetadata]()
        
        for child in mirror.children {
            guard let name = child.label, name.hasPrefix("_"), filterByName == nil || ("_" + filterByName! == name) else { continue }
            
            let label = String(name.dropFirst(1))
            if let out = child.value as? AttributeProtocol, let md = out.metadata(using: label, mirror: mirror, descendent: child) {
                cols.append(md)
            }   
        }
        
        return cols
    }
}
