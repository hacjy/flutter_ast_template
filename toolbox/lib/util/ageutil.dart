class AgeUtil{
  static int getAge(String birthday){
    if(birthday==null||birthday==''){
      return 0;
    }
    DateTime birthDate = DateTime.parse(birthday);
    Duration mDuration = DateTime.now().difference(birthDate);
    return (mDuration.inDays / 365).floor();
  }
}