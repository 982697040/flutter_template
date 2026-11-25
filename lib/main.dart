import 'package:flutter_template/bootstrap.dart';
import 'package:flutter_template/core/config/env_config.dart';

/// 默认应用入口
///
/// 支持通过编译参数动态切换运行环境：
/// - 开发环境（默认）：`flutter run` 或 `flutter run --dart-define=ENV=dev`
/// - 预发布环境：`flutter run --dart-define=ENV=staging`
/// - 生产环境：`flutter run --dart-define=ENV=prod`
///
/// 也可直接指定对应环境的专用入口文件：`main_dev.dart` / `main_staging.dart` / `main_prod.dart`。
Future<void> main() async {
  const String envName = String.fromEnvironment('ENV', defaultValue: 'dev');
  final AppEnv env = AppEnv.fromName(envName);
  await bootstrap(EnvConfig.fromEnv(env));
}
