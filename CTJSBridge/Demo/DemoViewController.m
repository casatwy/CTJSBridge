//
//  DemoViewController.m
//  CTJSBridge
//
//  Created by casa on 2018/3/14.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "DemoViewController.h"
#import <HandyFrame/UIView+LayoutMethods.h>

@interface DemoViewController ()

@property (nonatomic, strong) UIButton *successButton;
@property (nonatomic, strong) UIButton *failButton;
@property (nonatomic, strong) UIButton *progressButton;

@end

@implementation DemoViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.successButton];
    [self.view addSubview:self.failButton];
    [self.view addSubview:self.progressButton];
}

- (void)viewWillLayoutSubviews
{
    [self.successButton sizeToFit];
    [self.successButton centerEqualToView:self.view];
    
    [self.failButton sizeToFit];
    [self.failButton centerXEqualToView:self.view];
    [self.failButton bottom:20 FromView:self.successButton];
    
    [self.progressButton sizeToFit];
    [self.progressButton centerXEqualToView:self.view];
    [self.progressButton top:20 FromView:self.successButton];
}

#pragma mark - event response
- (void)didTappedSuccessButton:(UIButton *)button
{
    if (self.successCallback) {
        self.successCallback(@{
                               @"value":@"success result data from demo view controller",
                               @"receivedData":self.params
                               });
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didTappedFailButton:(UIButton *)button
{
    if (self.failCallback) {
        self.failCallback(@{
                            @"value":@"fail result data from demo view controller",
                            @"receivedData":self.params
                            });
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didTappedProgressButton:(UIButton *)button
{
    if (self.progressCallback) {
        self.progressCallback(@{
                                @"value":@"60%",
                                @"receivedData":self.params
                                });
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - life cycle
- (UIButton *)successButton
{
    if (_successButton == nil) {
        _successButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_successButton addTarget:self action:@selector(didTappedSuccessButton:) forControlEvents:UIControlEventTouchUpInside];
        [_successButton setTitle:@"success" forState:UIControlStateNormal];
    }
    return _successButton;
}

- (UIButton *)failButton
{
    if (_failButton == nil) {
        _failButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_failButton addTarget:self action:@selector(didTappedFailButton:) forControlEvents:UIControlEventTouchUpInside];
        [_failButton setTitle:@"fail" forState:UIControlStateNormal];
    }
    return _failButton;
}

- (UIButton *)progressButton
{
    if (_progressButton == nil) {
        _progressButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_progressButton addTarget:self action:@selector(didTappedProgressButton:) forControlEvents:UIControlEventTouchUpInside];
        [_progressButton setTitle:@"progress" forState:UIControlStateNormal];
    }
    return _progressButton;
}

@end
