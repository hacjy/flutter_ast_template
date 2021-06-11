import 'package:toolbox/generated/json/base/json_convert_content.dart';
import 'package:toolbox/generated/json/base/json_filed.dart';

class LoginResultInfoEntity with JsonConvert<LoginResultInfoEntity> {
	@JSONField(name: "access_token")
	String accessToken;
	@JSONField(name: "expire_time")
	String expireTime;
	@JSONField(name: "refresh_token")
	String refreshToken;
	@JSONField(name: "open_id")
	String openId;
	@JSONField(name: "buyer_id")
	String buyerId;
	LoginResultInfoUser user;
	LoginResultInfoStatus status;
	LoginResultInfoExtra extra;
}

class LoginResultInfoUser with JsonConvert<LoginResultInfoUser> {
	int id;
	String name;
	@JSONField(name: "phone_no")
	String phoneNo;
	@JSONField(name: "cert_id")
	String certId;
	@JSONField(name: "access_token")
	String accessToken;
	@JSONField(name: "refresh_token")
	String refreshToken;
	@JSONField(name: "expire_time")
	String expireTime;
	String created;
}

class LoginResultInfoStatus with JsonConvert<LoginResultInfoStatus> {
	@JSONField(name: "hospital_id")
	int hospitalId;
	@JSONField(name: "cur_user_id")
	int curUserId;
}

class LoginResultInfoExtra with JsonConvert<LoginResultInfoExtra> {

}
