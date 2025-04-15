part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

final class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

final class Unauthenticated extends AuthState {}
