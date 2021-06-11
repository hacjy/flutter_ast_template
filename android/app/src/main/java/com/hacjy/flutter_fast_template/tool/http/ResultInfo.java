package com.hacjy.flutter_fast_template.tool.http;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * 接口返回结果信息
 * @param <T>
 */
public class ResultInfo<T> implements Parcelable {
    public int code;
    public String msg;
    public T data;

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.code);
        dest.writeString(this.msg);
    }

    public ResultInfo() {
    }

    protected ResultInfo(Parcel in) {
        this.code = in.readInt();
        this.msg = in.readString();
    }

    public static final Creator<ResultInfo> CREATOR = new Creator<ResultInfo>() {
        @Override
        public ResultInfo createFromParcel(Parcel source) {
            return new ResultInfo(source);
        }

        @Override
        public ResultInfo[] newArray(int size) {
            return new ResultInfo[size];
        }
    };
}
