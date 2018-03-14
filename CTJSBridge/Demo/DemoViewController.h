//
//  DemoViewController.h
//  CTJSBridge
//
//  Created by casa on 2018/3/14.
//  Copyright © 2018年 casa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoViewController : UIViewController

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, copy) void(^successCallback)(NSDictionary *result);
@property (nonatomic, copy) void(^failCallback)(NSDictionary *result);
@property (nonatomic, copy) void(^progressCallback)(NSDictionary *result);

@end
