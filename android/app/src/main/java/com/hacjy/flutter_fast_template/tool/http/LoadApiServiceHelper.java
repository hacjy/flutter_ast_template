package com.hacjy.flutter_fast_template.tool.http;


import com.hacjy.flutter_fast_template.MyApplication;
import com.hacjy.flutter_fast_template.util.CLog;
import com.hacjy.flutter_fast_template.util.SharedPreUtil;
import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;

import java.io.IOException;
import java.net.SocketTimeoutException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

import retrofit.GsonConverterFactory;
import retrofit.Retrofit;

/**
 * api帮助类
 */
public class LoadApiServiceHelper {
    /**
     * 网络请求超时时间
     */
    private final static long TIME_OUT = 60;

    public static ApiService loadApiService(){
        String url = ApiUrl.baseUrl();
        return getRetrofit(url,createHeader())
                .create(ApiService.class);
    }

    public static Retrofit getRetrofit(String baseUrl, HashMap<String,String> headers){
        return getRetrofit(baseUrl,TIME_OUT,headers);
    }

    /**
     * 设置超时的retrofit
     * @param baseUrl
     * @param timeout 0 不设置超时
     * @return
     */
    public static Retrofit getRetrofit(String baseUrl, long timeout, final HashMap<String,String> headers){
        OkHttpClient okHttpClient = new OkHttpClient();
        Interceptor interceptor = new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
                Request original = chain.request();
                Request.Builder requestBuilder = original.newBuilder();

                List<String> paths = original.httpUrl().pathSegments();
                StringBuffer stringBuffer = new StringBuffer();
                if (paths != null && paths.size() > 0){
                    for (int i = 0; i < paths.size(); i++){
                        stringBuffer.append("/");
                        stringBuffer.append(paths.get(i));
                    }
                }
                String path = stringBuffer.toString();
                //需要再次设置method，不然会报HTTP 405 Method Not Allowed
                requestBuilder.method(original.method(),original.body());
                //地址类似https://ih.czfph.com:21014/v2/ihospital v2会被过滤掉，所以重新设置下请求的地址
                // (这时地址要是完整的接口地址)
                requestBuilder.url(ApiUrl.baseUrl()+path);

                if (headers != null && headers.size() > 0){
                    for (Map.Entry<String,String> header:headers.entrySet())
                        requestBuilder.addHeader(header.getKey(), header.getValue());
                }

                Request request = requestBuilder.build();
                Response response = null;
                try {
                    response = chain.proceed(request);
                    CLog.e("response",response.toString());
                    // 输出返回结果
                } catch (Exception e) {
                    e.printStackTrace();
                    if (e instanceof SocketTimeoutException){
                        CLog.e("http response","SocketTimeoutException");
                        MyApplication.getInstance().showToast("网络超时，请稍后重试");
                    }
                }

                return response;
            }
        };
        if (baseUrl.startsWith("https")){
            okHttpClient.setSslSocketFactory(SSLSocketClient.getSSLSocketFactory());
            okHttpClient.setHostnameVerifier(SSLSocketClient.getHostnameVerifier());
        }
        okHttpClient.interceptors().add(interceptor);
        if (timeout != 0) {
            okHttpClient.setConnectTimeout(timeout, TimeUnit.SECONDS);
        }
        return RetrofitUtil.getRetrofitBuilder(baseUrl)
                .addConverterFactory(GsonConverterFactory.create())
                .client(okHttpClient).build();
    }

    public static HashMap<String,String> createHeader(){
        HashMap<String,String> headMap = new HashMap<>();
        headMap.put("Content-Type","application/json;charset=UTF-8");
        headMap.put("Accept","application/json");
        String os = android.os.Build.VERSION.RELEASE;
        headMap.put("X-OS",os);
        //怎么从flutter传过来 从sharepreference中获取
        String accessToken = "";
        accessToken = SharedPreUtil.getString(MyApplication.getInstance(),"accessToken");
        if (accessToken.isEmpty()){
            accessToken = "hAgsgx46TMaTO31h2Bm2t6x8JrVInKxA5QVogmdEmxo=:"+ UUID.randomUUID().toString();
        }
        headMap.put("X-Authorization", accessToken);
        headMap.put("X-Channel","Android");
        return headMap;
    }

}
