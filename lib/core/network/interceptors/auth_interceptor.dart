import 'package:dio/dio.dart';
import 'package:flutter_template/core/logger/app_logger.dart';
import 'package:flutter_template/core/storage/secure_storage_service.dart';

/// 认证与授权拦截器
///
/// 职责：
/// 1. 在每次请求发送前，自动从 [SecureStorageService] 读取 Access Token 并注入 `Authorization` 请求头；
/// 2. 支持通过 `options.extra['requiresAuth'] = false` 跳过无需鉴权的接口（如登录、注册、公开接口）；
/// 3. 当服务端返回 HTTP 401 时，触发统一未授权回调（可用于无感刷新 Token 或清空登录态跳转登录页）。
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required SecureStorageService secureStorage,
    this.onUnauthorized,
  }) : _secureStorage = secureStorage;

  final SecureStorageService _secureStorage;

  /// 当收到 HTTP 401 未授权响应时的统一处理回调
  final Future<void> Function()? onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final bool requiresAuth = options.extra['requiresAuth'] as bool? ?? true;
    if (requiresAuth) {
      final String? token = await _secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      AppLogger.w('检测到 HTTP 401 未授权响应，触发认证失效处理', tag: 'AuthInterceptor');
      await _secureStorage.clearTokens();
      if (onUnauthorized != null) {
        await onUnauthorized!();
      }
    }
    handler.next(err);
  }
}
