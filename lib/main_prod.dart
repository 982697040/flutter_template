import 'package:flutter_template/bootstrap.dart';
import 'package:flutter_template/core/config/env_config.dart';

/// 生产环境专用入口
///
/// 构建命令：`flutter build apk -t lib/main_prod.dart --release`
Future<void> main() async {
  await bootstrap(EnvConfig.prod());
}
