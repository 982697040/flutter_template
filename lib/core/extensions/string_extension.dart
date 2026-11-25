/// 可空 [String] 常用判断扩展
extension NullableStringX on String? {
  /// 判断字符串是否为 null、空串或纯空白字符
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  /// 判断字符串是否包含有效非空内容
  bool get isNotNullOrBlank => !isNullOrBlank;
}

/// 非空 [String] 常用处理扩展
extension StringX on String {
  /// 首字母大写
  String get capitalized {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// 手机号脱敏显示（如 `138****8888`）
  String get maskedPhone {
    if (length != 11) {
      return this;
    }
    return '${substring(0, 3)}****${substring(7)}';
  }
}
