var mpgSoftware = mpgSoftware || {};


mpgSoftware.variantTable = (function () {
    "use strict";

    var loading = $('#rSpinner');
    var drivingVariablesToRemember = {};
    var setVariablesToRemember = function(drivingVariables){
        drivingVariablesToRemember = drivingVariables;
    };
    var getVariablesToRemember = function(){
        //console.log("drivingVariablesToRemember");
        //console.log(drivingVariablesToRemember);
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
        //console.log(phenotypeString);
        var phenotypeName = domElement.find(':selected').text();
        $('span.phenotypeSpecifier').text(phenotypeName);
        mpgSoftware.dynamicUi.modifyScreenFields({phenotype:phenotypeString},getVariablesToRemember());
    };

    /* dk adding this function for V2F integration */
    var refreshVariantFocusForPhenotype = function(PHENOTYPEANNOTATION,AJAXURL){
        var phenotypeString = PHENOTYPEANNOTATION;

        var pageURL_string = window.location.href;
        var url = new URL(pageURL_string);

        if (url.searchParams.get("chromosomeNumber")){

            var chromosomeInput = url.searchParams.get("chromosomeNumber");
            var startExtentInput = url.searchParams.get("startExtent");
            var endExtentInput = url.searchParams.get("endExtent");

            mpgSoftware.dynamicUi.modifyScreenFields({phenotype:phenotypeString, chromosome:chromosomeInput, startPosition:startExtentInput, endPosition:endExtentInput},getVariablesToRemember());

        } else {
            var urlPath = window.location.pathname.split("/");
            var geneName = urlPath[urlPath.length - 1];
            $.ajax({
                cache: false,
                type: "post",
                url: AJAXURL,
                data: {geneName: geneName},
                async: true
            }).done(function (geneInfoData) {

                var genePageExtent = 100000;

                var chromosomeInput = geneInfoData.geneInfo.CHROM;
                var startExtentInput = geneInfoData.geneInfo.BEG - genePageExtent;
                var endExtentInput = geneInfoData.geneInfo.END + genePageExtent;

                mpgSoftware.dynamicUi.modifyScreenFields({phenotype:phenotypeString, chromosome:chromosomeInput, startPosition:startExtentInput, endPosition:endExtentInput},getVariablesToRemember());
            });
        }

    };

    /* dk adding this function for V2F integration end */

    const refreshTableForAnnotations = function(x){
        mpgSoftware.dynamicUi.redrawVariantTable();
    };

    const fillAnnotationDropDownBox = function(annotationSelectorChoice){ //#annotationSelectorChoice
        const domElement = $(annotationSelectorChoice);
        if ((domElement).children().length===0){
            (domElement).append(new Option("<span class='boldit'>ATAC-Seq</span>","AccessibleChromatin_MACS"));
            (domElement).append(new Option("<span class='boldit'>ABC</span>","GenePrediction_ABC"));
            (domElement).append(new Option("<span class='boldit'>Cicero</span>","GenePrediction_cicero"));//GenePrediction_cicero
            (domElement).append(new Option("<span class='boldit'>DNase</span>","DNASE_NA"));
            (domElement).append(new Option("<span class='boldit'>H3K27ac</span>","H3K27AC_NA"));
            (domElement).append(new Option("<span class='boldit'>TF Binding Site</span>","FOXA2_SPP"));
            (domElement).append("<optgroup label='ChromHMM'>");
            (domElement).append(new Option("<span class='holdit'>Enhancer</span>","Enhancer_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Enhancer Active 1</span>","EnhancerActive1_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Enhancer Active 2</span>","EnhancerActive2_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Enhancer Bivalent</span>","EnhancerBivalent_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Enhancer Genic</span>","EnhancerGenic_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Enhancer Genic 2</span>","EnhancerGenic_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Enhancer Weak</span>","EnhancerWeak_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Heterochromatin</span>","Heterochromatin_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Promoter Active</span>","PromoterActive_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Promoter Flanking</span>","PromoterFlanking_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Promoter Weak</span>","PromoterWeak_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Quiescent Low</span>","QuiescentLow_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Repressed Polycomb</span>","RepressedPolycomb_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Repressed Polycomb Weak</span>","RepressedPolycombWeak_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Transcription</span>","Transcription_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>Transcription Weak</span>","TranscriptionWeak_ChromHMM"));
            (domElement).append(new Option("<span class='holdit'>ZNF Repeat</span>","ZNFRepeat_ChromHMM"));
            (domElement).append("</optgroup>");
            (domElement).multiselect('rebuild');
        }

    }


    const updateAnnotationDropDownBox = function(currentMethod,annotationOptions){
        switch(currentMethod){
            case "MACS":
                if (annotationOptions.length === 0){
                    $('#annotationSelectorChoice').append(new Option("<span class='boldit'>ATAC-Seq</span>","AccessibleChromatin_MACS"));
                } else {
                    _.forEach(_.sortBy(annotationOptions,'name'), function (rec ) {
                        $('#annotationSelectorChoice').append(new Option("<span class='boldit'>ATAC-Seq</span>",rec.value));
                    });
                }

                break;
            case "ABC":
                if (annotationOptions.length === 0){
                    $('#annotationSelectorChoice').append(new Option("<span class='boldit'>ABC</span>","GenePrediction_ABC"));
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
                    $('#annotationSelectorChoice').append(new Option("<span class='boldit'>TF Binding Site</span>",'NKX6.1_SPP'));
                }
                break;
            case "ChromHMM":
                $('#annotationSelectorChoice').append("<optgroup label='ChromHMM'>");
                _.forEach(_.sortBy(annotationOptions,'name'), function (rec ) {
                    $('#annotationSelectorChoice').append(new Option('&nbsp;&nbsp;&nbsp;&nbsp;'+rec.name,rec.value));
                });
                $('#annotationSelectorChoice').append("</optgroup>");
                break;
            case "cicero":
                if (annotationOptions.length === 0){
                    $('#annotationSelectorChoice').append(new Option("<span class='boldit'>Coaccessibility</span>","GenePrediction_cicero"));
                } else {
                    _.forEach(_.sortBy(annotationOptions, 'name'), function (rec) {
                        $('#annotationSelectorChoice').append(new Option("<span class='boldit'>Coaccessibility</span>", rec.value));
                    });
                }                break;
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
/*
        var pageURL_string = window.location.href;
        var url = new URL(pageURL_string);

        if (url.searchParams.get("chromosomeNumber")){

            //console.log("region view");
            var chromosomeInput = url.searchParams.get("chromosomeNumber");
            var startExtentInput = url.searchParams.get("startExtent");
            var endExtentInput = url.searchParams.get("endExtent");

            //console.log(preferredPhenotype+" : "+chromosomeInput+" : "+startExtentInput+" : "+endExtentInput);

            mpgSoftware.dynamicUi.modifyScreenFields({phenotype:preferredPhenotype, chromosome:chromosomeInput, startPosition:startExtentInput, endPosition:endExtentInput},getVariablesToRemember());

        } else {

            //console.log("gene id view");
            var urlPath = window.location.pathname.split("/");
            var geneName = urlPath[urlPath.length - 1];

            $.ajax({
                cache: false,
                type: "post",
                url: GENEINFOAJAXURL,
                data: {geneName: geneName},
                async: true
            }).done(function (geneInfoData) {
                //console.log(data);
                var genePageExtent = 100000;

                var chromosomeInput = geneInfoData.geneInfo.CHROM;
                var startExtentInput = geneInfoData.geneInfo.BEG - genePageExtent;
                var endExtentInput = geneInfoData.geneInfo.END + genePageExtent;

                //console.log(preferredPhenotype+" : "+chromosomeInput+" : "+startExtentInput+" : "+endExtentInput);

                mpgSoftware.dynamicUi.modifyScreenFields({phenotype:preferredPhenotype, chromosome:chromosomeInput, startPosition:startExtentInput, endPosition:endExtentInput},getVariablesToRemember());
            });

        }*/

    }

    return {
        setVariablesToRemember:setVariablesToRemember,
        initialPageSetUp:initialPageSetUp,
        refreshTableForPhenotype:refreshTableForPhenotype,
        refreshTableForAnnotations:refreshTableForAnnotations,
        updateAnnotationDropDownBox:updateAnnotationDropDownBox,
        fillAnnotationDropDownBox:fillAnnotationDropDownBox,
        refreshVariantFocusForPhenotype:refreshVariantFocusForPhenotype
    }
}());
