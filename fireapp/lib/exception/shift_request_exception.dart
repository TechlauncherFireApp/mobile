class ShiftRequestException implements Exception {
  final String message;
  ShiftRequestException(this.message);

  @override
  String toString() => 'ShiftRequestException : $message';
}
