/// 后端统一 JSON 响应体协议封装
///
/// 企业级后端接口通常遵循统一的包装结构，例如：
/// ```json
/// {
///   "code": 0,
///   "message": "success",
///   "data": { ... }
/// }
/// ```
/// 若后端约定成功码为 200 或字段名为 `msg` / `result`，可统一在此类调整，
/// 业务层无需关心最外层协议差异。
class ApiResponse<T> {
  const ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  /// 业务状态码（约定 0 或 200 表示成功）
  final int code;

  /// 业务提示信息
  final String message;

  /// 反序列化后的业务数据体
  final T? data;

  /// 判断业务请求是否成功
  bool get isSuccess => code == 0 || code == 200;

  /// 从原始 JSON Map 解析响应体
  ///
  /// [fromJsonT] 用于将 `data` 字段转换为强类型业务模型 [T]。
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final Object? rawCode = json['code'];
    final int parsedCode = switch (rawCode) {
      final int value => value,
      final String value => int.tryParse(value) ?? -1,
      _ => -1,
    };

    final String parsedMessage =
        (json['message'] ?? json['msg'] ?? '').toString();

    final Object? rawData = json['data'];

    return ApiResponse<T>(
      code: parsedCode,
      message: parsedMessage,
      data: rawData != null ? fromJsonT(rawData) : null,
    );
  }
}
