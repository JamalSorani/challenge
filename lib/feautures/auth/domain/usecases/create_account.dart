import 'package:new_challenge/core/error/failures.dart';
import 'package:new_challenge/feautures/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class CreateAccountUseCase {
  final AuthRepository repository;

  CreateAccountUseCase({required this.repository});
  Future<Either<Failure, Unit>> call(String email, String password) async {
    return await repository.createAccount(email, password);
  }
}
