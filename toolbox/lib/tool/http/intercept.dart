import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:nuid/nuid.dart';
import 'package:sprintf/sprintf.dart';
import 'package:toolbox/constants/constant.dart';
import 'package:toolbox/log/log.dart';
import 'package:toolbox/tool/http/base_result_entity.dart';

import 'dio_utils.dart';
import 'error_handle.dart';
import 'login_result_info_entity.dart';

class AuthInterceptor extends Interceptor {
  String uuid = '';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String platform;
    if(Platform.isAndroid) {
      platform = "android";
    } else if(Platform.isIOS) {
      platform = "ios";
    }
    options.headers['OS'] = platform;

    final String accessToken = SpUtil.getString(Constant.accessToken);
    if (accessToken.isNotEmpty) {
      options.headers['X-Authorization'] = '$accessToken';
    }else{
      options.headers['X-Authorization'] = 'hAgsgx46TMaTO31h2Bm2tyhklFao60TwkivJrG4GbKE=:'+ uuid;
    }
    if(uuid.isEmpty){
      uuid = getDeviceUUid();
    }
    return super.onRequest(options,handler);
  }
}

String getDeviceUUid(){
  final nuid = Nuid.instance;
  //时间戳
//  String uuid = 'app' + currentTimeMillis().toString();
  String uuid = nuid.next();
  return uuid;
}

int currentTimeMillis(){
  return new DateTime.now().millisecondsSinceEpoch;
}

///刷新token
class TokenInterceptor extends Interceptor {
  Dio _tokenDio = Dio();

  Future<Map<String,Object>> getToken() async {
    Map<String, Object> params = new Map();
    String userJson = SpUtil.getString(Constant.keyUser);
    Log.error('userJson:'+userJson);
    if(userJson != '' && userJson != null) {
      params = json.decode(userJson);
    }
    try {
      Log.info('开始刷新Token请求！');
      _tokenDio.options = DioUtils.instance.dio.options;
      //从user中获取accessToken，避免accessToken并清空了
      _tokenDio.options.headers['X-Authorization'] = params['access_token'];
      final Response response = await _tokenDio.put('/user/session',data:params);
      if (response.statusCode == ExceptionHandle.success) {
        return json.decode(response.data.toString());
      }
    } catch(e) {
      Log.error('刷新Token失败！');
    }
    return null;
  }

  @override
  void onRequest(RequestOptions options,  RequestInterceptorHandler handler) {
    try {
      Map<String, Object> params = new Map();
      String userJson = SpUtil.getString(Constant.keyUser);
      if(userJson != '' && userJson != null) {
        params = json.decode(userJson);
      }
      LoginResultInfoUser user = LoginResultInfoUser().fromJson(params);
      DateTime currentTime = DateTime.now();
      //比对时间 当前时间和给定的时间相差在5分钟内就刷新
      DateTime exprieTime = DateUtil.getDateTime(user.expireTime);
      int number = currentTime.difference(exprieTime).inMinutes;
      if(number >= 0 || (number < 0 && number.abs() >= 5)){
        dealToken(options);
      }
    }catch(e){
      print(e);
    }
    return super.onRequest(options,handler);
  }


  void dealToken(RequestOptions options) async {
    Log.debug('-----------自动刷新Token------------');
    final Dio dio = DioUtils.instance.dio;
    dio.interceptors.requestLock.lock();
    try{
     getToken().then((value) {
       Map<String, Object> params = value;
       if(params != null && params.length > 0) {
         params = params['data'];
         LoginResultInfoEntity entity = LoginResultInfoEntity().fromJson(params);
         final String accessToken = entity.accessToken; // 获取新的accessToken
         Log.error('-----------NewToken: $accessToken ------------');

         LoginResultInfoUser user = entity.user;
         if(accessToken != null && accessToken != '') {
           user.accessToken = accessToken;
           options.headers['X-Authorization'] = accessToken;
           SpUtil.putString(Constant.accessToken, accessToken);
         }
         user.expireTime = entity.expireTime;
         SpUtil.putString(Constant.keyUser, json.encode(user));
       }
     }); // 获取新的accessToken
    }catch(e){
      print(e);
    }
    dio.interceptors.requestLock.unlock();
  }
}

class LoggingInterceptor extends Interceptor{

  DateTime _startTime;
  DateTime _endTime;


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      _startTime = DateTime.now();
      Log.debug('----------Start----------');
      if (options.queryParameters.isEmpty) {
        Log.debug('RequestUrl: ' + options.baseUrl + options.path);
      } else {
        Log.debug('RequestUrl: ' + options.baseUrl + options.path + '?' +
            Transformer.urlEncodeMap(options.queryParameters));
      }
      Log.debug('RequestMethod: ' + options.method);
      Log.debug('RequestHeaders:' + options.headers.toString());
      Log.debug('RequestContentType: ${options.contentType}');
      String requestData = '';
      if (options.data != null && options.data != '' &&
          !(options.data is FormData)) {
        requestData = json.encode(options.data);
      }
      Log.debug('RequestData:' + requestData);
    } catch (e) { // 不指定错误类型，匹配所有
      print(e);
    }
    return super.onRequest(options,handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      _endTime = DateTime.now();
      int duration = _endTime.difference(_startTime).inMilliseconds;
      if (response.statusCode == ExceptionHandle.success) {
        Log.debug('ResponseCode: ${response.statusCode}');
      } else {
        Log.error('ResponseCode: ${response.statusCode}');
        Log.debug('ResponseStatusMsg:'+response.statusMessage);
//        if(response.statusCode == ExceptionHandle.internal_server_error){
//          BaseResultEntity<String> entity = new BaseResultEntity(response.statusCode, response.statusMessage, null);
//          response.data = json.encode(entity);
//        }
        //如果code是400 且包含detail字段的话，单独处理下
        if(response.statusCode == ExceptionHandle.status_code_400){
          String responseData = response.data.toString();
          if(responseData.contains(new RegExp('detail'))){
            BaseResultEntity entity = new BaseResultEntity.fromJson(json.decode(responseData));
            entity.code = response.statusCode;
            entity.msg = entity.detail;
            response.data = json.encode(entity);
          }
        }
      }
      // 输出结果
      Log.debug('ResponseData:'+response.data.toString());
      Log.debug('----------End: $duration 毫秒----------');
    } catch (e) { // 不指定错误类型，匹配所有
      print(e);
    }
    return super.onResponse(response,handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Log.debug('----------Error-----------');
    return super.onError(err, handler);
  }
}

//暂时用不上
class AdapterInterceptor extends Interceptor{

  static const String _kMsg = 'msg';
  static const String _kSlash = '\'';
  static const String _kMessage = 'message';

  static const String _kDefaultText = '\"无返回信息\"';
  static const String _kNotFound = '未找到查询信息';

  static const String _kFailureFormat = '{\"code\":%d,\"msg\":\"%s\"}';
  static const String _kSuccessFormat = '{\"code\":0,\"data\":%s,\"msg\":\"\"}';

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Response r = adapterData(response);
    return super.onResponse(r, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      adapterData(err.response);
    }
    return super.onError(err, handler);
  }

  Response adapterData(Response response) {
    String result;
    String content = response.data == null ? '' : response.data.toString();
    /// 成功时，直接格式化返回
    if (response.statusCode == ExceptionHandle.success || response.statusCode == ExceptionHandle.success_not_content) {
      if (content == null || content.isEmpty) {
        content = _kDefaultText;
      }
      result = sprintf(_kSuccessFormat, [content]);
      response.statusCode = ExceptionHandle.success;
    } else {
      if (response.statusCode == ExceptionHandle.not_found) {
        /// 错误数据格式化后，按照成功数据返回
        result = sprintf(_kFailureFormat, [response.statusCode, _kNotFound]);
        response.statusCode = ExceptionHandle.success;
      } else {
        if (content == null || content.isEmpty) {
          // 一般为网络断开等异常
          result = content;
        } else {
          String msg;
          try {
            content = content.replaceAll("\\", '');
            if (_kSlash == content.substring(0, 1)) {
              content = content.substring(1, content.length - 1);
            }
            Map<String, dynamic> map = json.decode(content);
            if (map.containsKey(_kMessage)) {
              msg = map[_kMessage];
            } else if (map.containsKey(_kMsg)) {
              msg = map[_kMsg];
            } else {
              msg = '未知异常';
            }
            result = sprintf(_kFailureFormat, [response.statusCode, msg]);
            // 401 token失效时，单独处理，其他一律为成功
            if (response.statusCode == ExceptionHandle.unauthorized) {
              response.statusCode = ExceptionHandle.unauthorized;
            } else {
              response.statusCode = ExceptionHandle.success;
            }
          } catch (e) {
            Log.debug('异常信息：$e');
            // 解析异常直接按照返回原数据处理（一般为返回500,503 HTML页面代码）
            result = sprintf(_kFailureFormat, [response.statusCode, '服务器异常(${response.statusCode})']);
          }
        }
      }
    }
    response.data = result;
    return response;
  }
}

