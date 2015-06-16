//
//  ViewController.m
//  JSBridge
//
//  Created by casa on 6/15/15.
//  Copyright (c) 2015 casa. All rights reserved.
//

#import "ViewController.h"
#import "CTJSBridgeWebviewDelegate.h"
#import "UIView+LayoutMethods.h"
#import "DemoConfiguration.h"
#import "DemoResponder.h"

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) CTJSBridgeWebviewDelegate *webviewDelegate;

@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webview];
    [self.view addSubview:self.reloadButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.webview topInContainer:20 shouldResize:YES];
    [self.webview fillWidth];
    [self.webview bottomInContainer:50 shouldResize:YES];
    
    [self.reloadButton top:0 FromView:self.webview];
    [self.reloadButton fillWidth];
    [self.reloadButton bottomInContainer:0 shouldResize:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.228.115"]]];
}

#pragma mark - event response
- (void)didTappedReloadButton:(UIButton *)button
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"reload" message:@"reloaded" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.228.115"]]];
}

#pragma mark - getters and setters
- (UIWebView *)webview
{
    if (_webview == nil) {
        _webview = [[UIWebView alloc] init];
        _webview.delegate = self.webviewDelegate;
    }
    return _webview;
}

- (CTJSBridgeWebviewDelegate *)webviewDelegate
{
    if (_webviewDelegate == nil) {
        _webviewDelegate = [[CTJSBridgeWebviewDelegate alloc] init];
        [_webviewDelegate registeConfigurationClass:[DemoConfiguration class]];
        [_webviewDelegate registeNativeResponderClass:[DemoResponder class] forMethodName:@"casa"];
    }
    return _webviewDelegate;
}

- (UIButton *)reloadButton
{
    if (_reloadButton == nil) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadButton addTarget:self action:@selector(didTappedReloadButton:) forControlEvents:UIControlEventTouchUpInside];
        [_reloadButton setTitle:@"reload" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _reloadButton;
}

@end
