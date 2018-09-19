//
//  ViewController.m
//  CTJSBridge
//
//  Created by casa on 2018/3/14.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "ViewController.h"
#import <HandyFrame/UIView+LayoutMethods.h>
#import "WebViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, weak) WKWebView *webview;
@property (nonatomic, weak) UIViewController *viewController;

@end

@implementation ViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.enterButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.enterButton sizeToFit];
    [self.enterButton centerEqualToView:self.view];
}

#pragma mark - event response
- (void)didTappedEnterButton:(UIButton *)button
{
    NSLog(@"%@", self.webview);
    NSLog(@"%@", self.viewController);
    WebViewController *viewController = [[WebViewController alloc] init];
    self.webview = viewController.webview;
    self.viewController = viewController;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - getters and setters
- (UIButton *)enterButton
{
    if (_enterButton == nil) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_enterButton addTarget:self action:@selector(didTappedEnterButton:) forControlEvents:UIControlEventTouchUpInside];
        [_enterButton setTitle:@"enter" forState:UIControlStateNormal];
    }
    return _enterButton;
}

@end
