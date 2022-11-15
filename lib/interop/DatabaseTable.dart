
enum DatabaseTable {
  components(0, 'components'),
  users     (1, 'users'),
  sessions  (2, 'sessions');

  const DatabaseTable(this.which, this.table);
  final int which;
  final String table;
  static const amount = 3;

  static DatabaseTable create(int which) { switch (which) {
    case 0: return DatabaseTable.components;
    case 1: return DatabaseTable.users;
    case 2: return DatabaseTable.sessions;
    default: throw ArgumentError(null);
  }}

  static List<DatabaseTable> get items => [components, users, sessions];
}
