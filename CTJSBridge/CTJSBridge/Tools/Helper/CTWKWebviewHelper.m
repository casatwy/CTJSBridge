//
//  CTWKWebviewHelper.m
//  CTWKWebView
//
//  Created by casa on 2017/4/21.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "CTWKWebviewHelper.h"

@implementation CTWKWebviewHelper

+ (NSString *)jsonStringWithData:(NSDictionary *)data
{
    NSString *messageJSON = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:data options:0 error:NULL] encoding:NSUTF8StringEncoding];;

    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];

    return messageJSON;
}

+ (void)callbackWithResult:(NSString *)result resultData:(NSDictionary *)resultData message:(WKScriptMessage *)message identifier:(NSString *)identifier
{
    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] initWithDictionary:resultData];
    resultDictionary[@"result"] = result;
    NSString *resultDataString = [CTWKWebviewHelper jsonStringWithData:resultDictionary];
    NSString *callbackString = [NSString stringWithFormat:@"window.Callback('%@', '%@', '%@')", identifier, result, resultDataString];

    if ([[NSThread currentThread] isMainThread]) {
        [message.webView evaluateJavaScript:callbackString completionHandler:nil];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [message.webView evaluateJavaScript:callbackString completionHandler:nil];
        });
    }
}

@end
