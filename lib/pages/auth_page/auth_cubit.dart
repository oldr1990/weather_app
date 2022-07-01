import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/network/auth_repository.dart';
import 'package:weather_app/network/model_response.dart';

import '../../models/user_data.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthNormal());
  final AuthRepository repository = AuthRepository();

  Future register(UserData data) async {
    emit(AuthLoading());
    final result = await repository.register(data);
    _resultHandler(result);
  }

  Future _resultHandler(Result<UserData> result) async {
    if (result is Success) {
      result as Success<UserData>;
      await repository.writeUserData(result.value);
      emit(AuthSuccess());
    } else {
      result as Error<UserData>;
      emit(AuthError(result));
    }
  }

  Future login(UserData data) async {
    emit(AuthLoading());
    final result = await repository.authorize(data);
    _resultHandler(result);
  }

  Future readUserData() async {
    emit(AuthLoading());
    final result = await repository.readUserData();
    if (result is Success) {
      result as Success<UserData>;
      login(result.value);
    } else {
      emit(AuthNormal());
    }
  }

  Future logout() async {
    emit(AuthLoading());
    final result = await repository.logout();
    if (result is Success) {
      emit(AuthNormal());
    } else {
      result as Error<bool>;
      emit(AuthError(result));
    }
  }
}
