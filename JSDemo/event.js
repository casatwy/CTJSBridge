$(document).ready(function(){
    bindEvent();
});

function bindEvent() {
    $("#J_button").bind("click", function(){
        LoadMethod("casa", {"key1":"value1", "key2":"value2"},{
            success:function(data){alert(data)},
            fail:function(data){alert(data)},
            progress:function(data){alert(data)}
        });
    });
}
