import 'package:flutter/material.dart';

import 'core/db/app_database.dart';
import 'core/theme/app_theme.dart';
import 'features/wallet/wallet_screen.dart';

class InsuranceProfileApp extends StatelessWidget {
  const InsuranceProfileApp({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance Profile',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: WalletScreen(database: database),
    );
  }
}
