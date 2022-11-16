
import 'DatabaseTable.dart';
import 'placeableInDbTable.dart';
import 'component.dart';

const valueC = 'value';

class Session implements PlaceableInDbTable {
  final String id;
  final String value;

  const Session(this.id, this.value);

  factory Session.fromJson(Map<String, dynamic> json)
  => Session(json[idC], json[valueC]);

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
