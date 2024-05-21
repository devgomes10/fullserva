class FirestoreException implements Exception {
  final String message;
  final dynamic originalException;

  FirestoreException(this.message, [this.originalException]);

  @override
  String toString() => 'FirestoreException: $message';
}
