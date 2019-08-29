var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.gaitInfo = (function () {


        var gaitInfoData = {};
        var loading = $('#spinner').show();

        var setGaitInfoData = function ( data ) {
            gaitInfoData = data;
        };

        var getGaitInfoData = function ( ) {
            return gaitInfoData;
        };





        var buildGaitDisplay = function (  ) {
            $(".pop-top").popover({placement: 'top'});
            $(".pop-right").popover({placement: 'right'});
            $(".pop-bottom").popover({placement: 'bottom'});
            $(".pop-left").popover({placement: 'left'});
            $(".pop-auto").popover({placement: 'auto'});
            loading.hide();
        }


        return {
            setGaitInfoData: setGaitInfoData,
            buildGaitDisplay:buildGaitDisplay
        }


    }());

})();