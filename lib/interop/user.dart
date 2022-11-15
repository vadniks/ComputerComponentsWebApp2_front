
import 'DatabaseTable.dart';
import 'placeableInDbTable.dart';

class User implements PlaceableInDbTable {

  @override
  DatabaseTable get table => DatabaseTable.users;
}
