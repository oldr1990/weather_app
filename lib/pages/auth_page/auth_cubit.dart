import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/network/firebase_auth_service.dart';
import 'package:weather_app/network/model_response.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());
  final FirebaseAuthService firebaseService = FirebaseAuthService();

  Future register(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await firebaseService.register(email, password);
    _resultHandler(result);
  }

  void _resultHandler(Result<User> result) {
    if (result is Success) {
      result as Success<User>;
      emit(state.copyWith(status: AuthStatus.success));
    } else {
      result as Error<User>;
      emit(state.copyWith(errorMessage: result.errorMessage));
    }
  }

  Future login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await firebaseService.authorize(email, password);
    _resultHandler(result);
  }
}
