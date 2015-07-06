//
//  DemoResponder.m
//  JSBridge
//
//  Created by casa on 6/16/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "DemoResponder.h"
#import "CTJSBridgeCallbackHandler.h"

@implementation DemoResponder

#pragma mark - CTJSBridgeNativeResponderProtocol
- (void)performActionWithParams:(NSDictionary *)params callbackHandler:(CTJSBridgeCallbackHandler *)callbackHandler
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"hello" message:@"here i am" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    [callbackHandler progressWithResultDictionary:@{@"status":@"progress"}];
    [callbackHandler successWithResultDictionary:@{@"success":@"success"}];
}

@end
