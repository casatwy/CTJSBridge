//
//  WebViewController.m
//  CTJSBridge
//
//  Created by casa on 2018/9/19.
//  Copyright © 2018年 casa. All rights reserved.
//

#import "WebViewController.h"
#import <HandyFrame/UIView+LayoutMethods.h>
#import <CTHandyCategories/NSObject+CTIP.h>

@interface WebViewController ()

@end

@implementation WebViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.webview];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", [self ct_ipAddressWithShouldPreferIPv4:YES]]];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.webview fill];
}

#pragma mark - getters and setters
- (WKWebView *)webview
{
    if (_webview == nil) {
        _webview = [WKWebView ct_WKWebViewWithConfiguration:nil prefixUserAgent:nil];
    }
    return _webview;
}

@end
