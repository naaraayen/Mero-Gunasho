// Custom Exception Handler
class HttpException implements Exception {
  String exceptionMessage;
  HttpException(this.exceptionMessage);

  @override
  String toString() {
    return exceptionMessage;
  }
}
