//
//  WKWebView+CTJSBridge.h
//  CTJSBridge
//
//  Created by casa on 2018/3/14.
//  Copyright © 2018年 casa. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (CTJSBridge) <WKNavigationDelegate>

+ (WKWebView *)ct_WKWebViewWithConfiguration:(WKWebViewConfiguration *)configuration prefixUserAgent:(NSString *)prefixUserAgent;

@end
