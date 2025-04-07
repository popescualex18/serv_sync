import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/main.dart';
import 'package:serv_sync/ui/shared/widgets/side_bar/side_bar.dart';
import 'package:serv_sync/ui/shared/widgets/snack_bar/snackbar_provider.dart';
import 'package:serv_sync/ui/state_management/cubits/app_cubit.dart';
import 'package:serv_sync/ui/state_management/cubits/daily_menu/daily_menu_cubit.dart';
import 'package:serv_sync/ui/state_management/cubits/daily_menu_overview_cubit/daily_menu_overview_cubit.dart';
import 'package:serv_sync/ui/state_management/cubits/menu/manage_menu_cubit.dart';
import 'package:serv_sync/ui/state_management/cubits/menu/menu_cubit.dart';
import 'package:serv_sync/ui/state_management/states/app_state.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late final AppCubit _cubit;
  late final StreamSubscription<AppState> _listener;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<AppCubit>();
    _listener = _cubit.stream.listen(_onStateChanged);

    locator.register(MenuCubit(_cubit));
    locator.register(ManageMenuCubit(_cubit));
    locator.register(DailyMenuCubit(_cubit));
    locator.register(DailyMenuOverviewCubit(_cubit));
  }

  @override
  void dispose() {
    _listener.cancel();
    _cubit.close();
    super.dispose();
  }

  void _onStateChanged(AppState state) {
    if (state.error != null) {
      SnackbarProvider.error(context, state.error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MenuCubit>(create: (context) => locator.get<MenuCubit>()),
        BlocProvider<ManageMenuCubit>(create: (context) => locator.get<ManageMenuCubit>()),
        BlocProvider<DailyMenuCubit>(create: (context) => locator.get<DailyMenuCubit>()),
      ],
      child: Scaffold(
        drawer: kIsWeb ? Sidebar() : null, // Drawer only for Web
        appBar: kIsWeb
            ? AppBar(

          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        )
            : null, // No AppBar on desktop or mobile
        body: Row(
          children: [
            if (!kIsWeb) Sidebar(), // Sidebar for Desktop & Mobile
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
