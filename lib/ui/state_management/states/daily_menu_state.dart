import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';

class DailyMenuState {
  final List<MenuItem> menuItems;
  final List<MenuItem> selectedMenuItems;
  bool menuNotFound;
  DailyMenuState({
    required this.menuItems,
    required this.selectedMenuItems,
    this.menuNotFound = false,
  });

  factory DailyMenuState.initial() => DailyMenuState(
    menuItems: [],
    selectedMenuItems: [],
  );
  DailyMenuState copyWith(
      {List<MenuItem>? menuItems,
        List<MenuItem>? selectedMenuItems,
      bool? menuNotFound}) =>
      DailyMenuState(
        menuItems: menuItems ?? this.menuItems,
        selectedMenuItems: selectedMenuItems ?? this.selectedMenuItems,
        menuNotFound: menuNotFound ?? false
      );
}
