// 🎯 Dart imports:
import 'dart:developer';
import 'dart:io';

// 📦 Package imports:
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:new_challenge/core/types/types.dart';

// 🌎 Project imports:

import '../interceptors/dio_log_interceptor.dart';

// 🌎 Project imports:


class DioClient with DioMixin implements Dio {
  final BaseOptions? baseOptions;
  DioClient({
    required this.baseUrl,
    this.baseOptions,
    List<Interceptor> interceptors = const [],
  }) {
    httpClientAdapter = IOHttpClientAdapter(
      validateCertificate: (certificate, host, port) => true,
      createHttpClient: () {
        final HttpClient client = HttpClient(context: SecurityContext());
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );
    options = (baseOptions ?? BaseOptions()).copyWith(
      followRedirects: true,
      maxRedirects: 5,
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'lang': "en",
      },
    );

    this.interceptors.addAll([...interceptors, DioLogInterceptor()]);
  }

  final String baseUrl;

  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _mapException(
      () => super.get(
        path,
        queryParameters: queryParameters,
        options: options,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        data: data,
      ),
    );
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ResponseExceptionMapper? exceptionMapper,
  }) {
    return _mapException(
      () => super.post(
        path,
        data: data,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  @override
  Future<Response<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ResponseExceptionMapper? exceptionMapper,
  }) {
    return _mapException(
      () => super.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ResponseExceptionMapper? exceptionMapper,
  }) {
    return _mapException(
      () => super.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> _mapException<T>(
    HttpLibraryMethod<T> method, {
    ResponseExceptionMapper? mapper,
  }) async {
    try {
      return await method();
    } on DioException catch (exception) {
      final response = exception.response;
      final message = handleMessage(response?.data);
      final networkException = AppNetworkException(
        reason: _determineReason(exception),
        exception: exception,
        message: message,
      );

      if (exception.type == DioExceptionType.badResponse) {
        if (response == null || response is! Response<T>) {
          throw AppNetworkResponseException(
            exception: exception,
            message: message,
          );
        }
        throw mapper?.call(response, exception) ??
            AppNetworkResponseException(
              exception: exception,
              statusCode: response.statusCode,
              data: response.data,
              message: message,
            );
      }

      throw networkException;
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      throw AppException.unknown(
        exception: e is Exception ? e : Exception('Unknown exception occurred'),
        message: e.toString(),
      );
    }
  }

  AppNetworkExceptionReason _determineReason(DioException exception) {
    if (exception.response?.statusCode.toString().startsWith('5') ?? false) {
      return AppNetworkExceptionReason.serverError;
    }
    switch (exception.type) {
      case DioExceptionType.cancel:
        return AppNetworkExceptionReason.canceled;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return AppNetworkExceptionReason.timedOut;
      case DioExceptionType.unknown:
      case DioExceptionType.badResponse:
        return AppNetworkExceptionReason.responseError;
      default:
        if (exception.error is SocketException) {
          return AppNetworkExceptionReason.noInternet;
        }
        return AppNetworkExceptionReason.responseError;
    }
  }

  String handleMessage(dynamic exceptionResponse) =>
      (exceptionResponse is Map && exceptionResponse['message'] != null)
          ? (exceptionResponse['message'] ?? " Some thing happen")
          : 'Something happen '; //todo click to submit error
}
