import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/logger/app_logger.dart';
import 'package:flutter_template/core/network/dio_client.dart';
import 'package:flutter_template/core/storage/storage_providers.dart';

/// 全局网络客户端 [DioClient] Provider
///
/// 统一由 Riverpod 维护单例生命周期，自动注入加密存储服务与未授权回调。
final Provider<DioClient> dioClientProvider = Provider<DioClient>(
  (Ref ref) {
    final secureStorage = ref.watch(secureStorageServiceProvider);
    return DioClient(
      secureStorage: secureStorage,
      onUnauthorized: () async {
        // TODO(auth): 接入登录状态管理后，在此触发全局登出并跳转登录页
        AppLogger.w('用户认证失效，待重定向至登录页', tag: 'Network');
      },
    );
  },
  name: 'dioClientProvider',
);
