part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}


class LoggedInState extends AuthState {
  final AuthModel authModel;

  const LoggedInState({required this.authModel});

  @override
  List<Object> get props => [authModel];
}

class LoggingInState extends AuthState {
  //to show splash page
}

class LoadingState extends AuthState {
  //to show circuler progress indicator
}

class LoggedOutState extends AuthState {
  final bool goToLoginPage;
  const LoggedOutState({required this.goToLoginPage});
}

class ErrorState extends AuthState {
  final String message;
  const ErrorState({required this.message});
}
