window.CTCallBackList = {};
String.prototype.hashCode = function() {
    var hash = 0;
    if (this.length == 0) return hash;
    for (var index = 0; index < this.length; index++) {
        var charactor = this.charCodeAt(index);
        hash = ((hash<<5)-hash)+charactor;
        hash = hash & hash;
    }
    return hash;
};

function LoadMethod(methodName, data, callback) {
    dataString = JSON.stringify(data);
    identifier = (methodName+dataString).hashCode().toString();
    window.CTCallBackList[identifier] = callback;

    url = "casa://nativeapi?callbackIdentifier="+identifier+"&data="+dataString+"&methodName="+methodName;
    window.location = url;
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
        if (resultStatus == "midway") {
            isFinished = false;
            callBackDict.midway(resultData);
        }

        if (isFinished) {
            window.CTCallBackList[identifier] = NULL;
            delete window.CTCallBackList[identifier];
        }
    }
}
