import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serv_sync/ui/shared/widgets/loading_spinner/loading_spinner.dart';
import 'package:serv_sync/ui/state_management/cubits/app_cubit.dart';

class BaseWidgetWrapper extends StatelessWidget {
  const BaseWidgetWrapper({
    super.key,
    this.onLoading,
    this.onError,
    required this.buildChild,
  });

  final Widget Function()? onLoading;
  final Widget Function()? onError;
  final Widget Function(BuildContext context) buildChild;

  @override
  Widget build(BuildContext context) {
    var isLoading = context.select<AppCubit, bool>(
      (cubit) => cubit.state.isLoading,
    );
    if (isLoading) {
      return onLoading?.call() ?? LoadingSpinner();
    }
    var hasError = context.select<AppCubit, bool>(
      (cubit) => cubit.state.error != null,
    );
    if (hasError) {
      return onError?.call() ?? SizedBox.shrink();
    }
    return Scaffold(
      body: buildChild(
        context,
      ),
    );
  }
}
