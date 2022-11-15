
import 'DatabaseTable.dart';

/*interface*/ class PlaceableInDbTable {
  DatabaseTable get table;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

extension DefaultMethods on PlaceableInDbTable {
  MapEntry<String, double> operator [](int index) => table.weightedColumns.entries.elementAt(index);
}
