/// 本地持久化存储 Key 统一管理
///
/// 严禁在业务代码中手写裸字符串作为本地缓存 Key，统一在此注册以防冲突和拼写错误。
abstract final class StorageKeys {
  // -------------------- 普通配置项（SharedPreferences） --------------------

  /// 用户选择的主题模式（system / light / dark）
  static const String themeMode = 'app_theme_mode';

  /// 用户选择的语言代码（空表示跟随系统，如 zh / en）
  static const String localeCode = 'app_locale_code';

  /// 是否已完成首次引导页
  static const String onboardingCompleted = 'app_onboarding_completed';

  // -------------------- 敏感凭据项（FlutterSecureStorage） --------------------

  /// 登录态访问令牌（Access Token）
  static const String accessToken = 'secure_access_token';

  /// 登录态刷新令牌（Refresh Token）
  static const String refreshToken = 'secure_refresh_token';
}
