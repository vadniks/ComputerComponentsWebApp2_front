
enum DatabaseTable {
  components(0, 'components', {
    'id' : 0.05,
    'title' : 0.25,
    'type' : 0.1,
    'description' : 0.4,
    'cost' : 0.1,
    'image' : 0.1
  }),
  users(1, 'users', {
    'id' : 0.05,
    'name' : 0.15,
    'role' : 0.1,
    'password' : 0.1,
    'firstName' : 0.15,
    'lastName' : 0.15,
    'phone' : 0.1,
    'address' : 0.1,
    'selection' : 0.1
  }),
  sessions  (2, 'sessions', {
    'id' : 0.5,
    'value' : 0.5
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
