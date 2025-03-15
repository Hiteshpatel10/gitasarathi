part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class Authenticating extends AuthState {}

class AuthSuccess extends AuthState {
  AuthSuccess({required this.token}) {
    _runOnInit();
  }

  final String token;

  void _runOnInit() {
    prefs.setString(AppPrefKeys.token, token);
  }
}

class AuthFailed extends AuthState {
  AuthFailed({this.errorMessage});
  final String? errorMessage;
}
