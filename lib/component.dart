
class Component {
  final int? id;
  final String title;
  final Type type;
  final String description;
  final int cost;
  final String? image;

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
  cpu (0, "Processor"),
  mb  (1, "Motherboard"),
  gpu (2, "Graphics adapter"),
  ram (3, "Operating memory"),
  hdd (4, "Hard drive"),
  ssd (5, "Solid state drive"),
  psu (6, "Power supply unit"),
  fan (7, "Cooler"),
  ca$e(8, "Case");

  const Type(this.type, this.title);
  final int type;
  final String title;

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
}
