import 'package:flutter_template/core/error/result.dart';
import 'package:flutter_template/features/home/domain/entities/app_overview_entity.dart';

/// 首页模块仓储抽象接口（Domain Layer）
///
/// 遵循依赖倒置原则（DIP）：
/// Domain / Presentation 层仅依赖此抽象接口，具体数据来源（网络接口、本地数据库或 Mock）
/// 由 Data 层的实现类 [HomeRepositoryImpl] 决定。
abstract interface class HomeRepository {
  /// 获取首页系统概览数据
  ///
  /// [simulateFailure] 仅用于模板演示错误兜底视图，接入真实业务接口后可移除。
  Future<Result<AppOverviewEntity>> getOverview({
    bool simulateFailure = false,
  });
}
