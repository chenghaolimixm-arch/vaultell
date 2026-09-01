import 'package:flutter/material.dart';

import 'app.dart';
import 'core/db/app_database.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  await database.policyDao.ensureDefaultProfile();
  final activePolicies = await database.policyDao.allActivePolicies();
  await NotificationService.instance.resyncAll(activePolicies);
  runApp(VaultellApp(database: database));
}
