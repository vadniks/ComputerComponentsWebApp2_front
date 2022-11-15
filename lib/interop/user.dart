
import 'DatabaseTable.dart';
import 'placeableInDbTable.dart';

class User implements PlaceableInDbTable {
  final int? id;
  final String name;
  final Role role;
  final String password;
  final String? firstName;
  final String? lastName;
  final int? phone;
  final String? address;
  final String? selection;

  const User({
    this.id,
    required this.name,
    required this.role,
    required this.password,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.selection
  });

  @override
  DatabaseTable get table => DatabaseTable.users;
}

enum Role {
  user(0), admin(1);

  const Role(this.value);
  final int value;
}
