//
//  CTJSBridgeNativeResponderProtocol.h
//  JSBridge
//
//  Created by casa on 6/16/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#ifndef JSBridge_CTJSBridgeNativeResponderProtocol_h
#define JSBridge_CTJSBridgeNativeResponderProtocol_h

@class NSDictionary;
@class CTJSBridgeCallbackHandler;

@protocol CTJSBridgeNativeResponderProtocol <NSObject>

@required
- (void)performActionWithParams:(NSDictionary *)params callbackHandler:(CTJSBridgeCallbackHandler *)callbackHandler;

@end

#endif
