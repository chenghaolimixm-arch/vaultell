// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_dao.dart';

// ignore_for_file: type=lint
mixin _$PolicyDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProfilesTable get profiles => attachedDatabase.profiles;
  $AssetsTable get assets => attachedDatabase.assets;
  $PoliciesTable get policies => attachedDatabase.policies;
  $QuotesTable get quotes => attachedDatabase.quotes;
  $DocumentsTable get documents => attachedDatabase.documents;
  PolicyDaoManager get managers => PolicyDaoManager(this);
}

class PolicyDaoManager {
  final _$PolicyDaoMixin _db;
  PolicyDaoManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db.attachedDatabase, _db.profiles);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db.attachedDatabase, _db.assets);
  $$PoliciesTableTableManager get policies =>
      $$PoliciesTableTableManager(_db.attachedDatabase, _db.policies);
  $$QuotesTableTableManager get quotes =>
      $$QuotesTableTableManager(_db.attachedDatabase, _db.quotes);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db.attachedDatabase, _db.documents);
}
