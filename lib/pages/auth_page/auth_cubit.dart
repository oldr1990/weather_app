import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/network/FirebaseService.dart';
import 'package:weather_app/network/model_response.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());
  final FirebaseService firebaseService = FirebaseService();

  Future register(String email, String password) async {
    final result = await firebaseService.register(email, password);
    if (result is Success) {
      result as Success<User?>;
    } else {
      result as Error<User?>;
      emit(state.copyWith(errorMessage: result.errorMessage));
    }
  }
}
