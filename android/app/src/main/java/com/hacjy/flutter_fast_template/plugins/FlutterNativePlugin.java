package com.hacjy.flutter_fast_template.plugins;

import android.app.Activity;

import com.hacjy.flutter_fast_template.bean.FaceCertifyRequestInfo;
import com.hacjy.flutter_fast_template.tool.AliFaceCertifyTool;
import com.hacjy.flutter_fast_template.util.JsonUtil;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterNativePlugin implements MethodChannel.MethodCallHandler {

    public static String CHANNEL = "com.czfph.czfph/face";  // 与flutter通信的渠道
    public static String METHOD_NAME_VERIFY_FACE = "verifyFace";  // 与flutter通信的方法
    static MethodChannel channel;
    private static Activity activity;

    private FlutterNativePlugin(Activity activity) {
        this.activity = activity;
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), CHANNEL);
        activity = registrar.activity();
        FlutterNativePlugin instance = new FlutterNativePlugin(activity);
        channel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals(METHOD_NAME_VERIFY_FACE)) {
            String params = (String) methodCall.arguments;
            FaceCertifyRequestInfo requestInfo = (FaceCertifyRequestInfo) JsonUtil.parseData(
                    params, FaceCertifyRequestInfo.class);
            if (requestInfo != null) {
                //执行方法
                AliFaceCertifyTool.gotoFaceCertify(activity,requestInfo);
            }
        }
        else {
            result.notImplemented();
        }
    }
}