import 'package:new_challenge/core/error/failures.dart';
import 'package:new_challenge/feautures/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class CheckIfResetPasswordCodeIsCorrectUseCase {
  final AuthRepository repository;

  CheckIfResetPasswordCodeIsCorrectUseCase({required this.repository});
  Future<Either<Failure, Unit>> call(String email, String code) async {
    return await repository.checkIfResetPasswordCodeIsCorrect(email, code);
  }
}
