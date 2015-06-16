//
//  CTJSBridgeWebviewDelegate.m
//  JSBridge
//
//  Created by casa on 6/15/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "CTJSBridgeWebviewDelegate.h"
#import "CTJSBridgeCallbackHandler.h"
#import "CTJSBridgeNativeResponderProtocol.h"

NSString * const kCTJSBridgeParamKeyCallbackIdentifier = @"callbackIdentifier";
NSString * const kCTJSBridgeParamKeyParams = @"data";
NSString * const kCTJSBridgeParamKeyNativeAPIName = @"methodName";

@interface CTJSBridgeWebviewDelegate ()

@property (nonatomic, strong) id<CTJSBridgeConfigurationProtocol> configuration;
@property (nonatomic, strong) NSMutableDictionary *responderDictionary;
@property (nonatomic, strong) NSMutableDictionary *responderClassDictionary;

@end

@implementation CTJSBridgeWebviewDelegate

#pragma mark - public methods
- (void)registeConfigurationClass:(__unsafe_unretained Class)className
{
    self.configuration = [[className alloc] init];
}

- (void)registeNativeResponderClass:(__unsafe_unretained Class)responderClass forMethodName:(NSString *)methodName
{
    if (responderClass && methodName) {
        self.responderClassDictionary[methodName] = responderClass;
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL result = YES;
    
    if ([request.URL.scheme isEqualToString:[self.configuration methodSchemeNameWithBridgeWebviewDelegate:self]]) {
        if ([request.URL.host isEqualToString:[self.configuration methodHostNameWithBridgeWebviewDelegate:self]]) {
            NSDictionary *params = [self dictionaryWithQueryString:request.URL.query];
            CTJSBridgeCallbackHandler *callbackHandler = [[CTJSBridgeCallbackHandler alloc] initWithWebview:webView callbackIdentifier:params[kCTJSBridgeParamKeyCallbackIdentifier]];
            
            id<CTJSBridgeNativeResponderProtocol> responder = [self responderWithMethodName:params[kCTJSBridgeParamKeyNativeAPIName]];
            if (responder && [responder respondsToSelector:@selector(performActionWithParams:callbackHandler:)]) {
                [callbackHandler midwayWithResultDictionary:@{@"status":@"willStartAction", @"params":params}];
                [responder performActionWithParams:params[kCTJSBridgeParamKeyParams] callbackHandler:callbackHandler];
            } else {
                [callbackHandler failedWithResultDictionary:@{@"error":@"no responder for your method"}];
            }
            
            result = NO;
        }
    }
    
    
    return result;
}

#pragma mark - private methods
- (NSDictionary *)dictionaryWithQueryString:(NSString *)queryString
{
    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *components = [queryString componentsSeparatedByString:@"&"];
    [components enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSArray *param = [obj componentsSeparatedByString:@"="];
            if ([param count] == 2) {
                NSString *key = param[0];
                NSString *encodedValue = param[1];
                
                NSString *decodedValue = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)encodedValue, CFSTR(""), kCFStringEncodingUTF8);
                resultDictionary[key] = decodedValue;
            }
        }
    }];
    
    NSError *error = nil;
    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:[resultDictionary[kCTJSBridgeParamKeyParams] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (!error && param) {
        resultDictionary[kCTJSBridgeParamKeyParams] = param;
    } else {
        [resultDictionary removeObjectForKey:kCTJSBridgeParamKeyParams];
    }
    
    return [resultDictionary copy];
}

- (id<CTJSBridgeNativeResponderProtocol>)responderWithMethodName:(NSString *)methodName
{
    id<CTJSBridgeNativeResponderProtocol> responder = nil;
    
    if (methodName) {
        if (!self.responderDictionary[methodName] && self.responderClassDictionary[methodName]) {
            self.responderDictionary[methodName] = [[self.responderClassDictionary[methodName] alloc] init];
        }
        responder = self.responderDictionary[methodName];
    }
    
    return responder;
}

#pragma mark - getters and setters
- (NSMutableDictionary *)responderDictionary
{
    if (_responderDictionary == nil) {
        _responderDictionary = [[NSMutableDictionary alloc] init];
    }
    return _responderDictionary;
}

- (NSMutableDictionary *)responderClassDictionary
{
    if (_responderClassDictionary == nil) {
        _responderClassDictionary = [[NSMutableDictionary alloc] init];
    }
    return _responderClassDictionary;
}

@end
