// ignore_for_file: file_names
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/network/model_response.dart';

import '../models/user_data.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Result<UserData>> authorize(UserData data) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: data.email, password: data.password);
      log(result.user.toString());
      if (result.user != null) {
        return Success<UserData>(data);
      } else {
        return Error<UserData>('Something went wrong');
      }
    } catch (e) {
      log(e.toString());
      return Error(e.toString());
    }
  }

  Future<Result<UserData>> register(UserData data) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: data.email, password: data.password);
      log(result.user.toString());
      if (result.user != null) {
        return Success<UserData>(data);
      } else {
        return Error<UserData>('Something went wrong');
      }
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Result<bool>> logout() async {
    try {
      await _auth.signOut();
      return Success(true);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
