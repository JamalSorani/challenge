import 'package:new_challenge/core/error/failures.dart';
import 'package:new_challenge/feautures/auth/data/models/auth_model.dart';
import 'package:new_challenge/feautures/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class TryAutoLoginUseCase {
  final AuthRepository repository;

  TryAutoLoginUseCase({required this.repository});
  Future<Either<Failure, AuthModel>> call() async {
    return await repository.tryAutoLogin();
  }
}
