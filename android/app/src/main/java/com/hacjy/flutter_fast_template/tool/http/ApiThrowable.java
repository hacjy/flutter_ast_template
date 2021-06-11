package com.hacjy.flutter_fast_template.tool.http;

/**
 * 自定义的Throwable
 * Created by cjy on 2018/7/25.
 */

public class ApiThrowable  extends Throwable {
    //错误码
    public int code;
    //错误提示
    public String msg;

    public ApiThrowable(int code) {
        super();
        this.code = code;
    }

    public ApiThrowable(int code,String msg){
        super(msg);
        this.code = code;
        this.msg = msg;
    }
}
