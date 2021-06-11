import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:toolbox/log/log.dart';
import 'package:tobias/tobias.dart' as tobias;
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:toolbox/tool/toast.dart';


typedef PayCallback = Function(String resultCode);

///https://github.com/OpenFlutter/fluwx/blob/master/README_CN.md
///https://github.com/OpenFlutter/tobias/blob/master/README_CN.md
///重要的是ios配置 TODO ios还未设置
class PayManager{
  static const String PAY_CHANNEL_WX = 'wx';
  static const String PAY_CHANNEL_ALIPAY = 'alipay';

  static const String PAY_SUCCESS = '200';
  static const String PAY_FAILED = '400';
  static const String PAY_LOADING = '800';

  static PayManager _instance;
  String wxAppId = '';

  PayManager._internal() {}

  static PayManager getInstance() {
    if (_instance == null) {
      _instance = new PayManager._internal();
    }
    return _instance;
  }

  void setWxAppid(String appid){
    wxAppId = appid;
    //通过 fluwx 注册WxApi.
    //registerWxApi(appId: "wxd930ea5d5a228f5f",universalLink: "https://your.univerallink.com/link/");
    //参数 universalLink 只在iOS上有用. 查看文档 以便了解如何生成通用链接.
    //你也可以学习到怎么在iOS工程中添加URL schema，怎么添加LSApplicationQueriesSchemes。这很重要。
    //对于Android, 可以查看本文以便了解怎么获取app签名. 然后你需要知道release和debug时，app签名有什么区别。如果签名不对，你会得一个错误 errCode = -1.
    fluwx.registerWxApi(appId: wxAppId, universalLink: 'https://www.ylzbtech.com/');
  }

  void pay(BuildContext context,String channel,
      String aliPayOrder, Map<String, dynamic> wxPayMap,PayCallback callback) async {
    if (channel == PAY_CHANNEL_ALIPAY) {
      Log.debug('支付宝支付');
      if (aliPayOrder == null || aliPayOrder == '') {
        ToastUtil.show(context, 'alipay支付串为空');
        return;
      }
      Map<dynamic, dynamic> payResult = await tobias.aliPay(aliPayOrder);
      Log.debug('支付结果: $payResult}');
      String resultCode = payResult['resultStatus'];
      if (resultCode == '9000') {
        Log.debug('支付成功');
        if (callback != null) {
          callback(PAY_SUCCESS);
        }
      } else if (resultCode == '8000') {
        Log.debug('结果处理中');
        if (callback != null) {
          callback(PAY_LOADING);
        }
      } else {
        Log.debug('支付失败');
        if (callback != null) {
          callback(PAY_FAILED);
        }
      }
    } else if (channel == PAY_CHANNEL_WX) {
      Log.debug('微信支付');
      if (wxAppId == null || wxAppId == '') {
        ToastUtil.show(context, '微信appid为空');
        return;
      }
      if (wxPayMap == null) {
        ToastUtil.show(context, 'wxpay支付串为空');
        return;
      }

      await fluwx.payWithWeChat(
          appId: wxPayMap['appid'],
          partnerId: wxPayMap['partnerid'],
          prepayId: wxPayMap['prepayid'],
          packageValue: wxPayMap['package'],
          nonceStr: wxPayMap['noncestr'],
          timeStamp: int.parse(wxPayMap['timestamp']),
          sign: wxPayMap['sign']);
      fluwx.weChatResponseEventHandler.listen((data) {
        print('微信支付回调通知');
        if (data is fluwx.WeChatPaymentResponse) {
          Log.debug('weChatResponse:'+data.errCode.toString());
          if (data.errCode == 0) {
            Log.debug('支付成功');
            if (callback != null) {
              callback(PAY_SUCCESS);
            }
          } else {
            Log.debug('支付失败');
            if (callback != null) {
              callback(PAY_FAILED);
            }
          }
        }
      });
    }
  }
}