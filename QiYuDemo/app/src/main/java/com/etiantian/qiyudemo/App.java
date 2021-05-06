package com.etiantian.qiyudemo;

import android.app.Application;

import com.qiyukf.unicorn.api.Unicorn;

public class App extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        //appKey = devTag() ? "49c87881861b9d275fdebb136baf3713" : "3858be3c20ceb6298575736cf27858a7";
        /// 初始化七鱼
        Unicorn.config(this, "49c87881861b9d275fdebb136baf3713", null, new GlideImageLoader(this));

        //Unicorn.init(this,"49c87881861b9d275fdebb136baf3713", null, new GlideImageLoader(this));
    }
}
