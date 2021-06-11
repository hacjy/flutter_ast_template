import 'package:flutter/material.dart';

///路由跳转工具类
class NavigatorUtils {
  /// 返回
  static void goBack(BuildContext context) {
    unfocus();
    Navigator.pop(context);
  }

  static void go(BuildContext context,String routeName){
    Navigator.of(context).pushNamed(routeName);
  }

  static void goAndFinish(BuildContext context,String routeName){
    Navigator.of(context).popAndPushNamed(routeName);
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, Object result) {
    unfocus();
    Navigator.pop<Object>(context, result);
  }

  static void unfocus() {
    // 使用下面的方式，会触发不必要的build。
    // FocusScope.of(context).unfocus();
    // https://github.com/flutter/flutter/issues/47128#issuecomment-627551073
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  static void popValue(BuildContext context,Object result) {
    Navigator.of(context).pop(result);
  }

  static void pushName(BuildContext context,String routeName,{Object arguments}) {
    Navigator.of(context).pushNamed(routeName,arguments: arguments);
  }

  static Future<dynamic> pushNameValue(BuildContext context,String routeName,{Object arguments})async {
    return  await Navigator.of(context).pushNamed(routeName,arguments: arguments);
  }

  static void pushNamePop(BuildContext context,String routeName,{Object arguments}){
    Navigator.of(context).popAndPushNamed(routeName,arguments: arguments);
  }
}
