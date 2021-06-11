import 'package:intl/intl.dart';

class DateTimeUtil{
  static const String formatYmd = 'yyyy-MM-dd';
  static const String formatYmdhms = 'yyyy-MM-dd HH:mm:ss';

  /// 获取时间，格式为HH:mm:ss(时分秒)
  /// param1- seconds:总秒数
  static String getHMmmss_Seconds(int seconds){
    int h = 0,m = 0,s = 0;String result = "";
    if(seconds <= 59){
      return "00:"+getDoubleStr(seconds);
    }else{
      m = seconds~/60;
      s = seconds % 60;
      if(m <= 59){
        return getDoubleStr(m)+":"+getDoubleStr(s);
      }else{
        h = m ~/ 60;
        m = m % 60;
        return getDoubleStr(h)+":"+getDoubleStr(m)+":"+getDoubleStr(s);
      }
    }
  }
  static String getDoubleStr(int num){
    try {
      if(num < 10){
        return "0"+num.toString();
      }else{
        return num.toString();
      }
    } catch (e) {
      return "00";
    }
  }

  static String getCurrentTime({String srtFormat=formatYmdhms}){
    var format = new DateFormat(srtFormat);
    DateTime nowTime = DateTime.now();
    String date = format.format(nowTime);
    return date;
  }

  static DayItem getDatItem(String preMonth, int duration) {
    var format = new DateFormat('yyyy-MM-dd');
    DateTime nowTime = DateTime.now();
    DateTime durationDate = nowTime.add(new Duration(days: duration));
    String month = durationDate.month.toString() + '月';
    int day = durationDate.day;
    String date = format.format(durationDate);
    if (month != preMonth) {
      month = month.toString();
    } else {
      month = '';
    }

    DayItem dayItem =
    DayItem(month, day.toString(), getWeek(durationDate), date);
    return dayItem;
  }


  // 获取星期
  static String getWeek(DateTime date) {
    var week = date.weekday;
    String w = '';
    switch (week.toString()) {
      case '1':
        w = '一';
        break;
      case '2':
        w = '二';
        break;
      case '3':
        w = '三';
        break;
      case '4':
        w = '四';
        break;
      case '5':
        w = '五';
        break;
      case '6':
        w = '六';
        break;
      case '7':
        w = '日';
        break;
    }
    return w.toString();
  }


}



class DayItem {
  DayItem(this.month, this.monthDay, this.weekDay,this.date);
  String month;
  String weekDay;
  String monthDay;
  String date;
}