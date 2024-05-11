import 'package:dartz/dartz.dart';
import 'package:new_challenge/core/error/exception.dart';
import 'package:new_challenge/core/error/failures.dart';
import 'package:new_challenge/core/network/network_info.dart';
import 'package:new_challenge/feautures/auth/data/datasources/auth_local_data_source.dart';
import 'package:new_challenge/feautures/auth/data/datasources/auth_remote_data_source.dart';
import 'package:new_challenge/feautures/auth/data/models/auth_model.dart';
import 'package:new_challenge/feautures/auth/domain/repositories/auth_repository.dart';

typedef Auth = Future<Unit> Function();

class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDateSource remoteDateSource;
  final AuthLocalDateSource localDateSource;
  final NetworkInfo networkInfo;

  const AuthRepositoryImp(
      {required this.remoteDateSource,
      required this.localDateSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, AuthModel>> login(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAuth = await remoteDateSource.login(email, password);
        localDateSource.cachAuthData(remoteAuth);
        print('jamal  done');
        return Right(remoteAuth);
      } catch (error) {
        print('jamal  ${error.toString()}');
        return Left(Failure(errorMessage: error.toString()));
      }
    } else {
      try {
        final localAuth = await localDateSource.getCachedAuthData();
        return Right(localAuth);
      } on ServerException {
        return left(const Failure(errorMessage: 'no internet connection'));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> createAccount(
      String email, String password) async {
    return await _getMessage(
        () => remoteDateSource.createUser(email, password));
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    return await _getMessage(() {
      localDateSource.clearCache();
      return remoteDateSource.logout();
    });
  }

  @override
  Future<Either<Failure, Unit>> confirmAccount(
      String email, String code) async {
    return await _getMessage(() {
      return remoteDateSource.confirmAccount(email, code);
    });
  }

  @override
  Future<Either<Failure, Unit>> generateResetPasswordCode(String email) async {
    return await _getMessage(() {
      return remoteDateSource.generateResetPasswordCode(email);
    });
  }

  @override
  Future<Either<Failure, Unit>> checkIfResetPasswordCodeIsCorrect(
      String email, String code) async {
    return await _getMessage(() {
      return remoteDateSource.checkIfResetPasswordCodeIsCorrect(email, code);
    });
  }

  @override
  Future<Either<Failure, Unit>> changePassword(
      String email, String restPasswordCode, String newPassword) async {
    return await _getMessage(() {
      return remoteDateSource.changePassword(
          email, restPasswordCode, newPassword);
    });
  }

  Future<Either<Failure, Unit>> _getMessage(Auth auth) async {
    if (await networkInfo.isConnected) {
      try {
        return const Right(unit);
      } catch (error) {
        return Left(Failure(errorMessage: error.toString()));
      }
    } else {
      return left(const Failure(errorMessage: 'no internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthModel>> tryAutoLogin() async {
    try {
      final localAuth = await localDateSource.getCachedAuthData();
      return Right(localAuth);
    } on ServerException {
      return left(const Failure(errorMessage: 'no cached data'));
    }
  }
}
