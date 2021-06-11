package com.hacjy.flutter_fast_template.bean;

import android.os.Parcel;
import android.os.Parcelable;

public class FaceCertifyRequestInfo implements Parcelable {
    public static final String FACE = "FACE";
    public static final String CERT_PHOTO = "CERT_PHOTO";
    public static final String CERT_PHOTO_FACE = "CERT_PHOTO_FACE";
    public static final String SMART_FACE = "SMART_FACE";

    public static final String USE_TO_REGISTER = "register";
    public static final String USE_TO_PATIENT = "patient";

    public static final String CERT_TYPE_ALIPAY = "alipay";
    public static final String CERT_TYPE_TENCENT = "tencent";

    /**
     * cert_type*	string
     * 实名类型 alipay:支付宝 tencent:腾讯
     *
     * cert_name*	string
     * 真实姓名
     *
     * cert_no*	string
     * 证件号码
     *
     * return_url*	string
     * 需要回跳的目标地址
     *
     * use_to*	string
     * 用途 register实名建档,, patient实名就诊人
     *
     * patient_id	string
     * 病人Id, 实名就诊人时必填
     */

    public String cert_type = CERT_TYPE_ALIPAY;
    public String cert_name;
    public String cert_no;
    public String return_url;
    public String use_to = USE_TO_PATIENT;
    public String patient_id;
    public String certify_id;


    public FaceCertifyRequestInfo() {
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.cert_type);
        dest.writeString(this.cert_name);
        dest.writeString(this.cert_no);
        dest.writeString(this.return_url);
        dest.writeString(this.use_to);
        dest.writeString(this.patient_id);
        dest.writeString(this.certify_id);
    }

    protected FaceCertifyRequestInfo(Parcel in) {
        this.cert_type = in.readString();
        this.cert_name = in.readString();
        this.cert_no = in.readString();
        this.return_url = in.readString();
        this.use_to = in.readString();
        this.patient_id = in.readString();
        this.certify_id = in.readString();
    }

    public static final Creator<FaceCertifyRequestInfo> CREATOR = new Creator<FaceCertifyRequestInfo>() {
        @Override
        public FaceCertifyRequestInfo createFromParcel(Parcel source) {
            return new FaceCertifyRequestInfo(source);
        }

        @Override
        public FaceCertifyRequestInfo[] newArray(int size) {
            return new FaceCertifyRequestInfo[size];
        }
    };
}
