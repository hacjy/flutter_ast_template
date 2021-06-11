import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:toolbox/constants/constant.dart';
import 'package:toolbox/tool/navigator_utils.dart';
import 'package:toolbox/tool/utils.dart';
import 'package:toolbox/widget/dialog/tips_dialog.dart';

class LoginUtil{
  static bool isShowLoginDialog = false;
  static final String KEY_USER = "key_user";

  static bool isLogin(){
    String token = getAccessToken();
    if(TextUtil.isEmpty(token))
      return false;
    return true;
  }

  static String getAccessToken() {
    String accessToken = SpUtil.getString(Constant.accessToken);
    return accessToken;
  }


  static void isLoginInterceptor(BuildContext context,Function action){
    if(isLogin()){
      if(action != null) {
        action();
      }
    }else{
      showLoginDialog(context);
    }
  }

  static  void showLoginDialog(BuildContext context) {
    try {
      if(!isShowLoginDialog) {
        isShowLoginDialog = true;
        showBlockDialog<void>(
          context: context,
          barrierDismissible: true,
          child: TipsDialog(
            title: '提示',
            content: '登录信息已失效，是否重新登录？',
            cancelText: '取消',
            okText: '确定',
            alignment: Alignment.center,
            bottomButtonStyle: BottomButtonStyle.line,
            onClickCancelEvent: () {
              NavigatorUtils.pop(context);
              isShowLoginDialog = false;
            },
            onClickOkEvent: () {
              NavigatorUtils.pop(context);
              isShowLoginDialog = false;
              NavigatorUtils.pushName(context,'/login');
            },
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  static String getLoaclUserData(){
    String userJson = SpUtil.getString(KEY_USER);
    return userJson;
  }

}