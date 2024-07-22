package com.sistalk.oppo_push_demo;

import android.app.Application;
import android.util.Log;

import com.heytap.msp.push.HeytapPushManager;
import com.heytap.msp.push.callback.ICallBackResultService;

public class App extends Application {
    String TAG = "App";

    @Override
    public void onCreate() {
        super.onCreate();
        HeytapPushManager.init(this, true);
        HeytapPushManager.register(this, "8mEfvC3k8msCck4c8Oo80GOoo", "f59eCcE7f8270C77548Fde85ce146Ed7", new ICallBackResultService() {
            @Override
            public void onRegister(int responseCode, String registerID,String packageName,String miniPackageName) {
                Log.e(TAG, "on oppo register + " + responseCode + " " + registerID);
                if (!registerID.isEmpty()) {
//                    deviceToken =registerID;
                }
            }

            @Override
            public void onUnRegister(int var1, String var2, String var3) {
                Log.e(TAG, "on oppo unregister + " + var1);
            }

            @Override
            public void onSetPushTime(int i, String s) {
                Log.e(TAG, "on oppo set push time + " + i + " " + s);
            }

            @Override
            public void onGetPushStatus(int i, int i1) {
                Log.e(TAG, "on oppo push status + " + i + " " + i1);
            }

            @Override
            public void onGetNotificationStatus(int i, int i1) {
                Log.e(TAG, "on oppo notification status + " + i + " " + i1);
            }

            @Override
            public void onError(int i, String s, String s1, String s2) {
                Log.e(TAG, "on oppo error + " + i + " " + s);
            }
        });


    }
}
