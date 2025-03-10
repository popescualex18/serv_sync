import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/domain/data_access/daily_menu_data_access.dart';
import 'package:serv_sync/domain/data_access/menu_data_access.dart';
import 'package:serv_sync/domain/entities/menu/daily_menu_components.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/ui/state_management/cubits/app_cubit.dart';
import 'package:serv_sync/ui/state_management/states/daily_menu_state.dart';

class DailyMenuCubit extends Cubit<DailyMenuState> {
  final AppCubit _cubit;
  final List<MenuItem> menus = [];

  Map<int, List<MenuItem>> dailyDefinitions = {
    0: [],
    1: [],
    2: [],
    3: [],
    4: [],
    5: [],
    6: [],
  };
  int categoryIndex = 0;
  Map<int, String> categories = {
    0: 'Meniul zilei',
    1: 'Meniu la alegere',
    2: 'Ciorbe/Supe',
    3: 'Garnituri',
    4: 'Salate',
    5: 'Pui&Porc',
    6: 'Diverse'
  };

  final DailyMenuDataAccess _dailyMenuDataAccess = DailyMenuDataAccess();
  final MenuDataAccess _menuDataAccess = MenuDataAccess();

  DailyMenuCubit(this._cubit) : super(DailyMenuState.initial());

  Future<void> save() async {
    await _cubit.guard(
      Future(
        () async {
          var dailyMenu = DailyMenuComponents(
            menuIds: state.selectedMenuItems.map((item) => item.id!).toList(),
            menuType: categoryIndex,
          );
          await _dailyMenuDataAccess.addDailyMenu(dailyMenu);
        },
      ),
    );
  }

  Future fetchData() async {
    await _cubit.guard(
      onEnd: () {
        var selectedCategoryMenuItems = dailyDefinitions[categoryIndex]!;
        var menuItems = filteredMenus(selectedCategoryMenuItems);
        emit(
          state.copyWith(
            menuItems: menuItems,
            selectedMenuItems: selectedCategoryMenuItems,
          ),
        );
      },
      Future(
        () async {
          var allMenus = await _menuDataAccess.fetchMenus();
          menus.addAll(allMenus);
          var selectedDailyDefinitions =
              await _dailyMenuDataAccess.fetchDailyMenus();
          for (var element in selectedDailyDefinitions) {
            var menus = allMenus.where(
              (item) => element.menuIds.contains(
                (item.id!),
              ),
            );
            dailyDefinitions[element.menuType]!.addAll(menus);
          }
        },
      ),
    );
  }

  void reset() {
    emit(DailyMenuState.initial());
    categoryIndex = 0;
    dailyDefinitions = {
      0: [],
      1: [],
      2: [],
      3: [],
      4: [],
      5: [],
      6: [],
    };
    _cubit.reset();
  }

  void filterMenus(String text) {
    var menus = filteredMenus(state.selectedMenuItems);
    var filter = menus.where((item) => item.name.toLowerCase().contains(text));
    emit(state.copyWith(menuItems: [...filter]));
  }

  void clearFilter() {
    var menus = filteredMenus(state.selectedMenuItems);
    emit(state.copyWith(menuItems: [...menus]));
  }

  void changeCategory(int selectedCategoryIndex) {
    dailyDefinitions[categoryIndex] = [...state.selectedMenuItems];
    final selectedCategoryMenuItems = dailyDefinitions[selectedCategoryIndex]!;
    categoryIndex = selectedCategoryIndex;
    var menus = filteredMenus(selectedCategoryMenuItems);
    emit(
      state.copyWith(
        menuItems: [...menus],
        selectedMenuItems: [...selectedCategoryMenuItems],
      ),
    );
  }

  List<MenuItem> filteredMenus(List<MenuItem> selectedCategoryMenuItems) {
    var filteredMenus = [...menus];
    filteredMenus.removeWhere(
      (item) => selectedCategoryMenuItems.contains(item),
    );
    return filteredMenus;
  }

  void addToCart(MenuItem item) {
    var menus = [...state.menuItems];
    menus.remove(item);
    emit(
      state.copyWith(
          menuItems: [...menus],
          selectedMenuItems: [...state.selectedMenuItems, item]),
    );
  }

  void removeFromCart(MenuItem item) {
    var items = [...state.selectedMenuItems];

    items.remove(item);

    emit(
      state.copyWith(
          menuItems: [...state.menuItems, item], selectedMenuItems: [...items]),
    );
  }
}
