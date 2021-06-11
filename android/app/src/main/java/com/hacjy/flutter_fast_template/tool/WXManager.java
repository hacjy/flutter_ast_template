package com.hacjy.flutter_fast_template.tool;

import com.hacjy.flutter_fast_template.MyApplication;
import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

public class WXManager {
    static  String appId = "wxfc334317edc2a1bd"; // 填应用AppId
    static  String originId = "gh_8d755e59af71"; // 填小程序原始id

    //自己的
//    static String appId = "wxfc334317edc2a1bd";
//    static  String originId = "gh_bbf0f66039d3";

    public static String getWxAppId(){
        return appId;
    }

    public static void openLocation(){
        String path = "pages/index/index?url=https%3A%2F%2Fchangzhou.h5daohang.com%2Fh5%2F&maddie_key=GXAERmr5BLxpt9DASCKC&maddie_mapid=czhospital";
        IWXAPI api = WXAPIFactory.createWXAPI(MyApplication.getInstance(), appId);

        WXLaunchMiniProgram.Req req = new WXLaunchMiniProgram.Req();
        req.userName = originId;
        //拉起小程序页面的可带参路径，不填默认拉起小程序首页，
        // 对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
        req.path = path;
        api.sendReq(req);
    }
}
