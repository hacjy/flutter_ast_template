package com.hacjy.flutter_fast_template.bean;

import android.os.Parcel;
import android.os.Parcelable;

public class FaceCertifyInfo implements Parcelable {
    public String certify_id;
    public String certify_url;

    public FaceCertifyInfo() {
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.certify_id);
        dest.writeString(this.certify_url);
    }

    protected FaceCertifyInfo(Parcel in) {
        this.certify_id = in.readString();
        this.certify_url = in.readString();
    }

    public static final Creator<FaceCertifyInfo> CREATOR = new Creator<FaceCertifyInfo>() {
        @Override
        public FaceCertifyInfo createFromParcel(Parcel source) {
            return new FaceCertifyInfo(source);
        }

        @Override
        public FaceCertifyInfo[] newArray(int size) {
            return new FaceCertifyInfo[size];
        }
    };
}
