import 'package:flutter/material.dart';

class TextFieldUtil{
  //光标定位到最后位置
  static void setCursor(TextEditingController controller){
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
  }
}