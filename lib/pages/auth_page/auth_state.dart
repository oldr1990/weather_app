part of 'auth_cubit.dart';

enum AuthStatus { initial, success, failure, loading }

class AuthState {
  final AuthStatus status;
  final String errorMessage;

//<editor-fold desc="Data Methods">

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          errorMessage == other.errorMessage);

  @override
  int get hashCode => status.hashCode ^ errorMessage.hashCode;

  @override
  String toString() {
    return 'AuthState{' ' status: $status,' ' errorMessage: $errorMessage,' '}';
  }

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'errorMessage': errorMessage,
    };
  }

  factory AuthState.fromMap(Map<String, dynamic> map) {
    return AuthState(
      status: map['status'] as AuthStatus,
      errorMessage: map['errorMessage'] as String,
    );
  }

//</editor-fold>
}
