import 'package:flutter_template/features/home/domain/entities/app_overview_entity.dart';

/// 首页系统概览数据传输模型（DTO / Data Model）
///
/// 负责 JSON 与 Dart 对象之间的序列化/反序列化，
/// 并通过 [toEntity] 转换为 Domain 层的纯业务实体，隔离后端字段命名变化。
class AppOverviewModel {
  const AppOverviewModel({
    required this.environmentName,
    required this.apiBaseUrl,
    required this.frameworkVersion,
    required this.lastUpdatedAt,
  });

  final String environmentName;
  final String apiBaseUrl;
  final String frameworkVersion;
  final DateTime lastUpdatedAt;

  /// 从后端 JSON 数据反序列化为 [AppOverviewModel]
  factory AppOverviewModel.fromJson(Map<String, dynamic> json) {
    return AppOverviewModel(
      environmentName: (json['environment_name'] ?? '').toString(),
      apiBaseUrl: (json['api_base_url'] ?? '').toString(),
      frameworkVersion: (json['framework_version'] ?? '').toString(),
      lastUpdatedAt: DateTime.tryParse(
            (json['last_updated_at'] ?? '').toString(),
          ) ??
          DateTime.now(),
    );
  }

  /// 序列化为 JSON Map
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'environment_name': environmentName,
      'api_base_url': apiBaseUrl,
      'framework_version': frameworkVersion,
      'last_updated_at': lastUpdatedAt.toIso8601String(),
    };
  }

  /// 转换为领域层实体 [AppOverviewEntity]
  AppOverviewEntity toEntity() {
    return AppOverviewEntity(
      environmentName: environmentName,
      apiBaseUrl: apiBaseUrl,
      frameworkVersion: frameworkVersion,
      lastUpdatedAt: lastUpdatedAt,
    );
  }
}
