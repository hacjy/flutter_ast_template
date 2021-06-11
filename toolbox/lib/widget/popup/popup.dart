import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef itemBuilder = Widget Function(BuildContext context, dynamic item, int index);

void showPopupWithButtons(BuildContext context, Widget content,{String cancelText='取消',
  String sureText = '确认'}){
  ThemeData themeData = Theme.of(context);
  showCupertinoModalPopup(context: context, builder: (context){
    return Container(
      height: 260,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).pop('cancel');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints.expand(width: 80),
                      child: Text(cancelText,
                        style: TextStyle(
                          color: themeData.hintColor,
                          fontSize: 16
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).pop('sure');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints.expand(width: 80),
                      child: Text(sureText,
                        style: TextStyle(
                          color: themeData.primaryColor,
                          fontSize: 16
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 220,
            child: content,
          )
        ],
      ),
    );
  });
}