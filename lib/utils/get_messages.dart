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

extension IntGetMessages on DateTime {
  String getWeekdayLabel(BuildContext context) {
    AppLocalizations strings = AppLocalizations.of(context)!;
    switch (weekday) {
      case DateTime.monday:
        return strings.monday;
      case DateTime.tuesday:
        return strings.tuesday;
      case DateTime.wednesday:
        return strings.wednesday;
      case DateTime.thursday:
        return strings.thursday;
      case DateTime.friday:
        return strings.friday;
      case DateTime.saturday:
        return strings.saturday;
      default:
        return strings.sunday;
    }
  }

  String getMonthLabel(BuildContext context) {
    AppLocalizations strings = AppLocalizations.of(context)!;
    switch (month) {
      case DateTime.january:
        return strings.january;
      case DateTime.february:
        return strings.february;
      case DateTime.march:
        return strings.march;
      case DateTime.april:
        return strings.april;
      case DateTime.may:
        return strings.may;
      case DateTime.june:
        return strings.june;
      case DateTime.july:
        return strings.july;
      case DateTime.august:
        return strings.august;
      case DateTime.september:
        return strings.september;
      case DateTime.october:
        return strings.october;
      case DateTime.november:
        return strings.november;
      default:
        return strings.december;
    }
  }
}
