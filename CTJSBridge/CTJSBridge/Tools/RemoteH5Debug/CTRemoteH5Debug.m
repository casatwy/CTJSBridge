//
//  CTRemoteH5Debug.m
//  CTJSBridge
//
//  Created by casa on 2018/3/14.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "CTRemoteH5Debug.h"
#import <PocketSocket/PSWebSocketServer.h>
#import <UIKit/UIKit.h>
#import <CTHandyCategories/NSObject+CTAlert.h>
#import <CTHandyCategories/NSObject+CTIP.h>
#import <CTHandyCategories/NSString+CTURL.h>
#import <CTMediator/CTMediator.h>

@interface CTRemoteH5Debug() <PSWebSocketServerDelegate>

@property (nonatomic, strong) PSWebSocketServer *server;
@property (nonatomic, strong) NSMutableDictionary <NSString *, PSWebSocket *> *clientList;
@property (nonatomic, strong) NSNumber *port;

@end

@implementation CTRemoteH5Debug

#pragma mark - life cycle
+ (void)load
{
#if DEBUG
    [[CTRemoteH5Debug sharedInstance] startService];
#endif
}

+ (instancetype)sharedInstance
{
    static CTRemoteH5Debug *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTRemoteH5Debug alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveUIApplicationDidFinishLaunchingNotification:)
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - public methods
- (void)startService
{
    self.port = nil;
    self.server = nil;
    [self.server start];
}

#pragma mark - PSWebSocketServerDelegate
- (void)serverDidStart:(PSWebSocketServer *)server
{
    // do nothing
}

- (void)server:(PSWebSocketServer *)server didFailWithError:(NSError *)error
{
    // do nothing
}

- (void)serverDidStop:(PSWebSocketServer *)server
{
    [self startService];
}

- (void)server:(PSWebSocketServer *)server webSocketDidOpen:(PSWebSocket *)webSocket
{
    NSString *ipAddress = [self clientIpAddress:webSocket];
    self.clientList[ipAddress] = webSocket;
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message
{
    if ([message isKindOfClass:[NSString class]]) {
        NSString *urlString = message;
        if ([urlString isKindOfClass:[NSString class]] == NO) {
            return;
        }
        
        NSURL *requestURL = [NSURL URLWithString:urlString];
        
        if ([requestURL.scheme isEqualToString:@"ctjsbridge"]) {
            
            NSMutableDictionary *params = [[requestURL.query ct_URLQueryParams] mutableCopy];
            NSString *callbackIdentifier = params[@"callbackIdentifier"];
            
            params[@"success"] = ^(NSDictionary *result){
                NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] initWithDictionary:result];
                resultDictionary[@"result"] = @"success";
                resultDictionary[@"callbackIdentifier"] = callbackIdentifier;
                
                NSString *resultString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:resultDictionary options:0 error:NULL] encoding:NSUTF8StringEncoding];
                [webSocket send:resultString];
            };
            
            params[@"fail"] = ^(NSDictionary *result){
                NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] initWithDictionary:result];
                resultDictionary[@"result"] = @"fail";
                resultDictionary[@"callbackIdentifier"] = callbackIdentifier;
                
                NSString *resultString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:resultDictionary options:0 error:NULL] encoding:NSUTF8StringEncoding];
                [webSocket send:resultString];
            };
            
            params[@"progress"] = ^(NSDictionary *result){
                NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] initWithDictionary:result];
                resultDictionary[@"result"] = @"progress";
                resultDictionary[@"callbackIdentifier"] = callbackIdentifier;
                
                NSString *resultString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:resultDictionary options:0 error:NULL] encoding:NSUTF8StringEncoding];
                [webSocket send:resultString];
            };
            
            params[@"isFromH5"] = @(YES);
            
            if ([requestURL.host isEqualToString:@"component"]) {
                
                NSString *targetName = [NSString stringWithFormat:@"H5%@", params[@"targetName"]];
                NSString *actionName = params[@"actionName"];
                
                if ([targetName isKindOfClass:[NSString class]] && targetName.length > 0 && [actionName isKindOfClass:[NSString class]] && actionName.length > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[CTMediator sharedInstance] performTarget:targetName action:actionName params:params shouldCacheTarget:YES];
                    });
                }
            }
            
            if ([requestURL.host isEqualToString:@"api"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[CTMediator sharedInstance] performTarget:@"H5API" action:@"loadAPI" params:params shouldCacheTarget:YES];
                });
            }
        }
    }
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSString *clientIpAddress = [self clientIpAddress:webSocket];
    [self.clientList removeObjectForKey:clientIpAddress];
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSString *clientIpAddress = [self clientIpAddress:webSocket];
    [self.clientList removeObjectForKey:clientIpAddress];
}

#pragma mark - event response
- (void)didReceiveUIApplicationDidFinishLaunchingNotification:(NSNotification *)notifaction
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    recognizer.numberOfTapsRequired = 5;
    [recognizer addTarget:self action:@selector(didTappedWindowFiveTimes:)];
    
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:recognizer];
}

- (void)didTappedWindowFiveTimes:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self ct_showAlertWithTitle:@""
                        message:[NSString stringWithFormat:@"Connect Info:%@:%@\nClient Count: %lu",
                                            [self ct_ipAddressWithShouldPreferIPv4:YES],
                                            self.port,
                                            (unsigned long)self.clientList.count]
                actionTitleList:@[@"OK"]
                        handler:nil
                     completion:nil];
}

#pragma mark - private method
- (NSString *)clientIpAddress:(PSWebSocket *)client
{
    NSString *clientIpAddress = [[self.clientList allKeysForObject:client] lastObject];
    if (clientIpAddress == nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        SEL remoteHost = NSSelectorFromString(@"remoteHost");
        if ([client respondsToSelector:remoteHost]) {
            clientIpAddress = [client performSelector:remoteHost];
        }
#pragma clang diagnostic pop
    }
    return clientIpAddress;
}

#pragma mark - getters and setters
- (PSWebSocketServer *)server
{
    if (_server == nil) {
        _server = [PSWebSocketServer serverWithHost:nil port:[self.port unsignedIntegerValue]];
        _server.delegate = self;
    }
    return _server;
}

- (NSNumber *)port
{
    if (_port == nil) {
        _port = @((arc4random() % 2000) + 9000);
    }
    return _port;
}

- (NSMutableDictionary<NSString *,PSWebSocket *> *)clientList
{
    if (_clientList == nil) {
        _clientList = [[NSMutableDictionary alloc] init];
    }
    return _clientList;
}

@end
