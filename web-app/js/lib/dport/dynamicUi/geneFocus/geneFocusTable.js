var mpgSoftware = mpgSoftware || {};


mpgSoftware.geneFocusTable = (function () {
    "use strict";

    var drivingVariablesToRemember = {};
    var setVariablesToRemember = function(drivingVariables){
        drivingVariablesToRemember = drivingVariables;
    };
    var getVariablesToRemember = function(){
        //console.log("drivingVariablesToRemember");
        //console.log(drivingVariablesToRemember);
        return drivingVariablesToRemember;
    };


    const initialPageSetUp = function(parametersToOverride,drivingVariables){
        if( typeof drivingVariables === 'undefined'){
            drivingVariables = getVariablesToRemember();
        }
        mpgSoftware.dynamicUi.modifyScreenFields(parametersToOverride,drivingVariables);

    }


    return {
        setVariablesToRemember:setVariablesToRemember,
        initialPageSetUp:initialPageSetUp
    }
}());
