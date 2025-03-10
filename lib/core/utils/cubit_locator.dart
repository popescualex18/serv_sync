class CubitLocator {
  static final Map<Type, Object> _instances = {};
  T register<T>(T instance) {
    _instances[T] = instance as Object;
    return instance;
  }
  T get<T extends Object>() {
    return _instances[T]! as T;
  }
}