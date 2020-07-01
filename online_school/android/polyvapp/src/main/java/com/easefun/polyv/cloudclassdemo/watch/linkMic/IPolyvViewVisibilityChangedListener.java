package com.easefun.polyv.cloudclassdemo.watch.linkMic;

import androidx.annotation.NonNull;
import android.view.View;

public interface IPolyvViewVisibilityChangedListener {
    void onVisibilityChanged(@NonNull View changedView, int visibility);
}
