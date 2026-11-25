import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// [BuildContext] 常用语法糖扩展
///
/// 减少页面代码中重复编写 `Theme.of(context)`、`MediaQuery.sizeOf(context)`、
/// `AppLocalizations.of(context)` 等模板代码，提升 UI 层可读性。
extension BuildContextX on BuildContext {
  /// 获取当前主题数据
  ThemeData get theme => Theme.of(this);

  /// 获取当前 Material 3 色彩方案
  ColorScheme get colorScheme => theme.colorScheme;

  /// 获取当前文字排版样式表
  TextTheme get textTheme => theme.textTheme;

  /// 获取当前语言环境的国际化词条实例
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// 获取当前屏幕尺寸（使用 `MediaQuery.sizeOf` 避免因键盘弹起触发无关重建）
  Size get screenSize => MediaQuery.sizeOf(this);

  /// 屏幕宽度
  double get screenWidth => screenSize.width;

  /// 屏幕高度
  double get screenHeight => screenSize.height;

  /// 当前是否为深色模式
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// 收起当前软键盘
  void unfocus() {
    final FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /// 统一展示轻量级底部提示条（SnackBar）
  void showSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 2),
  }) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(this);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          backgroundColor: isError ? colorScheme.error : null,
        ),
      );
  }
}
