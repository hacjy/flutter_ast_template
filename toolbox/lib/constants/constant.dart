import 'package:flutter/widgets.dart' ;
class Constant{
  //全局上下文
  static BuildContext context;
  //当前诊间的orderNO 有数据表示正在诊间
  static String currentOrderNO = '';
  //是否在登录页
  static bool inLoginPage = false;


  static const bool inProduction = false;
  static const bool isDriverTest = false;

  static const String code = "code";
  static const String message = "msg";
  static const String detail = "detail";
  static const String data = "data";
  static const String access_token = "access_token";
  static const String user = "user";
  static const String status = "status";

  static const String keyUser = "key_user";
  static const String accessToken = "accessToken";
  static const String refreshToken = "refresh_token";
  static const String expireTime = "expire_time";

  static const String imAppId="1400311209";
  static const String imUserId="imUserId";
 // static const String ihAccessToken = 'ihAccessToken';

  ///院内导航
  static const String nativeMapChannelName = 'app.cfph.com/location';
  static const String nativeMethodNameOpenLocation = 'openLocation';
}