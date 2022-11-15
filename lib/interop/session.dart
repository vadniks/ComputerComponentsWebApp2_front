
import 'DatabaseTable.dart';
import 'placeableInDbTable.dart';

class Session implements PlaceableInDbTable {
  final String id;
  final String value;
  const Session(this.id, this.value);

  @override
  DatabaseTable get table => DatabaseTable.sessions;
}
