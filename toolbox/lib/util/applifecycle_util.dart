import 'package:flutter/material.dart';

class AppLifecycleUtil{
  static bool isResumed(dynamic state){
    if(state == AppLifecycleState.resumed){
      return true;
    }
    return false;
  }

  static bool isPause(dynamic state){
    if(state == AppLifecycleState.paused){
      return true;
    }
    return false;
  }

  static bool isDetached(dynamic state){
    if(state == AppLifecycleState.detached){
      return true;
    }
    return false;
  }
}