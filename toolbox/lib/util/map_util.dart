import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:toolbox/tool/toast.dart';
import 'package:toolbox/util/gps_util.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtil{
  BuildContext context;

  MapUtil(this.context);

  /// 高德地图
  Future<bool> gotoGaoDeMap(longitude, latitude,
      {String toAddress}) async {
    List<num> list = GpsUtil.bd09_To_Gcj02(latitude, longitude);
    var url =
        '${Platform.isAndroid ? 'android' : 'ios'}amap://navi?sourceApplication=amap&lat=${list[0]}&lon=${list[1]}&dev=0&style=2&poiname=${toAddress ?? ''}';
    url=Uri.encodeFull(url);
    print('gotoGaoDeMap url=$url');
    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      ToastUtil.show(context,'未检测到高德地图~');
      return false;
    }

    await launch(url);

    return true;
  }

  /// 腾讯地图
  Future<bool> gotoTencentMap(longitude, latitude,
      {String toAddress}) async {
    List<num> list = GpsUtil.bd09_To_Gcj02(latitude, longitude);
    var url =
        'qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=${list[0]},${list[1]}&referer=FN4BZ-6E33P-LFTDB-VRZ4C-NTP3Z-RVFFK&debug=true&to=${toAddress ?? ''}';
    print('gotoTencentMap url=$url');
    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      ToastUtil.show(context,'未检测到腾讯地图~');
      return false;
    }

    await launch(url);

    return canLaunchUrl;
  }


  /// 百度地图
  Future<bool> gotoBaiduMap(longitude, latitude,
      {String toAddress}) async {
    var url =
        'baidumap://map/direction?destination=name:${toAddress ?? ''}|latlng:$latitude,$longitude&coord_type=bd09ll&mode=driving';
    url = Uri.encodeFull(url);
    print('gotoBaiduMap url=$url');

    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      ToastUtil.show(context, '未检测到百度地图~');
      return false;
    }

    await launch(url);

    return canLaunchUrl;
  }

  /// 苹果地图
  Future<bool> gotoAppleMap(longitude, latitude,
      {String toAddress}) async {
    List<num> list = GpsUtil.bd09_To_Gcj02(latitude, longitude);
    var url = 'http://maps.apple.com/?daddr=${list[0]},${list[1]}&address=$toAddress';
    url=Uri.encodeFull(url);
    print('url=$url');
    bool canLaunchUrl = await canLaunch(url);

    if (!canLaunchUrl) {
      ToastUtil.show(context, '打开失败~');
      return false;
    }

    await launch(url);
  }

}