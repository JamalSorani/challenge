import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:new_challenge/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:new_challenge/feautures/auth/data/models/auth_model.dart';

abstract class AuthRemoteDateSource {
  Future<Unit> createUser(String email, String password);
  Future<AuthModel> login(String email, String password);
  Future<Unit> logout();
  Future<Unit> confirmAccount(String email, String code);
  Future<Unit> generateResetPasswordCode(String email);
  Future<Unit> checkIfResetPasswordCodeIsCorrect(String email, String code);
  Future<Unit> changePassword(
      String email, String restPasswordCode, String newPassword);
}

const String baseUrl =
    'http://challenge1234567-001-site1.anytempurl.com/swagger/index.html/User/';

class AuthRemoteDateSourceImp implements AuthRemoteDateSource {
  final http.Client client;

  AuthRemoteDateSourceImp({required this.client});
  String? _token;

  @override
  Future<AuthModel> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/Login');
    final header = {
      "Content-Type": "application/json",
      "Authorizationn": _token ?? '',
    };
    final response = await client.post(
      url,
      headers: header,
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      _token = responseData['token'];
      return AuthModel(
        id: responseData['id'],
        email: responseData['email'],
        token: responseData['token'],
        isFirstLogin: responseData['isFirstLogin'],
      );
    } else {
      print('jamal     ${responseData['errorMessage']}');
      throw ServerException(errorMessage: responseData['errorMessage']);
    }
  }

  @override
  Future<Unit> logout() async {
    final header = {
      'Content-Type': 'application/json',
      'Authorization': _token ?? '',
    };
    final response = await client.get(
      Uri.parse("$baseUrl/Logout"),
      headers: header,
    );
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      final responseData = json.decode(response.body);
      throw ServerException(errorMessage: responseData['errorMessage']);
    }
  }

  @override
  Future<Unit> createUser(String email, String password) {
    final body = {
      'email': email,
      'password': password,
    };
    return _post(body, 'CreateUser');
  }

  @override
  Future<Unit> confirmAccount(String email, String code) {
    final body = {
      'email': email,
      'code': code,
    };
    return _post(body, 'ConfirmAccount');
  }

  @override
  Future<Unit> generateResetPasswordCode(String email) {
    final body = {
      'email': email,
    };
    return _post(body, 'GenerateResetPasswordCode');
  }

  @override
  Future<Unit> checkIfResetPasswordCodeIsCorrect(
      String email, String code) async {
    final body = {
      'email': email,
      'code': code,
    };
    return _post(body, 'CheckIfResetPasswordCodeIsCorrect');
  }

  @override
  Future<Unit> changePassword(
      String email, String restPasswordCode, String newPassword) async {
    final body = {
      'email': email,
      'restPasswordCode': restPasswordCode,
      'newPassword': newPassword,
    };
    final header = {
      'Content-Type': 'application/json',
      'Authorization': _token ?? '',
    };
    final response = await client.put(
      Uri.parse("$baseUrl/CreateUser"),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      final responseData = json.decode(response.body);
      throw ServerException(errorMessage: responseData['errorMessage']);
    }
  }

  Future<Unit> _post(Map<String, dynamic> body, String urlSegment) async {
    final header = {
      'Content-Type': 'application/json',
      'Authorization': _token ?? '',
    };
    final response = await client.post(
      Uri.parse("$baseUrl/$urlSegment"),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      final responseData = json.decode(response.body);
      throw ServerException(errorMessage: responseData['errorMessage']);
    }
  }
}
