import 'package:flutter/material.dart';
import 'package:toolbox/res/colors.dart';
import 'package:toolbox/ui/pixel.dart';

///底部按钮样式 默认是2个按钮，2种样式
///还可以设置一种按钮
enum BottomButtonStyle {
  line,
  round,
  onlyOne
}

///提示对话框
class TipsDialog extends Dialog{
  String title = "";
  String content = "";
  String cancelText = "";
  String okText = "";
  Alignment alignment;
  Widget titleWidget;
  Widget contentWidget;

  BottomButtonStyle bottomButtonStyle;
  //取消事件
  Function onClickCancelEvent;
  //确定事件
  Function onClickOkEvent;

  TipsDialog({
    Key key,
    this.title = "提示",
    this.content = "",
    this.cancelText = "取消",
    this.okText = "确定",
    this.bottomButtonStyle = BottomButtonStyle.line,
    this.onClickCancelEvent,
    this.onClickOkEvent,
    this.alignment = Alignment.topLeft,
    this.titleWidget,
    this.contentWidget
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return new Material(
        type: MaterialType.transparency,
        child:Center(
          child:  Container(
            width: FixPixel.px(270),
            padding: EdgeInsets.only(bottom: FixPixel.px(0)),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top:FixPixel.px(16),bottom:FixPixel.px(10)),
                        alignment: Alignment.center,
                        child:
                       titleWidget!=null?titleWidget: Text(
                            title,
                            style: TextStyle(
                                fontSize: FixPixel.px(16),
                                color: Colors.black
                            )),
                      ),
                     content==null||content==''?
                     (contentWidget!=null?contentWidget:Container())
                         : Container(
                        padding: EdgeInsets.only(left:FixPixel.px(12),right:FixPixel.px(12),
                            top:FixPixel.px(6),bottom:FixPixel.px(16)),
                        alignment: alignment,
                        child:Text(
                            content,
                            style: TextStyle(
                                fontSize: FixPixel.px(14),
                                color: AppColors.black_color
                            )),
                      ),
                    ],
                  ),
                ),
                bottomButtonStyle==BottomButtonStyle.onlyOne
                    ?createOnlyOneBottom(cancelText, okText, onClickCancelEvent, onClickOkEvent)
                    :bottomButtonStyle==BottomButtonStyle.line
                        ?createLineBottom(cancelText, okText, onClickCancelEvent, onClickOkEvent)
                        :createRoundBottom(cancelText, okText, onClickCancelEvent, onClickOkEvent),
              ],
            ),
          ),
        ),
      );
    });
  }
}

///第一种底部按钮（2个）样式：上横线，中竖线
Widget createLineBottom(cancelText,okText,onClickCancelEvent,onClickOkEvent){
  return Column(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: FixPixel.px(10)),
        height: 0.5,
        color: AppColors.gray_e7_Color,
      ),
      Container(
        height: 46,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(8.0),),
              ),
              child: InkWell(
                highlightColor: Colors.transparent,
                onTap: onClickCancelEvent,
                child: Container(
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(8.0),),
                      )),
                  constraints: BoxConstraints.expand(width: 129),
                  child: Text(cancelText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 0.5,
              color: AppColors.gray_e7_Color,
            ),
            Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomRight:  Radius.circular(8.0),),
              ),
              child: InkWell(
                highlightColor: Colors.transparent,
                onTap: onClickOkEvent,
                child: Container(
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(bottomRight:  Radius.circular(8.0),),
                      )),
                  constraints: BoxConstraints.expand(width: 129),
                  child: Text(okText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ],
  );
}

///第二种底部按钮（2个）样式：没有线条分开，两个圆角矩形按钮
Widget createRoundBottom(cancelText,okText,onClickCancelEvent,onClickOkEvent){
  return Column(
    children: <Widget>[
      Container(
        height: 40,
        margin: EdgeInsets.only(left: FixPixel.px(12),right: FixPixel.px(12),
        bottom: FixPixel.px(14)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0),),
              ),
              child: InkWell(
                highlightColor: Colors.transparent,
                onTap: onClickCancelEvent,
                child: Container(
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color:AppColors.primaryColor,style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(32.0),),
                      )),
                  constraints: BoxConstraints.expand(width: 108),
                  child: Text(cancelText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color:AppColors.primaryColor,
                        fontSize: 16
                    ),
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0),),
              ),
              child: InkWell(
                highlightColor: Colors.transparent,
                onTap: onClickOkEvent,
                child: Container(
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                      color: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0),),
                      )),
                  constraints: BoxConstraints.expand(width: 108),
                  child: Text(okText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.mainWhite,
                        fontSize: 16
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ],
  );
}

///只有一个底部按钮样式：圆角矩形按钮
Widget createOnlyOneBottom(cancelText,okText,onClickCancelEvent,onClickOkEvent){
  return Column(
    children: <Widget>[
      Container(
        height: 40,
        margin: EdgeInsets.only(left: FixPixel.px(12),right: FixPixel.px(12),
            bottom: FixPixel.px(14)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0),),
              ),
              child: InkWell(
                highlightColor: Colors.transparent,
                onTap: onClickOkEvent,
                child: Container(
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                      color: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0),),
                      )),
                  constraints: BoxConstraints.expand(width: 156),
                  child: Text(okText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.mainWhite,
                        fontSize: 16
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ],
  );
}
