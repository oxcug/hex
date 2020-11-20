
enum MigrationError: Error {
    case mismatchingVersionsCount,
         multipleLatestModelMigrations,
         noLatestModelMigration,
         duplicateAttributeEntriesForSingleModel
}
