$(function () {
    function display(bool) {
        if (bool) {
            $("#window").show();
        } else {
            $("#window").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            $("#goldOres").text(event.data.goldOres);
            $("#ironOres").text(event.data.ironOres);
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })


    

    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://codex_minerjob/exit', JSON.stringify({}));
            return
        }
    };
    $("#close").click(function () {
        $.post('http://codex_minerjob/exit', JSON.stringify({}));
        return
    })

    $("#sell").click(function () {
        $.post('http://codex_minerjob/sellResource', JSON.stringify({}));
        return
    })


    $("#buyPickAxe").click(function () {
        $.post('http://codex_minerjob/buyPickAxe', JSON.stringify({}));
        return
    })

    $("#buyFood").click(function () {
        $.post('http://codex_minerjob/buyFood', JSON.stringify({}));
        return
    })


    $("#buyWater").click(function () {
        $.post('http://codex_minerjob/buyWater', JSON.stringify({}));
        return
    })

   
})