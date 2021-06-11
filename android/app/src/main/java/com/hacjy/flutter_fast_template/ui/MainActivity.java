package com.hacjy.flutter_fast_template.ui;


import com.hacjy.flutter_fast_template.tool.WXManager;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "app.cfph.com/location";
    private static final String OPEN_LOCATION_METHOD = "openLocation";
    private MethodChannel methodChannel;

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine){
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL);
        methodChannel.setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals(OPEN_LOCATION_METHOD)) {
                            WXManager.openLocation();
                        } else {
                            //没有对应方法
                            result.notImplemented();
                        }
                    }
                }
        );
    }

}
