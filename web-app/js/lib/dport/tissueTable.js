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

    var fillPhenotypeDropDown = function(domSelector,preferredPhenotype){
        $.ajax({
            cache: false,
            type: "post",
            url: getVariablesToRemember().getAllPhenotypesAjaxUrl,
            data: {
            },
            async: true
        }).done(function (data, textStatus, jqXHR) {
            if (( typeof  data !== 'undefined') ||
                ( typeof  data.phenotypeMapping !== 'undefined')){
                var phenotypeNames = [];
                _.forEach(data.phenotypeMapping,function (phenotypeRecord,phenotypeName){
                    phenotypeNames.push(phenotypeName);
                });
                _.forEach(phenotypeNames.sort(),function (phenotypeName){
                    var optionToAdd;
                    if (phenotypeName===preferredPhenotype){
                        optionToAdd = '<option selected="selected">'+phenotypeName+'</option>';
                    } else {
                        optionToAdd = '<option>'+phenotypeName+'</option>';
                    }
                    $(domSelector).append(optionToAdd);
                })
            }

        }).fail(function (jqXHR, textStatus, errorThrown) {
            alert("Ajax call failed, url="+rememberUrl+", data="+rememberData+".");
            core.errorReporter(jqXHR, errorThrown)
        })

    }



    var refreshTableForPhenotype = function(preferredPhenotype){
         mpgSoftware.dynamicUi.modifyScreenFields({phenotype:preferredPhenotype},getVariablesToRemember());
    }


    var initialPageSetUp = function(){
        var preferredPhenotype = 'T2D';
        $('#mainTissueDiv').empty().append(Mustache.render($('#mainTissueTableOrganizer')[0].innerHTML,
            {phenotype:preferredPhenotype}
        ));
        fillPhenotypeDropDown('select.phenotypePicker',preferredPhenotype);
        mpgSoftware.dynamicUi.modifyScreenFields({phenotype:preferredPhenotype},getVariablesToRemember());
    }

    return {
        setVariablesToRemember:setVariablesToRemember,
        initialPageSetUp:initialPageSetUp,
        refreshTableForPhenotype:refreshTableForPhenotype
    }
}());

