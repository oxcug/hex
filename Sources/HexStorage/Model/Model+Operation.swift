import Foundation
import SQLite3

public extension RawModel {
    
    var operationBuilder: Operation<Self> {
        .init(dependencies: [])
    }
}
