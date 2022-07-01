abstract class Result<T> {}

class Success<T> extends Result<T> {
  final T value;

  Success(this.value);
}

class Error<T> extends Result<T> {
  final String? errorMessage;
  final ErrorType errorType;
  Error(this.errorMessage, this.errorType);
}

//Todo: Add more error handling
enum ErrorType { noInternet, loginData, userDisabled, userExist, unknown }
