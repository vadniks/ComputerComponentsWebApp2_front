
import 'DatabaseTable.dart';

/*interface*/ class PlaceableInDbTable {
  DatabaseTable get table;
  List<String> get values;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
