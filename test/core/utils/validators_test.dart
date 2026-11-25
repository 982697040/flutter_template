import 'package:flutter_template/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators 表单校验器单元测试', () {
    test('required 校验空值与正常文本', () {
      expect(Validators.required(null), isNotNull);
      expect(Validators.required('   '), isNotNull);
      expect(Validators.required('hello'), isNull);
    });

    test('email 校验合法与非法邮箱格式', () {
      expect(Validators.email('dev@example.com'), isNull);
      expect(Validators.email('invalid-email'), isNotNull);
    });

    test('phone 校验中国大陆手机号格式', () {
      expect(Validators.phone('13800138000'), isNull);
      expect(Validators.phone('12345'), isNotNull);
    });

    test('password 校验长度及字母数字组合要求', () {
      expect(Validators.password('Abc12345'), isNull);
      expect(Validators.password('12345678'), isNotNull);
      expect(Validators.password('abc123'), isNotNull);
    });
  });
}
