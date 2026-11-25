import 'package:flutter/material.dart';
import 'package:flutter_template/core/extensions/context_extension.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';

/// 通用空数据占位视图
///
/// 当列表或详情返回空数据时统一展示，支持可选的操作按钮（如“去创建”或“刷新”）。
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  /// 空状态提示文案，默认使用国际化文案
  final String? message;

  /// 占位图标
  final IconData icon;

  /// 可选底部引导操作组件
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 56,
              color: context.colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message ?? context.l10n.emptyData,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
