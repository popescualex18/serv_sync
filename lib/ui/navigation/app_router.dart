import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serv_sync/core/logging/logger.dart';
import 'package:serv_sync/main.dart';
import 'package:serv_sync/ui/features/daily_menu/daily_menu_page.dart';
import 'package:serv_sync/ui/features/daily_menu_overview/daily_menu_overview_page.dart';
import 'package:serv_sync/ui/features/menu/manage_menu_page.dart';
import 'package:serv_sync/ui/features/menu/menu_page.dart';
import 'package:serv_sync/ui/navigation/routes.dart';
import 'package:serv_sync/ui/shared/layout/main_layout.dart';
import 'package:serv_sync/ui/state_management/cubits/menu/menu_cubit.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => Routes.menu,
      ),
      ShellRoute(
        observers: [
          TalkerRouteObserver(
            Logger.instance,
          ),
        ],
        builder: (context, state, child) => MainLayout(
          child: child,
        ),
        routes: [
          GoRoute(
            path: Routes.menu,
            pageBuilder: (context, state) => _buildPageWithTransition(
              const MenuPage(),
              state,
            ),
            routes: [
              GoRoute(
                path: Routes.manageExistingMenu,
                onExit: (context, _) {
                  locator.get<MenuCubit>().loadMenus();
                  return Future.value(true);
                },
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id'];
                  return MaterialPage(
                    maintainState: false,
                    child: ManageMenuPage(
                      menuId: id,
                    ),
                  );
                },
              ),
              GoRoute(
                path: Routes.manageNewMenu,
                onExit: (context, _) {
                  locator.get<MenuCubit>().loadMenus();
                  return Future.value(true);
                },
                pageBuilder: (context, state) {
                  return MaterialPage(
                    maintainState: false,
                    child: ManageMenuPage(),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: Routes.dailyMenu,
            pageBuilder: (context, state) => _buildPageWithTransition(
              const DailyMenuPage(),
              state,
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.dailyMenuOverview,
       builder: (context, state) => DailyMenuOverviewPage())
    ],
  );

  static CustomTransitionPage _buildPageWithTransition(
      Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      name: state.name,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
