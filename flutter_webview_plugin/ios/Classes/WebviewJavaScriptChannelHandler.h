//
//  WebviewJavaScriptChannelHandler.h
//  flutter_webview_plugin
//
//  Created by waitwalker on 2021/3/24.
//
#import <Flutter/Flutter.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLTCommunityJavaScriptChannel : NSObject <WKScriptMessageHandler>

- (instancetype)initWithMethodChannel:(FlutterMethodChannel*)methodChannel
                javaScriptChannelName:(NSString*)javaScriptChannelName;

@end

NS_ASSUME_NONNULL_END
