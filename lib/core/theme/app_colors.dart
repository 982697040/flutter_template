import 'package:flutter/material.dart';

/// 设计系统颜色规范
///
/// 禁止在业务页面中直接硬编码 `Color(0xFF...)` 魔法色值；
/// 优先通过 `Theme.of(context).colorScheme` 获取语义色，
/// 或引用本文件中统一维护的品牌色与语义状态色。
abstract final class AppColors {
  // -------------------- 品牌主色 --------------------

  /// 品牌主色（科技蓝，可根据公司视觉规范统一替换）
  static const Color primary = Color(0xFF1A66FF);

  /// 品牌辅助色
  static const Color secondary = Color(0xFF00B8A9);

  // -------------------- 语义状态色 --------------------

  /// 成功态（已完成、校验通过）
  static const Color success = Color(0xFF16A34A);

  /// 警告态（需要注意、弱提醒）
  static const Color warning = Color(0xFFD97706);

  /// 错误态（危险操作、失败提示）
  static const Color error = Color(0xFFDC2626);

  /// 信息态（常规通知、提示）
  static const Color info = Color(0xFF2563EB);

  // -------------------- 浅色模式下中性色 --------------------

  static const Color lightBackground = Color(0xFFF6F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0xFFE5E7EB);

  // -------------------- 深色模式下中性色 --------------------

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkDivider = Color(0xFF334155);
}
