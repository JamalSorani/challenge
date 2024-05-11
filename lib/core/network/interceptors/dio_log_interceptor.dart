// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:new_challenge/core/types/enums.dart';

// 🌎 Project imports:


// � Package imports:
// � Flutter imports:

extension OptionsExtension on RequestOptions {}

enum _StatusType { succeed, failed }

class DioLogInterceptor extends Interceptor {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      logger.i(
        "***|| ${options.method} ${options.uri} ||***"
        "\n param : ${options.queryParameters}"
        "\n token : ${options.headers['Authorization']}"
        "\n data : ${options.data}",
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _StatusType statusType;
      if (response.statusCode == StatusCode.operationSucceeded.code) {
        statusType = _StatusType.succeed;
      } else {
        statusType = _StatusType.failed;
      }

      logger.f(
        "***|| INFO Response Request ${response.requestOptions.uri.path} ${statusType == _StatusType.succeed ? '✊' : ''} ||***"
        "\n Status code: ${response.statusCode}"
        "\n Status message: ${response.statusMessage}"
        "\n Data: ${encoder.convert(response.data)}",
      );
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      Logger(printer: PrettyPrinter(methodCount: 8)).e(
        "***|| ${err.requestOptions.uri.path} ||***"
        "\n response: ${err.response}"
        "\n message: ${err.message}"
        "\n type: ${err.type}",
        error: err.error,
        stackTrace: err.stackTrace,
      );
    }
    handler.next(err);
  }
}
