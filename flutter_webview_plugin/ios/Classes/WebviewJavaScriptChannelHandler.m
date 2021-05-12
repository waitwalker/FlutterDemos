//
//  WebviewJavaScriptChannelHandler.m
//  flutter_webview_plugin
//
//  Created by waitwalker on 2021/3/24.
//

#import "WebviewJavaScriptChannelHandler.h"

@implementation FLTCommunityJavaScriptChannel {
  FlutterMethodChannel* _methodChannel;
  NSString* _javaScriptChannelName;
}

- (instancetype)initWithMethodChannel:(FlutterMethodChannel*)methodChannel
                javaScriptChannelName:(NSString*)javaScriptChannelName {
  self = [super init];
  NSAssert(methodChannel != nil, @"methodChannel must not be null.");
  NSAssert(javaScriptChannelName != nil, @"javaScriptChannelName must not be null.");
  if (self) {
    _methodChannel = methodChannel;
    _javaScriptChannelName = javaScriptChannelName;
  }
  return self;
}

- (void)userContentController:(WKUserContentController*)userContentController
      didReceiveScriptMessage:(WKScriptMessage*)message {
  NSAssert(_methodChannel != nil, @"Can't send a message to an unitialized JavaScript channel.");
  NSAssert(_javaScriptChannelName != nil,
           @"Can't send a message to an unitialized JavaScript channel.");
  NSDictionary* arguments = @{
    @"channel" : _javaScriptChannelName,
    @"message" : [NSString stringWithFormat:@"%@", message.body]
  };
  [_methodChannel invokeMethod:@"javascriptChannelMessage" arguments:arguments];
}

@end
