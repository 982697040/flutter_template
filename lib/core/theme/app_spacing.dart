import 'package:flutter/widgets.dart';

/// 设计系统间距规范（基于 4dp 栅格体系）
///
/// 统一使用规范常量控制留白与间距，保证多页面视觉节奏一致。
abstract final class AppSpacing {
  /// 极小间距：4dp
  static const double xs = 4;

  /// 小间距：8dp
  static const double sm = 8;

  /// 中等间距：12dp
  static const double md = 12;

  /// 默认常规间距（页面标准水平边距）：16dp
  static const double lg = 16;

  /// 较大间距（区块间隔）：24dp
  static const double xl = 24;

  /// 超大间距：32dp
  static const double xxl = 32;

  /// 页面标准内边距
  static const EdgeInsets pagePadding = EdgeInsets.all(lg);

  /// 卡片标准内边距
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
}

/// 设计系统圆角规范
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double full = 999;

  static final BorderRadius smBorder = BorderRadius.circular(sm);
  static final BorderRadius mdBorder = BorderRadius.circular(md);
  static final BorderRadius lgBorder = BorderRadius.circular(lg);
}
