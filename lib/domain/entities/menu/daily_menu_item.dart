import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';

class DailyMenuItem {
  final String menuName;
  final double price;
  final String dailyMenuName;
  final MenuItem menu;
  final int menuType;

  DailyMenuItem({
    required this.menuName,
    required this.price,
    required this.dailyMenuName,
    required this.menu,
    required this.menuType,
  });

  factory DailyMenuItem.fromJson(Map<String, dynamic> json) {
    return DailyMenuItem(
      menuName: json['menuName'],
      price: (json['price'] as num).toDouble(),
      dailyMenuName: json['dailyMenuName'],
      menu: MenuItem.fromJson(json['menu']),
      menuType: json['menuType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuName': menuName,
      'price': price,
      'dailyMenuName': dailyMenuName,
      'menu': menu.toJson(),
      'menuType': menuType,
    };
  }
}