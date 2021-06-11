import 'dart:io';

import 'package:dio/dio.dart';

class ExceptionHandle {
  static const int success = 200;
  static const int success_not_content = 204;
  static const int status_code_400 = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int not_found = 404;
  static const int internal_server_error = 500;

  static const int net_error = 1000;
  static const int parse_error = 1001;
  static const int socket_error = 1002;
  static const int http_error = 1003;
  static const int timeout_error = 1004;
  static const int cancel_error = 1005;
  static const int unknown_error = 9999;

  static NetError handleException(dynamic error) {
    print(error);
    if (error is DioError) {
      if (error.type == DioErrorType.other || error.type == DioErrorType.response) {
        dynamic e = error.error;
        if (e is SocketException) {
          String msg = error.message;
          List<String> msgs = msg.split(RegExp(','));
          if(msgs != null && msgs.length  > 0){
            msg = msgs[0];
          }
          return NetError(socket_error,msg??'网络异常，请检查你的网络！');
        }
        if (e is HttpException) {
          return NetError(http_error, '服务器异常！');
        }
        if (e is FormatException) {
          return NetError(parse_error, '数据解析错误！');
        }
        DioError er = error;
        String msg = er.message;
        return NetError(unknown_error, msg);
      } else if (error.type == DioErrorType.connectTimeout ||
          error.type == DioErrorType.sendTimeout ||
          error.type == DioErrorType.receiveTimeout) {
        return NetError(timeout_error, '连接超时！');
      } else if (error.type == DioErrorType.cancel) {
        return NetError(cancel_error, '取消请求');
      } else {
        return NetError(unknown_error, '未知异常');
      }
    } else {
      return NetError(unknown_error, '未知异常');
    }
  }
}

class NetError{
  int code;
  String msg;

  NetError(this.code, this.msg);
}