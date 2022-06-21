abstract class Result<T> {}

class Success<T> extends Result<T> {
  final T value;

  Success(this.value);
}

class Error<T> extends Result<T> {
  final String errorMessage;

  Error(this.errorMessage);
}

//Todo: Add more error handling
enum ErrorType { network, server, unknown }
