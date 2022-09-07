import 'package:intl/intl.dart';

class Ds18b20Request {
  final int lastLoadedDate;
  final String deviceId;
  final bool newLoading;
  int getDayBeforeLastLoaded() => lastLoadedDate - 86400;
  String getLasAttemptLabel() {
    const pattern = "HH:mm DD/MM/YYYY";
    DateTime toDate =
        DateTime.fromMillisecondsSinceEpoch(lastLoadedDate * 1000);
    return DateFormat(pattern).format(toDate.subtract(const Duration(days: 1))) +
        " - " +
        DateFormat(pattern).format(toDate);
  }

  Ds18b20Request(this.lastLoadedDate, this.deviceId, this.newLoading);

  Ds18b20Request copy(
          {int? lastLoadedDate, String? deviceId, bool? newLoading}) =>
      Ds18b20Request(lastLoadedDate ?? this.lastLoadedDate,
          deviceId ?? this.deviceId, newLoading ?? this.newLoading);
}
