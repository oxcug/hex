//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

import Foundation
import Storage

extension Configuration {
    static var `default`: Configuration = {
        let config = try! Configuration(keyValueStore: UserDefaults(suiteName: "Tests")!, connections: [.memory])
        try! config.register(schema: ExampleSchema.self)
        return config
    }()
}

protocol ExampleSchemaProtocol {
    
}

@available(swift 5.9)
@Schema
final class ExampleSchema {
    typealias Conformant = ExampleSchemaProtocol
    
    var string: String = "<Default Value>"
    var date: Date = Date()
    var double: Double = 99
    var integer: Int = 1
    var nullableString: String?
    var nullableDate: Date?
    var nullableDouble: Double?
    var nullableInteger: Int?
}
