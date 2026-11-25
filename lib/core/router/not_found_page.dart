import 'package:flutter/material.dart';
import 'package:flutter_template/core/extensions/context_extension.dart';
import 'package:flutter_template/core/router/route_paths.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/shared/widgets/app_scaffold.dart';
import 'package:go_router/go_router.dart';

/// 404 路由未匹配兜底页面
///
/// 当通过 Deep Link、Web 地址栏或误操作访问到未注册路由时展示，
/// 引导用户一键安全返回首页。
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({
    super.key,
    required this.location,
  });

  /// 未能匹配的目标路径
  final String location;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.notFoundTitle,
      body: Center(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.explore_off_outlined,
                size: 64,
                color: context.colorScheme.outline,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                context.l10n.notFoundTitle,
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                context.l10n.notFoundDescription(location),
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () => context.go(RoutePaths.home),
                child: Text(context.l10n.backToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
