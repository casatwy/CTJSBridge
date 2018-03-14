//
//  WKWebView+CTJSBridge.m
//  CTJSBridge
//
//  Created by casa on 2018/3/14.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "WKWebView+CTJSBridge.h"

#import "CTWKWebViewAPIMessageHandler.h"
#import "CTWKWebViewNativeMethodMessageHandler.h"

@interface WKWebView (FactoryPrivateMethods)

@end

@implementation WKWebView (Factory)

+ (WKWebView *)ct_WKWebViewWithConfiguration:(WKWebViewConfiguration *)configuration prefixUserAgent:(NSString *)prefixUserAgent
{
    NSString *bridgeJSString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CTJSBridge" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:bridgeJSString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    
    WKWebViewConfiguration *webviewConfiguration = configuration;
    if (webviewConfiguration == nil) {
        webviewConfiguration = [[WKWebViewConfiguration alloc] init];
    }
    if (webviewConfiguration.userContentController == nil) {
        webviewConfiguration.userContentController = [[WKUserContentController alloc] init];
    }
    [webviewConfiguration.userContentController addUserScript:userScript];
    [webviewConfiguration.userContentController addScriptMessageHandler:[[CTWKWebViewAPIMessageHandler alloc] init] name:@"CTAPIMessage"];
    [webviewConfiguration.userContentController addScriptMessageHandler:[[CTWKWebViewNativeMethodMessageHandler alloc] init] name:@"CTNativeMethodMessage"];

    
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webviewConfiguration];
    [webview evaluateJavaScript:@"window.ct_isInDevice = true;" completionHandler:nil];

    if (prefixUserAgent != nil) {
        [webview evaluateJavaScript:@"navigator.userAgent" completionHandler:^(NSString * _Nullable originUserAgent, NSError * _Nullable error) {
            if ([originUserAgent hasPrefix:prefixUserAgent] == NO) {
                NSString *newUserAgent = [NSString stringWithFormat:@"%@%@", prefixUserAgent, originUserAgent];
                [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":newUserAgent}];
                webview.customUserAgent = newUserAgent;
            }
        }];
    }
    
    return webview;
}

@end
