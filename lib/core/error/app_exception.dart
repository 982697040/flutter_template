/// 统一业务与系统异常基类（使用 Dart 3 sealed class 实现穷尽式模式匹配）
///
/// 所有来自网络层、本地存储层、数据解析层以及业务规则校验层的异常，
/// 均应转换为 [AppException] 子类后再向 Domain / Presentation 层传递，
/// 确保 UI 层能以类型安全的方式进行精细化提示和恢复。
sealed class AppException implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.cause,
    this.stackTrace,
  });

  /// 面向开发或兜底展示的错误描述信息
  final String message;

  /// 错误码（可为 HTTP 状态码或后端约定的业务错误码）
  final int? code;

  /// 原始异常对象，便于日志记录和问题溯源
  final Object? cause;

  /// 异常堆栈信息
  final StackTrace? stackTrace;

  @override
  String toString() =>
      '$runtimeType(code: $code, message: $message, cause: $cause)';
}

/// 网络连接异常（无网络、DNS 解析失败、连接中断等）
final class NetworkException extends AppException {
  const NetworkException({
    super.message = '网络连接异常，请检查网络设置',
    super.code,
    super.cause,
    super.stackTrace,
  });
}

/// 请求超时异常（连接超时、发送超时、接收超时）
final class TimeoutException extends AppException {
  const TimeoutException({
    super.message = '请求超时，请稍后重试',
    super.code,
    super.cause,
    super.stackTrace,
  });
}

/// 认证与授权异常（HTTP 401/403 或 Token 失效）
final class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = '登录状态已失效，请重新登录',
    super.code = 401,
    super.cause,
    super.stackTrace,
  });
}

/// 服务端异常（HTTP 5xx 或网关错误）
final class ServerException extends AppException {
  const ServerException({
    super.message = '服务器繁忙，请稍后再试',
    super.code,
    super.cause,
    super.stackTrace,
  });
}

/// 业务逻辑异常（HTTP 200，但后端业务码非成功状态，如余额不足、参数不合法等）
final class BusinessException extends AppException {
  const BusinessException({
    required super.message,
    super.code,
    super.cause,
    super.stackTrace,
  });
}

/// 请求被主动取消异常（如页面销毁时通过 CancelToken 取消请求）
final class RequestCancelledException extends AppException {
  const RequestCancelledException({
    super.message = '请求已取消',
    super.code,
    super.cause,
    super.stackTrace,
  });
}

/// 本地缓存或持久化读写异常
final class StorageException extends AppException {
  const StorageException({
    super.message = '本地数据读写失败',
    super.code,
    super.cause,
    super.stackTrace,
  });
}

/// 数据格式解析异常（JSON 字段缺失、类型不匹配等）
final class ParseException extends AppException {
  const ParseException({
    super.message = '数据解析异常',
    super.code,
    super.cause,
    super.stackTrace,
  });
}

/// 兜底未知异常
final class UnknownException extends AppException {
  const UnknownException({
    super.message = '发生未知异常，请稍后重试',
    super.code,
    super.cause,
    super.stackTrace,
  });
}
