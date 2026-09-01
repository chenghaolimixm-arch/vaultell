import 'package:flutter/material.dart';

import 'core/db/app_database.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/app_lock_gate.dart';
import 'features/wallet/wallet_screen.dart';

class VaultellApp extends StatelessWidget {
  const VaultellApp({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vaultell',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: AppLockGate(child: WalletScreen(database: database)),
    );
  }
}
