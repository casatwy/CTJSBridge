# CTJSBridge
a javascript bridge for iOS app to interact with h5 web view

---

## Play With Demo

```

for native:

git clone git@github.com:casatwy/CTJSBridge.git
open JSBridge.xcodeproj

for H5:

cp ./JSDemo/event.js /your/www
cp ./JSDemo/index.html /your/www
cp ./JS/CTJSBridge.js /your/www

```

then modify the URL in `ViewController.m`

```
ViewController.m:52
[self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.228.115"]]];

ViewController.m:61
[self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.228.115"]]];

```

change the url string to your server's IP, and now you can run your app to play with the demo.

## Quik Start

1. create a configuration object which confirms to `<CTJSBridgeConfigurationProtocol>`，set the scheme and host for JSBridge.

```
@implementation DemoConfiguration

#pragma mark - CTJSBridgeConfigurationProtocol
- (NSString *)methodSchemeNameWithBridgeWebviewDelegate:(CTJSBridgeWebviewDelegate *)bridgeWebviewDelegate
{
    return @"casa";
}

- (NSString *)methodHostNameWithBridgeWebviewDelegate:(CTJSBridgeWebviewDelegate *)bridgeWebviewDelegate
{
    return @"nativeapi";
}

@end
```

2. create the native responder which confirms to `<CTJSBridgeNativeResponderProtocol>`

```
@implementation DemoResponder

#pragma mark - CTJSBridgeNativeResponderProtocol
- (void)performActionWithParams:(NSDictionary *)params callbackHandler:(CTJSBridgeCallbackHandler *)callbackHandler
{
    // do your work
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"hello" message:@"here i am" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    [callbackHandler successWithResultDictionary:@{@"success":@"success"}];
}

@end
```

3. initiate an instance of `CTJSBridgeWebviewDelegate`, registe the class of your responder and configuration object, and set this delegate as your webview's delegate.

```
- (CTJSBridgeWebviewDelegate *)webviewDelegate
{
    if (_webviewDelegate == nil) {
        _webviewDelegate = [[CTJSBridgeWebviewDelegate alloc] init];

        // registe configuration class
        [_webviewDelegate registeConfigurationClass:[DemoConfiguration class]];

        // registe responder class for method name
        [_webviewDelegate registeNativeResponderClass:[DemoResponder class] forMethodName:@"casa"];
    }
    return _webviewDelegate;
}

- (UIWebView *)webview
{
    if (_webview == nil) {
        _webview = [[UIWebView alloc] init];
        // set CTJSBridgeWebviewDelegate as webview's delegate
        _webview.delegate = self.webviewDelegate;
    }
    return _webview;
}
```

4. add your webview to view controller, and load.

```
[self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.228.115"]]];
```
