import 'package:bloc/bloc.dart';
import 'package:weather_app/network/firebase_auth_service.dart';
import 'package:weather_app/network/model_response.dart';
import 'package:weather_app/network/shared_prefernces_service.dart';

import '../../models/user_data.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());
  final FirebaseAuthService firebaseService = FirebaseAuthService();
  final SharedPreferencesService prefsService = SharedPreferencesService();

  Future register(UserData data) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await firebaseService.register(data);
    _resultHandler(result);
  }

  Future _resultHandler(Result<UserData> result) async {
    if (result is Success) {
      result as Success<UserData>;
      await prefsService.writeUserData(result.value);
      emit(state.copyWith(status: AuthStatus.success));
    } else {
      result as Error<UserData>;
      emit(state.copyWith(errorMessage: result.errorMessage));
    }
  }

  Future login(UserData data) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await firebaseService.authorize(data);
    _resultHandler(result);
  }

  Future readUserData() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await prefsService.readUserData();
    if (result is Success) {
      result as Success<UserData>;
      login(result.value);
    } else {
      emit(state.copyWith(status: AuthStatus.normal));
    }
  }

  Future logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await firebaseService.logout();
    if (result is Success) {
      await prefsService.removeUserData();
      emit(state.copyWith(status: AuthStatus.normal));
    } else {
      result as Error<bool>;
      emit(state.copyWith(errorMessage: result.errorMessage));
    }
  }
}
