package com.hacjy.flutter_fast_template.util;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

/**
 * Created by cjy on 2018/11/16.
 */

public class ToastUtil {
    private static Toast mToast;
    private static Toast mmToast;
    private static Toast mmcToast;

    public ToastUtil() {
    }

    public static void showToast(Context context, String text) {
        if (mToast == null) {
            //解决miuitoast带有app名称的问题
            mToast=Toast.makeText(context,null,Toast.LENGTH_SHORT);
            mToast.setText(text);
        } else {
            //如果当前Toast没有消失， 直接显示内容，不需要重新设置
            mToast.setText(text);
        }
        mToast.show();
    }

    public static void showMidToast(Context context, String text) {
        if(mmToast == null) {
            mmToast = Toast.makeText(context, text, Toast.LENGTH_SHORT);
            mmToast.setGravity(17, 0, 0);
        } else {
            mmToast.setText(text);
            mmToast.setDuration(Toast.LENGTH_SHORT);
        }

        mmToast.show();
    }

    public static void showCostomerMidToast(Context context, View view, String text) {
        if(mmcToast == null) {
            mmcToast = Toast.makeText(context, text, Toast.LENGTH_SHORT);
            mmcToast.setGravity(17, 0, 0);
            ((ViewGroup)mmcToast.getView()).addView(view, 0);
        } else {
            mmcToast.setText(text);
            mmcToast.setDuration(Toast.LENGTH_SHORT);
        }

        mmcToast.show();
    }
}
