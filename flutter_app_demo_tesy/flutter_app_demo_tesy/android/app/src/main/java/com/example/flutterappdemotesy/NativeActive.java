package com.wz.flutter_demo;

import android.app.Activity;
import android.os.Bundle;
import android.widget.Button;

import androidx.annotation.Nullable;

public class NativeActive extends Activity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.native_layout);
        Button btn= findViewById(R.id.btn);
        btn.setOnClickListener(v -> {
            finish();
        });
    }
}
