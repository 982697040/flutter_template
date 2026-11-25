import 'package:flutter_template/core/config/env_config.dart';
import 'package:flutter_template/core/constants/app_constants.dart';
import 'package:flutter_template/core/error/app_exception.dart';
import 'package:flutter_template/core/error/result.dart';
import 'package:flutter_template/core/network/api_endpoints.dart';
import 'package:flutter_template/core/network/dio_client.dart';
import 'package:flutter_template/features/home/data/models/app_overview_model.dart';

/// 首页模块远程数据源抽象接口
abstract interface class HomeRemoteDataSource {
  /// 拉取系统概览数据
  Future<Result<AppOverviewModel>> fetchOverview({
    bool simulateFailure = false,
  });
}

/// 首页模块远程数据源默认实现
///
/// 当前为空项目模板默认演示实现：返回本地构造的环境概览模型，
/// 确保无后端环境时应用也能完整启动并验证分层数据流。
/// 接入真实接口时，直接取消下方 `_dioClient.get(...)` 注释即可。
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._dioClient);

  // 预留给真实业务接口调用的统一 Dio 客户端实例
  // ignore: unused_field
  final DioClient _dioClient;

  @override
  Future<Result<AppOverviewModel>> fetchOverview({
    bool simulateFailure = false,
  }) async {
    // -------------------------------------------------------------------------
    // 真实业务接口接入示例（上线前替换下方的本地演示数据即可）：
    //
    // return _dioClient.get<AppOverviewModel>(
    //   ApiEndpoints.appOverview,
    //   parser: (Object? json) => AppOverviewModel.fromJson(
    //     json! as Map<String, dynamic>,
    //   ),
    // );
    // -------------------------------------------------------------------------
    // 引用 ApiEndpoints 保持接口常量可追溯
    assert(ApiEndpoints.appOverview.isNotEmpty);

    // 模拟轻量异步网络延迟，便于验证 Loading 与刷新交互
    await Future<void>.delayed(const Duration(milliseconds: 200));

    if (simulateFailure) {
      return const Failure<AppOverviewModel>(
        NetworkException(),
      );
    }

    final EnvConfig config = EnvConfig.current;
    return Success<AppOverviewModel>(
      AppOverviewModel(
        environmentName: config.displayName,
        apiBaseUrl: config.apiBaseUrl,
        frameworkVersion: AppConstants.frameworkVersion,
        lastUpdatedAt: DateTime.now(),
      ),
    );
  }
}
