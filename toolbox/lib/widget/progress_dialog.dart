
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toolbox/ui/pixel.dart';

/// 加载中的弹框
class ProgressDialog extends Dialog {

  ProgressDialog({
    Key key,
    this.hintText = '加载中...',
    this.isCancel = true,
  }):super(key: key);

  String hintText;
  bool isCancel;

  @override
  Widget build(BuildContext context) {
    
    Widget progress =
    WillPopScope(
      onWillPop: () async {
        return isCancel;
      },
      child: GestureDetector(
          onTap: (){
            if(isCancel) {
              Navigator.of(context).pop();
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Theme(
                data: ThemeData(
                  cupertinoOverrideTheme: const CupertinoThemeData(
                    brightness: Brightness.dark, // 局部指定夜间模式，加载圈颜色会设置为白色
                  ),
                ),
                child: const CupertinoActivityIndicator(radius: 14.0),
              ),
              Container(
                  margin: EdgeInsets.only(top: FixPixel.px(10)),
                  child:Text(hintText, style: const TextStyle(color: Colors.white),)
              ),

            ],
          ),),
    );
    
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: 88.0,
          width: 88.0,
          decoration: const ShapeDecoration(
            color: Color(0xFF3A3A3A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          child: progress,
        ),
      ),
    );
  }
}