import 'package:flutter_test/flutter_test.dart';
import 'package:vaultell/core/services/policy_extraction_service.dart';

void main() {
  test('extracts car policy fields from renewal text', () {
    const text = r'''
Allianz Australia
Policy number: ABC-123456789
Annual premium $1,850.00
Excess $650
Renewal date: 15 October 2026
''';
    final data = PolicyDataExtractor.fromText(text, sourceFileName: 'renewal.pdf');
    expect(data.insurerKey, 'allianz');
    expect(data.policyNumber, 'ABC-123456789');
    expect(data.premiumCents, 185000);
    expect(data.excessCents, 65000);
    expect(data.expiryDate, DateTime(2026, 10, 15));
  });

  test('extracts home sum insured and CBA alias', () {
    const text = r'''
CommBank Home Insurance
Sum insured $690,000
Total premium: $2,760.00
Policy No. HME-99999
Expires 21/11/2026
''';
    final data = PolicyDataExtractor.fromText(text, sourceFileName: 'home.pdf');
    expect(data.insurerKey, 'commbank');
    expect(data.sumInsuredCents, 69000000);
    expect(data.premiumCents, 276000);
    expect(data.policyNumber, 'HME-99999');
    expect(data.expiryDate, DateTime(2026, 11, 21));
  });

  test('returns empty result when nothing matches', () {
    const text = 'This is an unrelated document with no insurance details.';
    final data = PolicyDataExtractor.fromText(text, sourceFileName: 'note.txt');
    expect(data.hasAny, isFalse);
    expect(data.insurerKey, isNull);
    expect(data.premiumCents, isNull);
  });
}
