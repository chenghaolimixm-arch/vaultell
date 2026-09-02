import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaultell/core/db/app_database.dart';
import 'package:vaultell/core/models/additional_insured.dart';
import 'package:vaultell/core/models/insurance_type.dart';
import 'package:vaultell/core/models/policy_comparison.dart';
import 'package:vaultell/core/utils/formatters.dart';

void main() {
  test('premium change computes difference and percentage', () {
    const change = PremiumChange(lastYearCents: 185000, currentCents: 200000);
    expect(change.differenceCents, 15000);
    expect(change.percentChange, closeTo(8.108, 0.001));
  });

  test('premium change with zero last year has no percentage', () {
    const change = PremiumChange(lastYearCents: 0, currentCents: 120000);
    expect(change.hasData, isFalse);
    expect(change.percentChange, isNull);
  });

  test('additional insured JSON round-trips', () {
    const items = [
      AdditionalInsured(name: 'Portable items', cents: 1500000),
      AdditionalInsured(name: 'Keys', cents: 200000),
    ];
    final json = AdditionalInsured.encode(items);
    final decoded = AdditionalInsured.decode(json);
    expect(decoded.length, 2);
    expect(decoded[0].name, 'Portable items');
    expect(decoded[0].cents, 1500000);
    expect(decoded[1].cents, 200000);
  });

  test('money change formatting', () {
    expect(formatMoneyChange(15000), r'+$150.00');
    expect(formatMoneyChange(-5000), r'-$50.00');
  });

  test('policy stores comparison fields round-trip', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.policyDao.ensureDefaultProfile();

    final policy = await db.policyDao.insertPolicy(
      type: InsuranceType.car,
      insurer: 'Allianz',
      premiumCents: 200000,
      roadsideAssist: true,
      windscreenCover: true,
      replacementValueCents: 3500000,
      lastYearPremiumCents: 185000,
      lastYearRoadsideAssist: false,
      lastYearWindscreenCover: false,
      lastYearReplacementValueCents: 3400000,
    );

    expect(policy.roadsideAssist, isTrue);
    expect(policy.windscreenCover, isTrue);
    expect(policy.replacementValueCents, 3500000);
    expect(policy.lastYearPremiumCents, 185000);
    expect(policy.lastYearRoadsideAssist, isFalse);
    expect(policy.lastYearReplacementValueCents, 3400000);
  });
}
