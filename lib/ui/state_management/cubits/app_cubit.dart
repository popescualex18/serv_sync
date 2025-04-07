import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/core/logging/logger.dart';
import 'package:serv_sync/ui/state_management/states/app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial());

  Future guard(Future func, {Function()? onEnd}) async {
    Exception? error;
    try {
      emit(
        AppState.loading(),
      );
      await func;
    }  catch (e) {
      print(e);
      error = e as Exception;
    } finally {
      onEnd?.call();
      emit(
        AppState.complete(
          error: error,
        ),
      );

    }
  }
  void reset() {
    emit(AppState.initial());
  }
}
