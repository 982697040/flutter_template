import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/storage/secure_storage_service.dart';
import 'package:flutter_template/core/storage/storage_service.dart';

/// 普通本地键值存储服务 Provider
///
/// 必须在应用启动引导阶段（`bootstrap.dart`）通过 `ProviderScope.overrides`
/// 注入已完成初始化的 [SharedPrefsStorageService] 实例。
/// 在单元测试中可直接 override 为 [InMemoryStorageService]。
final Provider<StorageService> storageServiceProvider =
    Provider<StorageService>(
  (Ref ref) => throw UnimplementedError(
    'storageServiceProvider 必须在 ProviderScope 中进行 override 初始化',
  ),
  name: 'storageServiceProvider',
);

/// 加密安全存储服务 Provider
///
/// 默认提供 [FlutterSecureStorageService]；在单元测试中可 override 为 [InMemorySecureStorageService]。
final Provider<SecureStorageService> secureStorageServiceProvider =
    Provider<SecureStorageService>(
  (Ref ref) => FlutterSecureStorageService(),
  name: 'secureStorageServiceProvider',
);
