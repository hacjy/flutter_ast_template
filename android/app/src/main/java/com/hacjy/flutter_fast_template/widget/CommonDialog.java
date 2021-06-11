package com.hacjy.flutter_fast_template.widget;

import android.content.Context;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.hacjy.flutter_fast_template.R;
import com.hacjy.flutter_fast_template.util.ScreenUtil;

/**
 * 通用对话框
 */
public class CommonDialog extends BaseDialog {
    private static CommonDialog dialog;

    private TextView tvTitle;
    private Button btnCancel;
    private Button btnOk;
    private TextView tvContent;
    private OnClickCallback callback;

    public CommonDialog(@NonNull Context context) {
        super(context);
    }

    public CommonDialog(@NonNull Context context, int theme) {
        super(context,theme);
    }

    public static CommonDialog showDialog(Context context, boolean isCancelOutside){
        if (dialog != null) {
            if (dialog.isShowing()) {
                dialog.dismiss();
            }
            dialog = null;
        }
        if(dialog == null){
            dialog = new CommonDialog(context, R.style.style_doctor_dialog);
            allowCancelOutside(isCancelOutside);
        }
        dialog.show();

        return dialog;
    }

    private static void allowCancelOutside(boolean isCancel){
        if (dialog != null) {
            dialog.setCancelable(isCancel);
            dialog.setCanceledOnTouchOutside(isCancel);
        }
    }

    @Override
    public void initDataBeforeView() {
        super.initDataBeforeView();

        WindowManager.LayoutParams lp = this.getWindow().getAttributes();
        this.getWindow().setGravity(Gravity.CENTER);
        lp.width = (int) (ScreenUtil.getScreenWidth(this.getContext())*0.75);
        this.getWindow().setAttributes(lp);
    }

    @Override
    public void initView() {
        super.initView();
        View view = LayoutInflater.from(getContext()).inflate(R.layout.dialog_common,null);
        setContentView(view);

        tvTitle = findViewById(R.id.tv_title);
        tvContent = findViewById(R.id.tv_content);
        btnCancel = findViewById(R.id.btn_cancel);
        btnOk = findViewById(R.id.btn_ok);
    }

    @Override
    public void initListener() {
        super.initListener();
        btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
                if (callback != null){
                    callback.onClick(false);
                }
            }
        });
        btnOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
                if (callback != null){
                    callback.onClick(true);
                }
            }
        });
    }



    /**
     * 绑定数据
     * @param title
     * @param content
     */
    public CommonDialog bindData(String title,String content){
        tvTitle.setText(title);
        tvContent.setText(content);
        return this;
    }

    /**
     * 绑定数据
     * @param content
     */
    public CommonDialog bindData(String content){
        tvContent.setText(content);
        return this;
    }

    public CommonDialog setCallback(OnClickCallback callback) {
        this.callback = callback;
        return this;
    }



    public interface OnClickCallback{
        void onClick(boolean isOk);
    }
}
