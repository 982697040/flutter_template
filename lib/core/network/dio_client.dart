import 'package:dio/dio.dart';
import 'package:flutter_template/core/config/env_config.dart';
import 'package:flutter_template/core/constants/app_constants.dart';
import 'package:flutter_template/core/error/app_exception.dart';
import 'package:flutter_template/core/error/result.dart';
import 'package:flutter_template/core/network/api_response.dart';
import 'package:flutter_template/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_template/core/network/interceptors/error_interceptor.dart';
import 'package:flutter_template/core/network/interceptors/log_interceptor.dart';
import 'package:flutter_template/core/storage/secure_storage_service.dart';

/// 企业级网络请求客户端封装
///
/// 统一封装 GET / POST / PUT / DELETE 等常用 HTTP 方法：
/// - 自动注入基础域名、超时配置、公共请求头；
/// - 内置认证拦截器、日志拦截器、异常转换拦截器；
/// - 统一返回 [Result<T>]，业务数据源无需重复编写 try-catch 和外层协议解包逻辑。
class DioClient {
  DioClient({
    required SecureStorageService secureStorage,
    EnvConfig? envConfig,
    Future<void> Function()? onUnauthorized,
    Dio? dio,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: (envConfig ?? EnvConfig.current).apiBaseUrl,
                connectTimeout: AppConstants.connectTimeout,
                sendTimeout: AppConstants.sendTimeout,
                receiveTimeout: AppConstants.receiveTimeout,
                headers: const <String, dynamic>{
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
              ),
            ) {
    // 按执行顺序注册拦截器：认证 -> 日志 -> 异常标准化
    _dio.interceptors.addAll(<Interceptor>[
      AuthInterceptor(
        secureStorage: secureStorage,
        onUnauthorized: onUnauthorized,
      ),
      AppLogInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  final Dio _dio;

  /// 暴露底层 [Dio] 实例，供文件上传/下载等特殊场景使用
  Dio get rawDio => _dio;

  /// 发送 GET 请求并解包标准 [ApiResponse]
  Future<Result<T>> get<T>(
    String path, {
    required T Function(Object? json) parser,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      () => _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      parser: parser,
    );
  }

  /// 发送 POST 请求并解包标准 [ApiResponse]
  Future<Result<T>> post<T>(
    String path, {
    required T Function(Object? json) parser,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      () => _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      parser: parser,
    );
  }

  /// 发送 PUT 请求并解包标准 [ApiResponse]
  Future<Result<T>> put<T>(
    String path, {
    required T Function(Object? json) parser,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      () => _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      parser: parser,
    );
  }

  /// 发送 DELETE 请求并解包标准 [ApiResponse]
  Future<Result<T>> delete<T>(
    String path, {
    required T Function(Object? json) parser,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      () => _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      parser: parser,
    );
  }

  /// 核心请求执行器：统一解包后端协议、校验业务码并捕获所有异常转为 [Failure]
  Future<Result<T>> _request<T>(
    Future<Response<dynamic>> Function() executor, {
    required T Function(Object? json) parser,
  }) async {
    try {
      final Response<dynamic> response = await executor();
      final dynamic rawData = response.data;

      if (rawData is! Map<String, dynamic>) {
        return Failure<T>(
          ParseException(
            message: '服务端响应格式不符合 JSON 对象规范',
            cause: rawData,
          ),
        );
      }

      final ApiResponse<T> apiResponse = ApiResponse<T>.fromJson(
        rawData,
        parser,
      );

      if (!apiResponse.isSuccess) {
        return Failure<T>(
          BusinessException(
            code: apiResponse.code,
            message: apiResponse.message.isNotEmpty
                ? apiResponse.message
                : '业务处理失败',
          ),
        );
      }

      // 允许 Void / Nullable 泛型返回 null
      if (apiResponse.data is T) {
        return Success<T>(apiResponse.data as T);
      }

      return Failure<T>(
        const ParseException(message: '接口返回 data 字段为空或类型不匹配'),
      );
    } on DioException catch (e) {
      final Object? mappedError = e.error;
      if (mappedError is AppException) {
        return Failure<T>(mappedError);
      }
      return Failure<T>(DioErrorMapper.map(e));
    } on AppException catch (e) {
      return Failure<T>(e);
    } catch (e, stackTrace) {
      return Failure<T>(
        ParseException(
          message: '响应数据反序列化失败',
          cause: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
