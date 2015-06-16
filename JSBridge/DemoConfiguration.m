//
//  DemoConfiguration.m
//  JSBridge
//
//  Created by casa on 6/16/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "DemoConfiguration.h"

@implementation DemoConfiguration

#pragma mark - CTJSBridgeConfigurationProtocol
- (NSString *)methodSchemeNameWithBridgeWebviewDelegate:(CTJSBridgeWebviewDelegate *)bridgeWebviewDelegate
{
    return @"casa";
}

- (NSString *)methodHostNameWithBridgeWebviewDelegate:(CTJSBridgeWebviewDelegate *)bridgeWebviewDelegate
{
    return @"nativeapi";
}

@end
