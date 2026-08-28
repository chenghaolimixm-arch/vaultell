import 'package:flutter/material.dart';

import 'app.dart';
import 'core/db/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  await database.policyDao.ensureDefaultProfile();
  runApp(InsuranceProfileApp(database: database));
}
