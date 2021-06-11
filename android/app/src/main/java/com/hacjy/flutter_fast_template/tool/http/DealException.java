package com.hacjy.flutter_fast_template.tool.http;

import com.hacjy.flutter_fast_template.MyApplication;
import com.hacjy.flutter_fast_template.util.CLog;
import com.hacjy.flutter_fast_template.widget.LoadingDialog;
import com.squareup.okhttp.ResponseBody;

import java.net.ConnectException;

import retrofit.HttpException;

/**
 * 异常统一处理
 */
public class DealException {
    //预交金不足，请充值的提示
    public static final int ERROR_CODE_466 = 466;
    //未登录或者token失效、被踢出
    public static final int ERROR_CODE_401 = 401;
    //医生正在看诊其他患者，患者进入诊间的提示 特殊处理，弹窗
    public static final int ERROR_CODE_460 = 460;

    public static void dealError(Throwable throwable,boolean isToast){
        LoadingDialog.dismissDialog();
        if (throwable instanceof HttpException){
            HttpException httpException = (HttpException) throwable;
            ResponseBody errorBody = httpException.response().errorBody();
            if (errorBody != null){
                try {
                    String content = new String(errorBody.bytes());
                    CLog.e("request-errorContent",content);
                } catch (Exception e1) {
                    e1.printStackTrace();
                }
            }
        }else if (throwable instanceof ConnectException){
            MyApplication.getInstance().showToast("网络异常，请检查网络");
        }
    }

    public static void deal401(){
        try {
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
