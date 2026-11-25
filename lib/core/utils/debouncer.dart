import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_template/core/constants/app_constants.dart';

/// 防抖工具类（Debounce）
///
/// 适用场景：搜索框实时联想、窗口尺寸变化响应等高频输入场景。
/// 每次触发时重置计时器，仅在最后一次触发经过 [duration] 后才真正执行回调。
/// 使用完毕务必在 `dispose()` 中调用 [dispose] 释放定时器，防止内存泄漏。
class Debouncer {
  Debouncer({
    this.duration = AppConstants.searchDebounceDuration,
  });

  /// 防抖延迟时长
  final Duration duration;

  Timer? _timer;

  /// 提交待执行任务，若上一次任务尚未执行则自动取消
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// 立即取消待执行的定时任务并释放资源
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

/// 节流工具类（Throttle）
///
/// 适用场景：表单提交按钮防连点、支付确认按钮等需要限制点击频率的场景。
/// 在 [duration] 时间窗口内，仅执行第一次触发，忽略后续重复点击。
class Throttler {
  Throttler({
    this.duration = AppConstants.buttonThrottleDuration,
  });

  /// 节流冷却时长
  final Duration duration;

  DateTime? _lastExecutedAt;

  /// 若已超过冷却期则执行 [action]，否则忽略本次调用
  void run(VoidCallback action) {
    final DateTime now = DateTime.now();
    if (_lastExecutedAt == null ||
        now.difference(_lastExecutedAt!) >= duration) {
      _lastExecutedAt = now;
      action();
    }
  }
}
