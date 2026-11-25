/// 通用表单字段校验器集合
///
/// 所有校验方法均兼容 Flutter `TextFormField.validator` 签名：
/// - 校验通过返回 `null`；
/// - 校验失败返回面向用户的错误提示文本。
abstract final class Validators {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _chinaPhoneRegex = RegExp(r'^1[3-9]\d{9}$');

  /// 必填校验
  static String? required(String? value, {String message = '此项为必填项'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  /// 邮箱格式校验
  static String? email(String? value, {String message = '请输入正确的邮箱格式'}) {
    if (value == null || value.trim().isEmpty) {
      return '请输入邮箱地址';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return message;
    }
    return null;
  }

  /// 中国大陆手机号格式校验
  static String? phone(String? value, {String message = '请输入正确的 11 位手机号'}) {
    if (value == null || value.trim().isEmpty) {
      return '请输入手机号';
    }
    if (!_chinaPhoneRegex.hasMatch(value.trim())) {
      return message;
    }
    return null;
  }

  /// 密码强度校验（默认至少 8 位且包含字母与数字）
  static String? password(
    String? value, {
    int minLength = 8,
    String? message,
  }) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < minLength) {
      return message ?? '密码长度不能少于 $minLength 位';
    }
    final bool hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
    final bool hasDigit = RegExp(r'\d').hasMatch(value);
    if (!hasLetter || !hasDigit) {
      return message ?? '密码需同时包含字母和数字';
    }
    return null;
  }
}
