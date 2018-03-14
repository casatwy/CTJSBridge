/* eslint-disable */
window.CTCallBackList = {};
String.prototype.hashCode = function() {
  var hash = 0;
  if (this.length == 0) return hash;
  for (var index = 0; index < this.length; index++) {
    var charactor = this.charCodeAt(index);
    hash = ((hash << 5) - hash) + charactor;
    hash = hash & hash;
  }
  return hash;
};

function LinkToDevice(openCallback, closeCallback, errorCallback) {
  if (window.WebSocket != undefined) {
    if (window.sessionStorage.getItem('ip')) {
      var addressIp = window.sessionStorage.getItem('ip')
    } else {
      var addressIp = prompt("enter address in format: ip:port","");
      window.sessionStorage.setItem('ip', addressIp)
    }
    wsConnection = new WebSocket('ws://' + addressIp + '');

    wsConnection.addEventListener("open", function(event) {
      openCallback ? openCallback(event) : null;
    });

    wsConnection.addEventListener("close", function() {
      closeCallback ? closeCallback() : null;
    });

    wsConnection.addEventListener("error", function(event) {
      errorCallback ? errorCallback(event) : null;
    });

    wsConnection.addEventListener("message", function(event) {
      console.log("event.data", event.data)
      if (event.data != "connection initialized") {
        var resultData = JSON.parse(event.data);
        var callbackIdentifier = resultData.callbackIdentifier;
        window.Callback(callbackIdentifier, resultData.result, event.data);
      }
    });
  }
}

function CloseLink() {
  wsConnection.close();
}
function LoadNative(url) {
  wsConnection.send(url);
}

function LoadAPI(apiName, data, callback) {
  var dataString = encodeURIComponent(JSON.stringify(data));
  var timestamp = Date.parse(new Date());
  var identifier = (apiName + dataString + timestamp).hashCode().toString();
  window.CTCallBackList[identifier] = callback;

  var url = "ctjsbridge://api?callbackIdentifier=" + identifier + "&data=" + dataString + "&apiName=" + apiName;
  LoadNative(url);
}

function LoadMethod(targetName, actionName, data, callback) {
  var dataString = encodeURIComponent(JSON.stringify(data));
  var identifier = (targetName + actionName + dataString).hashCode().toString();
  window.CTCallBackList[identifier] = callback;

  var url = "ctjsbridge://component?callbackIdentifier=" + identifier + "&data=" + dataString + "&targetName=" + targetName + "&actionName=" + actionName;
  LoadNative(url);
}

window.Callback = function(identifier, resultStatus, resultData) {

  callBackDict = window.CTCallBackList[identifier];

  if (callBackDict) {

    isFinished = true;
    if (resultStatus == "success") {
      callBackDict.success(resultData);
    }
    if (resultStatus == "fail") {
      callBackDict.fail(resultData);
    }
    if (resultStatus == "progress") {
      isFinished = false;
      callBackDict.progress(resultData);
    }

    if (isFinished) {
      window.CTCallBackList[identifier] = null;
      delete window.CTCallBackList[identifier];
    }
  }
}

window.CTJSBridge = {
  LoadMethod: window.LoadMethod,
  LoadAPI: window.LoadAPI,
}

if (typeof wsConnection == "undefined" || wsConnection.readyState != 1) {
  if (navigator.userAgent.indexOf('iBailian') == -1) {
    LinkToDevice(function(event) {
      // linked
      console.log('linked')
    }, function() {
      // close
      console.log('close')
    }, function(event) {
      // error
      console.log('error')
      window.sessionStorage.removeItem('ip')
    });
  }
} else {
  console.log('close')
  CloseLink();
}
