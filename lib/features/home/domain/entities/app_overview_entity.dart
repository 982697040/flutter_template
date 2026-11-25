/// 首页系统概览领域实体（Domain Entity）
///
/// 领域层实体应保持纯净、不可变，不依赖任何 JSON 序列化库或 UI 框架，
/// 仅承载核心业务数据结构与业务规则。
class AppOverviewEntity {
  const AppOverviewEntity({
    required this.environmentName,
    required this.apiBaseUrl,
    required this.frameworkVersion,
    required this.lastUpdatedAt,
  });

  /// 当前运行环境名称
  final String environmentName;

  /// 当前接口基础地址
  final String apiBaseUrl;

  /// 当前框架版本号
  final String frameworkVersion;

  /// 最近一次数据刷新时间
  final DateTime lastUpdatedAt;
}
