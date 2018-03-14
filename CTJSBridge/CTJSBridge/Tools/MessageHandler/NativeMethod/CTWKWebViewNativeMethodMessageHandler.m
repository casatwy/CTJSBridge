//
//  CTWKWebViewNativeMethodMessageHandler.m
//  CTWKWebView
//
//  Created by casa on 2017/3/21.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "CTWKWebViewNativeMethodMessageHandler.h"
#import <CTMediator/CTMediator.h>
#import "CTWKWebviewHelper.h"

@implementation CTWKWebViewNativeMethodMessageHandler

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

    NSString *targetName = [NSString stringWithFormat:@"H5%@", params[@"targetName"]];
    NSString *actionName = params[@"actionName"];
    if ([actionName isKindOfClass:[NSString class]] && actionName.length > 0) {
        [[CTMediator sharedInstance] performTarget:targetName action:actionName params:params shouldCacheTarget:YES];
    }
}

@end
