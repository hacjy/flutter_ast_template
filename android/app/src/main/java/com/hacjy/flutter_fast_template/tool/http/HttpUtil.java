package com.hacjy.flutter_fast_template.tool.http;

import com.hacjy.flutter_fast_template.bean.FaceCertifyRequestInfo;
import com.hacjy.flutter_fast_template.util.JsonUtil;
import com.hacjy.flutter_fast_template.util.MapUtil;
import com.squareup.okhttp.MediaType;
import com.squareup.okhttp.RequestBody;

import rx.Observable;

/**
 * 接口请求
 */
public class HttpUtil{

    /**
     * @param
     * @return
     * @throws Exception
     */
    public static Observable initFaceCertify(FaceCertifyRequestInfo info) throws Exception {

        return LoadApiServiceHelper
                .loadApiService()
                .initFaceCertify(createBody(JsonUtil.objectToString(info)))
                .compose(MyTransformerUtil.applySchedulersNoVerify());
    }

    /**
     *
     * @return
     * @throws Exception
     */
    public static Observable getFaceCertifyResult(String certifyId) throws Exception {
        FaceCertifyRequestInfo info = new FaceCertifyRequestInfo();
        info.certify_id = certifyId;

        return LoadApiServiceHelper
                .loadApiService()
                .getFaceCertifyResult(MapUtil.objectToMap(info))
                .compose(MyTransformerUtil.applySchedulersNoVerify());
    }

    /**
     * 创建请求Body
     * @param paramsJson
     * @return
     */
    private static RequestBody createBody(String paramsJson){
        RequestBody body = RequestBody.create(MediaType.parse("application/json; charset=utf-8"),paramsJson);
        return body;
    }

}
