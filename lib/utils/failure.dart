abstract class Failure {
  final String message;
  final int code;

  Failure(this.message, {this.code = 0});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

class ServerFailure extends Failure {
  ServerFailure(String message, {int code = 0}) : super(message, code: code);
}
