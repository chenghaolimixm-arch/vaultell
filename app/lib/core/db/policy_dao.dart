import 'package:drift/drift.dart';

import '../models/insurance_type.dart';
import 'app_database.dart';
import 'tables.dart';

part 'policy_dao.g.dart';

@DriftAccessor(tables: [Profiles, Assets, Policies, Quotes, Documents])
class PolicyDao extends DatabaseAccessor<AppDatabase> with _$PolicyDaoMixin {
  PolicyDao(super.db);

  // ---- Profile ------------------------------------------------------------

  Future<int> ensureDefaultProfile() async {
    final existing = await (select(profiles)..limit(1)).get();
    if (existing.isNotEmpty) return existing.first.id;
    return into(profiles).insert(ProfilesCompanion.insert());
  }

  // ---- Policies -----------------------------------------------------------

  Stream<List<Policy>> watchAllPolicies() => (select(policies)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();

  Stream<List<Policy>> watchPoliciesByType(InsuranceType type) => (select(policies)
        ..where((t) => t.insuranceType.equals(type.name))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();

  Stream<Policy?> watchPolicy(int id) =>
      (select(policies)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<List<Policy>> activePoliciesOfType(InsuranceType type) =>
      (select(policies)
            ..where(
              (t) => t.insuranceType.equals(type.name) & t.status.equals('active'),
            ))
          .get();

  /// Inserts a policy, enforcing the "one active health policy" rule.
  Future<Policy> insertPolicy({
    required InsuranceType type,
    required String insurer,
    String? insurerKey,
    String policyNumber = '',
    String policyType = '',
    int premiumCents = 0,
    int excessCents = 0,
    int sumInsuredCents = 0,
    DateTime? endDate,
    String status = 'active',
    String notes = '',
    String? assetName,
  }) async {
    if (type == InsuranceType.health && status == 'active') {
      final existing = await activePoliciesOfType(type);
      if (existing.isNotEmpty) {
        throw StateError('健康险只能保存一份有效保单。');
      }
    }

    final profileId = await ensureDefaultProfile();
    int? assetId;
    if (type.subjectType != null && assetName != null && assetName.trim().isNotEmpty) {
      assetId = await into(assets).insert(AssetsCompanion.insert(
        profileId: profileId,
        type: type.subjectType!,
        name: assetName.trim(),
      ));
    }

    final id = await into(policies).insert(PoliciesCompanion.insert(
      profileId: profileId,
      assetId: Value(assetId),
      insuranceType: type.name,
      insurer: insurer,
      insurerKey: Value(insurerKey),
      policyNumber: Value(policyNumber),
      policyType: Value(policyType),
      premiumCents: Value(premiumCents),
      excessCents: Value(excessCents),
      sumInsuredCents: Value(sumInsuredCents),
      endDate: Value(endDate),
      status: Value(status),
      notes: Value(notes),
    ));

    return (select(policies)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> updatePolicy(
    int id, {
    required String insurer,
    String? insurerKey,
    String policyNumber = '',
    String policyType = '',
    int premiumCents = 0,
    int excessCents = 0,
    int sumInsuredCents = 0,
    DateTime? endDate,
    String status = 'active',
    String notes = '',
  }) async {
    await (update(policies)..where((t) => t.id.equals(id))).write(PoliciesCompanion(
      insurer: Value(insurer),
      insurerKey: Value(insurerKey),
      policyNumber: Value(policyNumber),
      policyType: Value(policyType),
      premiumCents: Value(premiumCents),
      excessCents: Value(excessCents),
      sumInsuredCents: Value(sumInsuredCents),
      endDate: Value(endDate),
      status: Value(status),
      notes: Value(notes),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> deletePolicy(int id) async {
    await (delete(policies)..where((t) => t.id.equals(id))).go();
  }

  // ---- Quotes -------------------------------------------------------------

  Stream<List<Quote>> watchQuotesForPolicy(int policyId) => (select(quotes)
        ..where((t) => t.policyId.equals(policyId))
        ..orderBy([(t) => OrderingTerm.asc(t.premiumCents)]))
      .watch();

  Future<void> addQuote({
    required int policyId,
    required String insurer,
    int premiumCents = 0,
    int excessCents = 0,
    int sumInsuredCents = 0,
    String coverSummary = '',
    bool isMock = true,
  }) async {
    await into(quotes).insert(QuotesCompanion.insert(
      policyId: policyId,
      insurer: insurer,
      premiumCents: Value(premiumCents),
      excessCents: Value(excessCents),
      sumInsuredCents: Value(sumInsuredCents),
      coverSummary: Value(coverSummary),
      isMock: Value(isMock),
    ));
  }

  // ---- Documents ----------------------------------------------------------

  Stream<List<Document>> watchDocumentsForPolicy(int policyId) => (select(documents)
        ..where((t) => t.policyId.equals(policyId))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();

  Future<void> addDocument({
    required int policyId,
    required String kind,
    required String fileName,
    required String localPath,
  }) async {
    await into(documents).insert(DocumentsCompanion.insert(
      policyId: policyId,
      kind: Value(kind),
      fileName: fileName,
      localPath: localPath,
    ));
  }
}
