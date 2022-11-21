
import '../util.dart';
import 'DatabaseTable.dart';
import 'placeableInDbTable.dart';
import 'component.dart';

const nameC = 'name',
  roleC = 'role',
  passwordC = 'password',
  firstNameC = 'firstName',
  lastNameC = 'lastName',
  phoneC = 'phone',
  addressC = 'address',
  selectionC = 'selection';

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

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json[idC],
    name: json[nameC],
    role: Role.create(json[roleC]),
    password: json[passwordC],
    firstName: json[firstNameC],
    lastName: json[lastNameC],
    phone: json[phoneC],
    address: json[addressC],
    selection: json[selectionC]
  );

  @override
  DatabaseTable get table => DatabaseTable.users;

  @override
  List<String> get values => [
    id.toString(),
    name,
    role.name,
    password,
    firstName.value,
    lastName.value,
    phone.toString(),
    address.value,
    selection.value
  ];

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is User &&
      runtimeType == other.runtimeType &&
      id == other.id &&
      name == other.name &&
      role == other.role &&
      password == other.password &&
      firstName == other.firstName &&
      lastName == other.lastName &&
      phone == other.phone &&
      address == other.address &&
      selection == other.selection;

  @override
  int get hashCode =>
    id.hashCode ^
    name.hashCode ^
    role.hashCode ^
    password.hashCode ^
    firstName.hashCode ^
    lastName.hashCode ^
    phone.hashCode ^
    address.hashCode ^
    selection.hashCode;

  @override
  get idProperty => id;

  @override
  Map<String, dynamic> get asMap => {
    idC : id,
    nameC : name,
    roleC : role.name.toUpperCase(),
    passwordC : password,
    firstNameC : firstName,
    lastNameC : lastName,
    phoneC : phone,
    addressC : address,
    selectionC : selection
  };
}

enum Role {
  user(0), admin(1);

  const Role(this.value);
  final int value;

  static Role create(String capitalized) { switch (capitalized) {
    case 'USER': return user;
    case 'ADMIN': return admin;
    default: throw ArgumentError(null);
  } }
}
