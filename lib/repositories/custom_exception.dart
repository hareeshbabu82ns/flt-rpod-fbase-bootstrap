class CustomException implements Exception {
  final String? message;
  final Exception? originalException;

  const CustomException(
      {this.message = 'Something went Wrong!', this.originalException});

  @override
  String toString() => 'CustomException { message: $message }';
}
