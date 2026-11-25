import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/config/env_config.dart';
import 'package:flutter_template/core/logger/app_logger.dart';

/// Riverpod 全局状态变更监听器
///
/// 在开发环境下自动记录 Provider 的更新与异常事件，
/// 便于排查状态流转问题，类似于 Redux Logger。
class AppProviderObserver extends ProviderObserver {
  const AppProviderObserver();

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (!EnvConfig.current.enableLog) {
      return;
    }
    AppLogger.d(
      'Provider 更新: ${provider.name ?? provider.runtimeType} -> $newValue',
      tag: 'Riverpod',
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    AppLogger.e(
      'Provider 异常: ${provider.name ?? provider.runtimeType}',
      tag: 'Riverpod',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
