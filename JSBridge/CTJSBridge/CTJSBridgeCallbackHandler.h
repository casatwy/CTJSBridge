//
//  CTJSBridgeCallbackHandler.h
//  JSBridge
//
//  Created by casa on 6/16/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTJSBridgeCallbackHandler : NSObject

- (instancetype)initWithWebview:(UIWebView *)webview callbackIdentifier:(NSString *)callbackIdentifier;

- (void)progressWithResultDictionary:(NSDictionary *)resultDictionary;
- (void)successWithResultDictionary:(NSDictionary *)resultDictionary;
- (void)failedWithResultDictionary:(NSDictionary *)resultDictionary;

@end
