import 'package:flutter/material.dart';
import 'package:serv_sync/ui/navigation/routes.dart';

class SidebarItemModel {
  final IconData icon;
  final String label;
  final String route;
  final bool newRoute;

  SidebarItemModel({
    required this.icon,
    required this.label,
    required this.route,
    this.newRoute = false,
  });
}

class Data {
  static final List<SidebarItemModel> sidebarItems = [
    SidebarItemModel(icon: Icons.restaurant_menu, label: 'Menu', route: Routes.menu),
    SidebarItemModel(icon: Icons.menu_book_sharp, label: 'Meniul zilei', route: Routes.dailyMenu),
    SidebarItemModel(icon: Icons.menu_book_sharp, label: 'Meniul zilei Overview', route: Routes.dailyMenuOverview, newRoute: true),
  ];
}