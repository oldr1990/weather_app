import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/models/ds18b20.dart';
import 'package:weather_app/network/model_response.dart';

import '../models/device.dart';

class FirebaseFirestoreService {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Future<Result<List<Device>>> getDevices() async {
    try {
      final result = await db.collection('device').get();
      final devices =
          result.docs.map((doc) => Device.fromMap(doc.data())).toList();
      devices.removeWhere((element) => element.userId != user?.uid);
      return Success(devices);
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Result<bool>> addDevice(Device device) async {
    try {
      await db.collection('device').add(device.toMap());
      return Success(true);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
