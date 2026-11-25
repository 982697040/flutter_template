/// 应用运行环境枚举
///
/// 通过不同入口文件（`main_dev.dart` / `main_staging.dart` / `main_prod.dart`）
/// 或编译参数 `--dart-define=ENV=dev|staging|prod` 切换环境。
enum AppEnv {
  /// 开发环境：开启详细日志、连接开发服务器
  dev,

  /// 预发布 / 测试环境：接近生产配置，用于联调与 QA 验收
  staging,

  /// 生产环境：关闭调试日志、开启线上错误上报
  prod;

  /// 根据字符串解析运行环境，无法识别时默认回退到 [AppEnv.dev]
  static AppEnv fromName(String name) {
    return AppEnv.values.firstWhere(
      (AppEnv e) => e.name == name.toLowerCase(),
      orElse: () => AppEnv.dev,
    );
  }
}

/// 多环境配置管理类
///
/// 集中管理各环境下的 API 地址、日志开关、错误上报开关等参数。
/// 支持通过 `--dart-define=API_BASE_URL=...` 在 CI/CD 打包时动态覆盖接口地址。
class EnvConfig {
  const EnvConfig._({
    required this.env,
    required this.appName,
    required this.apiBaseUrl,
    required this.enableLog,
    required this.enableCrashReporting,
  });

  /// 当前运行环境类型
  final AppEnv env;

  /// 当前环境对应的应用显示名称
  final String appName;

  /// 后端接口基础地址（Base URL）
  final String apiBaseUrl;

  /// 是否启用控制台日志输出（含网络请求与状态变更日志）
  final bool enableLog;

  /// 是否启用线上崩溃与异常上报（如 Sentry / Firebase Crashlytics）
  final bool enableCrashReporting;

  /// 是否为开发环境
  bool get isDev => env == AppEnv.dev;

  /// 是否为预发布环境
  bool get isStaging => env == AppEnv.staging;

  /// 是否为生产环境
  bool get isProd => env == AppEnv.prod;

  /// 编译期注入的自定义接口地址（可选）
  static const String _dartDefineBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  /// 全局当前生效的环境配置实例
  static EnvConfig _current = EnvConfig.dev();

  /// 获取当前生效的环境配置
  static EnvConfig get current => _current;

  /// 初始化全局环境配置（仅在应用启动引导阶段调用）
  static void initialize(EnvConfig config) {
    _current = config;
  }

  /// 根据 [AppEnv] 枚举创建对应环境配置
  factory EnvConfig.fromEnv(AppEnv env) {
    switch (env) {
      case AppEnv.dev:
        return EnvConfig.dev();
      case AppEnv.staging:
        return EnvConfig.staging();
      case AppEnv.prod:
        return EnvConfig.prod();
    }
  }

  /// 开发环境默认配置
  factory EnvConfig.dev() {
    return EnvConfig._(
      env: AppEnv.dev,
      appName: 'Flutter Template (Dev)',
      apiBaseUrl: _dartDefineBaseUrl.isNotEmpty
          ? _dartDefineBaseUrl
          : 'https://dev-api.example.com/v1',
      enableLog: true,
      enableCrashReporting: false,
    );
  }

  /// 预发布 / 测试环境默认配置
  factory EnvConfig.staging() {
    return EnvConfig._(
      env: AppEnv.staging,
      appName: 'Flutter Template (Staging)',
      apiBaseUrl: _dartDefineBaseUrl.isNotEmpty
          ? _dartDefineBaseUrl
          : 'https://staging-api.example.com/v1',
      enableLog: true,
      enableCrashReporting: true,
    );
  }

  /// 生产环境默认配置
  factory EnvConfig.prod() {
    return EnvConfig._(
      env: AppEnv.prod,
      appName: 'Flutter Template',
      apiBaseUrl: _dartDefineBaseUrl.isNotEmpty
          ? _dartDefineBaseUrl
          : 'https://api.example.com/v1',
      enableLog: false,
      enableCrashReporting: true,
    );
  }

  /// 环境中文名称展示
  String get displayName {
    switch (env) {
      case AppEnv.dev:
        return '开发环境 (DEV)';
      case AppEnv.staging:
        return '预发布环境 (STAGING)';
      case AppEnv.prod:
        return '生产环境 (PROD)';
    }
  }
}
