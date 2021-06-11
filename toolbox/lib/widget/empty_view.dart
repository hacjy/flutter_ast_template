import 'package:flutter/material.dart';
import 'package:toolbox/res/colors.dart';
import 'package:toolbox/ui/pixel.dart';

typedef OnClickCallback = Function();

class EmptyView{
  static Widget buildEmptyView(BuildContext context,Widget icon,String hintText,{EdgeInsets padding,OnClickCallback callback}){
    return GestureDetector(
      onTap: callback??null,
      child: Container(
        padding: padding??EdgeInsets.only(bottom: FixPixel.px(FixPixel.px(96) + FixPixel.paddingBottom)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: icon
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(FixPixel.px(10)),
                child: Text(
                  hintText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.gray_82_Color,
                    fontSize: FixPixel.px(14),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}