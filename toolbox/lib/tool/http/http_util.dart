import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:toolbox/constants/constant.dart';
import 'package:toolbox/generated/json/base/json_convert_content.dart';
import 'package:toolbox/tool/toast.dart';

import 'net.dart';

typedef NetSuccessCallback<T> = Function(T data);

///主工程自己实现下 因为jsonconvert是要当前的才可用
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
        onSuccess: (data) {//datajson
          if (isClose) closeProgress();
          if (onSuccess != null) {
//            onSuccess(data);
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
//    if (code != ExceptionHandle.cancel_error) {
//      Toast.show(msg);
//    }
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