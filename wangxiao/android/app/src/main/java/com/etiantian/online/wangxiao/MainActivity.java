package com.etiantian.online.wangxiao;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static String device_channel_name = "com.etiantian/device_type";
    private static String wangxiao_channel_name = "aixue_wangxiao_channel";
    FlutterEngine theFlutterEngine;
    MethodChannel methodChannel;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        theFlutterEngine = flutterEngine;
        new MethodChannel(flutterEngine.getDartExecutor(), device_channel_name)
                .setMethodCallHandler(
                        (call, result) -> {
                            System.out.println(call.method);
                            if (call.method.equals("deviceType")) {
                                boolean isPad = isTablet(this);
                                result.success(isPad);
                            }
                        }
                );

        methodChannel = new MethodChannel(flutterEngine.getDartExecutor(),wangxiao_channel_name);

        //退到后台
        boolean has = getIntent().hasExtra("onlineSchoolApp");
        Log.i("","");
        // 是否跳转
        // 是,获取参数,插件通信
        if (has) {
            String string = getIntent().getStringExtra("onlineSchoolApp");
            String deStr = startDecrypt(string);
            methodChannel.invokeMethod("comeFromAixue",deStr);
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        if (methodChannel == null) {
            methodChannel = new MethodChannel(theFlutterEngine.getDartExecutor(),wangxiao_channel_name);
        }

        boolean has = intent.hasExtra("onlineSchoolApp");
        Log.i("","");
        // 是否跳转
        // 是,获取参数,插件通信
        if (has) {
            String string = intent.getStringExtra("onlineSchoolApp");
            String deStr = startDecrypt(string);
            methodChannel.invokeMethod("comeFromAixue",deStr);
        }
    }

    /**
     * des 解密算法
     * @param text 待解密的字符串
     * @return 解密后的字符串
     */
    public static String startDecrypt(String text){
        try {
            return DesUtils.decrypt(text, "*#C2HWAIX*#");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 判断当前设备是手机还是平板，代码来自 Google I/O App for Android
     * @param context
     * @return 平板返回 True，手机返回 False
     */
    public static boolean isTablet(Context context) {
        return (context.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) >= Configuration.SCREENLAYOUT_SIZE_LARGE;
    }
}
