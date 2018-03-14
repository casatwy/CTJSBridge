//
//  CTWKWebviewHelper.h
//  CTWKWebView
//
//  Created by casa on 2017/4/21.
//  Copyright © 2017年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface CTWKWebviewHelper : NSObject

+ (void)callbackWithResult:(NSString *)result resultData:(NSDictionary *)resultData message:(WKScriptMessage *)message identifier:(NSString *)identifier;

@end
