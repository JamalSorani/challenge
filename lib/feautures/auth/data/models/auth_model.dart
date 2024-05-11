import 'package:new_challenge/feautures/auth/domain/entities/auth.dart';

class AuthModel extends Auth {
  const AuthModel(
      {super.id,
      required super.email,
      super.password,
      super.token,
      required super.isFirstLogin});
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        token: json['token'],
        isFirstLogin: json['isFirstLogin']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'token': token,
      'isFirstLogin': isFirstLogin,
    };
  }
}
