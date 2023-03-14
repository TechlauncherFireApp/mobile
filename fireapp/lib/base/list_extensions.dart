
extension ListExtensions<T> on List<T> {

  bool has(bool Function(T) test) {
    for (T e in this) {
      if (test(e)) return true;
    }
    return false;
  }

  T? firstOrNull(bool Function(T) test) {
    for (T e in this) {
      if (test(e)) return e;
    }
    return null;
  }

}