import 'package:new_challenge/core/error/failures.dart';
import 'package:new_challenge/feautures/auth/data/models/auth_model.dart';
import 'package:new_challenge/feautures/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});
  Future<Either<Failure, AuthModel>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
