import 'package:dio/dio.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:toolbox/log/log.dart';
import 'package:toolbox/util/applifecycle_util.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BaseLifecycleEffect{
  static String currKey = '';
  static Map<String,CancelToken> cancelList = {};

  static void clean(){
    cancelList = {};
  }

  static CancelToken get currCancelToken => cancelList[currKey];

  static Map<Object, Effect<T>> createMap<T>(Map<Object,Effect<T>> map,
      {
        Effect<T> dispose,
        Effect<T> didChangeAppLifecycle,
      }
  ){
    String key = T.toString();
    currKey = key;
    Log.debug('key='+key);
    if(cancelList[key] == null) {
      cancelList[key] = CancelToken();
    }

    Map<Object, Effect<T>> result = map;
    //APP状态
    result[Lifecycle.didChangeAppLifecycleState] = (Action action, Context<T> ctx){
      if(action.payload != null) {
        if (AppLifecycleUtil.isPause(action.payload) ||
            AppLifecycleUtil.isDetached(action.payload)) {
          EasyLoading.dismiss(animation: false);
        }
      }
      if(didChangeAppLifecycle != null){
        didChangeAppLifecycle(action,ctx);
      }
    };
    //页面销毁回调
    result[Lifecycle.dispose] = (Action action, Context<T> ctx){
      //加载框隐藏
      EasyLoading.dismiss(animation: false);
      //取消请求
      if( cancelList[key] !=null && ! cancelList[key].isCancelled){
        cancelList[key].cancel();
        cancelList[key] = null;
        currKey = '';
      }
      if(dispose != null){
        dispose(action,ctx);
      }
    };
    return result;
  }

}