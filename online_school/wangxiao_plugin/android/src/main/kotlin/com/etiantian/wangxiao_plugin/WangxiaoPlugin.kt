package com.etiantian.wangxiao_plugin

import android.content.Context
import com.mcxiaoke.packer.helper.PackerNg
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class WangxiaoPlugin : MethodCallHandler {
    companion object {
        private var activeContext: Context? = null

      @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "wangxiao_plugin")
            channel.setMethodCallHandler(WangxiaoPlugin())
            activeContext = registrar.activeContext();
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "getChannel") {
            result.success(PackerNg.getChannel(activeContext));
        } else {
            result.notImplemented()
        }
    }
}
