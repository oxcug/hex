///
/// Copyright © 2021-2023 Benefic Technologies Inc. All rights reserved.
/// License Information: https://github.com/benefic-org/storage/blob/master/LICENSE

import Foundation

public protocol KeyValueStorageScope: RawRepresentable where RawValue == String {}

public protocol KeyValueStorageProtocol {
    
    init(config: Configuration, scope: (any KeyValueStorageScope)?)
    
    func getObject<T: AttributeValue>(forKey: String) -> T?
    
    func set<T: AttributeValue>(object: T?, forKey: String)
    
    func reset(scope: (any KeyValueStorageScope)?)
}
