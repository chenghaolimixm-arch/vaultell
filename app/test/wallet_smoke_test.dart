import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultell/core/db/app_database.dart';
import 'package:vaultell/features/wallet/wallet_screen.dart';

void main() {
  testWidgets('wallet screen renders four insurance types', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.policyDao.ensureDefaultProfile();

    await tester.pumpWidget(
      MaterialApp(home: WalletScreen(database: db)),
    );
    // Advance the fake clock so drift's stream debounce timer can fire.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Car Insurance'), findsOneWidget);
    expect(find.text('Home Insurance'), findsOneWidget);
    expect(find.text('Landlord Insurance'), findsOneWidget);
    expect(find.text('Pet Insurance'), findsOneWidget);

    // Closing the database in the test body cancels drift's pending timers.
    await db.close();
  });
}
