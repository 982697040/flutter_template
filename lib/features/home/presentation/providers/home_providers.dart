import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/error/result.dart';
import 'package:flutter_template/core/network/dio_client.dart';
import 'package:flutter_template/core/network/network_providers.dart';
import 'package:flutter_template/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flutter_template/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_template/features/home/domain/entities/app_overview_entity.dart';
import 'package:flutter_template/features/home/domain/repositories/home_repository.dart';

/// 首页远程数据源 Provider
final Provider<HomeRemoteDataSource> homeRemoteDataSourceProvider =
    Provider<HomeRemoteDataSource>(
  (Ref ref) {
    final DioClient dioClient = ref.watch(dioClientProvider);
    return HomeRemoteDataSourceImpl(dioClient);
  },
  name: 'homeRemoteDataSourceProvider',
);

/// 首页仓储 Provider（对外仅暴露抽象接口 [HomeRepository]）
final Provider<HomeRepository> homeRepositoryProvider =
    Provider<HomeRepository>(
  (Ref ref) {
    final HomeRemoteDataSource remoteDataSource =
        ref.watch(homeRemoteDataSourceProvider);
    return HomeRepositoryImpl(remoteDataSource);
  },
  name: 'homeRepositoryProvider',
);

/// 首页概览状态管理器 Provider（AsyncNotifier 标准范式）
///
/// 演示企业级异步页面状态的完整闭环：加载中（Loading）、数据态（Data）、异常态（Error）及刷新/重试。
final AsyncNotifierProvider<HomeOverviewController, AppOverviewEntity>
    homeOverviewControllerProvider =
    AsyncNotifierProvider<HomeOverviewController, AppOverviewEntity>(
  HomeOverviewController.new,
  name: 'homeOverviewControllerProvider',
);

/// 首页概览状态控制器
class HomeOverviewController extends AsyncNotifier<AppOverviewEntity> {
  @override
  Future<AppOverviewEntity> build() async {
    return _loadOverview();
  }

  /// 主动刷新首页概览数据
  Future<void> refresh({bool simulateFailure = false}) async {
    state = const AsyncLoading<AppOverviewEntity>();
    state = await AsyncValue.guard<AppOverviewEntity>(
      () => _loadOverview(simulateFailure: simulateFailure),
    );
  }

  /// 调用仓储并借助 [Result.getOrThrow] 交由 Riverpod 统一管理异常状态
  Future<AppOverviewEntity> _loadOverview({
    bool simulateFailure = false,
  }) async {
    final HomeRepository repository = ref.read(homeRepositoryProvider);
    final Result<AppOverviewEntity> result = await repository.getOverview(
      simulateFailure: simulateFailure,
    );
    return result.getOrThrow();
  }
}
