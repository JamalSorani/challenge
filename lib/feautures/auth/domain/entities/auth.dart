import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  final int? id;
  final String email;
  final String? password;
  final String? token;
  final bool isFirstLogin;
  const Auth({
    this.id,
    required this.email,
    this.password,
    this.token,
    required this.isFirstLogin,
  });

  @override
  List<Object?> get props => [id, email, password];
}
