/// 应用级全局常量定义
///
/// 避免在业务代码中散落魔法数字与硬编码字符串，所有全局配置常量集中在此维护。
abstract final class AppConstants {
  /// 框架模板版本号（用于关于页面或调试信息展示）
  static const String frameworkVersion = '1.0.0';

  /// 网络连接超时时间（毫秒）
  static const Duration connectTimeout = Duration(seconds: 15);

  /// 网络发送数据超时时间
  static const Duration sendTimeout = Duration(seconds: 15);

  /// 网络接收响应超时时间
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// 列表分页默认每页条数
  static const int defaultPageSize = 20;

  /// 搜索框默认防抖延迟时间
  static const Duration searchDebounceDuration = Duration(milliseconds: 400);

  /// 按钮防连点默认节流间隔
  static const Duration buttonThrottleDuration = Duration(milliseconds: 600);
}
