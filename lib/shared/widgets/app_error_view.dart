import 'package:flutter/material.dart';
import 'package:flutter_template/core/error/app_exception.dart';
import 'package:flutter_template/core/extensions/context_extension.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';

/// 通用错误状态占位视图（内置异常本地化映射与一键重试）
///
/// 接收任意异常对象（优先识别 [AppException]），自动展示友好提示，
/// 并支持通过 [onRetry] 回调触发重新加载。
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.error,
    this.onRetry,
  });

  /// 发生的异常对象（通常来自 [AsyncError.error] 或 [Failure.exception]）
  final Object error;

  /// 点击“重试”按钮时的回调，为空时不展示按钮
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final String displayMessage = _resolveMessage(context, error);

    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              displayMessage,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge,
            ),
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 将标准异常类型映射为当前语言的本地化文案
  String _resolveMessage(BuildContext context, Object error) {
    if (error is AppException) {
      return switch (error) {
        NetworkException() => context.l10n.networkError,
        TimeoutException() => context.l10n.timeoutError,
        UnauthorizedException() => context.l10n.unauthorizedError,
        ServerException() => context.l10n.serverError,
        BusinessException(:final String message) => message,
        RequestCancelledException(:final String message) => message,
        StorageException(:final String message) => message,
        ParseException(:final String message) => message,
        UnknownException() => context.l10n.unknownError,
      };
    }
    return context.l10n.unknownError;
  }
}
