// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:weather_app/models/device_type.dart';

class Device {
  String id;
  String name;
  String description;
  String type;
  String buttery;
  String userId;

  DeviceType deviceType() {
    return DeviceType.values
        .firstWhere((element) => element.toString() == type);
  }

  Device({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.buttery,
    required this.userId,
  });

  Device copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? buttery,
    String? userId,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      buttery: buttery ?? this.buttery,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'buttery': buttery,
      'userId': userId,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      type: map['type'] as String,
      buttery: map['buttery'] as String,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) =>
      Device.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Device(id: $id, name: $name, description: $description, type: $type, buttery: $buttery, userId: $userId)';
  }
}
