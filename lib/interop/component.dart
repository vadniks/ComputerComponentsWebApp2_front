
// ignore_for_file: curly_braces_in_flow_control_structures

import '../util.dart';
import 'DatabaseTable.dart';
import 'placeableInDbTable.dart';

class Component implements PlaceableInDbTable {
  final int? id;
  final String title;
  final Type type;
  final String description;
  final int cost;
  final String? image;

  @override
  DatabaseTable get table => DatabaseTable.components;

  @override
  List<String> get values => [
    id.toString(),
    title,
    type.name,
    description,
    cost.toString(),
    image.value
  ];

  const Component({
    this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.cost,
    this.image
  });

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Component &&
      runtimeType == other.runtimeType &&
      id == other.id &&
      title == other.title &&
      type == other.type &&
      description == other.description &&
      cost == other.cost &&
      image == other.image;

  @override
  int get hashCode =>
    id.hashCode ^
    title.hashCode ^
    type.hashCode ^
    description.hashCode ^
    cost.hashCode ^
    image.hashCode;

  @override
  String toString() => 'Component{'
    'id: $id, '
    'title: $title, '
    'type: $type, '
    'description: $description, '
    'cost: $cost, '
    'image: $image}';
}

enum Type {
  cpu (0, 'Processor', 'pc_cpu'),
  mb  (1, 'Motherboard', 'pc_mb'),
  gpu (2, 'Graphics adapter', 'pc_gpu'),
  ram (3, 'Operating memory', 'pc_ram'),
  hdd (4, 'Hard drive', 'pc_hdd'),
  ssd (5, 'Solid state drive', 'pc_ssd'),
  psu (6, 'Power supply unit', 'pc_psu'),
  fan (7, 'Cooler', 'pc_fan'),
  ca$e(8, 'Case', 'pc_case');

  const Type(this.type, this.title, this.icon);
  final int type;
  final String title;
  final String icon;
  static const amount = 9;

  static Type? create(int type) { switch (type) {
    case 0: return Type.cpu;
    case 1: return Type.mb;
    case 2: return Type.gpu;
    case 3: return Type.ram;
    case 4: return Type.hdd;
    case 5: return Type.ssd;
    case 6: return Type.psu;
    case 7: return Type.fan;
    case 8: return Type.ca$e;
    default: return null;
  } }

  static List<Type> get types => [for (var i = 0; i < amount; i++) create(i)!];
}
