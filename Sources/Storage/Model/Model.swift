//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import Foundation

protocol OpaqueModel {
    associatedtype Conformance
}

@dynamicMemberLookup
public final class Model<Schema: SchemaRepresentable> {
    
    typealias Schema = Schema
    
    public var attributeValueStorage = [String: AttributeValue?]()
    
    var attributeTransformers = [String: AttributeTransformer]()
    
    func populateAttributeTransformers() {
        Self.Schema.attributeMetadatas().forEach {
            attributeTransformers[$0.name] = $0.transformer
        }
    }
    
    func populateAttributeValueStorage(values: [String: AttributeValue?]) {
        values.forEach {
            if let fn = attributeTransformers[$0.key] {
                attributeValueStorage[$0.key] = (fn.set($0.value!) as? any AttributeValue)
            } else {
                attributeValueStorage[$0.key] = $0.value
            }
        }
    }
    
    func retreieveAttributeValueFromStorage(for key: String) -> AttributeValue? {
        guard let value = attributeValueStorage[key] else { return nil }
        if let fn = attributeTransformers[key] {
            return (fn.get(value) as! any AttributeValue)
        } else {
            return value
        }
    }
	
	func findPrimaryKey() -> (column: String, value: (any AttributeValue)?)? {
		//TODO: this is also pretty ugly. We should create a property wrapper that binds the primary instead of assuming it's the first UUID.
		
		guard let firstUUIDColumn = Self.Schema.attributeMetadatas()
			.first(where: { $0.type == .uuid }) else { return nil }
		return (
			column: firstUUIDColumn.name,
			value: self.retreieveAttributeValueFromStorage(for: firstUUIDColumn.name)
		)
	}
	
	func updateAttributeValueFromStorage(for key: String, with value: any AttributeValue) {
		let newValue: any AttributeValue
        if let fn = attributeTransformers[key] {
             newValue = (fn.set(value) as! any AttributeValue)
        } else {
            newValue = value
        }
		
		attributeValueStorage[key] = newValue
    }
    
    public required init(with value: Schema) {
        var values = [String: AttributeValue?]()
        let m = Mirror(reflecting: value)
        
        m.children
            .filter { $0.label?.starts(with: "_") ?? false }
            .forEach {
                guard let sub = $0.label?.dropFirst(1) else { return }
                let key = String(sub)
                
                values[key] = ($0.value as? AttributeProtocol)?.value
            }
        
        populateAttributeTransformers()
        populateAttributeValueStorage(values: values)
    }
    
    public required init(from attributeValues: [String: AttributeValue?]) {
        populateAttributeTransformers()
        self.attributeValueStorage = attributeValues
    }
    
	public subscript<T>(dynamicMember key: String) -> T {
		print("Searching using key: \(key) (storage: \(attributeValueStorage))")
		return retreieveAttributeValueFromStorage(for: key) as! T
	}

	public func assign<T: AttributeValue>(_ key: String, to newValue: T) -> ModelOperation<Schema>? {
		print("Updating value with key: \(key) with newValue \(newValue) (storage: \(attributeValueStorage))")
		updateAttributeValueFromStorage(for: key, with: newValue)
		
		//TODO: I'm really not happy with this awkward ass syntax (e.g getting a operation by using assignment syntax), but it's fine for now.
		guard let pkey = findPrimaryKey() else {
			print("Did not automatically find primary key for \(Self.Schema.schemaName), no column identified as a UUID.")
			return nil
		}
		
		guard let pkeyValue = pkey.value else {
			print("*Did* find primary key for \(Self.Schema.schemaName), however primary key value is nil.")
			return nil
		}
		
		return ModelOperation<Schema>(
			.update,
			.row,
			values: [key:newValue],
			predicate: Predicate<Schema>.init(lhs: .columnSymbol(pkey.column), op: .equals, rhs: .literalValue(pkeyValue))
		)
	}
}
