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
                var translation ={};
                _.forEach(data.phenotypeMapping,function (phenotypeRecord){
                    _.forEach(phenotypeRecord,function (humanReadablePhenotype,phenotypeName){
                        phenotypeNames.push(phenotypeName);
                        translation[phenotypeName]=humanReadablePhenotype
                    });

                });
                _.forEach(phenotypeNames.sort(),function (phenotypeName){
                    var optionToAdd;
                    if (phenotypeName===preferredPhenotype){
                        optionToAdd = '<option selected="selected" value="'+phenotypeName+'">'+translation[phenotypeName]+'</option>';
                    } else {
                        optionToAdd = '<option value="'+phenotypeName+'">'+translation[phenotypeName]+'</option>';
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
        var phenotypeString = $(preferredPhenotype).val();
         mpgSoftware.dynamicUi.modifyScreenFields({phenotype:phenotypeString},getVariablesToRemember());
    }

    var refreshTableForAnnotations = function(x){
        mpgSoftware.dynamicUi.redrawTissueTable();
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
        refreshTableForPhenotype:refreshTableForPhenotype,
        refreshTableForAnnotations:refreshTableForAnnotations
    }
}());

