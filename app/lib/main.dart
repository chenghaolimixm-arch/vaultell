import 'package:flutter/material.dart';

import 'app.dart';
import 'core/db/app_database.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  await database.policyDao.ensureDefaultProfile();
  // Health insurance was removed from the app; drop any existing records.
  await database.policyDao.removePoliciesOfType('health');
  final activePolicies = await database.policyDao.allActivePolicies();
  await NotificationService.instance.resyncAll(activePolicies);
  runApp(VaultellApp(database: database));
}
