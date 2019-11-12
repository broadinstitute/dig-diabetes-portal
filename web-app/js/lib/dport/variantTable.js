var mpgSoftware = mpgSoftware || {};


mpgSoftware.variantTable = (function () {
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
                //var translation ={};
                _.forEach(data.phenotypeMapping,function (phenotypeRecord){
                    _.forEach(phenotypeRecord,function (humanReadablePhenotype,phenotypeName){
                        phenotypeNames.push({phenotypeCode:phenotypeName,readablePhenotype:humanReadablePhenotype});
                        // translation[phenotypeName]=humanReadablePhenotype
                    });

                });
                _.forEach(_.sortBy(phenotypeNames,['readablePhenotype']),function (phenotype){
                    var optionToAdd;
                    if (phenotype.phenotypeCode===preferredPhenotype){
                        optionToAdd = '<option selected="selected" value="'+phenotype.phenotypeCode+'">'+phenotype.readablePhenotype+'</option>';
                        $('span.phenotypeSpecifier').text(phenotype.readablePhenotype);
                    } else {
                        optionToAdd = '<option value="'+phenotype.phenotypeCode+'">'+phenotype.readablePhenotype+'</option>';
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
        var domElement = $(preferredPhenotype);
        var phenotypeString = domElement.val();
        var phenotypeName = domElement.find(':selected').text();
        $('span.phenotypeSpecifier').text(phenotypeName);
        mpgSoftware.dynamicUi.modifyScreenFields({phenotype:phenotypeString},getVariablesToRemember());
    };

    const refreshTableForAnnotations = function(x){
        mpgSoftware.dynamicUi.redrawVariantTable();
    };


    const updateAnnotationDropDownBox = function(currentMethod,annotationOptions){
        switch(currentMethod){
            case "MACS":
                if (annotationOptions.length === 0){
                    $('#annotationSelectorChoice').append(new Option("<span class='boldit'>ATAC-Seq</span>","MACS_MACS"));
                } else {
                    _.forEach(_.sortBy(annotationOptions,'name'), function (rec ) {
                        $('#annotationSelectorChoice').append(new Option("<span class='boldit'>ATAC-Seq</span>",rec.value));
                    });
                }

                break;
            case "ABC":
                if (annotationOptions.length === 0){
                    $('#annotationSelectorChoice').append(new Option("<span class='boldit'>ABC</span>","ABC_ABC"));
                } else {
                    _.forEach(_.sortBy(annotationOptions, 'name'), function (rec) {
                        $('#annotationSelectorChoice').append(new Option("<span class='boldit'>ABC</span>", rec.value));
                    });
                }
                break;
            case "SPP":
                if (annotationOptions.length>1){
                    $('#annotationSelectorChoice').append("<optgroup label='TF Binding Sites'>");
                    _.forEach(_.sortBy(annotationOptions,'name'), function (rec ) {
                        $('#annotationSelectorChoice').append(new Option('&nbsp;&nbsp;&nbsp;&nbsp;'+rec.name,rec.value));
                    });
                    $('#annotationSelectorChoice').append("</optgroup>");
                } else if (annotationOptions.length === 1) {
                    _.forEach(_.sortBy(annotationOptions,'name'), function (rec ) {
                        $('#annotationSelectorChoice').append(new Option("<span class='boldit'>TF Binding Site</span>",rec.value));
                    });
                } else if (annotationOptions.length === 0) {
                    $('#annotationSelectorChoice').append(new Option("<span class='boldit'>TF Binding Site</span>",'SPP_SPP'));
                }
                break;
            case "ChromHMM":
                $('#annotationSelectorChoice').append("<optgroup label='ChromHMM'>");
                _.forEach(_.sortBy(annotationOptions,'name'), function (rec ) {
                    $('#annotationSelectorChoice').append(new Option('&nbsp;&nbsp;&nbsp;&nbsp;'+rec.name,rec.value));
                });
                $('#annotationSelectorChoice').append("</optgroup>");
                break;
            case "TFMOTIF":
                break;

            default:
                _.forEach(_.sortBy(annotationOptions,'name'), function (rec ) {
                    $('#annotationSelectorChoice').append(new Option(rec.name,rec.value));
                });
        }
        $('#annotationSelectorChoice').multiselect('rebuild');
    };


    const initialPageSetUp = function(preferredPhenotype){
        var drivingVariables = getVariablesToRemember();
        if (( typeof preferredPhenotype === 'undefined')||(preferredPhenotype.length===0)){
            preferredPhenotype = 'T2D';
        }
        $(drivingVariables.dynamicTableConfiguration.domSpecificationForAccumulatorStorage).empty().append(Mustache.render($('#mainVariantTableOrganizer')[0].innerHTML,
            {   phenotype:preferredPhenotype,
                domTableSpecifier: drivingVariables.dynamicTableConfiguration.initializeSharedTableMemory,
                organizingDiv: drivingVariables.dynamicTableConfiguration.organizingDiv  }
        ));
        fillPhenotypeDropDown('select.phenotypePicker',preferredPhenotype);
        $('#annotationSelectorChoice').multiselect({includeSelectAllOption: true,
            onDropdownHide: function(event) {
                mpgSoftware.dynamicUi.filterEpigeneticTable(drivingVariables.dynamicTableConfiguration.initializeSharedTableMemory);
            },
            onDropdownShow: function(event) {
                $('#methodFilterCheckbox').prop('checked',true);
            },
            enableClickableOptGroups: true,
            enableHTML: true
            });
        $('#gregorFilterCheckbox').click(function(){
            mpgSoftware.dynamicUi.filterEpigeneticTable(drivingVariables.dynamicTableConfiguration.initializeSharedTableMemory);
        });
        $('#methodFilterCheckbox').change(function(){
            mpgSoftware.dynamicUi.filterEpigeneticTable(drivingVariables.dynamicTableConfiguration.initializeSharedTableMemory);
        });
        $('#displayBlankRows').click(function(){
            mpgSoftware.dynamicUi.filterEpigeneticTable(drivingVariables.dynamicTableConfiguration.initializeSharedTableMemory);
        });
        $('.modal-content').resizable({
            alsoResize: ".modal-header, .modal-body, .modal-footer"
        });
        mpgSoftware.dynamicUi.modifyScreenFields({phenotype:preferredPhenotype},getVariablesToRemember());
    }

    return {
        setVariablesToRemember:setVariablesToRemember,
        initialPageSetUp:initialPageSetUp,
        refreshTableForPhenotype:refreshTableForPhenotype,
        refreshTableForAnnotations:refreshTableForAnnotations,
        updateAnnotationDropDownBox:updateAnnotationDropDownBox
    }
}());
