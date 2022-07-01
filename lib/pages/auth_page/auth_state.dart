part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final Error error;

  AuthError(this.error);
}

class AuthLoading extends AuthState {}

class AuthNormal extends AuthState {}
