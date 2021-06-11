import 'dart:async';

import 'package:flutter/services.dart';

class Toolbox {
  static const MethodChannel _channel =
      const MethodChannel('toolbox');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get platformUid async {
    final String uuid = await _channel.invokeMethod('getDeviceUUID');
    return uuid;
  }
}
