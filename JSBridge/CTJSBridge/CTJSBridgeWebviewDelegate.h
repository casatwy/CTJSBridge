//
//  CTJSBridgeWebviewDelegate.h
//  JSBridge
//
//  Created by casa on 6/15/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTJSBridgeConfigurationProtocol.h"

@interface CTJSBridgeWebviewDelegate : NSObject <UIWebViewDelegate>

- (void)registeConfigurationClass:(__unsafe_unretained Class)className;
- (void)registeNativeResponderClass:(__unsafe_unretained Class)responderClass forMethodName:(NSString *)methodName;

@end
