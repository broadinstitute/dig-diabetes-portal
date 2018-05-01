var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.grsInfo = (function () {


        var grsInfoData = {};
        var loading = $('#spinner').show();

        var setGrsInfoData = function ( data ) {
            grsInfoData = data;
        };

        var getGrsInfoData = function ( ) {
            return grsInfoData;
        };





        var buildGrsDisplay = function (  ) {
            $(".pop-top").popover({placement: 'top'});
            $(".pop-right").popover({placement: 'right'});
            $(".pop-bottom").popover({placement: 'bottom'});
            $(".pop-left").popover({placement: 'left'});
            $(".pop-auto").popover({placement: 'auto'});
            loading.hide();
        }


        return {
            setGrsInfoData: setGrsInfoData,
            buildGrsDisplay:buildGrsDisplay
        }


    }());

})();