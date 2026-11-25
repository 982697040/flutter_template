/// 应用全局路由路径与路由名称常量
///
/// 禁止在业务跳转中手写硬编码路径字符串（如 `context.go('/settings')`），
/// 统一通过 [RoutePaths] / [RouteNames] 引用，降低重构风险。
abstract final class RoutePaths {
  /// 首页 / 工作台
  static const String home = '/';

  /// 系统设置页
  static const String settings = '/settings';
}

/// 命名路由名称常量（配合 `context.goNamed` / `context.pushNamed` 使用）
abstract final class RouteNames {
  static const String home = 'home';
  static const String settings = 'settings';
}
