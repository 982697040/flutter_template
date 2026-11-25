import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template/core/constants/storage_keys.dart';

/// 敏感数据加密存储抽象接口
///
/// 专用于存储 Token、用户密钥等敏感信息，底层分别映射：
/// - Android: EncryptedSharedPreferences / Android Keystore
/// - iOS / macOS: Keychain
abstract interface class SecureStorageService {
  /// 读取敏感字符串
  Future<String?> read(String key);

  /// 写入敏感字符串
  Future<void> write(String key, String value);

  /// 删除指定 Key 的敏感数据
  Future<void> delete(String key);

  /// 清空所有加密存储数据（通常在退出登录时调用）
  Future<void> clearAll();

  /// 便捷方法：读取 Access Token
  Future<String?> getAccessToken();

  /// 便捷方法：写入 Access Token
  Future<void> saveAccessToken(String token);

  /// 便捷方法：读取 Refresh Token
  Future<String?> getRefreshToken();

  /// 便捷方法：写入 Refresh Token
  Future<void> saveRefreshToken(String token);

  /// 便捷方法：清除所有认证令牌
  Future<void> clearTokens();
}

/// 基于 [FlutterSecureStorage] 的默认加密存储实现
class FlutterSecureStorageService implements SecureStorageService {
  FlutterSecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> clearAll() => _storage.deleteAll();

  @override
  Future<String?> getAccessToken() => read(StorageKeys.accessToken);

  @override
  Future<void> saveAccessToken(String token) =>
      write(StorageKeys.accessToken, token);

  @override
  Future<String?> getRefreshToken() => read(StorageKeys.refreshToken);

  @override
  Future<void> saveRefreshToken(String token) =>
      write(StorageKeys.refreshToken, token);

  @override
  Future<void> clearTokens() async {
    await delete(StorageKeys.accessToken);
    await delete(StorageKeys.refreshToken);
  }
}

/// 内存态敏感存储实现（专用于单元测试，避免触发原生通道）
class InMemorySecureStorageService implements SecureStorageService {
  final Map<String, String> _store = <String, String>{};

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> write(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clearAll() async {
    _store.clear();
  }

  @override
  Future<String?> getAccessToken() => read(StorageKeys.accessToken);

  @override
  Future<void> saveAccessToken(String token) =>
      write(StorageKeys.accessToken, token);

  @override
  Future<String?> getRefreshToken() => read(StorageKeys.refreshToken);

  @override
  Future<void> saveRefreshToken(String token) =>
      write(StorageKeys.refreshToken, token);

  @override
  Future<void> clearTokens() async {
    await delete(StorageKeys.accessToken);
    await delete(StorageKeys.refreshToken);
  }
}
