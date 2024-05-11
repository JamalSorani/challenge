// 🎯 Dart imports:
import 'dart:async';
import 'dart:developer';

// 📦 Package imports:
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:new_challenge/core/types/app_exception.dart';
import 'package:new_challenge/core/types/types.dart';

// 🌎 Project imports:


import 'dio_override.dart';

// 📦 Package imports:




class Client {
  final String baseUrl;
  final List<Interceptor> interceptors;
  final BaseOptions? baseOptions;

  late final DioClient _client;
  Client({
    this.baseUrl = '',
    this.interceptors = const [],
    this.baseOptions,
  }) : _client = DioClient(
          baseUrl: baseUrl,
          interceptors: interceptors,
          baseOptions: baseOptions,
        );

  Future<Either<AppException, T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    return toApiResult(
      () => _client
          .get(
            path,
            data: data,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
            options: options,
            queryParameters: queryParameters,
          )
          .then((value) => fromJson(value.data!)),
    );
  }

  Future<Either<AppException, T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ResponseExceptionMapper? exceptionMapper,
    required T Function(Map<String, dynamic> json) fromJson,
  }) =>
      toApiResult(
        () => _client
            .post(
              path,
              cancelToken: cancelToken,
              data: data,
              exceptionMapper: exceptionMapper,
              onReceiveProgress: onReceiveProgress,
              onSendProgress: onSendProgress,
              queryParameters: queryParameters,
              options: options,
            )
            .then((value) => fromJson(value.data!)),
      );

  Future<Either<AppException, T?>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ResponseExceptionMapper? exceptionMapper,
    required T Function(Map<String, dynamic> json) fromJson,
  }) =>
      toApiResult(
        () => _client
            .put(
              path,
              data: data,
              cancelToken: cancelToken,
              exceptionMapper: exceptionMapper,
              onReceiveProgress: onReceiveProgress,
              onSendProgress: onSendProgress,
              options: options,
              queryParameters: queryParameters,
            )
            .then((value) => fromJson(value.data)),
      );

  Future<Either<AppException, T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ResponseExceptionMapper? exceptionMapper,
    required T Function(Map<String, dynamic> json) fromJson,
  }) =>
      toApiResult(
        () => _client
            .delete(
              path,
              cancelToken: cancelToken,
              data: data,
              exceptionMapper: exceptionMapper,
              options: options,
              queryParameters: queryParameters,
            )
            .then((value) => fromJson(value.data)),
      );

  String addBearer(String token) => 'Bearer $token';
}

Future<Either<AppException, T>> toApiResult<T>(FutureOr<T> Function() call) async {
  String? errorMessage;
  try {
    return Right(await call());
  } on AppNetworkResponseException catch (e) {
    if (e.data is! String) {
      errorMessage = e.message;
      return Left(e);
    }
    return Left(e);
  } on AppNetworkException catch (e) {
    errorMessage = e.message;
    return Left(e);
  } on AppException catch (e) {
    errorMessage = e.message;
    return Left(e);
  } catch (e, s) {
    log(e.toString(), stackTrace: s);
    final exception = AppException.unknown(exception: e, message: e.toString());
    return Left(exception);
  } finally {
    // if (errorMessage != null) AppToasts.showFailureMessage(errorMessage);
  }
}
