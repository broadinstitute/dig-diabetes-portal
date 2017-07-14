var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.regionInfo = (function () {

        var buildRenderData = function (data){
            var renderData = {};
            return renderData;
        };

        var fillRegionInfoTable = function(vars) {

            var promise = $.ajax({
                cache: false,
                type: "post",
                url: vars.fillCredibleSetTableUrl,
                data: vars,
                async: true
            });
            promise.done(
                function (data) {
                    var drivingVariables = buildRenderData();
                    $(".credibleSetTableGoesHere").empty().append(
                        Mustache.render( $('#credibleSetTableTemplate')[0].innerHTML,drivingVariables)
                    );
                }
            );
            promise.fail();

        }

        return { fillRegionInfoTable: fillRegionInfoTable}

    })();



})();
