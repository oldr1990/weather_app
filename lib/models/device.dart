// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:weather_app/models/device_type.dart';

class Device {
  String id;
  String name;
  String description;
  String type;
  int battery;
  String userId;

  DeviceType deviceType() {
    switch (type) {
      case 'ds18b20':
        return DeviceType.ds18b20;
      case 'bmp280':
        return DeviceType.bmp280;
      default:
        return DeviceType.unknown;
    }
  }

  Device({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.battery,
    required this.userId,
  });

  Device copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    int? battery,
    String? userId,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      battery: battery ?? this.battery,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'battery': battery,
      'name': name,
      'description': description,
      'type': type,
      'userId': userId,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map, String id) {
    return Device(
      id: id,
      name: map['name'] as String,
      description: map['description'] as String,
      type: map['type'] as String,
      battery: map['battery'] as int,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Device(id: $id, name: $name, description: $description, type: $type, buttery: $battery, userId: $userId)';
  }
}
