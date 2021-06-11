import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SystemUtil{

  static void copyText(String text){
    Clipboard.setData(ClipboardData(text: text));
  }

  static void callPhone(String phone) async{
    final url = 'tel:' + phone;//打电话
    if (await canLaunch(url) != null) {
      launch(url);
    } else {
      print('不能打开该url');
    }
  }
}