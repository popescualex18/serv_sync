import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/domain/data_access/daily_menu_data_access.dart';
import 'package:serv_sync/domain/data_access/menu_data_access.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/ui/state_management/cubits/app_cubit.dart';

class DailyMenuOverviewCubit extends Cubit<Map<int, List<MenuItem>>> {
  final AppCubit _cubit;

  int categoryIndex = 0;

  final DailyMenuDataAccess _dailyMenuDataAccess = DailyMenuDataAccess();
  final MenuDataAccess _menuDataAccess = MenuDataAccess();

  DailyMenuOverviewCubit(this._cubit)
      : super({
          0: [],
          1: [],
          2: [],
          3: [],
          4: [],
          5: [],
          6: [],
        });

  Future fetchData() async {
    await _cubit.guard(
      Future(
        () async {
          var allMenus = await _menuDataAccess.fetchMenus();
          final Map<int, List<MenuItem>> dailyDefinitions = {};
          var selectedDailyDefinitions =
              await _dailyMenuDataAccess.fetchDailyMenus();
          for (var element in selectedDailyDefinitions) {
            var menus = allMenus.where(
              (item) => element.menuIds.contains(
                (item.id!),
              ),
            );
            if(dailyDefinitions.containsKey(element.menuType)){
              dailyDefinitions[element.menuType]!.addAll(menus);
            }
            else {
              dailyDefinitions[element.menuType] = menus.toList();
            }
          }
          emit(dailyDefinitions);
        },
      ),
    );
  }
}
