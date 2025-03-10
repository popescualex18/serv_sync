class AppState {
  final Exception? error;
  final bool isLoading;
  AppState({
    this.error,
    this.isLoading = false,
  });
  factory AppState.initial() => AppState();
  factory AppState.loading() => AppState(isLoading: true);
  factory AppState.complete({Exception? error}) => AppState(
        error: error,
        isLoading: false,
      );
}
