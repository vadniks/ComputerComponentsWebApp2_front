
import 'DatabaseTable.dart';
import 'placeableInDbTable.dart';

class Session implements PlaceableInDbTable {
  final String id;
  final String value;
  const Session(this.id, this.value);

  @override
  DatabaseTable get table => DatabaseTable.sessions;

  @override
  List<String> get values => [id, value];

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Session &&
      runtimeType == other.runtimeType &&
      id == other.id &&
      value == other.value;

  @override
  int get hashCode => id.hashCode ^ value.hashCode;
}
