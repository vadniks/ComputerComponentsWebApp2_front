
import 'DatabaseTable.dart';

/*interface*/ class PlaceableInDbTable {
  DatabaseTable get table;
  List<String> get values;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

extension DefaultMethods on PlaceableInDbTable {
  MapEntry<String, double> operator [](String weightedColumnsKey)
  => table.weightedColumns.entries.firstWhere((element) => element.key == weightedColumnsKey);
}
