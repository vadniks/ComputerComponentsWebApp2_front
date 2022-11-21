
import 'component.dart';
import 'user.dart';
import 'session.dart';
import 'dart:core';

enum DatabaseTable {
  components(0, 'components', {
    idC : 0.05,
    titleC : 0.25,
    typeC : 0.1,
    descriptionC : 0.4,
    costC : 0.1,
    imageC : 0.1
  }, [true, false, false, false, false, true]),
  users(1, 'users', {
    idC : 0.05,
    nameC : 0.15,
    roleC : 0.1,
    passwordC : 0.1,
    firstNameC : 0.15,
    lastNameC : 0.15,
    phoneC : 0.1,
    addressC : 0.1,
    selectionC : 0.1
  }, [true, false, false, false, true, true, true, true, true]),
  sessions  (2, 'sessions', {
    idC : 0.5,
    valueC : 0.5
  }, [false, false]);

  const DatabaseTable(this.which, this.table, this.weightedColumns, this.nullablesMask);
  final int which;
  final String table;
  final Map<String, double> weightedColumns;
  final List<bool> nullablesMask;
  static const amount = 3;

  static DatabaseTable create(int which) { switch (which) {
    case 0: return DatabaseTable.components;
    case 1: return DatabaseTable.users;
    case 2: return DatabaseTable.sessions;
    default: throw ArgumentError(null);
  }}

  static List<DatabaseTable> get items => [components, users, sessions];
}
