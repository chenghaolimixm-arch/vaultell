import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_profile_app/core/models/insurance_type.dart';
import 'package:insurance_profile_app/core/models/insurer_catalog.dart';

void main() {
  test('catalog resolves claim URL per insurance type with fallback', () {
    final commbank = InsurerCatalog.byKey('commbank')!;
    expect(commbank.claimUrlFor(InsuranceType.car), contains('car-insurance'));
    expect(commbank.claimUrlFor(InsuranceType.home), contains('home-insurance'));

    // RACV has no per-type override: falls back to the default claim page.
    final racv = InsurerCatalog.byKey('racv')!;
    expect(racv.claimUrlFor(InsuranceType.car), racv.defaultClaimUrl);
  });

  test('catalog lookup by name is case-insensitive', () {
    expect(InsurerCatalog.byName('allianz')?.key, 'allianz');
    expect(InsurerCatalog.byName(' ALLIANZ ')?.key, 'allianz');
    expect(InsurerCatalog.byName('Not An Insurer'), isNull);
  });

  test('every catalog entry has a valid http(s) claim URL', () {
    for (final entry in InsurerCatalog.all) {
      final uri = Uri.tryParse(entry.defaultClaimUrl);
      expect(uri, isNotNull, reason: entry.name);
      expect(uri!.scheme, anyOf('http', 'https'), reason: entry.name);
    }
  });
}
