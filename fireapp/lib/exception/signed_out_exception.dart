class SignedOutException implements Exception {
  final String message;
  SignedOutException(this.message);

  @override
  String toString() {
    return 'SignedOutException: $message';
  }
}
