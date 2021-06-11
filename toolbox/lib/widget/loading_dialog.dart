import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  //进度提醒内容
  final String msg;
  //加载中动画
  final Widget progress;
  //字体颜色
  final Color textColor;
  final Color bgColor;

  LoadingDialog(
      {Key key,
        this.msg = '加载中...',
        this.progress = const CircularProgressIndicator(),
        this.textColor = Colors.white,
        this.bgColor = Colors.transparent,
}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return new Material(
        color: bgColor,
          child:
          Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  progress,
                  Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    child: Text(
                      msg,
                      style: TextStyle(color: textColor, fontSize: 16.0),
                    ),
                  )
                ],
              ),
            ),
          )
      );});
  }
}