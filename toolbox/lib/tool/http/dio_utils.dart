
import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toolbox/constants/constant.dart';
import 'package:toolbox/constants/event.dart';
import 'package:toolbox/log/log.dart';
import 'package:toolbox/tool/event_bus_utils.dart';
import 'package:flustars/flustars.dart';
import 'base_result_entity.dart';
import 'error_handle.dart';

/// 默认dio配置
int _connectTimeout = 5*60000;
int _receiveTimeout = 5*60000;
int _sendTimeout = 5*60000;
String _baseUrl = "";
List<Interceptor> _interceptors = [];
bool _ignoreCertificate = false;

/// 初始化Dio配置 需要在app main中调用该方法初始化下
void setInitDio({
  int connectTimeout,
  int receiveTimeout,
  int sendTimeout,
  String baseUrl,
  List<Interceptor> interceptors,
  bool ignoreCertificate,
}) {
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _baseUrl = baseUrl ?? _baseUrl;
  _interceptors = interceptors ?? _interceptors;
  _ignoreCertificate = ignoreCertificate ?? _ignoreCertificate;
}

typedef NetSuccessSourceCallback<T> = Function(BaseResultEntity<T> data);
typedef NetSuccessCallback<T> = Function(BaseResultEntity<T> data);
typedef NetErrorCallback = Function(int code, String msg);

/// @weilu https://github.com/simplezhli
class DioUtils {

  static final DioUtils _singleton = DioUtils._();

  static DioUtils get instance => DioUtils();

  factory DioUtils() => _singleton;

  static Dio _dio;

  Dio get dio => _dio;

  DioUtils._() {
    BaseOptions _options = BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
      /// dio默认json解析，这里指定返回UTF8字符串，自己处理解析。（可也以自定义Transformer实现）
      responseType: ResponseType.plain,
      validateStatus: (_) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      baseUrl: _baseUrl,
//  contentType: ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8'),
    );
    _dio = Dio(_options);
    /// Fiddler抓包代理配置 https://www.jianshu.com/p/d831b1f7c45b
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
//      client.findProxy = (uri) {
//        //proxy all request to localhost:8888
//        return 'PROXY 10.41.0.132:8888';
//      };
          ///忽略证书
          if(_ignoreCertificate) {
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
          }
    };

    /// 添加拦截器
    _interceptors.forEach((interceptor) {
      _dio.interceptors.add(interceptor);
    });
  }

  static BuildContext context;

  Future<BaseResultEntity<T>> dioRequest<T> (String method, String url, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,}) async {
    final Response<String> response = await _dio.request<String>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: _checkOptions(method, options),
      cancelToken: cancelToken,
    );
    try {
      final String data = response.data.toString();

      //如果是{} 判断
      if(data != null && (data.isEmpty || data == '{}' || data == '{}\n')){
        return BaseResultEntity(ExceptionHandle.parse_error, '数据为空！', null);
      }
      if(response.statusCode == ExceptionHandle.unauthorized){
        return BaseResultEntity(ExceptionHandle.unauthorized, '登录数据已过期！', null);
      }

      final Map<String, dynamic> _map = parseData(data);
      if(response.statusCode!=200){
        _map['code'] = response.statusCode;
      }
      return BaseResultEntity.fromJson(_map);
    } catch(e) {
      if(response.statusCode == ExceptionHandle.internal_server_error){
        return BaseResultEntity(ExceptionHandle.internal_server_error, '服务器内部错误！', null);
      }
      debugPrint(e);
      return BaseResultEntity(ExceptionHandle.parse_error, '数据解析错误！', null);
    }
  }

  Options _checkOptions(String method, Options options) {
    options ??= Options();
    options.method = method;
    return options;
  }

  /// 统一处理(onSuccessSource返回base，onSuccess返回T对象，onSuccessList返回 List<T>)
  Future requestNetwork<T>(Method method, String url, {
    NetSuccessSourceCallback<T> onSuccessSource,
    NetSuccessCallback<T> onSuccess,
    NetErrorCallback onError,
    dynamic params,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
  }) {
    final String m = _getRequestMethod(method);
    return dioRequest<T>(m, url,
      data: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    ).then((BaseResultEntity<T> result) {
      if (result.code == 200 || result.code == 0) {
        if (onSuccess != null) {
//          onSuccess(result.data);
          onSuccess(result);
        }
        if(onSuccessSource != null){
          onSuccessSource(result);
        }
      } else {
        _onError(result.code, result.msg, onError);
      }
    }, onError: (dynamic e) {
      _cancelLogPrint(e, url);
      final NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  /// 统一处理(onSuccessSource返回base，onSuccess返回T对象，onSuccessList返回 List<T>)
  Future<BaseResultEntity<T>> asyncRequestNetwork2<T>(Method method, String url, {
    NetSuccessSourceCallback<T> onSuccessSource,
    NetSuccessCallback<T> onSuccess,
    NetErrorCallback onError,
    dynamic params,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
  }) {
    final String m = _getRequestMethod(method);
    return dioRequest<T>(m, url,
      data: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  void asyncRequestNetwork<T>(Method method, String url, {
    NetSuccessSourceCallback<T> onSuccessSource,
    NetSuccessCallback<T> onSuccess,
    NetErrorCallback onError,
    dynamic params,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
  }) {
    final String m = _getRequestMethod(method);
    Stream.fromFuture(dioRequest<T>(m, url,
      data: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    )).asBroadcastStream()
        .listen((result) {
      if (result.code == 200 || result.code == 0) {
        if (onSuccess != null) {
//          onSuccess(result.data);
          onSuccess(result);
        }
        if(onSuccessSource != null){
          onSuccessSource(result);
        }
      } else {
        _onError(result.code, result.msg, onError);
      }
    }, onError: (dynamic e) {
      _cancelLogPrint(e, url);
      final NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  void _cancelLogPrint(dynamic e, String url) {
    if (e is DioError && CancelToken.isCancel(e)) {
      Log.error('取消请求接口： $url');
    }
  }

  void _onError(int code, String msg, NetErrorCallback onError) {
    if (code == null) {
      code = ExceptionHandle.unknown_error;
      msg = '未知异常';
    }
    Log.error('接口请求异常： code: $code, msg: $msg');
    if (onError != null && code != ExceptionHandle.cancel_error) {
      onError(code, msg);
    }
    if (code == ExceptionHandle.unauthorized) {
      deal401();
      return;
    }
    if(msg.contains(new RegExp('登录数据无效'))){
      deal401();
    }
  }

  void deal401(){
    EventBusUtils.fire(new Auth401Event());
    SpUtil.putString(Constant.accessToken,'');
  }

  String _getRequestMethod(Method method) {
    String m;
    switch(method) {
      case Method.get:
        m = 'GET';
        break;
      case Method.post:
        m = 'POST';
        break;
      case Method.put:
        m = 'PUT';
        break;
      case Method.patch:
        m = 'PATCH';
        break;
      case Method.delete:
        m = 'DELETE';
        break;
      case Method.head:
        m = 'HEAD';
        break;
    }
    return m;
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data);
}

enum Method {
  get,
  post,
  put,
  patch,
  delete,
  head
}