
// ignore_for_file: curly_braces_in_flow_control_structures

import '../util.dart';
import 'DatabaseTable.dart';
import 'placeableInDbTable.dart';

const idC = 'id',
  titleC = 'title',
  typeC = 'type',
  descriptionC = 'description',
  costC = 'cost',
  imageC = 'image';

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

  factory Component.fromJson(Map<String, dynamic> json) => Component(
    id: json[idC],
    title: json[titleC],
    type: Type.create2(json[typeC])!,
    description: json[descriptionC],
    cost: json[costC],
    image: json[imageC]
  );

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
  cpu (0, 'Processor', 'pc_cpu', 'CPU'),
  mb  (1, 'Motherboard', 'pc_mb', 'MB'),
  gpu (2, 'Graphics adapter', 'pc_gpu', 'GPU'),
  ram (3, 'Operating memory', 'pc_ram', 'RAM'),
  hdd (4, 'Hard drive', 'pc_hdd', 'HDD'),
  ssd (5, 'Solid state drive', 'pc_ssd', 'SSD'),
  psu (6, 'Power supply unit', 'pc_psu', 'PSU'),
  fan (7, 'Cooler', 'pc_fan', 'FAN'),
  ca$e(8, 'Case', 'pc_case', 'CASE');

  const Type(this.type, this.title, this.icon, this.value);
  final int type;
  final String title;
  final String icon;
  final String value;
  static const amount = 9;

  static Type? create(int type) { switch (type) {
    case 0: return cpu;
    case 1: return mb;
    case 2: return gpu;
    case 3: return ram;
    case 4: return hdd;
    case 5: return ssd;
    case 6: return psu;
    case 7: return fan;
    case 8: return ca$e;
    default: return null;
  } }

  static Type? create2(String value) { switch (value) {
    case 'CPU': return cpu;
    case 'MB': return mb;
    case 'GPU': return gpu;
    case 'RAM': return ram;
    case 'HDD': return hdd;
    case 'SSD': return ssd;
    case 'PSU': return psu;
    case 'FAN': return fan;
    case 'CASE': return ca$e;
    default: return null;
  } }

  static List<Type> get types => [for (var i = 0; i < amount; i++) create(i)!];
}

class Selection {
  int? cpu, mb, gpu, ram, hdd, ssd, psu, fan, ca$e;

  static const cpuC = 'cpu', mbC = 'mb', gpuC = 'gpu', ramC = 'ram',
      hddC = 'hdd', ssdC = 'ssd', psuC = 'psu', fanC = 'fan', caseC = 'case';

  Selection({cpu, mb, gpu, ram, hdd, ssd, psu, fan, ca$e});

  factory Selection.fromJson(Map<String, dynamic> json) => Selection(
    cpu: json[cpuC],
    mb: json[mbC],
    gpu: json[gpuC],
    ram: json[ramC],
    hdd: json[hddC],
    ssd: json[ssdC],
    psu: json[psuC],
    fan: json[fanC],
    ca$e: json[caseC]
  );
}
