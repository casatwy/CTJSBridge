# CTJSBridge

An iOS bridge for sending messages between Obj-C and JavaScript in WKWebView

### Features

- [x] Remote Debug
- [x] Send/Handle Mesasage From Native To JS
- [x] Send/Handle Mesasage From JS To Native

## Install

- You have to checkout that your mac has installed [golang](https://golang.org/doc/install)

- cd into `CTJSBridge/WebServer` directory and `make run` 

![](image/make_run.jpg)

- if you get `listen tcp :80: bind: address already in use
make: *** [run] Error 1` Error. Open then `CTJSBridge/WebServer/main.go` file and change the 80 to other port

- Then `pod update` and run the `CTJSBridge.xcworkspace` project on simulator

- When it is running, you will see the `It works` on the screen, and then click on the screen five times. And remeber the connect info.

![](image/simulator.jpg)

- Opne Safari.app and go to `localhost:3001` and enter connect info

- Finally you can control the simulator by safari

![](image/finally.gif)


## Usage


#### Cocoapods

pod 'CTJSBridge'

## Requirements

* iOS 8 or higher
* golang

## Authors

* **Casa Taloyum** -  [Casa Taloyum](https://github.com/casatwy)

## Communication

* If you **found a bug**, open an issue.
* If you **have a feature request**, open an issue.
* If you **want to contribute**, submit a pull request.

## License

This project is licensed under the MIT License.

