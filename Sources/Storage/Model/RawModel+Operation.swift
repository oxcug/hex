///
/// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
/// License Information: https://github.com/oxcug/hex/blob/master/LICENSE


public class Predicate<Schema> {
    
    public enum Operator {
        case and, or, equals, notEquals, contains, lessThan, greaterThan, lessThanOrEquals, greaterThanOrEquals
    }
    
    public enum Param {
        case subPredicate(Predicate)
        case literalValue(AttributeValue)
        case columnSymbol(String)
    }
    
    var lhs: Param
    var op: Operator
    var rhs: Param

    public init(lhs: Param, op: Operator, rhs: Param) {
        self.lhs = lhs
        self.op = op
        self.rhs = rhs
    }
}

public extension Predicate {
    static func &&(self: Predicate<Schema>, rhs: Predicate<Schema>) -> Predicate<Schema> {
        Predicate(lhs: .subPredicate(self), op: .and, rhs: .subPredicate(rhs))
    }
}

//public extension KeyPath where Value: AttributeValue {
//    
//    static func ==(lhs: KeyPath<Root, Value>, rhs: Value) -> Predicate<Root> {
//        Predicate(lhs: .columnSymbol(lhs.propertyComponent), op: .equals, rhs: .literalValue(rhs))
//    }
//    
//    static func ~=(lhs: KeyPath<Root, Value>, rhs: Value) -> Predicate<Root> {
//        Predicate(lhs: .columnSymbol(lhs.propertyComponent), op: .contains, rhs: .literalValue(rhs))
//    }
//    
//    static func !=(lhs: KeyPath<Root, Value>, rhs: Value) -> Predicate<Root> {
//        Predicate(lhs: .columnSymbol(lhs.propertyComponent), op: .notEquals, rhs: .literalValue(rhs))
//    }
//    
//    static func >(lhs: KeyPath<Root, Value>, rhs: Value) -> Predicate<Root> {
//        Predicate(lhs: .columnSymbol(lhs.propertyComponent), op: .greaterThan, rhs: .literalValue(rhs))
//    }
//
//    static func >=(lhs: KeyPath<Root, Value>, rhs: Value) -> Predicate<Root> {
//        Predicate(lhs: .columnSymbol(lhs.propertyComponent), op: .greaterThanOrEquals, rhs: .literalValue(rhs))
//    }
//    
//    static func <(lhs: KeyPath<Root, Value>, rhs: Value) -> Predicate<Root> {
//        Predicate(lhs: .columnSymbol(lhs.propertyComponent), op: .lessThan, rhs: .literalValue(rhs))
//    }
//
//    static func <=(lhs: KeyPath<Root, Value>, rhs: Value) -> Predicate<Root> {
//        Predicate(lhs: .columnSymbol(lhs.propertyComponent), op: .lessThanOrEquals, rhs: .literalValue(rhs))
//    }
//}

extension Predicate {
    
    private static func _compileOperation(op: Operator) -> String {
        var sql = ""
        switch op {
        case .notEquals:
            sql += "!="
        case .contains:
            sql += "LIKE"
        case .and:
            sql += "AND"
        case .or:
            sql += "OR"
        case .equals:
            sql += "="
        case .lessThan:
            sql += "<"
        case .greaterThan:
            sql += ">"
        case .lessThanOrEquals:
            sql += "<="
        case .greaterThanOrEquals:
            sql += ">="
        }
        
        return sql
    }
    
    private static func _compileSymbol(xhs: Param, op: Operator, for config: Configuration) -> String {
        var sql = ""
        
        switch xhs {
        case .columnSymbol(let col):
            sql += "\(col)"
        case .literalValue(let val):
            switch op {
            case .contains:
                guard let val = val as? String else { fatalError() }
                sql += "%\(val)%".asSQL
            default:
                sql += val.asSQL
            }
        case .subPredicate(let pred):
            sql += pred.compile(for: config)
        }
        
        return sql
    }
    
    func compile(for config: Configuration) -> String {
        var sql = " "
        
        sql += Self._compileSymbol(xhs: lhs, op: op, for: config)
        sql += " "
        sql += Self._compileOperation(op: op)
        sql += " "
        sql += Self._compileSymbol(xhs: rhs, op: op, for: config)
        
        return sql
    }
}

public extension Model {
        
    /// Creates a operation to `upsert` (update or insert) this model.
    func upsert() -> ModelOperation<Schema> {
        ModelOperation(.create, .row, values: self.attributeValueStorage)
    }
    
    /// Deletes this model from the .
    func delete() -> ModelOperation<Schema> {
        ModelOperation(.delete, .row)
    }
    
    static func find(where predicate: Predicate<Schema>, offset: UInt = 0, count: UInt = 1) -> ModelOperation<Schema> {
        ModelOperation(.read, .row, predicate: predicate)
    }
    
    static func findAll() -> ModelOperation<Schema> {
        ModelOperation(.read, .table)
    }
}
