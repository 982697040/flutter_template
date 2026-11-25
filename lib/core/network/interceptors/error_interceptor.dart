import 'package:dio/dio.dart';
import 'package:flutter_template/core/error/app_exception.dart';

/// 网络异常标准化转换器
///
/// 将底层 [DioException] 映射为领域层可统一识别的 [AppException] 子类，
/// 彻底屏蔽第三方网络库异常细节，避免上层业务代码耦合 Dio。
abstract final class DioErrorMapper {
  /// 将 [DioException] 转换为标准的 [AppException]
  static AppException map(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return TimeoutException(
          cause: err,
          stackTrace: err.stackTrace,
        );

      case DioExceptionType.cancel:
        return RequestCancelledException(
          cause: err,
          stackTrace: err.stackTrace,
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return NetworkException(
          cause: err,
          stackTrace: err.stackTrace,
        );

      case DioExceptionType.badResponse:
        return _mapStatusCode(err);

      case DioExceptionType.unknown:
        return UnknownException(
          message: err.message ?? '发生未知网络错误，请稍后重试',
          cause: err,
          stackTrace: err.stackTrace,
        );
    }
  }

  /// 根据 HTTP 状态码与服务端响应体精细化映射异常类型
  static AppException _mapStatusCode(DioException err) {
    final int? statusCode = err.response?.statusCode;
    final String? serverMessage = _extractServerMessage(err.response?.data);

    if (statusCode == 401 || statusCode == 403) {
      return UnauthorizedException(
        message: serverMessage ?? '登录状态已失效，请重新登录',
        code: statusCode,
        cause: err,
        stackTrace: err.stackTrace,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return ServerException(
        message: serverMessage ?? '服务器繁忙（$statusCode），请稍后再试',
        code: statusCode,
        cause: err,
        stackTrace: err.stackTrace,
      );
    }

    return BusinessException(
      message: serverMessage ?? '请求处理失败（$statusCode）',
      code: statusCode,
      cause: err,
      stackTrace: err.stackTrace,
    );
  }

  /// 尝试从服务端错误响应体中提取友好错误信息
  static String? _extractServerMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final Object? msg = data['message'] ?? data['msg'] ?? data['error'];
      if (msg is String && msg.isNotEmpty) {
        return msg;
      }
    }
    return null;
  }
}

/// Dio 错误拦截器：将标准化后的 [AppException] 挂载至 [DioException.error]
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final AppException appException = DioErrorMapper.map(err);
    handler.next(
      err.copyWith(error: appException),
    );
  }
}
