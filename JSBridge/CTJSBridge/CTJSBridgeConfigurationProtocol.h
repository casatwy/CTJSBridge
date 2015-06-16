//
//  CTJSBridgeConfigurationProtocol.h
//  JSBridge
//
//  Created by casa on 6/16/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#ifndef JSBridge_CTJSBridgeConfigurationProtocol_h
#define JSBridge_CTJSBridgeConfigurationProtocol_h

@class CTJSBridgeWebviewDelegate;

@protocol CTJSBridgeConfigurationProtocol <NSObject>

@required
- (NSString *)methodSchemeNameWithBridgeWebviewDelegate:(CTJSBridgeWebviewDelegate *)bridgeWebviewDelegate;
- (NSString *)methodHostNameWithBridgeWebviewDelegate:(CTJSBridgeWebviewDelegate *)bridgeWebviewDelegate;

@end

#endif
