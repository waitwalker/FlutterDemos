package com.etiantian.online.wangxiao;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.easefun.polyv.businesssdk.PolyvChatDomainManager;
import com.easefun.polyv.businesssdk.model.chat.PolyvChatDomain;
import com.easefun.polyv.businesssdk.model.video.PolyvPlayBackVO;
import com.easefun.polyv.businesssdk.service.PolyvLoginManager;
import com.easefun.polyv.businesssdk.vodplayer.PolyvVodSDKClient;
import com.easefun.polyv.cloudclass.chat.PolyvChatApiRequestHelper;
import com.easefun.polyv.cloudclass.config.PolyvLiveSDKClient;
import com.easefun.polyv.cloudclass.config.PolyvVClassGlobalConfig;
import com.easefun.polyv.cloudclass.model.PolyvLiveClassDetailVO;
import com.easefun.polyv.cloudclass.model.PolyvLiveStatusVO;
import com.easefun.polyv.cloudclass.net.PolyvApiManager;
import com.easefun.polyv.cloudclass.playback.video.PolyvPlaybackListType;
import com.easefun.polyv.cloudclassdemo.watch.PolyvCloudClassHomeActivity;
import com.easefun.polyv.foundationsdk.log.PolyvCommonLog;
import com.easefun.polyv.foundationsdk.net.PolyvResponseBean;
import com.easefun.polyv.foundationsdk.net.PolyvResponseExcutor;
import com.easefun.polyv.foundationsdk.net.PolyvrResponseCallback;
import com.easefun.polyv.linkmic.PolyvLinkMicClient;
import com.easefun.polyv.thirdpart.blankj.utilcode.util.ToastUtils;

import java.io.IOException;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Consumer;
import retrofit2.adapter.rxjava2.HttpException;

public class MainActivity extends FlutterActivity {

    private static String method_channel = "com.etiantian/flutter_channel";
    private static String method_channel_name = "aixue_wangxiao_channel";

    private static String iv = "2u9gDPKdX6GyQJKU";
    private static String aeskey = "VXtlHmwfS2oYm0CZ";
    private static String config = "";

    private static String kAppUserId = "";
    private static String kAppUserName = "";

    private Disposable getTokenDisposable, verifyDispose, liveDetailDisposable;

    MethodChannel methodChannel;
    MethodChannel appSchemeMethod;
    FlutterEngine engine;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        engine  = provideFlutterEngine(this);
        GeneratedPluginRegistrant.registerWith(engine);
        //initNativeMethod(engine);
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
        appSchemeMethod = new MethodChannel(engine.getDartExecutor(),method_channel_name);
        MethodChannel nativeChannel = new MethodChannel(engine.getDartExecutor()
                .getBinaryMessenger(), method_channel);

        nativeChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                if (call.method.equals("deviceType")) {
                    boolean isPad = isTablet(MainActivity.this);
                    result.success(isPad);
                } else if (call.method.equals("init_sdk")) {
                    System.out.print("初始化保利威SDK成功");
                    result.success(true);
                } else if (call.method.equals("live")) {
                    System.out.print("保利威调用直播成功");
                    System.out.print(call.arguments);
                    Map map = (Map) call.arguments;
                    String channelId = (String)map.get("channelId");
                    String appUserId = (String)map.get("appUserId");
                    String appUserName = (String)map.get("appUserName");
                    String vid = "";
                    String userId = "68b11b9327";
                    String appId = "fk61slxubd";
                    String appSecert = "63dc6b8150454cffb1ba6c3715421981";
                    boolean isNormalLivePlayBack = true;
                    int videoListType = 0;
                    if (channelId != null && channelId.length() > 0) {
                        kAppUserId = appUserId;
                        kAppUserName = appUserName;
                        checkToken(vid,channelId,userId,isNormalLivePlayBack,videoListType,appId,appSecert);
                    }
                    result.success(true);
                } else if (call.method.equals("playback")) {
                    System.out.print("保利威调用回放成功");

                    result.success(true);
                } else {
                    result.notImplemented();
                }
            }
        });

        //退到后台
        boolean has = getIntent().hasExtra("onlineSchoolApp");
        Log.i("","");
        // 是否跳转
        // 是,获取参数,插件通信
        if (has) {
            String string = getIntent().getStringExtra("onlineSchoolApp");
            String deStr = startDecrypt(string);
            appSchemeMethod.invokeMethod("comeFromAixue",deStr);
        }
    }

    public void failedStatus(String message) {
        ToastUtils.showLong(message);
    }

    public void errorStatus(Throwable e) {
        PolyvCommonLog.exception(e);
        if (e instanceof HttpException) {
            try {
                ToastUtils.showLong(((HttpException) e).response().errorBody().string());
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        } else {
            ToastUtils.showLong(e.getMessage());
        }
    }

    // 请求权限
    private void checkToken(String vid, String channelId, String userId, boolean isNormalLivePlayBack, int videoListType, String appId, String appSecret) {
        //请求token接口
        getTokenDisposable = PolyvLoginManager.checkLoginToken(userId, appSecret, appId, channelId, vid, new PolyvrResponseCallback<PolyvChatDomain>() {
            @Override
            public void onSuccess(PolyvChatDomain responseBean) {
                if (vid != null && vid.length() > 0) {
                    PolyvLinkMicClient.getInstance().setAppIdSecret(appId, appSecret);
                    PolyvLiveSDKClient.getInstance().setAppIdSecret(appId, appSecret);
                    PolyvVodSDKClient.getInstance().initConfig(appId, appSecret);

                    requestPlayBackStatus(vid,channelId,userId,true,0);
                    return;
                }

                PolyvLinkMicClient.getInstance().setAppIdSecret(appId, appSecret);
                PolyvLiveSDKClient.getInstance().setAppIdSecret(appId, appSecret);
                PolyvVodSDKClient.getInstance().initConfig(appId, appSecret);

                requestLiveStatus(userId,channelId);

                PolyvChatDomainManager.getInstance().setChatDomain(responseBean);
            }

            @Override
            public void onFailure(PolyvResponseBean<PolyvChatDomain> responseBean) {
                super.onFailure(responseBean);
                failedStatus(responseBean.getMessage());
            }

            @Override
            public void onError(Throwable e) {
                super.onError(e);
                errorStatus(e);
            }
        });
    }

    // 请求回放状态
    private void requestPlayBackStatus(String vid, String channelId, String userId, boolean isNormalLivePlayBack, int videoListType) {
        if (TextUtils.isEmpty(vid)) {
            return;
        }
        verifyDispose = PolyvLoginManager.getPlayBackType(vid, new PolyvrResponseCallback<PolyvPlayBackVO>() {
            @Override
            public void onSuccess(PolyvPlayBackVO playBack) {
                boolean isLivePlayBack = playBack.getLiveType() == 0;
                startActivityForPlayback(vid,channelId, userId, isLivePlayBack,videoListType);
            }

            @Override
            public void onFailure(PolyvResponseBean<PolyvPlayBackVO> responseBean) {
                super.onFailure(responseBean);
                failedStatus(responseBean.getMessage());
            }

            @Override
            public void onError(Throwable e) {
                super.onError(e);
                errorStatus(e);
            }
        });
    }

    // 请求直播状态
    private void requestLiveStatus(final String userId, String channelId) {
        verifyDispose = PolyvResponseExcutor.excuteUndefinData(PolyvApiManager.getPolyvLiveStatusApi().geLiveStatusJson(channelId)
                , new PolyvrResponseCallback<PolyvLiveStatusVO>() {
                    @Override
                    public void onSuccess(PolyvLiveStatusVO statusVO) {
                        String data = statusVO.getData();
                        String[] dataArr = data.split(",");

                        final boolean isAlone = "alone".equals(dataArr[1]);//是否有ppt

                        requestLiveDetail(new Consumer<String>() {
                            @Override
                            public void accept(String rtcType) throws Exception {
//                    if (isParticipant) {
//                      if ("urtc".equals(rtcType) || TextUtils.isEmpty(rtcType)) {
//                        ToastUtils.showShort("暂不支持该频道观看");
//                        return;
//                      }
//                    }
                                startActivityForLive(channelId, userId, isAlone, false, rtcType);
                            }
                        }, channelId);
                    }

                    @Override
                    public void onFailure(PolyvResponseBean<PolyvLiveStatusVO> responseBean) {
                        super.onFailure(responseBean);
                        failedStatus(responseBean.getMessage());
                    }

                    @Override
                    public void onError(Throwable e) {
                        super.onError(e);
                        errorStatus(e);
                    }
                });
    }


    private void requestLiveDetail(final Consumer<String> onSuccess, String channelId) {
        if (liveDetailDisposable != null) {
            liveDetailDisposable.dispose();
        }
        liveDetailDisposable = PolyvResponseExcutor.excuteUndefinData(PolyvChatApiRequestHelper.getInstance()
                .requestLiveClassDetailApi(channelId.trim()), new PolyvrResponseCallback<PolyvLiveClassDetailVO>() {
            @Override
            public void onSuccess(PolyvLiveClassDetailVO polyvLiveClassDetailVO) {
                try {
                    onSuccess.accept(polyvLiveClassDetailVO.getData().getRtcType());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onError(Throwable e) {
                super.onError(e);
                errorStatus(e);
            }
        });
    }
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="startActivity">
    private void startActivityForLive(String channelId, String userId, boolean isNormalLive, boolean isParticipant,String rtcType) {
        // 是否修改昵称
//    if (etParticipantNickName != null) {
//      String participantNickName = etParticipantNickName.getText().toString();
//      String participantViewerId = etParticipantViewerId.getText().toString();
//      try {
//        Integer.parseInt(participantViewerId);
//      } catch (NumberFormatException e) {
//        ToastUtils.showShort("参与者Id格式错误");
//        return;
//      }
//      PolyvVClassGlobalConfig.username = participantNickName;
//      PolyvVClassGlobalConfig.viewerId = participantViewerId;
//    }

        PolyvVClassGlobalConfig.username = kAppUserName;
        PolyvVClassGlobalConfig.viewerId = kAppUserId;
        PolyvCloudClassHomeActivity.startActivityForLiveWithParticipant(MainActivity.this, channelId, userId, isNormalLive, isParticipant, rtcType);
    }

    private void startActivityForPlayback(String videoId, String channelId, String userId, boolean isNormalLivePlayBack, int videoListType) {
        if (!isNormalLivePlayBack && videoListType == PolyvPlaybackListType.VOD) {
            ToastUtils.showShort("三分屏场景暂不支持使用点播列表播放");
            return;
        }
        PolyvCloudClassHomeActivity.startActivityForPlayBack(MainActivity.this, videoId, channelId, userId, isNormalLivePlayBack, videoListType);
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        appSchemeMethod = new MethodChannel(engine.getDartExecutor(),method_channel_name);
        boolean has = intent.hasExtra("onlineSchoolApp");
        Log.i("","");
        // 是否跳转
        // 是,获取参数,插件通信
        if (has) {
            String string = intent.getStringExtra("onlineSchoolApp");
            String deStr = startDecrypt(string);
            appSchemeMethod.invokeMethod("comeFromAixue",deStr);
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
