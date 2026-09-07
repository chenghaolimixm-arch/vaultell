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

  test('extracts Youi car schedule: contract period range, vehicle, excess, premium', () {
    const text = r'''
Car Insurance Policy Schedule
Contract Period
17/07/2026 (11:44 AEST) – 16/07/2027 (23:59 AEST)
Insured Car 2025 Tesla Model Y Rear-Wheel Drive Wagon
Registration Number MSX
Insurance Type Comprehensive
Excess
Basic Excess Amount
Windscreen/Glass Claims $1,000
All Other Claims $1,000
Annual Premium Summary
Base Premium $1,443.88
Total Premium $1,731.21
''';
    final data = PolicyDataExtractor.fromText(text, sourceFileName: 'youi.pdf');
    expect(data.expiryDate, DateTime(2027, 7, 16));
    expect(data.subjectName, '2025 Tesla Model Y Rear-Wheel Drive Wagon');
    expect(data.excessCents, 100000);
    expect(data.premiumCents, 173121);
  });

  test('extracts home certificate: period to, sum insured, excess, premium, address', () {
    const text = r'''
Period of insurance:
From: 19 May 2026 (07:21 AM AEST/AEDT)
To: 19 May 2027 (12:01 AM AEST/AEDT)
Insured Address: 3 Banyan Cct,
WELLINGTON POINT QLD 4160
Sum Insured: Building Cover: $820,000.00
Contents Cover: $35,000.00
Basic excess: Building Cover: $1,000.00
Contents Cover: $1,000.00
TOTAL ANNUAL COST: $2,127.95
''';
    final data = PolicyDataExtractor.fromText(text, sourceFileName: 'home.pdf');
    expect(data.expiryDate, DateTime(2027, 5, 19));
    expect(data.sumInsuredCents, 82000000);
    expect(data.excessCents, 100000);
    expect(data.premiumCents, 212795);
    expect(data.subjectName, '3 Banyan Cct');
  });
}
