abstract class BaseException implements Exception {
  final String errorMessage;
  BaseException(this.errorMessage);
  @override
  String toString() {
    return errorMessage;
  }
}