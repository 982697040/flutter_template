import 'package:flutter_template/bootstrap.dart';
import 'package:flutter_template/core/config/env_config.dart';

/// 预发布 / 测试环境专用入口
///
/// 启动命令：`flutter run -t lib/main_staging.dart`
Future<void> main() async {
  await bootstrap(EnvConfig.staging());
}
