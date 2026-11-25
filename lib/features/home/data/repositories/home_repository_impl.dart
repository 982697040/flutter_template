import 'package:flutter_template/core/error/result.dart';
import 'package:flutter_template/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flutter_template/features/home/data/models/app_overview_model.dart';
import 'package:flutter_template/features/home/domain/entities/app_overview_entity.dart';
import 'package:flutter_template/features/home/domain/repositories/home_repository.dart';

/// 首页模块仓储实现类（Data Layer）
///
/// 协调远程数据源（及后续可扩展的本地缓存数据源），并将 Data Model 映射为 Domain Entity。
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Result<AppOverviewEntity>> getOverview({
    bool simulateFailure = false,
  }) async {
    final Result<AppOverviewModel> result =
        await _remoteDataSource.fetchOverview(
      simulateFailure: simulateFailure,
    );
    return result.map((AppOverviewModel model) => model.toEntity());
  }
}
