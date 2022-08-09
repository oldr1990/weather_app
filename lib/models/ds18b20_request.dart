class Ds18b20Request {
  final int lastLoadedDate;
  final String deviceId;
  final bool newLoading;
  int getDayBeforeLastLoaded() => lastLoadedDate - 86400;

  Ds18b20Request(this.lastLoadedDate, this.deviceId, this.newLoading);

  Ds18b20Request copy({
          int? lastLoadedDate, String? deviceId, bool? newLoading}) =>
      Ds18b20Request(lastLoadedDate ?? this.lastLoadedDate,
          deviceId ?? this.deviceId, newLoading ?? this.newLoading);
}
