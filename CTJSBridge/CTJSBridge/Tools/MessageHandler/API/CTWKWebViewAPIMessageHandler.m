//
//  CTWKWebViewAPIMessageHandler.m
//  CTWKWebView
//
//  Created by casa on 2017/3/21.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "CTWKWebViewAPIMessageHandler.h"
#import <CTMediator/CTMediator.h>
#import "CTWKWebviewHelper.h"

@implementation CTWKWebViewAPIMessageHandler

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:message.body];
    NSString *identifier = params[@"identifier"];

    params[@"success"] = ^(NSDictionary *result){
        [CTWKWebviewHelper callbackWithResult:@"success" resultData:result message:message identifier:identifier];
    };

    params[@"fail"] = ^(NSDictionary *result){
        [CTWKWebviewHelper callbackWithResult:@"fail" resultData:result message:message identifier:identifier];
    };

    params[@"progress"] = ^(NSDictionary *result){
        [CTWKWebviewHelper callbackWithResult:@"progress" resultData:result message:message identifier:identifier];
    };

    params[@"isFromH5"] = @(YES);
    params[@"webview"] = message.webView;

    [[CTMediator sharedInstance] performTarget:@"H5API" action:@"loadAPI" params:params shouldCacheTarget:YES];
}

@end
