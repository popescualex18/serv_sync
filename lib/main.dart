import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:serv_sync/core/constants/constants.dart';
import 'package:serv_sync/core/logging/logger.dart';
import 'package:serv_sync/core/utils/cubit_locator.dart';
import 'package:serv_sync/ui/navigation/app_router.dart';
import 'package:serv_sync/ui/state_management/cubits/app_cubit.dart';
import 'package:serv_sync/ui/state_management/cubits/daily_menu_overview_cubit/daily_menu_overview_cubit.dart';
import 'package:serv_sync/ui/state_management/cubits/side_bar/sidebar_cubit.dart';
import 'package:window_manager/window_manager.dart';

import 'firebase_options.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
final CubitLocator locator = CubitLocator();
void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await tryWindowsInitialize();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MyApp());
  }, (error, stackTrace) {
    Logger.instance.log('Caught an error: $error $stackTrace');
  });
}

Future tryWindowsInitialize() async {
  if (GetPlatform.isWeb) {
    return;
  }
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setMinimumSize(Constants.minWindowsSize);
    await windowManager.setSize(Constants.minWindowsSize);
    await windowManager.center();
    await windowManager.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router;

    return MultiBlocProvider(
      providers: [
        BlocProvider<SidebarCubit>(
          create: (BuildContext context) => locator.register(
            SidebarCubit(),
          ),
        ),
        BlocProvider<AppCubit>(
          create: (BuildContext context) => locator.register(
            AppCubit(),
          ),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
