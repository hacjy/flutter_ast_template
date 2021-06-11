import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:toolbox/log/log.dart';

/// 适配设计稿的尺寸与设备逻辑尺寸
class FixPixel {

  static double _designWith;
  static double _width = 0;
  static double _height = 0;
  static double _paddingTop = 22;
  static double _paddingBottom = 0;

  static double _design2LocalRate = 1;
  static double _local2DesignRate = 1;
  /// 设计稿尺寸
  static void init(double designWith){
    _designWith = designWith;
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    _width = mediaQuery.size.width;
    _height = mediaQuery.size.height;
    _paddingTop = mediaQuery.padding.top;
    _paddingBottom = mediaQuery.padding.bottom;


    _design2LocalRate = _width/_designWith;
    _local2DesignRate = _designWith/_width;

    Log.info('设计稿尺寸 $designWith 屏幕尺寸 $width');
  }

  /// 设计尺寸转换屏幕尺寸
  static double px(double designSize){
    if (_width == 0) init(375);
    return designSize * _design2LocalRate;
  }
  /// 屏幕尺寸转换设计尺寸
  static double l2d(double localSize){
    return localSize * _local2DesignRate;
  }

  static get width => _width;
  static get designWith => _designWith;
  static get height => _height;
  static get paddingTop => _paddingTop;
  static get paddingBottom => _paddingBottom;
}