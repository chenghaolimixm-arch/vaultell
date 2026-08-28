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
  int get schemaVersion => 1;

  late final PolicyDao policyDao = PolicyDao(this);
}
