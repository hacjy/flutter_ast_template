package com.hacjy.flutter_fast_template.tool.http;

import com.hacjy.flutter_fast_template.MyApplication;
import com.hacjy.flutter_fast_template.util.StringUtil;

import rx.Observable;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Action1;
import rx.functions.Func1;
import rx.schedulers.Schedulers;

/**
 * 请求返回结果的统一处理
 */

public class MyTransformerUtil {
    /**
     * 重试次数
     */
    private final static int RETRY_COUNT = 3;

    /**
     * 默认的处理，有重试机制
     */
    public final static Observable.Transformer defaultTransformer = new Observable.Transformer() {
        @Override
        public Object call(Object o) {
            return getObservable(o,RETRY_COUNT,true);
        }
    };

    /**
     * 默认的处理，无重试机制
     */
    public final static Observable.Transformer defaultNoRetryTransformer = new Observable.Transformer() {
        @Override
        public Object call(Object o) {
            return getObservable(o,0,true);
        }
    };

    /**
     * 不处理
     */
    public final static Observable.Transformer noDealTransformer = new Observable.Transformer() {
        @Override
        public Object call(Object o) {
            return getObservable(o,RETRY_COUNT,false);
        }
    };

    /**
     * 不处理 不重试
     */
    public final static Observable.Transformer noDealNoRetryTransformer = new Observable.Transformer() {
        @Override
        public Object call(Object o) {
            return getObservable(o,0,false);
        }
    };

    /**
     * 获取Observble
     * @param o
     * @param retry 重试次数
     * @param togeterDeal 是否统一处理结果
     * @return
     */
    private static Observable getObservable(Object o, int retry,boolean togeterDeal){
        //该方法有问题 会报onNetworkMainThrea异常 弃用
        final Observable obv = (Observable) o;
        if (retry != 0){
            obv.retry(retry);
        }
        obv.subscribeOn(Schedulers.io())
           .unsubscribeOn(Schedulers.io())
           .observeOn(AndroidSchedulers.mainThread());
        if(togeterDeal) {
                obv.flatMap(new Func1<ResultInfo, Observable<ResultInfo>>() {
                @Override
                public Observable<ResultInfo> call(ResultInfo baseResultWrapper) {
                    if (baseResultWrapper == null) {
                        throw new ApiExection(ApiExection.ERROR_CODE);
                    }
                    if (baseResultWrapper.code != 200) {
                        return obv.error(new ApiThrowable(baseResultWrapper.code, baseResultWrapper.msg));
                    }
                    return obv.just(baseResultWrapper);
                }
            });
        }
        return obv;

    }


    /**
     * 不验证数据
     * @return
     */
    public static Observable.Transformer applySchedulersNoVerify() {
        return schedulersTransformerNoRetry;
    }

    /**
     * 不验证数据
     * @return
     */
    public static Observable.Transformer applySchedulersNoVerifyNoToast() {
        return schedulersTransformerNoRetryNoToast;
    }

    private static final Observable.Transformer schedulersTransformerNoRetryNoToast = new Observable.Transformer() {
        @Override
        public Object call(Object o) {
            return ((Observable) o)
                    .subscribeOn(Schedulers.io())
                    .unsubscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .doOnError(new Action1<Throwable>() {
                        @Override
                        public void call(Throwable throwable) {
                            //发生error的统一处理 主要是因为现在的请求错误信息是放在http请求状态中的。
                            DealException.dealError(throwable,false);
                        }
                    })
                    .flatMap(new Func1<ResultInfo, Observable<ResultInfo>>() {
                        @Override
                        public Observable<ResultInfo> call(ResultInfo baseResultWrapper) {
                            if (baseResultWrapper == null) {
                                throw new ApiExection(ApiExection.ERROR_CODE);
                            }
                            if (baseResultWrapper.code != 200) {
                                return Observable.error(new ApiThrowable(baseResultWrapper.code, baseResultWrapper.msg));
                            }
                            return Observable.just(baseResultWrapper);
                        }
                    });
        }
    };

    /**
     * 不进行重试次数的弹出
     */
    private static final Observable.Transformer schedulersTransformerNoRetry = new Observable.Transformer() {
        @Override
        public Object call(Object o) {
            return ((Observable) o)
                    .subscribeOn(Schedulers.io())
                    .unsubscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .doOnError(new Action1<Throwable>() {
                        @Override
                        public void call(Throwable throwable) {
                            //发生error的统一处理 主要是因为现在的请求错误信息是放在http请求状态中的。
                            DealException.dealError(throwable,true);
                        }
                    })
                    .flatMap(new Func1<ResultInfo, Observable<ResultInfo>>() {
                        @Override
                        public Observable<ResultInfo> call(ResultInfo baseResultWrapper) {
                            if (baseResultWrapper == null) {
                                throw new ApiExection(ApiExection.ERROR_CODE);
                            }
                            if (baseResultWrapper.code != 200) {
                                String msg = baseResultWrapper.msg;
                                if (!StringUtil.isEmpty(msg)) {
                                    MyApplication.getInstance().showToast(msg);
                                }
                                return Observable.error(new ApiThrowable(baseResultWrapper.code, baseResultWrapper.msg));
                            }
                            return Observable.just(baseResultWrapper);
                        }
                    });
        }
    };

}
