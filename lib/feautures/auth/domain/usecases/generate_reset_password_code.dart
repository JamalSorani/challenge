import 'package:new_challenge/core/error/failures.dart';
import 'package:new_challenge/feautures/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class GenerateResetPasswordCodeUseCase {
  final AuthRepository repository;

  GenerateResetPasswordCodeUseCase({required this.repository});
  Future<Either<Failure, Unit>> call(String email) async {
    return await repository.generateResetPasswordCode(email);
  }
}
