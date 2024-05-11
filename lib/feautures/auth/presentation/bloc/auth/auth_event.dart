part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});
}

class LogoutEvent extends AuthEvent {}

class TryAutoLoginEvent extends AuthEvent {}

class CreateAccountEvent extends AuthEvent {
  final String email;
  final String password;

  const CreateAccountEvent({required this.email, required this.password});
}
