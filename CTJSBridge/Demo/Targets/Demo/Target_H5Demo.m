//
//  Target_H5Demo.m
//  CTJSBridge
//
//  Created by casa on 2018/3/14.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "Target_H5Demo.h"
#import <CTHandyCategories/NSObject+CTNavigation.h>
#import "DemoViewController.h"

@implementation Target_H5Demo

- (void)Action_push:(NSDictionary *)params
{
    NSLog(@"%@", params);
    DemoViewController *viewController = [[DemoViewController alloc] init];
    viewController.successCallback = params[@"success"];
    viewController.failCallback = params[@"fail"];
    viewController.progressCallback = params[@"progress"];
    viewController.params = params[@"data"];
    [self ct_pushViewController:viewController animated:YES];
}

@end
