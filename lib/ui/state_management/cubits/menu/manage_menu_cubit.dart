import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/domain/data_access/menu_data_access.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/ui/state_management/cubits/app_cubit.dart';

class ManageMenuCubit extends Cubit<MenuItem?> {
  final AppCubit _cubit;

  final MenuDataAccess _access = MenuDataAccess();
  MenuItem _menu = MenuItem.empty();
  ManageMenuCubit(this._cubit) : super(null);

  Future loadMenu(String? id) async {
    await _cubit.guard(
      onEnd: () =>  emit(_menu),
      Future(
        () async {
          if (id == null) {
            _menu = MenuItem.empty();

            return;
          }
          var result = await _access.fetchMenuById(id);
          _menu = result;
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
