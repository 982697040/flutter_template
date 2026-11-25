import 'package:dio/dio.dart';
import 'package:flutter_template/core/config/env_config.dart';
import 'package:flutter_template/core/logger/app_logger.dart';

/// 网络请求与响应格式化日志拦截器
///
/// 仅在 [EnvConfig.enableLog] 开启时输出请求详情，避免生产环境泄露敏感报文或影响性能。
class AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (EnvConfig.current.enableLog) {
      AppLogger.d(
        '>>> [${options.method}] ${options.uri}\n'
        'Headers: ${_sanitizeHeaders(options.headers)}\n'
        'Query: ${options.queryParameters}\n'
        'Body: ${options.data}',
        tag: 'HTTP',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (EnvConfig.current.enableLog) {
      AppLogger.d(
        '<<< [${response.statusCode}] ${response.requestOptions.uri}\n'
        'Data: ${response.data}',
        tag: 'HTTP',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (EnvConfig.current.enableLog) {
      AppLogger.e(
        'xxx [${err.response?.statusCode ?? err.type.name}] '
        '${err.requestOptions.uri}\n'
        'Message: ${err.message}\n'
        'Response: ${err.response?.data}',
        tag: 'HTTP',
        error: err.error,
        stackTrace: err.stackTrace,
      );
    }
    handler.next(err);
  }

  /// 对日志中的敏感请求头（如 Authorization）进行脱敏处理，防止凭据明文落盘
  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final Map<String, dynamic> sanitized = Map<String, dynamic>.from(headers);
    if (sanitized.containsKey('Authorization')) {
      sanitized['Authorization'] = 'Bearer ***';
    }
    return sanitized;
  }
}
