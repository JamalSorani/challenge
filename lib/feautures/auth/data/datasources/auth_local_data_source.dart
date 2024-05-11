import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:new_challenge/core/error/exception.dart';
import 'package:new_challenge/feautures/auth/data/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDateSource {
  Future<AuthModel> getCachedAuthData();
  Future<Unit> cachAuthData(AuthModel authModel);
  Future<Unit> clearCache();
}

const cachedAuth = 'CACHED_AUTH';

class AuthLocalDateSourceImp implements AuthLocalDateSource {
  final SharedPreferences sharedPreferences;

  const AuthLocalDateSourceImp({required this.sharedPreferences});
  @override
  Future<Unit> cachAuthData(AuthModel authModel) {
    final authModelToJson = authModel.toJson();
    sharedPreferences.setString(cachedAuth, json.encode(authModelToJson));
    return Future.value(unit);
  }

  @override
  Future<AuthModel> getCachedAuthData() {
    final jsonString = sharedPreferences.getString(cachedAuth);
    if (jsonString != null) {
      final decodeJsonData = json.decode(jsonString);
      AuthModel jsonToAuthModel = AuthModel.fromJson(decodeJsonData);
      return Future.value(jsonToAuthModel);
    } else {
      throw ServerException(errorMessage: 'no data');
    }
  }

  @override
  Future<Unit> clearCache() async {
    sharedPreferences.clear();
    return Future.value(unit);
  }
}
