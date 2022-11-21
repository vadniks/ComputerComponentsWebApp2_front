
import 'DatabaseTable.dart';

/*interface*/ class PlaceableInDbTable {
  DatabaseTable get table;
  List<String> get values;
  Map<String, dynamic> get asMap;
  dynamic get idProperty;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

extension DefaultMethods on PlaceableInDbTable {

  String get name {
    final name = table.name;
    return name.substring(0, name.length);
  }
}
