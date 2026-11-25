import 'package:shared_preferences/shared_preferences.dart';

/// 普通键值存储抽象接口
///
/// 通过依赖抽象接口而非直接依赖 `SharedPreferences`，便于：
/// 1. 单元测试时注入内存实现（[InMemoryStorageService]），无需依赖真机/平台通道；
/// 2. 未来无缝替换为 Hive / MMKV / Isar 等高性能存储引擎，业务代码零改动。
abstract interface class StorageService {
  /// 读取字符串值
  String? getString(String key);

  /// 写入字符串值
  Future<bool> setString(String key, String value);

  /// 读取布尔值
  bool? getBool(String key);

  /// 写入布尔值
  Future<bool> setBool(String key, bool value);

  /// 读取整数值
  int? getInt(String key);

  /// 写入整数值
  Future<bool> setInt(String key, int value);

  /// 删除指定 Key 的数据
  Future<bool> remove(String key);

  /// 清空所有普通本地缓存
  Future<bool> clear();
}

/// 基于 [SharedPreferences] 的默认持久化存储实现
class SharedPrefsStorageService implements StorageService {
  const SharedPrefsStorageService(this._prefs);

  final SharedPreferences _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  int? getInt(String key) => _prefs.getInt(key);

  @override
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  @override
  Future<bool> remove(String key) => _prefs.remove(key);

  @override
  Future<bool> clear() => _prefs.clear();
}

/// 内存态存储实现（主要用于单元测试或降级兜底）
class InMemoryStorageService implements StorageService {
  final Map<String, Object> _store = <String, Object>{};

  @override
  String? getString(String key) => _store[key] as String?;

  @override
  Future<bool> setString(String key, String value) async {
    _store[key] = value;
    return true;
  }

  @override
  bool? getBool(String key) => _store[key] as bool?;

  @override
  Future<bool> setBool(String key, bool value) async {
    _store[key] = value;
    return true;
  }

  @override
  int? getInt(String key) => _store[key] as int?;

  @override
  Future<bool> setInt(String key, int value) async {
    _store[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _store.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _store.clear();
    return true;
  }
}
