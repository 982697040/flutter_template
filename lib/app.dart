import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/config/env_config.dart';
import 'package:flutter_template/core/router/app_router.dart';
import 'package:flutter_template/core/theme/app_theme.dart';
import 'package:flutter_template/core/theme/theme_controller.dart';
import 'package:flutter_template/l10n/locale_controller.dart';
import 'package:go_router/go_router.dart';

/// 应用顶层根 Widget
///
/// 职责仅限于装配全局基础设施：
/// - 主题系统（浅色 / 深色 / 跟随系统）
/// - 国际化系统（简体中文 / English / 跟随系统）
/// - 声明式路由（[GoRouter]）
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(appRouterProvider);
    final ThemeMode themeMode = ref.watch(themeControllerProvider);
    final Locale? locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appTitle,
      // 仅在非生产环境或需要时显示 Debug 标识，企业项目通常默认隐藏以保持界面整洁
      debugShowCheckedModeBanner: EnvConfig.current.isDev,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
    );
  }
}
