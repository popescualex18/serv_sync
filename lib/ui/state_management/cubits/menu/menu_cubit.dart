import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/domain/data_access/menu_data_access.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/ui/state_management/cubits/app_cubit.dart';

class MenuCubit extends Cubit<List<MenuItem>> {
  final AppCubit _cubit;
  final List<MenuItem> allMenus = [];
  final MenuDataAccess _access = MenuDataAccess();
  String filterValue ='';
  MenuCubit(this._cubit) : super(<MenuItem>[]);

  void filterMenus(String text) {
    var menus = allMenus.where(
      (menu) => menu.name.toLowerCase().contains(
            text,
          ),
    );
    filterValue = text;
    emit([...menus]);
  }

  Future<void>  delete(String id) async{
    _access.delete(id);
    var result = await _access.fetchMenus();
    allMenus.clear();
    allMenus.addAll(result);
    filterMenus(filterValue);
  }


  void clearFilter() {
    emit([...allMenus]);
  }

  Future loadMenus() async {
    await _cubit.guard(
      Future(
        () async {
          var result = await _access.fetchMenus();
          allMenus.addAll(result);
          emit(result);
        },
      ),
    );
  }

  void reset() {
    emit([]);
    allMenus.clear();
    _cubit.reset();
  }
}
