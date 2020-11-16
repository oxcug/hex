import Foundation

enum MigrationError: Error {
    case multipleLatestModelMigrations,
         noLatestModelMigration,
         duplicateAttributeEntriesForSingleModel
}
