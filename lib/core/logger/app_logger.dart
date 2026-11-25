import 'package:flutter/foundation.dart';
import 'package:flutter_template/core/config/env_config.dart';
import 'package:logger/logger.dart';

/// 应用统一日志工具类
///
/// 禁止在项目中直接使用 `print()` 或 `debugPrint()` 随意打日志，
/// 统一通过 [AppLogger] 输出，以便按运行环境自动过滤日志级别，
/// 并支持后续对接本地日志文件持久化或远程日志平台。
abstract final class AppLogger {
  static final Logger _logger = Logger(
    filter: _EnvLogFilter(),
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 6,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// 调试日志（仅在开发 / 预发布环境输出）
  static void d(
    dynamic message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.d(_format(message, tag), error: error, stackTrace: stackTrace);
  }

  /// 常规信息日志（关键业务节点、生命周期事件）
  static void i(
    dynamic message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.i(_format(message, tag), error: error, stackTrace: stackTrace);
  }

  /// 警告日志（可恢复的异常状态或降级逻辑）
  static void w(
    dynamic message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.w(_format(message, tag), error: error, stackTrace: stackTrace);
  }

  /// 错误日志（业务或系统异常，建议携带 error 与 stackTrace）
  static void e(
    dynamic message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(_format(message, tag), error: error, stackTrace: stackTrace);
  }

  /// 拼接可选的模块标签，方便按模块检索日志
  static dynamic _format(dynamic message, String? tag) {
    if (tag == null || tag.isEmpty) {
      return message;
    }
    return '[$tag] $message';
  }
}

/// 基于当前运行环境的日志过滤器
///
/// - 生产环境关闭普通调试日志，仅在必要时保留错误日志输出；
/// - 开发及预发布环境开启完整日志，便于排查问题。
class _EnvLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kReleaseMode && !EnvConfig.current.enableLog) {
      return event.level.index >= Level.error.index;
    }
    return EnvConfig.current.enableLog || event.level.index >= Level.error.index;
  }
}
