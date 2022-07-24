import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/models/ds18b20.dart';
import 'package:weather_app/network/error_extension_util.dart';
import 'package:weather_app/network/model_response.dart';

import '../models/device.dart';

class FirestoreRepository {
  final db = FirebaseFirestore.instance;
  final userID = FirebaseAuth.instance.currentUser?.uid;
  DocumentSnapshot<Object?>? _lastLoadedDs18b20;
  Future<Result<List<Device>>> getDevices() async {
    try {
      final result = await db
          .collection('device')
          .where('userId', isEqualTo: userID)
          .get();
      final devices =
          result.docs.map((doc) => Device.fromMap(doc.data(), doc.id)).toList();
      return Success(devices);
    } on FirebaseException catch (e) {
      return Error(e.message, e.getErrorType());
    } catch (e) {
      return Error<List<Device>>(e.toString(), ErrorType.unknown);
    }
  }

  Future<Result<bool>> addDevice(Device device) async {
    try {
      await db
          .collection('device')
          .add(device.copyWith(userId: userID).toMap());
      return Success(true);
    } on FirebaseException catch (e) {
      return Error(e.message, ErrorType.unknown);
    } catch (e) {
      return Error(e.toString(), ErrorType.unknown);
    }
  }

  Future<Result<bool>> updateDevice(Device device) async {
    try {
      await db.collection('device').doc(device.id).update(device.toMap());
      return Success(true);
    } on FirebaseException catch (e) {
      return Error(e.message, e.getErrorType());
    } catch (e) {
      return Error(e.toString(), ErrorType.unknown);
    }
  }

  Future<Result<bool>> deleteDevice(Device device) async {
    try {
      await db.collection('device').doc(device.id).delete();
      return Success(true);
    } on FirebaseException catch (e) {
      return Error(e.message, e.getErrorType());
    } catch (e) {
      return Error(e.toString(), ErrorType.unknown);
    }
  }

  Future<Result<List<Ds18b20>>> getDs18b20(
      Device device, bool newLoading) async {
    try {
      QuerySnapshot<Map<String, dynamic>>? result;
      if (newLoading) {
        _lastLoadedDs18b20 = null;
        result = await db
            .collection('ds18b20')
            .orderBy('time', descending: true)
            .limit(24)
            .get();
      } else {
        result = await db
            .collection('ds18b20')
            .orderBy('time', descending: true)
            .startAfterDocument(_lastLoadedDs18b20!)
            .limit(24)
            .get();
      }
      final data =
          result.docs.map((doc) => Ds18b20.fromMap(doc.data())).toList();
      _lastLoadedDs18b20 = result.docs[result.docs.length - 1];
      return Success(data);
    } on FirebaseException catch (e) {
      return Error(e.message, e.getErrorType());
    } catch (e) {
      return Error(e.toString(), ErrorType.unknown);
    }
  }
}
