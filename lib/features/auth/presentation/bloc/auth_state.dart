part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

//Add the all states in the authentication
final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final String uid;

  const AuthSuccess(this.uid); 
}

final class AuthFailure extends AuthState {
  final String message;

  // AuthFailure(this.message); // can optimize this by adding const in both AuthState and Auth Failure class
  const AuthFailure(this.message);
}
