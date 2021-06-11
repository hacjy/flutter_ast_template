import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_logan/flutter_logan.dart';

class Log {
  static const int ERROR = 0;
  static const int WARNING = 1;
  static const int INFO = 2;
  static const int DEBUG = 3;

  static void debug(Object txt) {
    FlutterLogan.log(DEBUG, '$txt');
  }

  static void error(Object txt) {
    FlutterLogan.log(ERROR, '$txt');
  }

  static void info(Object txt) {
    FlutterLogan.log(INFO, '$txt');
  }

  static void warning(Object txt) {
    FlutterLogan.log(WARNING,'$txt');
  }

  static init () async {
    String result = 'Failed to init log';
    try {
      final bool back = await FlutterLogan.init(
          '0123456789012345', '0123456789012345', 1024 * 1024 * 10);
      if (back) {
        result = 'Init log succeed';
      }
    } on PlatformException {
      result = 'Failed to init log';
    }
    print(result);
  }

  static Future<String> getLogPath() async{
    String result;
    try {
      final today = DateTime.now();
      final date = "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      final String path = await FlutterLogan.getUploadPath(date);
      if (path != null) {
        result = 'upload path = ' + path;
      } else {
        result = 'Failed to get upload path';
      }
    } on PlatformException {
      result = 'Failed to get upload path';
    }
    print(result);
    return result;
  }


  static Future<String> upload() async{
    String result = 'Failed upload to server';
    try {
      final today = DateTime.now();
      final date = "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      final bool bakc = await FlutterLogan.upload(
          'http://127.0.0.1:3000/logupload',
          date,
          'FlutterTestAppId',
          'FlutterTestUnionId',
          'FlutterTestDeviceId'
      );
      if (bakc) {
        result = 'Upload to server succeed';
      }
    } on PlatformException {
      result = 'Failed upload to server';
    }
    print(result);
    return result;
  }

}