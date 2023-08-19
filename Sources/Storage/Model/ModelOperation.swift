//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

enum OperationType {
	case create, read, update, delete
}

enum OperationSubject {
	case table, row
}

enum OperationParameter {
	case value
}

extension AttributeValueType {
	var sql: String {
		switch self {
			case .bool: return "BOOL"
			case .date: return "DATETIME"
			case .float: return "REAL"
			case .integer: return "INTEGER"
			case .string: return "TEXT"
			case .uuid: return "CHAR(36)"
		}
	}
}

extension AttributeProtocol {
	var sql: String {
		guard let sqlValue = value ?? defaultValue else {
			return "NULL"
		}
		
		return String(describing: sqlValue).replacingOccurrences(of: "'", with: "\\'")
	}
}

protocol AnyModelOperation {
	
	var dependencies: [AnyModelOperation] { get set }
	
	func compile(for configuration: Configuration) -> String
}

public struct ModelOperation<Schema: SchemaRepresentable>: AnyModelOperation {
	
	var type: OperationType? = nil
	
	var subject: OperationSubject? = nil
	
	var values: [String: AttributeValue?]? = nil
	
	var searchPredicate: Predicate<Schema>? = nil
	
	var overrideTableName: String? = nil
	
	var dependencies: [AnyModelOperation]
	
	var readCountLimit: UInt?
	
	init() {
		self.dependencies = []
	}
	
	init(_ type: OperationType,
		 _ subject: OperationSubject,
		 overrideTableName: String? = nil,
		 values: [String: AttributeValue?]? = nil,
		 predicate: Predicate<Schema>? = nil,
		 dependencies: [Self]? = nil,
		 readCountLimit: UInt? = nil
	) {
		self.type = type
		self.overrideTableName = overrideTableName
		self.subject = subject
		self.values = values
		self.searchPredicate = predicate
		self.dependencies = dependencies ?? []
		self.readCountLimit = readCountLimit
	}
	
	static func createTable(validating schema: ModelSchema, versionNumber: UInt) -> Self {
		var op = Self(.create, .table)
		let values: [String:AttributeValue] = ["modelName": Schema._schemaName.description, "numberOfMigrationsPerformed": Int(versionNumber)]
		op.dependencies = [Self(.create, .row, overrideTableName: "__migrations", values: values)]
		return op
	}
	
	func compile(for configuration: Configuration) -> String {
		var out: String = ""
		
		for dependency in dependencies {
			out = out + dependency.compile(for: configuration)
		}
		
		guard let type = type, let subject = subject else {
			return out
		}
		
		let tableName = overrideTableName ?? Schema._schemaName.description
		switch type {
			case .create:
				switch subject {
					case .table:
						out += "CREATE TABLE \(tableName) ("
						
						let cols = Schema.attributeMetadatas()
						for i in 0..<cols.count {
							let col = cols[i]
							out += "`\(col.name)` \(col.type.sql)"
							
							if !col.nullable {
								out += " NOT NULL"
							}
							
							/// Add comma to every line except the last one (trailing commas are invalid SQL)
							if i < cols.count - 1 {
								out += ","
							}
							
							out += "\n"
						}
						
						out += ");\n"
					case .row:
						guard let values = values else  {
							preconditionFailure("Failed to provide values.")
						}
						let keys = values.keys
						
						out += """
INSERT INTO \(tableName) (\(keys.map { "`\($0)`" }.joined(separator: ", ")))
VALUES (\(keys.map {
	guard let value = values[$0] else {
		preconditionFailure("Schema mismatch!")
	}
	
	guard let stringSQLValue = value?.asSQL else {
		return "NULL"
	}

	return stringSQLValue
}.joined(separator: ", ")));\n
"""
				}
			case .read:
				switch subject {
					case .row:
						if let limit = readCountLimit {
							out += "SELECT * FROM \(tableName) WHERE \(searchPredicate?.compile(for: configuration) ?? "") LIMIT \(limit);\n"
						} else {
							out += "SELECT * FROM \(tableName) WHERE \(searchPredicate?.compile(for: configuration) ?? "");\n"
						}
					case .table:
						if let limit = readCountLimit {
							out += "SELECT * FROM \(tableName) LIMIT \(limit);\n"
						} else {
							out += "SELECT * FROM \(tableName);\n"
						}
				}
			case .update:
				switch subject {
					case .row:
						guard let values = values else  {
							preconditionFailure("Failed to provide values.")
						}
						let keys = values.keys
						
						let setClause = keys.map {
							guard let value = values[$0] else {
								preconditionFailure("Schema mismatch!")
							}
							
							guard let stringSQLValue = value?.asSQL else {
								return "NULL"
							}
							
							return "\($0)=\(stringSQLValue)"
						}.joined(separator: ", ")
						
						out += "UPDATE \(tableName) SET \(setClause) WHERE \(searchPredicate?.compile(for: configuration) ?? "");\n"
						
					case .table:
						// TODO: Implement other operation styles.
						break
				}
			case .delete:
				// TODO: Implement other operation styles.
				out = ""
		}
		
		return out
	}
	
	/// Adds this operation to the configuration's operation buffer to be executed at the next `push`.
	/// - Parameter configuration: The target configuration to perform this operation on.
	@discardableResult public func commit(using configuration: Configuration) -> Transaction<Schema> {
		for i in 0..<configuration.dbs.count {
			/// Check if the migration builder has an pending migration operation,
			/// if so, wrap the appended operation in it. Otherwise, just set this as the db's pending op.
			var resultingOp = self
			
			/// Check if this model has been registered or not.
			/// - If not, then skip generating any migrations.
			let schemaName = Schema._schemaName.description
			if let performedMigrationCount = configuration.dbs[i].latestTableMigrationCountMap[schemaName] {
				let currentBuilder = ModelMigrationBuilder<Schema>(numberOfPerformedMigrations: performedMigrationCount ?? nil)
				if let migration = Schema._migrate(as: currentBuilder) {
					resultingOp.dependencies.append(migration)
					configuration.dbs[i].latestTableMigrationCountMap[schemaName] = (performedMigrationCount ?? 0) + 1
				}
			}
			
			///  Add the operation as a dependency if we have any pending operations. Otherwise, add it as the pending op.
			if var pendingOp = configuration.dbs[i].pendingOperation {
				pendingOp.dependencies.append(resultingOp)
			} else {
				configuration.dbs[i].pendingOperation = resultingOp
			}
		}
		
		return Transaction<Schema>(config: configuration)
	}
}
