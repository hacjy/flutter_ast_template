class TimeUtil{
  static String secondToString(int inputSecond){
    int second = inputSecond%60;
    int minute = inputSecond~/60;
    int hours = 0;
    if(minute>=60){
       hours = minute~/60;
      minute = minute%60;
    }
    
    String time = '';
    if(hours<10){
      time += '0';
    }
    time += '$hours';
    time += ':';
    
    if(minute<10){
      time += '0';
    }
    time += '$minute';
    time += ':';
    
    if(second<10){
      time += '0';
    }
    time += '$second';
    return time;

  }
}