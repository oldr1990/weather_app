class BMP280 {
  final double temperature;
  final double pressure;
  final DateTime date;

  const BMP280({
    this.temperature = 0.0,
    this.pressure = 0.0,
    required this.date,
  });

  @override
  String toString() =>
      'BME280(date: $date, temperature: $temperature, pressure: $pressure)';

  factory BMP280.fromMap(Map<String, dynamic> map) {
    return BMP280(
      temperature: map['temperature'] as double,
      pressure: map['pressure'] as double,
      date: DateTime.fromMillisecondsSinceEpoch((map['time'] as int) * 1000),
    );
  }
}
