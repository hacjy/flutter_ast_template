package com.hacjy.flutter_fast_template.wxapi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.hacjy.flutter_fast_template.R;
import com.hacjy.flutter_fast_template.tool.WXManager;
import com.hacjy.flutter_fast_template.util.CLog;
import com.hacjy.flutter_fast_template.util.JsonUtil;
import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

/**
 * 微信回调
 */
public class WXEntryActivity extends Activity implements IWXAPIEventHandler {
    private static final String TAG = "WXEntryActivity";

    private IWXAPI api;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pay_result);

        api = WXAPIFactory.createWXAPI(this, WXManager.getWxAppId());
        api.handleIntent(getIntent(), this);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        api.handleIntent(intent, this);
    }

    @Override
    public void onReq(BaseReq req) {
    }

    @Override
    public void onResp(BaseResp resp) {
        CLog.e("wx-result", JsonUtil.objectToString(resp));
        if (resp.getType() == ConstantsAPI.COMMAND_LAUNCH_WX_MINIPROGRAM) {
            WXLaunchMiniProgram.Resp launchMiniProResp = (WXLaunchMiniProgram.Resp) resp;
            //对应小程序组件 <button open-type="launchApp"> 中的 app-parameter 属性
            String extraData =launchMiniProResp.extMsg;
            CLog.e("wx-result-extraData", extraData==null?"":extraData);
        }
    }
}