import 'dart:convert';

import '../db/app_database.dart';

/// Local backup/restore of all structured data as a JSON file.
///
/// Document binaries are not embedded; file records (name/path metadata) are
/// included so a restore keeps the history. Files themselves can be re-added.
class BackupData {
  const BackupData({
    required this.profiles,
    required this.assets,
    required this.policies,
    required this.quotes,
    required this.documents,
  });

  final List<Profile> profiles;
  final List<Asset> assets;
  final List<Policy> policies;
  final List<Quote> quotes;
  final List<Document> documents;
}

class BackupService {
  BackupService._();

  static const int schemaVersion = 1;

  static String encode({
    required List<Profile> profiles,
    required List<Asset> assets,
    required List<Policy> policies,
    required List<Quote> quotes,
    required List<Document> documents,
  }) {
    return jsonEncode({
      'schemaVersion': schemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'profiles': profiles.map((e) => e.toJson()).toList(),
      'assets': assets.map((e) => e.toJson()).toList(),
      'policies': policies.map((e) => e.toJson()).toList(),
      'quotes': quotes.map((e) => e.toJson()).toList(),
      'documents': documents.map((e) => e.toJson()).toList(),
    });
  }

  static BackupData decode(String source) {
    final json = jsonDecode(source);
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid backup file');
    }
    final version = json['schemaVersion'];
    if (version != schemaVersion) {
      throw FormatException('Unsupported backup version: $version');
    }
    List<T> list<T>(String key, T Function(Map<String, dynamic>) fromJson) =>
        (json[key] as List<dynamic>? ?? const [])
            .map((e) => fromJson(e as Map<String, dynamic>))
            .toList();

    return BackupData(
      profiles: list('profiles', Profile.fromJson),
      assets: list('assets', Asset.fromJson),
      policies: list('policies', Policy.fromJson),
      quotes: list('quotes', Quote.fromJson),
      documents: list('documents', Document.fromJson),
    );
  }

  static Future<String> export(AppDatabase db) async {
    final dao = db.policyDao;
    return encode(
      profiles: await dao.allProfiles(),
      assets: await dao.allAssets(),
      policies: await dao.allPoliciesForBackup(),
      quotes: await dao.allQuotes(),
      documents: await dao.allDocuments(),
    );
  }

  /// Replaces all local data with the backup content. Returns restored
  /// policy count (useful for a confirmation message).
  static Future<int> restore(AppDatabase db, String source) async {
    final data = decode(source);
    await db.policyDao.restoreAll(
      profiles: data.profiles,
      assets: data.assets,
      policies: data.policies,
      quotes: data.quotes,
      documents: data.documents,
    );
    return data.policies.length;
  }
}
