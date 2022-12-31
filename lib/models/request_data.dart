class RequestData {
  final String deviceId;
  final bool newLoading;

  RequestData(this.deviceId, this.newLoading);

  RequestData copy({String? deviceId, bool? newLoading}) =>
      RequestData(deviceId ?? this.deviceId, newLoading ?? this.newLoading);
}
