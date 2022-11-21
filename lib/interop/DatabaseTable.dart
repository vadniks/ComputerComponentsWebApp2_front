
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
  }),
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
  }),
  sessions  (2, 'sessions', {
    idC : 0.5,
    valueC : 0.5
  });

  const DatabaseTable(this.which, this.table, this.weightedColumns);
  final int which;
  final String table;
  final Map<String, double> weightedColumns;
  static const amount = 3;

  static DatabaseTable create(int which) { switch (which) {
    case 0: return DatabaseTable.components;
    case 1: return DatabaseTable.users;
    case 2: return DatabaseTable.sessions;
    default: throw ArgumentError(null);
  }}

  static List<DatabaseTable> get items => [components, users, sessions];
}
