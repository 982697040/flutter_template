import 'package:flutter/material.dart';
import 'package:flutter_template/core/extensions/context_extension.dart';

/// 通用业务页面骨架组件
///
/// 统一封装企业级页面的常规交互体验：
/// 1. 点击空白区域自动收起软键盘；
/// 2. 统一 [SafeArea] 安全区控制（支持全面屏与刘海屏）；
/// 3. 简化标题栏与页面主体布局配置。
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.useSafeArea = true,
  });

  /// 页面主体内容
  final Widget body;

  /// 页面标题文本（为 null 时不渲染默认 AppBar）
  final String? title;

  /// AppBar 右侧操作按钮列表
  final List<Widget>? actions;

  /// 悬浮操作按钮
  final Widget? floatingActionButton;

  /// 底部导航栏
  final Widget? bottomNavigationBar;

  /// 是否自动启用 [SafeArea] 保护
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: context.unfocus,
      child: Scaffold(
        appBar: title != null
            ? AppBar(
                title: Text(title!),
                actions: actions,
              )
            : null,
        body: useSafeArea ? SafeArea(child: body) : body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
