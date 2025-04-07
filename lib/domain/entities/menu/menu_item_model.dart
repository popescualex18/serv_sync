import 'package:serv_sync/main.dart';

class BaseEntity {
  final String? id;
  BaseEntity({this.id});
}

class MenuItem extends BaseEntity {
  final String name;
  final double price;
  final int categoryId;
  final bool hasBread;
  final bool hasPolenta;
  final List<int> categories;

  MenuItem({
    super.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.hasBread,
    required this.hasPolenta,
    required this.categories,
  });
  static const idFieldKey = 'id';
  // Convert JSON to Model
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      categoryId: json['categoryId'],
      hasBread: json['hasBread'],
      hasPolenta: json['hasPolenta'],
      categories:
          (json['categories'] as List?)?.map((e) => e as int).toList() ?? [],
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "categoryId": categoryId,
      "hasBread": hasBread,
      "hasPolenta": hasPolenta,
      "categories": categories,
    };
  }

  // CopyWith method to create a modified copy of the object
  MenuItem copyWith({
    String? id,
    String? name,
    double? price,
    int? categoryId,
    bool? hasBread,
    bool? hasPolenta,
    List<int>? categories,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      hasBread: hasBread ?? this.hasBread,
      hasPolenta: hasPolenta ?? this.hasPolenta,
      categories: categories ?? this.categories,
    );
  }

  factory MenuItem.empty() => MenuItem(
        id: uuid.v4(),
        name: "",
        price: 0.0,
        categoryId: 1,
        hasBread: false,
        hasPolenta: false,
        categories: [],
      );
}
