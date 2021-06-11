import 'package:flutter/material.dart';
import 'package:toolbox/res/colors.dart';
import 'package:toolbox/ui/pixel.dart';

class IputDialog extends Dialog{
  String title = "";
  String content = "";
  String cancelText = "";
  String okText = "";
  TextEditingController editingController = TextEditingController();



  IputDialog({
    Key key,
    this.title = "提示",
    this.content = "",
    this.cancelText = "取消",
    this.okText = "确定",
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
                        Text(
                            title,
                            style: TextStyle(
                                fontSize: FixPixel.px(16),
                                color: Colors.black
                            )),
                      ),
                      Container(
                        padding: EdgeInsets.only(left:FixPixel.px(12),right:FixPixel.px(12),
                            top:FixPixel.px(6),bottom:FixPixel.px(16)),
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.symmetric(horizontal: FixPixel.px(15)),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.dividerColor),
                          borderRadius: BorderRadius.all(Radius.circular(FixPixel.px(10)))
                        ),
                        
                        child:TextField(
                          minLines: 1,
                            controller: editingController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "请输入${content==''?title:content}",
                              hintStyle: TextStyle(fontSize: 14, color: AppColors.gray_c4_Color),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
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
                              onTap: (){
                                Navigator.of(context).pop();
                              },
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
                              onTap: (){
                                Navigator.of(context).pop(editingController.text);
                              },
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
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

