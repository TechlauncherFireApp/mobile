class MakeNewShiftException implements Exception {
  final String message;
  MakeNewShiftException(this.message);

  @override
  String toString() => 'MakeNewShiftException: $message';
}
