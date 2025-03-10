import 'dart:async';

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
  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late final AppCubit _cubit;
  late final StreamSubscription<AppState> _listener;
  @override
  void initState() {
    _cubit = context.read<AppCubit>();
    _listener = _cubit.stream.listen(_onStateChanged);
    super.initState();
    locator.register(
      MenuCubit(_cubit),
    );
    locator.register(
      ManageMenuCubit(_cubit),
    );
    locator.register(
      DailyMenuCubit(_cubit),
    );
    locator.register(
      DailyMenuOverviewCubit(_cubit),
    );
  }

  @override
  void dispose() {
    _listener.cancel();
    _cubit.close();
    super.dispose();
  }

  void _onStateChanged(AppState state) {
    if (state.error != null) {
      SnackbarProvider.error(
        context,
        state.error.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MenuCubit>(
          create: (BuildContext context) => locator.get<MenuCubit>(),
        ),
        BlocProvider<ManageMenuCubit>(
          create: (BuildContext context) => locator.get<ManageMenuCubit>(),
        ),
        BlocProvider<DailyMenuCubit>(
          create: (BuildContext context) => locator.get<DailyMenuCubit>(),
        ),
      ],
      child: Scaffold(
        body: Row(
          children: [
            Sidebar(),
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
