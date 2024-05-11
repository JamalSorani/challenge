import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_challenge/feautures/auth/data/models/auth_model.dart';
import 'package:new_challenge/feautures/auth/domain/usecases/create_account.dart';
import 'package:new_challenge/feautures/auth/domain/usecases/login.dart';
import 'package:new_challenge/feautures/auth/domain/usecases/logout.dart';
import 'package:new_challenge/feautures/auth/domain/usecases/try_auto_login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase login;
  final LogoutUseCase logout;
  final TryAutoLoginUseCase tryAutoLogin;
  final CreateAccountUseCase createAccoun;
  AuthBloc({
    required this.login,
    required this.logout,
    required this.tryAutoLogin,
    required this.createAccoun,
  }) : super(LoggingInState()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoadingState());
        final failureOrDone = await login(event.email, event.password);
        failureOrDone.fold((failure) {
          emit(ErrorState(message: failure.errorMessage));
        }, (data) {
          emit(LoggedInState(authModel: data));
        });
      } else if (event is TryAutoLoginEvent) {
        emit(LoggingInState());
        final failureOrDone = await tryAutoLogin();
        failureOrDone.fold((failure) {
          emit(const LoggedOutState(goToLoginPage: false));
        }, (data) {
          emit(LoggedInState(authModel: data));
        });
      } else if (event is LogoutEvent) {
        emit(LoadingState());
        final failureOrDone = await logout();
        failureOrDone.fold((failure) {
          emit(ErrorState(message: failure.errorMessage));
        }, (data) {
          emit(const LoggedOutState(goToLoginPage: false));
        });
      } else if (event is CreateAccountEvent) {
        emit(LoadingState());
        final failureOrDone = await createAccoun(event.email, event.password);
        failureOrDone.fold((failure) {
          emit(ErrorState(message: failure.errorMessage));
        }, (data) {
          emit(const LoggedOutState(goToLoginPage: true));
        });
      }
    });
  }
}
