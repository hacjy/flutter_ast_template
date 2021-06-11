package com.hacjy.flutter_fast_template.widget;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.hacjy.flutter_fast_template.R;
import com.hacjy.flutter_fast_template.util.ScreenUtil;
import com.hacjy.flutter_fast_template.util.StringUtil;


/**
 * 加载对话框
 * Created by cjy on 2018/7/17.
 */

public class LoadingDialog extends Dialog {
    private static LoadingDialog mDialog;
    private ILoadingCallBack mCallBack;
    //是否可以取消
    private boolean canCancel = false;

    private TextView tvLoadingText;

    public LoadingDialog(Context context) {
        super(context);
    }

    public LoadingDialog(Context context, int theme) {
        super(context, theme);
    }

    public LoadingDialog(Context context, int theme, boolean canCancel){
        super(context, theme);
        this.canCancel = canCancel;
    }

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.initView();
        this.initListener();
        this.initData();
    }

    //显示dilog
    public static LoadingDialog showDialog(Context context) {
        if (mDialog != null) {
            mDialog.dismissDialog();
            mDialog = null;
        }
        if (mDialog == null) {
            mDialog = new LoadingDialog(context, R.style.style_loading_dialog);
            mDialog.show();
        }
        return mDialog;
    }

    public static LoadingDialog showDialog(Context context,boolean canCancel){
        if (mDialog != null) {
            mDialog.dismissDialog();
            mDialog = null;
        }
        if (mDialog == null) {
            mDialog = new LoadingDialog(context, R.style.style_loading_dialog,canCancel);
            mDialog.show();
        }
        return mDialog;
    }

    public static boolean isShow(){
        if (mDialog != null) {
            return mDialog.isShowing();
        }
        return false;
    }

    //销毁dialog
    public static void dismissDialog() {
        try {
            if (mDialog != null) {
                mDialog.dismiss();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void show() {
        try {
            super.show();
            initDataBeforeView();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void initDataBeforeView() {
        Window win = getWindow();
//        win.setType(WindowManager.LayoutParams.TYPE_SYSTEM_OVERLAY);
        //间距为0
        win.getDecorView().setPadding(0, 0, 0, 0);
        win.setGravity(Gravity.CENTER);
        WindowManager.LayoutParams lp = getWindow().getAttributes();
        lp.width = ScreenUtil.dip2px(getContext(), 100);
        lp.height = ScreenUtil.dip2px(getContext(), 100);

        win.setAttributes(lp);
        setCancelable(canCancel);

    }

    public void initView() {
        View view = LayoutInflater.from(getContext()).inflate(R.layout.loading_view,null);
        tvLoadingText = view.findViewById(R.id.tv_loading_text);
        setContentView(view);
    }

    public void initData() {
    }

    public void initListener() {
        setOnKeyListener(new OnKeyListener() {
            @Override
            public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
                if (KeyEvent.KEYCODE_BACK == keyCode) {
                    dismiss();
                }
                return false;
            }
        });
    }

    @Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
    }

    @Override
    public void dismiss() {
        super.dismiss();
        if (mCallBack != null) {
            mCallBack.dismissCallBack();
        }
        mDialog = null;
    }

    public LoadingDialog bindData(String content){
        if(tvLoadingText != null){
            tvLoadingText.setText(StringUtil.isEmpty(content)?"加载中...":content);
        }
        return this;
    }

    public interface ILoadingCallBack {
        void dismissCallBack();
    }

    public LoadingDialog setCallBack(ILoadingCallBack mCallBack) {
        this.mCallBack = mCallBack;
        return this;
    }
}
