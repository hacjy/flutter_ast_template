package com.hacjy.flutter_fast_template.tool.http;

import com.hacjy.flutter_fast_template.bean.FaceCertifyInfo;
import com.squareup.okhttp.RequestBody;

import java.util.Map;

import retrofit.http.Body;
import retrofit.http.GET;
import retrofit.http.POST;
import retrofit.http.QueryMap;
import rx.Observable;

/**
 * 接口地址
 */
public interface ApiService {

    @POST(ApiUrl.INIT_FACE_CERTIFY)
    Observable<ResultInfo<FaceCertifyInfo>> initFaceCertify(@Body RequestBody data);

    @GET(ApiUrl.GET_FACE_CERITIFY_RESULT)
    Observable<ResultInfo<String>> getFaceCertifyResult(@QueryMap Map<String, Object> data);
}
