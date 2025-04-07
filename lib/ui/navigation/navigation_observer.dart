import 'package:flutter/material.dart';
import 'package:serv_sync/main.dart';
import 'package:serv_sync/ui/state_management/cubits/side_bar/sidebar_cubit.dart';

class SidebarNavigatorObserver extends NavigatorObserver {

  void _updateSidebar(Route<dynamic>? route) {
    final routeName = route?.settings.name;
    if (routeName != null && locator.get<SidebarCubit>().routeMap.containsKey(routeName)) {
      locator.get<SidebarCubit>().selectPage(routeName);
    }

  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateSidebar(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateSidebar(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _updateSidebar(newRoute);
  }
}
