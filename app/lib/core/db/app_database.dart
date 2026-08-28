import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'policy_dao.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Profiles, Assets, Policies, Quotes, Documents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'insurance_profile'));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await customStatement('ALTER TABLE policies ADD COLUMN insurer_key TEXT;');
          }
          if (from < 3) {
            // Move any previously entered renewal dates into the expiry date column.
            await customStatement(
              'UPDATE policies SET end_date = renewal_date '
              'WHERE end_date IS NULL AND renewal_date IS NOT NULL;',
            );
          }
        },
      );

  late final PolicyDao policyDao = PolicyDao(this);
}
