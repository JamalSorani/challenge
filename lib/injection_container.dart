import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_challenge/core/network/network_info.dart';
import 'package:new_challenge/feautures/auth/data/datasources/auth_local_data_source.dart';
import 'package:new_challenge/feautures/auth/data/datasources/auth_remote_data_source.dart';
import 'package:new_challenge/feautures/auth/data/repositories/auth_repository_imp.dart';
import 'package:new_challenge/feautures/auth/domain/repositories/auth_repository.dart';
import 'package:new_challenge/feautures/auth/domain/usecases/change_password.dart';
import 'package:new_challenge/feautures/auth/domain/usecases/check_if_reset_password_code_is_correct.dart';
import 'package:new_challenge/feautures/auth/domain/usecases/confirm_account.dart';
import 'package:new_challenge/feautures/auth/domain/usecases/create_account.dart';
import 'package:new_challenge/feautures/auth/domain/usecases/generate_reset_password_code.dart';
import 'package:new_challenge/feautures/auth/domain/usecases/login.dart';
import 'package:new_challenge/feautures/auth/domain/usecases/logout.dart';
import 'package:new_challenge/feautures/auth/domain/usecases/try_auto_login.dart';
import 'package:new_challenge/feautures/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //bloc
  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
      logout: sl(),
      tryAutoLogin: sl(),
      createAccoun: sl(),
    ),
  );

  //usecases
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateAccountUseCase(repository: sl()));
  sl.registerLazySingleton(
      () => GenerateResetPasswordCodeUseCase(repository: sl()));
  sl.registerLazySingleton(() => ConfirmAccountUseCase(repository: sl()));
  sl.registerLazySingleton(
      () => CheckIfResetPasswordCodeIsCorrectUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(repository: sl()));
  sl.registerLazySingleton(() => TryAutoLoginUseCase(repository: sl()));

  //repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImp(
        remoteDateSource: sl(),
        localDateSource: sl(),
        networkInfo: sl(),
      ));

  //dateSources
  sl.registerLazySingleton<AuthRemoteDateSource>(
      () => AuthRemoteDateSourceImp(client: sl()));
  sl.registerLazySingleton<AuthLocalDateSource>(
      () => AuthLocalDateSourceImp(sharedPreferences: sl()));

  //core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImp(sl()));

  //external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
