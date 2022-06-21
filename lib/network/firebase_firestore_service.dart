import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/models/ds18b20.dart';
import 'package:weather_app/network/model_response.dart';

import '../models/device.dart';

class FirebaseFirestoreService {
  final db = FirebaseFirestore.instance;
  final userID = FirebaseAuth.instance.currentUser?.uid;

  Future<Result<List<Device>>> getDevices() async {
    try {
      final result = await db
          .collection('device')
          .where('userId', isEqualTo: userID)
          .get();
      final devices =
          result.docs.map((doc) => Device.fromMap(doc.data())).toList();
      return Success(devices);
    } on SocketException {
      return Error("Please, check your internet connection and try again.");
    } on TimeoutException {
      return Error("Server not responding!");
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Result<bool>> addDevice(Device device) async {
    try {
      await db
          .collection('device')
          .add(device.copyWith(userId: userID).toMap());
      return Success(true);
    } on SocketException {
      return Error("Please, check your internet connection and try again.");
    } on TimeoutException {
      return Error("Server not responding!");
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Result<bool>> deleteDevice(Device device) async {
    try {
      await db.collection('device').doc(device.id).delete();
      return Success(true);
    } on SocketException {
      return Error("Please, check your internet connection and try again.");
    } on TimeoutException {
      return Error("Server not responding!");
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Result<List<Ds18b20>>> getDs18b20(Device device) async {
    try {
      final result = await db
          .collection('ds18b20/${device.id}')
          .orderBy('time')
          .limit(20)
          .get();
      final data =
          result.docs.map((doc) => Ds18b20.fromMap(doc.data())).toList();
      return Success(data);
    } on SocketException {
      return Error("Please, check your internet connection and try again.");
    } on TimeoutException {
      return Error("Server not responding!");
    } catch (e) {
      return Error(e.toString());
    }
  }
}
