import 'dart:convert';

/// An extra insured amount on home/landlord policies, e.g.
/// "Portable items $15,000" or "Replacement of keys $2,000".
class AdditionalInsured {
  const AdditionalInsured({required this.name, required this.cents});

  final String name;
  final int cents;

  Map<String, dynamic> toJson() => {'name': name, 'cents': cents};

  factory AdditionalInsured.fromJson(Map<String, dynamic> json) => AdditionalInsured(
        name: json['name'] as String? ?? '',
        cents: json['cents'] as int? ?? 0,
      );

  static List<AdditionalInsured> decode(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>? ?? const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(AdditionalInsured.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  static String encode(List<AdditionalInsured> items) =>
      jsonEncode(items.map((e) => e.toJson()).toList());
}
