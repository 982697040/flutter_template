import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/constants/storage_keys.dart';
import 'package:flutter_template/core/storage/storage_providers.dart';
import 'package:flutter_template/core/storage/storage_service.dart';

/// 全局语言环境状态控制器 Provider
///
/// - 状态为 `null` 时表示“跟随系统语言”；
/// - 状态为具体 [Locale]（如 `Locale('zh')` / `Locale('en')`）时强制使用指定语言。
final NotifierProvider<LocaleController, Locale?> localeControllerProvider =
    NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
  name: 'localeControllerProvider',
);

/// 国际化语言状态管理器
class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() {
    final StorageService storage = ref.watch(storageServiceProvider);
    final String? savedCode = storage.getString(StorageKeys.localeCode);
    if (savedCode == null || savedCode.isEmpty) {
      return null;
    }
    return Locale(savedCode);
  }

  /// 切换应用语言并持久化；传入 `null` 表示恢复“跟随系统”
  Future<void> setLocale(Locale? locale) async {
    if (state == locale) {
      return;
    }
    state = locale;
    final StorageService storage = ref.read(storageServiceProvider);
    if (locale == null) {
      await storage.remove(StorageKeys.localeCode);
    } else {
      await storage.setString(StorageKeys.localeCode, locale.languageCode);
    }
  }
}
