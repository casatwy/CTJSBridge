/* eslint-disable */
window.CTCallBackList = {};
window.CTJSBridge = {
    LoadAPI:LoadAPI,
    LoadMethod:LoadMethod,
};

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

function LoadAPI(apiName, data, callback) {
	var dataString = encodeURIComponent(JSON.stringify(data));
	var timestamp = Date.parse(new Date());
	var identifier = (apiName + dataString + timestamp).hashCode().toString();
	window.CTCallBackList[identifier] = callback;
    window.webkit.messageHandlers.CTAPIMessage.postMessage({
        apiName:apiName,
        data:data,
		identifier:identifier
    });
}

function LoadMethod(targetName, actionName, data, callback) {
	var dataString = encodeURIComponent(JSON.stringify(data));
	var timestamp = Date.parse(new Date());
	var identifier = (targetName + actionName + dataString + timestamp).hashCode().toString();
	window.CTCallBackList[identifier] = callback;
    window.webkit.messageHandlers.CTNativeMethodMessage.postMessage({
        targetName:targetName,
        actionName:actionName,
        data:data,
        identifier:identifier,
    });
}
