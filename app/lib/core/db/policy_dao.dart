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

  Future<List<Policy>> allActivePolicies() =>
      (select(policies)..where((t) => t.status.equals('active'))).get();

  Future<List<Profile>> allProfiles() => select(profiles).get();

  Future<List<Asset>> allAssets() => select(assets).get();

  Future<List<Policy>> allPoliciesForBackup() => select(policies).get();

  Future<List<Quote>> allQuotes() => select(quotes).get();

  Future<List<Document>> allDocuments() => select(documents).get();

  /// Inserts a policy.
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
    bool roadsideAssist = false,
    bool windscreenCover = false,
    int replacementValueCents = 0,
    int buildingInsuredCents = 0,
    int contentsInsuredCents = 0,
    String additionalInsuredJson = '[]',
    int lastYearPremiumCents = 0,
    bool lastYearRoadsideAssist = false,
    bool lastYearWindscreenCover = false,
    int lastYearReplacementValueCents = 0,
    int lastYearBuildingInsuredCents = 0,
    int lastYearContentsInsuredCents = 0,
    String lastYearAdditionalInsuredJson = '[]',
  }) async {
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
      roadsideAssist: Value(roadsideAssist),
      windscreenCover: Value(windscreenCover),
      replacementValueCents: Value(replacementValueCents),
      buildingInsuredCents: Value(buildingInsuredCents),
      contentsInsuredCents: Value(contentsInsuredCents),
      additionalInsuredJson: Value(additionalInsuredJson),
      lastYearPremiumCents: Value(lastYearPremiumCents),
      lastYearRoadsideAssist: Value(lastYearRoadsideAssist),
      lastYearWindscreenCover: Value(lastYearWindscreenCover),
      lastYearReplacementValueCents: Value(lastYearReplacementValueCents),
      lastYearBuildingInsuredCents: Value(lastYearBuildingInsuredCents),
      lastYearContentsInsuredCents: Value(lastYearContentsInsuredCents),
      lastYearAdditionalInsuredJson: Value(lastYearAdditionalInsuredJson),
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
    bool roadsideAssist = false,
    bool windscreenCover = false,
    int replacementValueCents = 0,
    int buildingInsuredCents = 0,
    int contentsInsuredCents = 0,
    String additionalInsuredJson = '[]',
    int lastYearPremiumCents = 0,
    bool lastYearRoadsideAssist = false,
    bool lastYearWindscreenCover = false,
    int lastYearReplacementValueCents = 0,
    int lastYearBuildingInsuredCents = 0,
    int lastYearContentsInsuredCents = 0,
    String lastYearAdditionalInsuredJson = '[]',
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
      roadsideAssist: Value(roadsideAssist),
      windscreenCover: Value(windscreenCover),
      replacementValueCents: Value(replacementValueCents),
      buildingInsuredCents: Value(buildingInsuredCents),
      contentsInsuredCents: Value(contentsInsuredCents),
      additionalInsuredJson: Value(additionalInsuredJson),
      lastYearPremiumCents: Value(lastYearPremiumCents),
      lastYearRoadsideAssist: Value(lastYearRoadsideAssist),
      lastYearWindscreenCover: Value(lastYearWindscreenCover),
      lastYearReplacementValueCents: Value(lastYearReplacementValueCents),
      lastYearBuildingInsuredCents: Value(lastYearBuildingInsuredCents),
      lastYearContentsInsuredCents: Value(lastYearContentsInsuredCents),
      lastYearAdditionalInsuredJson: Value(lastYearAdditionalInsuredJson),
    ));
  }

  Future<void> deletePolicy(int id) async {
    await (delete(policies)..where((t) => t.id.equals(id))).go();
  }

  Future<void> removePoliciesOfType(String insuranceType) async {
    await (delete(policies)..where((t) => t.insuranceType.equals(insuranceType))).go();
  }

  Future<void> deleteDocument(int id) async {
    await (delete(documents)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteAllData() async {
    await delete(documents).go();
    await delete(quotes).go();
    await delete(policies).go();
    await delete(assets).go();
    await delete(profiles).go();
  }

  /// Replaces all local data with the given rows, preserving original IDs so
  /// foreign keys stay consistent. Used by backup restore.
  Future<void> restoreAll({
    required List<Profile> profiles,
    required List<Asset> assets,
    required List<Policy> policies,
    required List<Quote> quotes,
    required List<Document> documents,
  }) async {
    await transaction(() async {
      await deleteAllData();
      await batch((b) {
        b.insertAll(
          this.profiles,
          profiles.map(
            (p) => ProfilesCompanion.insert(
              id: Value(p.id),
              displayName: Value(p.displayName),
              createdAt: Value(p.createdAt),
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
        b.insertAll(
          this.assets,
          assets.map(
            (a) => AssetsCompanion.insert(
              id: Value(a.id),
              profileId: a.profileId,
              type: a.type,
              name: a.name,
              detailsJson: Value(a.detailsJson),
              createdAt: Value(a.createdAt),
              updatedAt: Value(a.updatedAt),
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
        b.insertAll(
          this.policies,
          policies.map(
            (p) => PoliciesCompanion.insert(
              id: Value(p.id),
              profileId: p.profileId,
              assetId: Value(p.assetId),
              insuranceType: p.insuranceType,
              insurer: p.insurer,
              insurerKey: Value(p.insurerKey),
              policyNumber: Value(p.policyNumber),
              policyType: Value(p.policyType),
              premiumCents: Value(p.premiumCents),
              excessCents: Value(p.excessCents),
              sumInsuredCents: Value(p.sumInsuredCents),
              roadsideAssist: Value(p.roadsideAssist),
              windscreenCover: Value(p.windscreenCover),
              replacementValueCents: Value(p.replacementValueCents),
              buildingInsuredCents: Value(p.buildingInsuredCents),
              contentsInsuredCents: Value(p.contentsInsuredCents),
              additionalInsuredJson: Value(p.additionalInsuredJson),
              lastYearPremiumCents: Value(p.lastYearPremiumCents),
              lastYearRoadsideAssist: Value(p.lastYearRoadsideAssist),
              lastYearWindscreenCover: Value(p.lastYearWindscreenCover),
              lastYearReplacementValueCents: Value(p.lastYearReplacementValueCents),
              lastYearBuildingInsuredCents: Value(p.lastYearBuildingInsuredCents),
              lastYearContentsInsuredCents: Value(p.lastYearContentsInsuredCents),
              lastYearAdditionalInsuredJson: Value(p.lastYearAdditionalInsuredJson),
              startDate: Value(p.startDate),
              endDate: Value(p.endDate),
              renewalDate: Value(p.renewalDate),
              status: Value(p.status),
              notes: Value(p.notes),
              createdAt: Value(p.createdAt),
              updatedAt: Value(p.updatedAt),
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
        b.insertAll(
          this.quotes,
          quotes.map(
            (q) => QuotesCompanion.insert(
              id: Value(q.id),
              policyId: q.policyId,
              insurer: q.insurer,
              premiumCents: Value(q.premiumCents),
              excessCents: Value(q.excessCents),
              sumInsuredCents: Value(q.sumInsuredCents),
              coverSummary: Value(q.coverSummary),
              isMock: Value(q.isMock),
              sourceFile: Value(q.sourceFile),
              createdAt: Value(q.createdAt),
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
        b.insertAll(
          this.documents,
          documents.map(
            (d) => DocumentsCompanion.insert(
              id: Value(d.id),
              policyId: d.policyId,
              kind: Value(d.kind),
              fileName: d.fileName,
              localPath: d.localPath,
              extractedJson: Value(d.extractedJson),
              createdAt: Value(d.createdAt),
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
      });
    });
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
