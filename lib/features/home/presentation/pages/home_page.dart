import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/extensions/context_extension.dart';
import 'package:flutter_template/core/router/route_paths.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/features/home/domain/entities/app_overview_entity.dart';
import 'package:flutter_template/features/home/presentation/providers/home_providers.dart';
import 'package:flutter_template/shared/widgets/app_error_view.dart';
import 'package:flutter_template/shared/widgets/app_loading_view.dart';
import 'package:flutter_template/shared/widgets/app_scaffold.dart';
import 'package:go_router/go_router.dart';

/// 首页示例页面（展示框架基础设施就绪状态与标准状态消费范式）
///
/// 正式业务开发时可直接清空或替换本页内容，保留相同的分层接入方式即可。
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppOverviewEntity> overviewState =
        ref.watch(homeOverviewControllerProvider);

    return AppScaffold(
      title: context.l10n.homeTitle,
      actions: <Widget>[
        IconButton(
          tooltip: context.l10n.settingsTitle,
          onPressed: () => context.push(RoutePaths.settings),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
      body: overviewState.when(
        loading: () => const AppLoadingView(),
        error: (Object error, StackTrace stackTrace) => AppErrorView(
          error: error,
          onRetry: () =>
              ref.read(homeOverviewControllerProvider.notifier).refresh(),
        ),
        data: (AppOverviewEntity overview) => _HomeContent(
          overview: overview,
          onRefresh: () async {
            await ref.read(homeOverviewControllerProvider.notifier).refresh();
            if (context.mounted) {
              context.showSnackBar(context.l10n.refreshSuccess);
            }
          },
          onSimulateError: () => ref
              .read(homeOverviewControllerProvider.notifier)
              .refresh(simulateFailure: true),
          onOpenSettings: () => context.push(RoutePaths.settings),
        ),
      ),
    );
  }
}

/// 首页主体内容拆分为独立无状态子组件，避免单一 build 方法过长
class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.overview,
    required this.onRefresh,
    required this.onSimulateError,
    required this.onOpenSettings,
  });

  final AppOverviewEntity overview;
  final Future<void> Function() onRefresh;
  final VoidCallback onSimulateError;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: AppSpacing.pagePadding,
        children: <Widget>[
          // 顶部欢迎卡片
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.verified_outlined,
                        color: context.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          context.l10n.welcomeTitle,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.l10n.welcomeSubtitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 环境与架构信息卡片
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.l10n.aboutSection,
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _InfoRow(
                    label: context.l10n.currentEnvironment,
                    value: overview.environmentName,
                  ),
                  const Divider(height: AppSpacing.xl),
                  _InfoRow(
                    label: context.l10n.apiBaseUrl,
                    value: overview.apiBaseUrl,
                  ),
                  const Divider(height: AppSpacing.xl),
                  _InfoRow(
                    label: context.l10n.frameworkVersion,
                    value: 'v${overview.frameworkVersion}',
                  ),
                  const Divider(height: AppSpacing.xl),
                  _InfoRow(
                    label: context.l10n.architecturePattern,
                    value: context.l10n.architecturePatternValue,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 快速能力验证操作区
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.l10n.quickActions,
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: onOpenSettings,
                        icon: const Icon(Icons.tune_rounded),
                        label: Text(context.l10n.openSettings),
                      ),
                      OutlinedButton.icon(
                        onPressed: onRefresh,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(context.l10n.simulateRefresh),
                      ),
                      OutlinedButton.icon(
                        onPressed: onSimulateError,
                        icon: const Icon(Icons.bug_report_outlined),
                        label: Text(context.l10n.simulateError),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 键值对展示行组件
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 112,
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
