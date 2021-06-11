# toolbox

常用工具类

#1、网络dio的使用说明

位置：在lib/tool/http

主要类：dio_utils.dart

(1)使用之前需要先设置下网络配置:
````
void initDio() {
  final List<Interceptor> interceptors = [];
  /// 统一添加身份验证请求头
  interceptors.add(AuthInterceptor());
  /// 刷新Token
  interceptors.add(TokenInterceptor());
  /// 打印Log(生产模式去除)
  if (!Constant.inProduction) {
    interceptors.add(LoggingInterceptor());
  }
  /// 适配数据(根据自己的数据结构，可自行选择添加)
  interceptors.add(AdapterInterceptor());
  setInitDio(
    baseUrl: ApiUrl.baseUrl,
    interceptors: interceptors,
  );
}
````

(2)需要自己定义一个http_util，解析接口数据，因为json使用的是插件FlutterJsonBeanFactory，
JsonConvert需要依赖工程。所以在哪里用到网络，就在哪里写个自己的http_util。下面有提供一个demo，可做参考。
````
import 'package:czfph/generated/json/base/json_convert_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:toolbox/constants/Constant.dart';
import 'package:toolbox/tool/Toast.dart';
import 'package:toolbox/tool/http/net.dart';

typedef NetSuccessCallback<T> = Function(T data);

///http请求
class HttpUtil{
  static void asyncRequestNetwork<T>(Method method, {
    BuildContext context,
    @required String url,
    bool isShow = true,
    bool isClose = true,
    NetSuccessCallback<T> onSuccess,
    NetSuccessSourceCallback<T> onSuccessSource,
    NetErrorCallback onError,
    dynamic params,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
  }) {
    try {
      if (isShow) showProgress();
      DioUtils.instance.asyncRequestNetwork<T>(method, url,
        params: params,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSuccess: (data) {//BaseResultEntity
          if (isClose) closeProgress();
          if (onSuccess != null) {
            BaseResultEntity resultEntity = data as BaseResultEntity;
            Map<String,dynamic> dataJson = resultEntity.dataJson;
            onSuccess(_generateOBJ(dataJson[Constant.data]));
          }
        },
        onSuccessSource: (data){
          if (isClose) closeProgress();
          if (onSuccessSource != null) {
            onSuccessSource(data);
          }
        },
        onError: (code, msg) {
          _onError(code, msg, onError);
        },
      );
    }catch (e) { // 不指定错误类型，匹配所有
      closeProgress();
      print(e.toString());
    }
  }

  static void showProgress(){
    EasyLoading.show(status:"加载中...");
  }

  static void closeProgress(){
    EasyLoading.dismiss();
  }

  static void _onError(int code, String msg, NetErrorCallback onError) {
    /// 异常时直接关闭加载圈，不受isClose影响
    closeProgress();
    Toast.show(msg);
    /// 页面如果dispose， && getContext() != null 则不回调onError
    if (onError != null) {
      onError(code, msg);
    }
  }

  static S _generateOBJ<S>(Object json) {
    if (S.toString() == 'String') {
      return json.toString() as S;
    } else if (S.toString() == 'Map<dynamic, dynamic>') {
      return json as S;
    } else {
      return JsonConvert.fromJsonAsT<S>(json);
    }
  }
}
````

(3)具体接口调用demo
````
///获取短信验证码
void getSmscode(Context ctx,bool isShow) async{
  VerifyCodeState state = ctx.state;
  await HttpUtil.asyncRequestNetwork<String>(Method.post,
      context: ctx.context,
      url: ApiUrl.getSmscode,
      params:state.requestInfo,
      isShow: isShow,
      onSuccess: (data) {
        Toast.show(ctx.context, "短信验证码已发送，注意查收");
        if(countdownTime == 0){
          startCountdown(ctx);
        }
      }
  );
}
````

