//
//  CTJSBridgeCallbackHandler.m
//  JSBridge
//
//  Created by casa on 6/16/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTJSBridgeCallbackHandler.h"

@interface CTJSBridgeCallbackHandler ()

@property (nonatomic, weak) UIWebView *webview;
@property (nonatomic, strong) NSString *callbackIdentifier;

@end

@implementation CTJSBridgeCallbackHandler

#pragma mark - public methods
- (instancetype)initWithWebview:(UIWebView *)webview callbackIdentifier:(NSString *)callbackIdentifier
{
    self = [super init];
    if (self) {
        _webview = webview;
        _callbackIdentifier = callbackIdentifier;
    }
    return self;
}

- (void)progressWithResultDictionary:(NSDictionary *)resultData
{
    if (self.webview) {
        NSError *error = nil;
        NSString *resultDataString = [[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:resultData options:0 error:&error] encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        
        if (!error) {
            NSString *callbackString = [NSString stringWithFormat:@"window.Callback(\"%@\", \"progress\", \"%@\")", self.callbackIdentifier, resultDataString];
            [self.webview performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:callbackString waitUntilDone:NO];
        } else {
            NSLog(@"CTJSBridgeCallbackHandler:%s:%d: %@", __PRETTY_FUNCTION__, __LINE__, error);
        }
    }
}

- (void)successWithResultDictionary:(NSDictionary *)resultData
{
    if (self.webview) {
        NSError *error = nil;
        NSString *resultDataString = [[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:resultData options:0 error:&error] encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        
        if (!error) {
            NSString *callbackString = [NSString stringWithFormat:@"window.Callback(\"%@\", \"success\", \"%@\")", self.callbackIdentifier, resultDataString];
            [self.webview performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:callbackString waitUntilDone:NO];
        } else {
            NSLog(@"CTJSBridgeCallbackHandler:%s:%d: %@", __PRETTY_FUNCTION__, __LINE__, error);
        }
    }
}

- (void)failedWithResultDictionary:(NSDictionary *)resultData
{
    if (self.webview) {
        NSError *error = nil;
        NSString *resultDataString = [[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:resultData options:0 error:&error] encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        
        if (!error) {
            NSString *callbackString = [NSString stringWithFormat:@"window.Callback(\"%@\", \"fail\", \"%@\")", self.callbackIdentifier, resultDataString];
            [self.webview performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:callbackString waitUntilDone:NO];
        } else {
            NSLog(@"CTJSBridgeCallbackHandler:%s:%d: %@", __PRETTY_FUNCTION__, __LINE__, error);
        }
    }
}

@end
