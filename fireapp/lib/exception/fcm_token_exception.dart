class FcmTokenException implements Exception {
  final String message;
  FcmTokenException(this.message);

  @override
  String toString() => 'FcmTokenException: $message';
}
