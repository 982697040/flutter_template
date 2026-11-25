import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/config/env_config.dart';
import 'package:flutter_template/core/logger/app_logger.dart';

/// 全局异常捕获与上报中心
///
/// 负责统一接管三类未捕获异常：
/// 1. Flutter 框架层渲染/构建异常（[FlutterError.onError]）
/// 2. 平台调度层异步异常（[PlatformDispatcher.instance.onError]）
/// 3. Zone 沙箱内未捕获的 Dart 异步异常（`runZonedGuarded`）
///
/// 生产环境可在此集中接入 Sentry / Firebase Crashlytics / 阿里云 EMAS 等监控 SDK。
abstract final class GlobalErrorHandler {
  /// 初始化全局异常捕获钩子与 Release 模式错误 Widget 兜底
  static void initialize() {
    // 1. 捕获 Flutter 框架层异常（如布局溢出、build 异常等）
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        // 开发环境下保留默认控制台红字输出，方便定位
        FlutterError.presentError(details);
      }
      reportError(
        details.exception,
        details.stack ?? StackTrace.current,
        source: 'FlutterError',
      );
    };

    // 2. 捕获未进入 FlutterError 的顶层异步异常
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      reportError(error, stack, source: 'PlatformDispatcher');
      // 返回 true 表示异常已被统一处理，避免进程非预期终止
      return true;
    };

    // 3. Release 模式下用友好兜底界面替换默认“红屏/灰屏”，提升线上用户体验
    if (kReleaseMode) {
      ErrorWidget.builder = (FlutterErrorDetails details) {
        return const Material(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    '页面渲染出现异常，请稍后重试',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      };
    }
  }

  /// 统一异常记录与远程上报入口
  static void reportError(
    Object error,
    StackTrace stackTrace, {
    String source = 'Zone',
  }) {
    AppLogger.e(
      '捕获未处理异常 ($source)',
      tag: 'GlobalError',
      error: error,
      stackTrace: stackTrace,
    );

    if (EnvConfig.current.enableCrashReporting) {
      // TODO(crash-reporting): 接入 Sentry / Firebase Crashlytics 上报 SDK
      // 示例：Sentry.captureException(error, stackTrace: stackTrace);
    }
  }
}
