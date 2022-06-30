import 'package:flutter/material.dart';
import 'package:weather_app/network/model_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension GetErrorMessage on Error {
  String getErrorMessage(BuildContext context) {
    AppLocalizations strings = AppLocalizations.of(context)!;
    switch (errorType) {
      case ErrorType.noInternet:
        return strings.error_no_internet_connection;
      case ErrorType.loginData:
        return strings.invalid_input;
      case ErrorType.userDisabled:
        return strings.error_user_disabled;
      case ErrorType.userExist:
        return strings.error_user_exists;
      case ErrorType.unknown:
        return strings.unexpected_error;
    }
  }
}
