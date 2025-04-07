import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serv_sync/core/logging/logger.dart';
import 'package:serv_sync/domain/entities/menu/menu_item_model.dart';
import 'package:serv_sync/main.dart';
import 'package:serv_sync/ui/features/daily_menu/daily_menu_page.dart';
import 'package:serv_sync/ui/features/daily_menu_overview/daily_menu_overview_page.dart';
import 'package:serv_sync/ui/features/invoice/invoice_screen.dart';
import 'package:serv_sync/ui/features/menu/manage_menu_page.dart';
import 'package:serv_sync/ui/features/menu/menu_page.dart';
import 'package:serv_sync/ui/features/privacy_policy/privacy_policy.dart';
import 'package:serv_sync/ui/navigation/navigation_observer.dart';
import 'package:serv_sync/ui/navigation/routes.dart';
import 'package:serv_sync/ui/shared/layout/main_layout.dart';
import 'package:serv_sync/ui/state_management/cubits/menu/menu_cubit.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    observers: [
      SidebarNavigatorObserver(),
    ],
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => Routes.menu,
      ),
      GoRoute(

          path: Routes.privacyPolicy,
          name: Routes.privacyPolicy,
          builder: (
            context,
            state,
          ) =>
              PrivacyPolicy()),
      ShellRoute(
        observers: [
          TalkerRouteObserver(
            Logger.instance,
          ),
          SidebarNavigatorObserver(),
        ],
        builder: (context, state, child) => MainLayout(
          child: child,
        ),
        routes: [
          GoRoute(
            name: Routes.menu,
            path: Routes.menu,
            pageBuilder: (context, state) => _buildPageWithTransition(
              const MenuPage(),
              state,
            ),
            routes: [
              GoRoute(
                path: Routes.manageExistingMenu,
                name: Routes.manageExistingMenu,

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
                path: Routes.addNew,
                name: Routes.addNew,
                pageBuilder: (context, state) {
                  final menuItem = state.extra as MenuItem?;

                  return MaterialPage(
                    maintainState: false,
                    child: ManageMenuPage(
                      menuItem: menuItem,
                    ),
                  );
                },
              ),
              GoRoute(
                path: Routes.manageNewMenu,
                name: Routes.manageNewMenu,
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
            name: Routes.dailyMenu,
            pageBuilder: (context, state) => _buildPageWithTransition(
              const DailyMenuPage(),
              state,
            ),
          ),
          GoRoute(
            path: Routes.invoiceScreen,
            pageBuilder: (context, state) => _buildPageWithTransition(
              const InvoiceScreen(),
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
