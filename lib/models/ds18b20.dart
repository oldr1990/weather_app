// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Ds18b20 {
  DateTime date;
  double temperature;

  Ds18b20({
    required this.date,
    required this.temperature,
  });

  Ds18b20 copyWith({
    DateTime? date,
    double? temperature,
  }) {
    return Ds18b20(
      date: date ?? this.date,
      temperature: temperature ?? this.temperature,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'temperature': temperature,
    };
  }

  factory Ds18b20.fromMap(Map<String, dynamic> map) {
    return Ds18b20(
      date: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      temperature: map['value'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ds18b20.fromJson(String source) =>
      Ds18b20.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Ds18b20(date: $date, temperature: $temperature)';
}
