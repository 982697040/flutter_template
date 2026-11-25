import 'package:flutter_template/core/error/app_exception.dart';

/// 函数式结果封装类型（基于 Dart 3 sealed class）
///
/// 用于 Repository 与 UseCase 的返回值，显式表达操作可能成功（[Success]）
/// 或失败（[Failure]），避免在业务代码中到处散落 try-catch 导致异常漏处理。
///
/// 使用示例：
/// ```dart
/// final Result<User> result = await userRepository.getProfile();
/// result.when(
///   success: (user) => AppLogger.i('加载成功: ${user.name}'),
///   failure: (error) => AppLogger.e('加载失败: ${error.message}'),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// 当前结果是否为成功状态
  bool get isSuccess => this is Success<T>;

  /// 当前结果是否为失败状态
  bool get isFailure => this is Failure<T>;

  /// 获取成功数据；若当前为失败状态则返回 null
  T? get dataOrNull => switch (this) {
        Success<T>(:final T data) => data,
        Failure<T>() => null,
      };

  /// 获取异常信息；若当前为成功状态则返回 null
  AppException? get errorOrNull => switch (this) {
        Success<T>() => null,
        Failure<T>(:final AppException exception) => exception,
      };

  /// 分支折叠处理：强制调用方同时处理成功和失败两种结果
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException exception) failure,
  }) {
    return switch (this) {
      Success<T>(:final T data) => success(data),
      Failure<T>(:final AppException exception) => failure(exception),
    };
  }

  /// 对成功数据进行映射转换，失败状态保持原样透传
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success<T>(:final T data) => Success<R>(transform(data)),
      Failure<T>(:final AppException exception) => Failure<R>(exception),
    };
  }

  /// 获取数据，若失败则直接抛出内部 [AppException]
  ///
  /// 适合在 Riverpod `FutureProvider` / `AsyncNotifier` 中使用，
  /// 由 Riverpod 自动接管为 `AsyncError`。
  T getOrThrow() {
    return switch (this) {
      Success<T>(:final T data) => data,
      Failure<T>(:final AppException exception) => throw exception,
    };
  }
}

/// 操作成功结果
final class Success<T> extends Result<T> {
  const Success(this.data);

  /// 成功返回的业务数据
  final T data;
}

/// 操作失败结果
final class Failure<T> extends Result<T> {
  const Failure(this.exception);

  /// 标准化后的应用异常对象
  final AppException exception;
}
