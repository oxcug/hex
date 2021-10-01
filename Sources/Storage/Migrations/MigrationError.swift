//
// Copyright © 2021 Benefic Technologies Inc. All rights reserved.
// License Information: https://github.com/oxcug/hex/blob/master/LICENSE

enum MigrationError: Error {
    case mismatchingVersionsCount,
         multipleLatestModelMigrations,
         noLatestModelMigration,
         duplicateAttributeEntriesForSingleModel
}
