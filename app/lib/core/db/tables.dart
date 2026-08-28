import 'package:drift/drift.dart';

/// Local profile (single user on this device; no cloud account in MVP).
class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get displayName => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Insurance subjects: a car, a property or a pet a policy is attached to.
class Assets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get type => text()(); // car | property | pet
  TextColumn get name => text()();
  TextColumn get detailsJson => text().withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Policies across the five insurance types. All types except health allow
/// multiple active policies per user.
class Policies extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  IntColumn get assetId => integer().nullable().references(Assets, #id)();
  TextColumn get insuranceType => text()(); // car | home | landlord | health | pet
  TextColumn get insurer => text()();
  TextColumn get insurerKey => text().nullable()(); // key in InsurerCatalog; null for custom insurers
  TextColumn get policyNumber => text().withDefault(const Constant(''))();
  TextColumn get policyType => text().withDefault(const Constant(''))();
  IntColumn get premiumCents => integer().withDefault(const Constant(0))();
  IntColumn get excessCents => integer().withDefault(const Constant(0))();
  IntColumn get sumInsuredCents => integer().withDefault(const Constant(0))();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()(); // policy expiry date
  DateTimeColumn get renewalDate => dateTime().nullable()(); // legacy, unused by UI
  TextColumn get status => text().withDefault(const Constant('active'))(); // active | cancelled | expired
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Quotes compared against a policy. MVP quotes are mock data (is_mock = true)
/// and must always be labelled as examples, never as real insurer quotes.
class Quotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get policyId => integer().references(Policies, #id)();
  TextColumn get insurer => text()();
  IntColumn get premiumCents => integer().withDefault(const Constant(0))();
  IntColumn get excessCents => integer().withDefault(const Constant(0))();
  IntColumn get sumInsuredCents => integer().withDefault(const Constant(0))();
  TextColumn get coverSummary => text().withDefault(const Constant(''))();
  BoolColumn get isMock => boolean().withDefault(const Constant(true))();
  TextColumn get sourceFile => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Locally stored policy documents (renewal notice, previous policy, quote PDF
/// or screenshot). Extracted fields are kept in extracted_json with the source
/// file path so the extraction is auditable.
class Documents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get policyId => integer().references(Policies, #id)();
  TextColumn get kind => text().withDefault(const Constant('other'))(); // renewal | previous | quote | other
  TextColumn get fileName => text()();
  TextColumn get localPath => text()();
  TextColumn get extractedJson => text().withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
