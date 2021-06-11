import 'package:toolbox/constants/constant.dart';
import 'package:toolbox/generated/json/base/json_convert_content.dart';

class BaseResultEntity<T>{
  int code;
  String msg;
  String detail;
  T data;
  //结果数据的json串
  Map<String, dynamic> dataJson;

  BaseResultEntity(this.code, this.msg, this.data,{this.detail});

  BaseResultEntity.fromJson(Map<String, dynamic> json) {
    code = json[Constant.code] as int;
    msg = json[Constant.message] as String;
    detail = json[Constant.detail] as String;
    dataJson = json;
//    if (json.containsKey(Constant.data)) {
//      data = _generateOBJ(json[Constant.data]);
//    }
  }

  S _generateOBJ<S>(Object json) {
    if (S.toString() == 'String') {
      return json.toString() as S;
    } else if (T.toString() == 'Map<dynamic, dynamic>') {
      return json as S;
    } else {
      return JsonConvert.fromJsonAsT<S>(json);
    }
  }

  ///解决异常：Converting object to an encodable object failed: Instance of 'BaseResultEntity<String>'
  Map toJson() {
    Map map = new Map();
    map["code"] = this.code;
    map["msg"] = this.msg;
    map["data"] = this.data;
    map["detail"] = this.detail;
    return map;
  }
}