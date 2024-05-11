import 'package:new_challenge/core/error/failures.dart';
import 'package:new_challenge/feautures/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ConfirmAccountUseCase {
  final AuthRepository repository;

  ConfirmAccountUseCase({required this.repository});
  Future<Either<Failure, Unit>> call(String email, String code) async {
    return await repository.confirmAccount(email, code);
  }
}
