
enum MigrationError: Error {
    case migrationFailed,
         multipleLatestModelMigrations,
         noLatestModelMigration,
         duplicateAttributeEntriesForSingleModel
}
