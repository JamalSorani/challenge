import 'package:dartz/dartz.dart';
import 'package:new_challenge/feautures/auth/data/models/auth_model.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> createAccount(String email, String password);
  Future<Either<Failure, AuthModel>> login(String email, String password);
  Future<Either<Failure, AuthModel>> tryAutoLogin();
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, Unit>> confirmAccount(String email, String code);
  Future<Either<Failure, Unit>> generateResetPasswordCode(String email);
  Future<Either<Failure, Unit>> checkIfResetPasswordCodeIsCorrect(
      String email, String code);
  Future<Either<Failure, Unit>> changePassword(
      String email, String restPasswordCode, String newPassword);
}
