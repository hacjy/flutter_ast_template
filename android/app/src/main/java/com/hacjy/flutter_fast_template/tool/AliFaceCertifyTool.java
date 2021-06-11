package com.hacjy.flutter_fast_template.tool;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;

import com.hacjy.flutter_fast_template.R;
import com.hacjy.flutter_fast_template.bean.FaceCertifyInfo;
import com.hacjy.flutter_fast_template.bean.FaceCertifyRequestInfo;
import com.hacjy.flutter_fast_template.tool.http.HttpUtil;
import com.hacjy.flutter_fast_template.tool.http.ResultInfo;
import com.hacjy.flutter_fast_template.util.ToastUtil;
import com.hacjy.flutter_fast_template.widget.CommonDialog;
import com.hacjy.flutter_fast_template.widget.LoadingDialog;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

import rx.Subscriber;

/**
 * 身份认证工具类：支付宝
 * 本地回调 对应的androidmanifest也要设置
 */
public class AliFaceCertifyTool {
    public static final String refererUrl = "czfph://health.faceback";

    private static FaceCertifyRequestInfo requestInfo;

    public static void toAliFace(Context context, FaceCertifyInfo info){
        if (info != null) {
            try {
                Intent action = new Intent(Intent.ACTION_VIEW);
                StringBuilder builder = new StringBuilder();
                builder.append("alipays://platformapi/startapp?appId=20000067");
                builder.append("&url=");
                builder.append(URLEncoder.encode(info.certify_url,"UTF-8"));
                action.setData(Uri.parse(builder.toString()));
                context.startActivity(action);
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
    }

    private static void test(Context context){
        String id = "ec40a6e934e14c5d39e9e1c2afac2cdd";
        String url = "https://openapi.alipay.com/gateway.do?app_id=2021001158676253&biz_content=%7B%22certify_id%22%3A%20%22ec40a6e934e14c5d39e9e1c2afac2cdd%22%7D&charset=utf-8&format=JSON&method=alipay.user.certify.open.certify&sign_type=RSA2&timestamp=2020-07-09%2017%3A33%3A20&version=1.0&sign=e/alJAkdaT0mZFQmpMMuwfQ4tvVkKdklS2B8dvTizxsBX1VqHOXu2vStwIsi1InlVzEA3Lcd3hNfn3ufRSN8L289XnXVHtz2hQa9ELvu7WEl%2BcFUDo9mxQjJ%2BKd4Q5rAKSe8DiNTvSw1IF/nkaQKIcxRg8xqYV/Q%2BGWdeN3crkayXfVIBNEEofa0crFR6uqS4PaAw7dm8QNizhTf/LoSUW2XI8eKnwNrqbKkkGuGvnAabCZDrPeyQMPHdg9XTrVb6pryf5zAs3uhrNKLcWvKro3WaDzzeQIBFHRduBEi6dQMIJodPZyp13Rc5RRaXVBOz3GyMMkjO5yt/Dl2qjHAhg%3D%3D";
        FaceCertifyInfo faceCertifyInfo = new FaceCertifyInfo();
        faceCertifyInfo.certify_id = id;
        faceCertifyInfo.certify_url = url;
        if (requestInfo != null) {
            requestInfo.certify_id = faceCertifyInfo.certify_id;
        }
        toAliFace(context,faceCertifyInfo);
    }

    private static void initFaceCertify(final Context context, final FaceCertifyRequestInfo requestInfo){
        //TODO 测试
//        test(context);
        try {
            if (requestInfo == null)
                return;
            LoadingDialog.showDialog(context);
            HttpUtil.initFaceCertify(requestInfo).subscribe(new Subscriber() {
                @Override
                public void onCompleted() {

                }

                @Override
                public void onError(Throwable e) {
                    e.printStackTrace();
                }

                @Override
                public void onNext(Object o) {
                    LoadingDialog.dismissDialog();
                    ResultInfo<FaceCertifyInfo> resultInfo = (ResultInfo<FaceCertifyInfo>) o;
                    if (resultInfo != null){
                        FaceCertifyInfo faceCertifyInfo = resultInfo.data;
                        if (requestInfo != null) {
                            requestInfo.certify_id = faceCertifyInfo.certify_id;
                        }
                        toAliFace(context,faceCertifyInfo);
                    }

                }
            });
        } catch (Exception e) {
            LoadingDialog.dismissDialog();
            e.printStackTrace();
        }
    }

    private static void getFaceCertifyResult(final Context context, final String certifyId){
        try {
            LoadingDialog.showDialog(context);
            HttpUtil.getFaceCertifyResult(certifyId).subscribe(new Subscriber() {
                @Override
                public void onCompleted() {

                }

                @Override
                public void onError(Throwable e) {
                    e.printStackTrace();
                }

                @Override
                public void onNext(Object o) {
                    LoadingDialog.dismissDialog();
                    //人脸识别结果
                    ToastUtil.showToast(context,"人脸识别成功");
                    requestInfo = null;
                }
            });
        } catch (Exception e) {
            LoadingDialog.dismissDialog();
            e.printStackTrace();
        }
    }

    public static void showDialog(Context context,String name,String idNo,String useTo,String patientId){
        setCeritifyInfo(name,idNo,useTo,refererUrl,patientId);
        //提示对话框
        CommonDialog.showDialog(context,false)
                .bindData("温馨提示",
                context.getString(R.string.txt_face_certify_to_complete_hint))
                .setCallback(new CommonDialog.OnClickCallback() {
                    @Override
                    public void onClick(boolean isOk) {
                        if (isOk){
                            initFaceCertify(context,requestInfo);
                        }
                    }
                });
    }

    public static void showConfirmDialog(Context context,String name,String idNo,
                                         String useTo,String returnUrl,
                                         String confirmContent,String patientId){
        setCeritifyInfo(name,idNo,useTo,returnUrl,patientId);
        //提示对话框
        CommonDialog.showDialog(context,false)
                .bindData("温馨提示",confirmContent)
        .setCallback(new CommonDialog.OnClickCallback() {
            @Override
            public void onClick(boolean isOk) {
                if (isOk){
                    initFaceCertify(context,requestInfo);
                }
            }
        });
    }

    public static void setCeritifyInfo(String name,String idNo,String useTo,
                                       String returnUrl,String patientId){
        if (requestInfo == null)
            requestInfo = new FaceCertifyRequestInfo();
        requestInfo.cert_name = name;
        requestInfo.cert_no = idNo;
        requestInfo.use_to = useTo;
        requestInfo.return_url = returnUrl;
        requestInfo.patient_id = patientId;
    }

    public static void setCeritifyInfo(FaceCertifyRequestInfo info){
        requestInfo = info;
    }

    /**
     * 去人脸识别实名认证
     * @param context
     */
    public static void gotoFaceCertify(Context context,FaceCertifyRequestInfo info){
        setCeritifyInfo(info);
        if (hasInstallAlipay(context)) {
            initFaceCertify(context,requestInfo);
        } else {
            ToastUtil.showToast(context,"请先安装支付宝");
        }
    }

    /**
     * 去人脸识别实名认证
     * @param context
     */
    public static void gotoFaceCertify(Context context){
        if (hasInstallAlipay(context)) {
            initFaceCertify(context,requestInfo);
        } else {
            ToastUtil.showToast(context,"请先安装支付宝");
        }
    }

    /**
     * 人脸识别回调
     * @param context
     */
    public static void faceCertifyCallback(Context context){
        if (requestInfo != null) {
            getFaceCertifyResult(context,requestInfo.certify_id);
        }
    }

    /**
     * 判断是否安装了支付宝
     *
     * @return true 为已经安装
     */
    public static boolean hasInstallAlipay(Context context) {
        PackageManager manager = context.getPackageManager();
        Intent action = new Intent(Intent.ACTION_VIEW);
        action.setData(Uri.parse("alipays://"));
        List<ResolveInfo> list = manager.queryIntentActivities(action, PackageManager.GET_RESOLVED_FILTER);
        return list != null && list.size() > 0;
    }

}
