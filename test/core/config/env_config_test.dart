import 'package:flutter_template/core/config/env_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnvConfig 多环境配置单元测试', () {
    test('AppEnv.fromName 应能正确解析合法环境名并支持未知值回退到 dev', () {
      expect(AppEnv.fromName('dev'), AppEnv.dev);
      expect(AppEnv.fromName('STAGING'), AppEnv.staging);
      expect(AppEnv.fromName('prod'), AppEnv.prod);
      expect(AppEnv.fromName('unknown_env'), AppEnv.dev);
    });

    test('各环境工厂方法应返回对应的日志与上报开关配置', () {
      final EnvConfig dev = EnvConfig.dev();
      expect(dev.isDev, isTrue);
      expect(dev.enableLog, isTrue);
      expect(dev.enableCrashReporting, isFalse);

      final EnvConfig staging = EnvConfig.staging();
      expect(staging.isStaging, isTrue);
      expect(staging.enableLog, isTrue);
      expect(staging.enableCrashReporting, isTrue);

      final EnvConfig prod = EnvConfig.prod();
      expect(prod.isProd, isTrue);
      expect(prod.enableLog, isFalse);
      expect(prod.enableCrashReporting, isTrue);
    });
  });
}
