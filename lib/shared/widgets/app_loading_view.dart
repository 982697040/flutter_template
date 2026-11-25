import 'package:flutter/material.dart';
import 'package:flutter_template/core/extensions/context_extension.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';

/// 通用加载状态占位组件
///
/// 在页面首次异步加载数据期间使用，保证全应用 Loading 视觉一致。
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({
    super.key,
    this.message,
  });

  /// 可选加载文案，为空时自动展示国际化默认文案
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: AppSpacing.md),
          Text(
            message ?? context.l10n.loading,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
