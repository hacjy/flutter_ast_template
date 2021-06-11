import 'package:toolbox/tool/http/login_result_info_entity.dart';

loginResultInfoEntityFromJson(LoginResultInfoEntity data, Map<String, dynamic> json) {
	if (json['access_token'] != null) {
		data.accessToken = json['access_token']?.toString();
	}
	if (json['expire_time'] != null) {
		data.expireTime = json['expire_time']?.toString();
	}
	if (json['refresh_token'] != null) {
		data.refreshToken = json['refresh_token']?.toString();
	}
	if (json['open_id'] != null) {
		data.openId = json['open_id']?.toString();
	}
	if (json['buyer_id'] != null) {
		data.buyerId = json['buyer_id']?.toString();
	}
	if (json['user'] != null) {
		data.user = new LoginResultInfoUser().fromJson(json['user']);
	}
	if (json['status'] != null) {
		data.status = new LoginResultInfoStatus().fromJson(json['status']);
	}
	if (json['extra'] != null) {
		data.extra = new LoginResultInfoExtra().fromJson(json['extra']);
	}
	return data;
}

Map<String, dynamic> loginResultInfoEntityToJson(LoginResultInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['access_token'] = entity.accessToken;
	data['expire_time'] = entity.expireTime;
	data['refresh_token'] = entity.refreshToken;
	data['open_id'] = entity.openId;
	data['buyer_id'] = entity.buyerId;
	if (entity.user != null) {
		data['user'] = entity.user.toJson();
	}
	if (entity.status != null) {
		data['status'] = entity.status.toJson();
	}
	if (entity.extra != null) {
		data['extra'] = entity.extra.toJson();
	}
	return data;
}

loginResultInfoUserFromJson(LoginResultInfoUser data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['phone_no'] != null) {
		data.phoneNo = json['phone_no']?.toString();
	}
	if (json['cert_id'] != null) {
		data.certId = json['cert_id']?.toString();
	}
	if (json['access_token'] != null) {
		data.accessToken = json['access_token']?.toString();
	}
	if (json['refresh_token'] != null) {
		data.refreshToken = json['refresh_token']?.toString();
	}
	if (json['expire_time'] != null) {
		data.expireTime = json['expire_time']?.toString();
	}
	if (json['created'] != null) {
		data.created = json['created']?.toString();
	}
	return data;
}

Map<String, dynamic> loginResultInfoUserToJson(LoginResultInfoUser entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['phone_no'] = entity.phoneNo;
	data['cert_id'] = entity.certId;
	data['access_token'] = entity.accessToken;
	data['refresh_token'] = entity.refreshToken;
	data['expire_time'] = entity.expireTime;
	data['created'] = entity.created;
	return data;
}

loginResultInfoStatusFromJson(LoginResultInfoStatus data, Map<String, dynamic> json) {
	if (json['hospital_id'] != null) {
		data.hospitalId = json['hospital_id']?.toInt();
	}
	if (json['cur_user_id'] != null) {
		data.curUserId = json['cur_user_id']?.toInt();
	}
	return data;
}

Map<String, dynamic> loginResultInfoStatusToJson(LoginResultInfoStatus entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['hospital_id'] = entity.hospitalId;
	data['cur_user_id'] = entity.curUserId;
	return data;
}

loginResultInfoExtraFromJson(LoginResultInfoExtra data, Map<String, dynamic> json) {
	return data;
}

Map<String, dynamic> loginResultInfoExtraToJson(LoginResultInfoExtra entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	return data;
}