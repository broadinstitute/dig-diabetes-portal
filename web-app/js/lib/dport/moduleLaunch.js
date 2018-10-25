
var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";
    mpgSoftware.moduleLaunch = (function () {

        var mySavedVariables = {};
        var setMySavedVariables = function(saveTheseVariables){
            mySavedVariables = saveTheseVariables;
        }

        var getMySavedVariables = function(){
            return mySavedVariables;
        }

        var launchLDClumping = function() {
            var rememVars = mpgSoftware.moduleLaunch.getMySavedVariables();
            var selectedVal = $('#phenotypeDropdown').val();
            //var launchLDClumpURL = "/dig-diabetes-portal/trait/traitSearch" + "?trait=" + selectedVal + "&significance=" + 0.0005;
            var launchLDClumpURL = rememVars.traitSearchUrl + "?trait=" + selectedVal + "&significance=" + 0.0005;
            window.location.href = launchLDClumpURL;

        }

        // called when page loads
        var fillPhenotypesDropdown = function (portaltype) {
            var rememVars = mpgSoftware.moduleLaunch.getMySavedVariables();
            var loading = $('#spinner').show();
            var rememberportaltype = portaltype;
            $.ajax({
                cache: false,
                type: "post",
                url: rememVars.retrievePhenotypesAjaxUrl,
                data: {getNonePhenotype: false},
                async: true,
                success: function (data) {
                    if (( data !== null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.datasets !== 'undefined' ) &&
                        (  data.datasets !== null )) {
                        UTILS.fillPhenotypeCompoundDropdown(data.datasets, '#phenotypeDropdown', true, [], rememberportaltype);
                    }
                    loading.hide();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };


        return{
            fillPhenotypesDropdown: fillPhenotypesDropdown,
            setMySavedVariables:setMySavedVariables,
            getMySavedVariables:getMySavedVariables,
            launchLDClumping: launchLDClumping


        }
    }());


})();



