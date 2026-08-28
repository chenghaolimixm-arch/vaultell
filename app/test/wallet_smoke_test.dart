import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_profile_app/core/db/app_database.dart';
import 'package:insurance_profile_app/core/models/insurance_type.dart';
import 'package:insurance_profile_app/features/wallet/wallet_screen.dart';

void main() {
  testWidgets('wallet screen renders five insurance types', (tester) async {
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
    expect(find.text('Health Insurance'), findsOneWidget);
    expect(find.text('Pet Insurance'), findsOneWidget);

    // Closing the database in the test body cancels drift's pending timers.
    await db.close();
  });

  test('health insurance blocks a second active policy', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.policyDao.ensureDefaultProfile();

    await db.policyDao.insertPolicy(
      type: InsuranceType.health,
      insurer: 'Medibank',
      premiumCents: 120000,
    );

    expect(
      () => db.policyDao.insertPolicy(
        type: InsuranceType.health,
        insurer: 'Bupa',
        premiumCents: 110000,
      ),
      throwsStateError,
    );
  });
}
