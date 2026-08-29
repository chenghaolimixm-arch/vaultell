import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_profile_app/core/db/app_database.dart';
import 'package:insurance_profile_app/core/models/insurance_type.dart';
import 'package:insurance_profile_app/core/services/backup_service.dart';

void main() {
  test('backup round-trips all data into a fresh database', () async {
    final db1 = AppDatabase.forTesting(NativeDatabase.memory());
    await db1.policyDao.ensureDefaultProfile();
    final policy = await db1.policyDao.insertPolicy(
      type: InsuranceType.home,
      insurer: 'AAMI',
      premiumCents: 276000,
      buildingInsuredCents: 69000000,
      contentsInsuredCents: 8000000,
      endDate: DateTime(2026, 11, 21),
      lastYearPremiumCents: 218000,
    );
    await db1.policyDao.addQuote(
      policyId: policy.id,
      insurer: 'Allianz',
      premiumCents: 240000,
      isMock: true,
    );
    await db1.policyDao.addDocument(
      policyId: policy.id,
      kind: 'renewal',
      fileName: 'renewal.pdf',
      localPath: '/tmp/renewal.pdf',
    );

    final json = await BackupService.export(db1);
    await db1.close();

    final db2 = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db2.close);
    final policyCount = await BackupService.restore(db2, json);
    expect(policyCount, 1);

    final policies = await db2.policyDao.allPoliciesForBackup();
    expect(policies.length, 1);
    expect(policies.first.premiumCents, 276000);
    expect(policies.first.buildingInsuredCents, 69000000);
    expect(policies.first.contentsInsuredCents, 8000000);
    expect(policies.first.lastYearPremiumCents, 218000);
    expect(policies.first.endDate, DateTime(2026, 11, 21));

    final quotes = await db2.policyDao.allQuotes();
    expect(quotes.length, 1);
    expect(quotes.first.premiumCents, 240000);

    final docs = await db2.policyDao.allDocuments();
    expect(docs.length, 1);
    expect(docs.first.fileName, 'renewal.pdf');
  });

  test('decode rejects unsupported versions', () {
    expect(
      () => BackupService.decode('{"schemaVersion":99}'),
      throwsFormatException,
    );
  });

  test('delete document removes the record', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.policyDao.ensureDefaultProfile();
    final policy = await db.policyDao.insertPolicy(
      type: InsuranceType.car,
      insurer: 'Allianz',
    );
    await db.policyDao.addDocument(
      policyId: policy.id,
      kind: 'other',
      fileName: 'a.pdf',
      localPath: '/tmp/a.pdf',
    );

    final docs = await db.policyDao.allDocuments();
    expect(docs.length, 1);
    await db.policyDao.deleteDocument(docs.first.id);
    expect(await db.policyDao.allDocuments(), isEmpty);
  });
}
