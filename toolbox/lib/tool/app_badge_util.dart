//import 'package:flutter_app_badger/flutter_app_badger.dart';
//
/////桌面图标未读数 有问题 Android打包运行闪退
/////https://pub.flutter-io.cn/packages/flutter_app_badger
/////ios需要配置Info.plist: 苹果配置这个很难过审核
////
////<key>UIBackgroundModes</key>
////    <array>
////        <string>remote-notification</string>
////    </array>
//class AppBadgeUtil{
//  static Future<void> setBadgeCount(int count) async {
//    bool isSupported = await FlutterAppBadger.isAppBadgeSupported();
//    if(isSupported){
//      if(count <= 0){
//        removeBadge();
//      }else{
//        addBadge(count);
//      }
//    }
//  }
//
//  static void addBadge(int count) {
//    FlutterAppBadger.updateBadgeCount(count);
//  }
//
//  static void removeBadge() {
//    FlutterAppBadger.removeBadge();
//  }
//}