import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';

class DailyMenuState {
  final List<MenuItem> menuItems;
  final List<MenuItem> selectedMenuItems;
  DailyMenuState({
    required this.menuItems,
    required this.selectedMenuItems,
  });

  factory DailyMenuState.initial() => DailyMenuState(
    menuItems: [],
    selectedMenuItems: [],
  );
  DailyMenuState copyWith(
      {List<MenuItem>? menuItems,
        List<MenuItem>? selectedMenuItems}) =>
      DailyMenuState(
        menuItems: menuItems ?? this.menuItems,
        selectedMenuItems: selectedMenuItems ?? this.selectedMenuItems,
      );
}
