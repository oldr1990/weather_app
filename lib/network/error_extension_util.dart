import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/network/model_response.dart';

extension MessageExtractor on FirebaseException {
  ErrorType getErrorType() {
    switch (code) {
      case 'network-request-failed':
        return ErrorType.noInternet;
      case 'invalid-email':
        return ErrorType.loginData;
      case 'user-disabled':
        return ErrorType.userDisabled;
      case 'wrong-password':
        return ErrorType.loginData;
      case 'account-exists-with-different-credential':
        return ErrorType.userExist;
      default:
        return ErrorType.unknown;
    }
  }
}
