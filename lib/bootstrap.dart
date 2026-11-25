import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/app.dart';
import 'package:flutter_template/core/config/env_config.dart';
import 'package:flutter_template/core/error/error_handler.dart';
import 'package:flutter_template/core/logger/app_logger.dart';
import 'package:flutter_template/core/logger/app_provider_observer.dart';
import 'package:flutter_template/core/storage/storage_providers.dart';
import 'package:flutter_template/core/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 应用统一启动引导函数
///
/// 所有环境入口（`main.dart` / `main_dev.dart` / `main_staging.dart` / `main_prod.dart`）
/// 均委托给 [bootstrap] 执行标准化初始化流程：
/// 1. 注入当前运行环境配置（[EnvConfig]）；
/// 2. 初始化 Flutter 引擎绑定与全局三层异常捕获机制；
/// 3. 配置系统 UI 样式（状态栏透明沉浸、屏幕方向策略等）；
/// 4. 预热异步核心依赖（如 [SharedPreferences]）；
/// 5. 挂载带状态观测能力的 [ProviderScope] 并启动根组件 [App]。
Future<void> bootstrap(EnvConfig config) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // 1. 初始化多环境配置
      EnvConfig.initialize(config);

      // 2. 初始化全局异常捕获与 Release 错误兜底视图
      GlobalErrorHandler.initialize();

      // 3. 配置状态栏/导航栏透明边缘到边缘视觉风格
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      );

      // 4. 预热本地持久化依赖，确保同步读取主题与语言配置无首屏闪烁
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final StorageService storageService = SharedPrefsStorageService(prefs);

      AppLogger.i(
        '应用启动成功 | 环境: ${config.displayName} | BaseURL: ${config.apiBaseUrl}',
        tag: 'Bootstrap',
      );

      // 5. 启动应用并注入核心依赖
      runApp(
        ProviderScope(
          observers: const <ProviderObserver>[
            AppProviderObserver(),
          ],
          overrides: <Override>[
            storageServiceProvider.overrideWithValue(storageService),
          ],
          child: const App(),
        ),
      );
    },
    (Object error, StackTrace stackTrace) {
      GlobalErrorHandler.reportError(error, stackTrace, source: 'runZonedGuarded');
    },
  );
}
