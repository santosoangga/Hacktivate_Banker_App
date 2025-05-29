part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthLoginRequested extends AuthEvent {
  final String userId;
  final String userPassword;

  AuthLoginRequested({required this.userId, required this.userPassword});
}
