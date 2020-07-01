package com.example.fluttertonative;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FlutterEngine engine = provideFlutterEngine(this);
        assert engine != null;
        GeneratedPluginRegistrant.registerWith(engine);
        initNativeMethod(engine);
    }

    @Nullable
    @Override
    public FlutterEngine provideFlutterEngine(@NonNull Context context) {
        FlutterEngine flutterEngine = super.provideFlutterEngine(context);
        if (flutterEngine != null) return flutterEngine;
        flutterEngine = FlutterEngineCache.getInstance().get("cache_engine");
        if (flutterEngine == null) {
            flutterEngine = new FlutterEngine(context.getApplicationContext());
            FlutterEngineCache.getInstance().put("cache_engine", flutterEngine);
        }
        return flutterEngine;
    }

    private void initNativeMethod(FlutterEngine engine) {
        MethodChannel nativeChannel = new MethodChannel(engine.getDartExecutor()
                .getBinaryMessenger(), "flutter_demo");

        nativeChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                switch (call.method) {
                    case "gotoNative":
                        Intent intent = new Intent(MainActivity.this, NativeActivi.class);
                        startActivity(intent);
                        break;
                    default:
                        Log.e("NativeError", "方法: " + call.method + ">>>>>>" + "参数: " + call.arguments);
                        break;
                }
            }
        });
    }
}
