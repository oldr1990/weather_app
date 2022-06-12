// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/network/model_response.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Result<User?>> authorize(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return Success(result.user);
    } catch (e) {
      return Error(e.toString());
    }
  }

  Future<Result<User?>> register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return Success(result.user);
    } catch (e) {
      return Error(e.toString());
    }
  }
}
