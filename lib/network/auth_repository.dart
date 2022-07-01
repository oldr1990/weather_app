// ignore_for_file: file_names
import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/network/error_extension_util.dart';
import 'package:weather_app/network/model_response.dart';

import '../models/user_data.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _prefs = SharedPreferences.getInstance();
  final _passKey = "password";
  final _emailKey = "email";

  Future<Result<UserData>> authorize(UserData data) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: data.email, password: data.password);
      log(result.user.toString());
      if (result.user != null) {
        return Success<UserData>(data);
      } else {
        return Error<UserData>(null, ErrorType.unknown);
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      return Error(e.message, e.getErrorType());
    } catch (e) {
      log(e.toString());
      return Error(e.toString(), ErrorType.unknown);
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
        return Error<UserData>(null, ErrorType.unknown);
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      return Error(e.message, e.getErrorType());
    } catch (e) {
      log(e.toString());
      return Error(e.toString(), ErrorType.unknown);
    }
  }

  Future<Result<bool>> logout() async {
    try {
      await _auth.signOut();
      await _removeUserData();
      return Success(true);
    } catch (e) {
      return Error<bool>(null, ErrorType.unknown);
    }
  }

  Future<bool> writeUserData(UserData data) async {
    try {
      final prefs = await _prefs;
      prefs.setString(_emailKey, data.email);
      prefs.setString(_passKey, data.password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Result<UserData>> readUserData() async {
    try {
      final prefs = await _prefs;
      final email = prefs.getString(_emailKey);
      final password = prefs.getString(_passKey);
      if (email != null && password != null) {
        return Success(UserData(email: email, password: password));
      } else {
        return Error(null, ErrorType.userDisabled);
      }
    } catch (e) {
      return Error(e.toString(), ErrorType.unknown);
    }
  }

  Future<bool> _removeUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(_emailKey);
      prefs.remove(_passKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
