import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:toolbox/log/log.dart';
import 'package:toolbox/tool/http/net.dart';
import 'package:toolbox/tool/pay/pay_manager.dart';
import 'package:toolbox/ui/pixel.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bugly/flutter_bugly.dart';

import 'app.dart';

class _WidgetsBindingObserver extends WidgetsBindingObserver {
  @override
  void didChangeMetrics() {
    Log.info('didChangeMetrics');
    FixPixel.init(375);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //生命周期变化
    print('didChangeAppLifecycleState-main');
    if(state != null){
      if(state == AppLifecycleState.paused || state == AppLifecycleState.detached){
        EasyLoading.dismiss(animation: false);
      }
    }
  }

}

void main() async {
  ///初始化bugly
  FlutterBugly.postCatchedException(() async {
    ///是否是生产环境
    final isProd = bool.fromEnvironment('dart.vm.product');
    Log.init();
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance!.addObserver(_WidgetsBindingObserver());
    await SpUtil.getInstance();
    initDio();
    ///微信appid
    PayManager.getInstance().setWxAppid("");

    runApp(buildApp());
  });
  FlutterBugly.init(androidAppId: "3ec0578968",iOSAppId: "9132b7b191",autoCheckUpgrade: false);
}

void initDio() {
  ///是否是生产环境
  final isProd = bool.fromEnvironment('dart.vm.product');
  Log.info("isProd:"+isProd.toString());

  bool isRelease = isProd;
  /// 域名
  String baseUrl = "https://www.wanandroid.com";
  final List<Interceptor> interceptors = [];
  ///统一添加身份验证请求头
  interceptors.add(AuthInterceptor());
  ///刷新token
  interceptors.add(TokenInterceptor());
  ///打印Log
  interceptors.add(LoggingInterceptor());

  setInitDio(
    baseUrl: baseUrl,
    interceptors: interceptors,
    ignoreCertificate: true,
  );
}

