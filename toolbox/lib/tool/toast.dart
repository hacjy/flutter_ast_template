
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toolbox/res/colors.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:toolbox/ui/pixel.dart';

/// Toast工具类
class ToastUtil {
  static Fluttertoast flutterToast;

  static void show(BuildContext context,String msg, {int duration = 2000,ToastGravity  gravity=ToastGravity.CENTER}) {
    if (msg == null) {
      return;
    }
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.transparent,
        fontSize: 16.0
    );
  }

  static void showError(BuildContext context,String msg, {int duration = 2000}) {
    if (msg == null) {
      return;
    }
    EasyLoading.showError(msg,duration:Duration(milliseconds: duration),
    );
  }

  static void showSuccess(BuildContext context,String msg, {int duration = 2000}) {
    if (msg == null) {
      return;
    }
    EasyLoading.showSuccess(msg,duration:Duration(milliseconds: duration),
    );
  }

  static Widget createToast(String msg){
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color(0x90000000),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(msg,style: TextStyle(fontSize: FixPixel.px(14),
                color: AppColors.white),),
          )
        ],
      ),
    );
    return toast;
  }
}
