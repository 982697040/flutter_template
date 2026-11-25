import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/config/env_config.dart';
import 'package:flutter_template/core/extensions/context_extension.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/theme/theme_controller.dart';
import 'package:flutter_template/l10n/locale_controller.dart';
import 'package:flutter_template/shared/widgets/app_scaffold.dart';

/// 系统设置页面
///
/// 演示框架内置的两大全局响应式能力：
/// 1. 深浅色主题即时切换与持久化（[themeControllerProvider]）；
/// 2. 中英文多语言即时切换与持久化（[localeControllerProvider]）。
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode currentThemeMode = ref.watch(themeControllerProvider);
    final Locale? currentLocale = ref.watch(localeControllerProvider);

    return AppScaffold(
      title: context.l10n.settingsTitle,
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: <Widget>[
          // 主题外观设置卡片
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.l10n.themeSetting,
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      segments: <ButtonSegment<ThemeMode>>[
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.system,
                          label: Text(context.l10n.themeSystem),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.light,
                          label: Text(context.l10n.themeLight),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.dark,
                          label: Text(context.l10n.themeDark),
                        ),
                      ],
                      selected: <ThemeMode>{currentThemeMode},
                      onSelectionChanged: (Set<ThemeMode> selection) {
                        ref
                            .read(themeControllerProvider.notifier)
                            .setThemeMode(selection.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 多语言设置卡片
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.l10n.languageSetting,
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.l10n.languageSystem),
                    value: '',
                    groupValue: currentLocale?.languageCode ?? '',
                    onChanged: (_) => ref
                        .read(localeControllerProvider.notifier)
                        .setLocale(null),
                  ),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.l10n.languageZh),
                    value: 'zh',
                    groupValue: currentLocale?.languageCode ?? '',
                    onChanged: (_) => ref
                        .read(localeControllerProvider.notifier)
                        .setLocale(const Locale('zh')),
                  ),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.l10n.languageEn),
                    value: 'en',
                    groupValue: currentLocale?.languageCode ?? '',
                    onChanged: (_) => ref
                        .read(localeControllerProvider.notifier)
                        .setLocale(const Locale('en')),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 当前构建环境信息
          Card(
            child: ListTile(
              leading: const Icon(Icons.dns_outlined),
              title: Text(context.l10n.currentEnvironment),
              subtitle: Text(
                '${EnvConfig.current.displayName}\n${EnvConfig.current.apiBaseUrl}',
              ),
              isThreeLine: true,
            ),
          ),
        ],
      ),
    );
  }
}
