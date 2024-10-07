class NullUserIdShiftException implements Exception {
  final String message;
  NullUserIdShiftException(this.message);

  @override
  String toString() => 'NullUserIdShiftException: $message';
}
