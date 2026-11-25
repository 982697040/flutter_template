import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/constants/storage_keys.dart';
import 'package:flutter_template/core/storage/storage_providers.dart';
import 'package:flutter_template/core/storage/storage_service.dart';

/// 全局主题模式状态控制器 Provider
///
/// 支持 `ThemeMode.system`（跟随系统）、`ThemeMode.light`（浅色）、`ThemeMode.dark`（深色），
/// 并在用户切换时自动持久化到本地存储。
final NotifierProvider<ThemeController, ThemeMode> themeControllerProvider =
    NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
  name: 'themeControllerProvider',
);

/// 主题模式状态管理器
class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final StorageService storage = ref.watch(storageServiceProvider);
    final String? savedMode = storage.getString(StorageKeys.themeMode);
    return _parseThemeMode(savedMode);
  }

  /// 更新主题模式并持久化到本地
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) {
      return;
    }
    state = mode;
    final StorageService storage = ref.read(storageServiceProvider);
    await storage.setString(StorageKeys.themeMode, mode.name);
  }

  /// 将存储字符串安全解析为 [ThemeMode]
  ThemeMode _parseThemeMode(String? value) {
    return ThemeMode.values.firstWhere(
      (ThemeMode mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}
