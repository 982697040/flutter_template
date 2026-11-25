import 'package:flutter_template/core/error/app_exception.dart';
import 'package:flutter_template/core/error/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result<T> 函数式结果封装单元测试', () {
    test('Success 应正确暴露数据并支持 map 映射', () {
      const Result<int> result = Success<int>(21);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, 21);
      expect(result.errorOrNull, isNull);
      expect(result.getOrThrow(), 21);

      final Result<String> mapped = result.map((int value) => '数值:$value');
      expect(mapped.dataOrNull, '数值:21');
    });

    test('Failure 应正确透传异常并在 getOrThrow 时抛出 AppException', () {
      const BusinessException error = BusinessException(
        code: 40001,
        message: '参数不合法',
      );
      const Result<int> result = Failure<int>(error);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.errorOrNull, error);
      expect(result.getOrThrow, throwsA(isA<BusinessException>()));

      final String message = result.when(
        success: (int data) => 'ok',
        failure: (AppException exception) => exception.message,
      );
      expect(message, '参数不合法');
    });
  });
}
