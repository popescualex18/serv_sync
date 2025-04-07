import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/domain/data_access/menu_data_access.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/ui/state_management/cubits/app_cubit.dart';

class ManageMenuCubit extends Cubit<MenuItem?> {
  final AppCubit _cubit;

  final MenuDataAccess _access = MenuDataAccess();
  MenuItem _menu = MenuItem.empty();
  bool hasCategorySelected =false;
  ManageMenuCubit(this._cubit) : super(null);

  void resetMenu(){
    _menu = MenuItem.empty();
    emit(_menu);
  }

  Future loadMenu(String? id, MenuItem? menuItem) async {
    await _cubit.guard(
      onEnd: () =>  emit(_menu),
      Future(
        () async {
          if(menuItem != null) {
            _menu = menuItem;

            return;
          }
          if (id == null) {
            _menu = MenuItem.empty();

            return;
          }
          var result = await _access.fetchMenuById(id);
          _menu = result;
          hasCategorySelected = _menu.categories.isNotEmpty;
        },
      ),
    );
  }

  void setName(String name) {
    _menu = _menu.copyWith(name: name);
  }

  void setPrice(double price) {
    _menu = _menu.copyWith(price: price);
  }

  void setHasBread(bool value) {
    _menu = _menu.copyWith(hasBread: value);
    emit(_menu);
  }
  void setCategories(int category, bool isSelected) {
    var categories = [..._menu.categories];
    if(isSelected) {
      categories.add(category);
    } else {
      categories.remove(category);
    }
    _menu = _menu.copyWith(categories: categories);
    hasCategorySelected = _menu.categories.isNotEmpty;
    emit(_menu);
  }
  void setHasPolenta(bool value) {
    _menu = _menu.copyWith(hasPolenta: value);
    emit(_menu);
  }

  Future<void> save() async {
    await _cubit.guard(
      Future(
        () async {
          _access.addOrUpdateMenu(menu: _menu);
        },
      ),
    );
  }

  void reset() {
    _cubit.reset();
  }
}
