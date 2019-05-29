var mpgSoftware = mpgSoftware || {};

mpgSoftware.tissueTable = (function () {
    "use strict";

    var loading = $('#rSpinner');
    var drivingVariablesToRemember = {};
    var setVariablesToRemember = function(drivingVariables){
        drivingVariablesToRemember = drivingVariables;
    };
    var getVariablesToRemember = function(){
        return drivingVariablesToRemember;
    };

    var initialPageSetUp = function(){
        mpgSoftware.dynamicUi.modifyScreenFields({},getVariablesToRemember());
    }

    return {
        setVariablesToRemember:setVariablesToRemember,
        initialPageSetUp:initialPageSetUp
    }
}());

