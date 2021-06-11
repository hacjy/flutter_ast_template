package com.hacjy.flutter_fast_template;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import androidx.multidex.MultiDex;

import com.hacjy.flutter_fast_template.util.ToastUtil;

import io.flutter.app.FlutterApplication;

/**
 */

public class MyApplication extends FlutterApplication {
    public static final String TAG = "MyApplication";

    private static MyApplication mContext;

    public static MyApplication getInstance() {
        return mContext;
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

    @Override
    public void onCreate() {
        super.onCreate();
        mContext = this;
    }

    public static Context getApp(){
        return mContext;
    }

    public void showToast(final String content){
        //切到主线程
        Handler handler = new Handler(Looper.getMainLooper()){
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                ToastUtil.showToast(MyApplication.getInstance(), content);
            }
        };
        handler.sendEmptyMessage(1);
    }

}
