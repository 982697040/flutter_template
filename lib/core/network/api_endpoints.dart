/// 后端 API 相对路径统一注册表
///
/// 所有网络请求的接口路径必须在此集中管理，禁止在数据源中硬编码分散的 URL。
/// 完整请求地址 = [EnvConfig.apiBaseUrl] + 相对路径。
abstract final class ApiEndpoints {
  /// 系统健康检查 / 首页概览示例接口
  static const String appOverview = '/app/overview';

  /// 用户认证相关接口占位示例
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String userProfile = '/user/profile';
}
