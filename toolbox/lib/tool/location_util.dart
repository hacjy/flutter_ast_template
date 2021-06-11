import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toolbox/constants/constant.dart';

class LocationUtil{
  static void openLocation(BuildContext context) async {
    // Native channel
    const platform = const MethodChannel(Constant.nativeMapChannelName);
    bool result = false;
    try {
      Future<bool> future = await platform.invokeMethod(Constant.nativeMethodNameOpenLocation);
      future.then((data){
        result = data;
      });
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
}