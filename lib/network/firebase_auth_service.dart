// ignore_for_file: file_names
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/network/model_response.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Result<User>> authorize(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      log(result.user.toString());
      if (result.user != null) {
        return Success<User>(result.user!);
      } else {
        return Error<User>('Something went wrong');
      }
    } catch (e) {
      log(e.toString());
      return Error(e.toString());
    }
  }

  Future<Result<User>> register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      log(result.user.toString());
      if (result.user != null) {
        return Success<User>(result.user!);
      } else {
        return Error<User>('Something went wrong');
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
