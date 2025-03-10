import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/ui/navigation/routes.dart';
import 'package:serv_sync/ui/state_management/states/sidebar_state.dart';

class SidebarCubit extends Cubit<SidebarState> {
  SidebarCubit() : super(SidebarState.initial());
  final routeMap = {
    Routes.menu: 0,
    Routes.dailyMenu: 1,
    Routes.dailyMenuOverview: 2,
  };

  void selectPage(String route) {
    emit(state.copyWith(selectedIndex: routeMap[route]));
  }
}
