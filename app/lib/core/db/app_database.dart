import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'policy_dao.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Profiles, Assets, Policies, Quotes, Documents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'vaultell'));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 4;

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
          if (from < 4) {
            await customStatement('ALTER TABLE policies ADD COLUMN roadside_assist INTEGER NOT NULL DEFAULT 0;');
            await customStatement('ALTER TABLE policies ADD COLUMN windscreen_cover INTEGER NOT NULL DEFAULT 0;');
            await customStatement('ALTER TABLE policies ADD COLUMN replacement_value_cents INTEGER NOT NULL DEFAULT 0;');
            await customStatement('ALTER TABLE policies ADD COLUMN building_insured_cents INTEGER NOT NULL DEFAULT 0;');
            await customStatement('ALTER TABLE policies ADD COLUMN contents_insured_cents INTEGER NOT NULL DEFAULT 0;');
            await customStatement('ALTER TABLE policies ADD COLUMN additional_insured_json TEXT NOT NULL DEFAULT \'[]\';');
            await customStatement('ALTER TABLE policies ADD COLUMN last_year_premium_cents INTEGER NOT NULL DEFAULT 0;');
            await customStatement('ALTER TABLE policies ADD COLUMN last_year_roadside_assist INTEGER NOT NULL DEFAULT 0;');
            await customStatement('ALTER TABLE policies ADD COLUMN last_year_windscreen_cover INTEGER NOT NULL DEFAULT 0;');
            await customStatement('ALTER TABLE policies ADD COLUMN last_year_replacement_value_cents INTEGER NOT NULL DEFAULT 0;');
            await customStatement('ALTER TABLE policies ADD COLUMN last_year_building_insured_cents INTEGER NOT NULL DEFAULT 0;');
            await customStatement('ALTER TABLE policies ADD COLUMN last_year_contents_insured_cents INTEGER NOT NULL DEFAULT 0;');
            await customStatement('ALTER TABLE policies ADD COLUMN last_year_additional_insured_json TEXT NOT NULL DEFAULT \'[]\';');
          }
        },
      );

  late final PolicyDao policyDao = PolicyDao(this);
}
