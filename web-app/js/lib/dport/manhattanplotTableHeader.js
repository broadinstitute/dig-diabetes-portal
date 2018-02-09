
var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";
    mpgSoftware.manhattanplotTableHeader = (function () {

        var mySavedVariables = {};
        var setMySavedVariables = function(saveTheseVariables){
            mySavedVariables = saveTheseVariables;
        }

        var getMySavedVariables = function(){
            return mySavedVariables;
        }



        var fillSampleGroupDropdown = function (phenotype) {
            var coreVariables = getMySavedVariables();
            var loader = $('#rSpinner');
            loader.show();

            $.ajax({
                cache: false,
                type: "post",
                url: coreVariables.ajaxSampleGroupsPerTraitUrl,
                data: {phenotype: phenotype},
                async: false,
                success: function (data) {

                    var rowDataStructure = [];
                    if ((typeof data !== 'undefined') &&
                        (data)) {
                        if ((data.sampleGroups) &&
                            (data.sampleGroups.length > 0)) {//assume we have data and process it
                            for (var i = 0; i < data.sampleGroups.length; i++) {
                                var sampleGroup = data.sampleGroups[i];
                                $('#manhattanSampleGroupChooser').append(new Option(sampleGroup.sgn, sampleGroup.sg, sampleGroup.default))
                            }
                        }
                    }
                    loader.hide();
                },
                error: function (jqXHR, exception) {
                    loader.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });

        };


        var onPageLoad = function() {
            document.getElementById("clump").checked = true;
        }

        var unclickClumpCheckbox = function(){
            var myVars = mpgSoftware.manhattanplotTableHeader.getMySavedVariables();
            $('#clump').change(function() {
                if(!$(this).is(':checked')){
                    mpgSoftware.manhattanplotTableHeader.fillClumpVariants(myVars.phenotypeName,document.getElementById("manhattanSampleGroupChooser").value);
                    alert('worked');
                }
                else {
                    //clear the clump and call the non-clump data and d3 plot
                    $('#phenotypeTraits').dataTable({"retrieve": true}).fnDestroy();
                    mpgSoftware.regionalTraitAnalysis.fillRegionalTraitAnalysis(myVars.phenotypeName,sampleGroup);

                }

            })}





        var fillClumpVariants = function (phenotypeNamex, dataset) {
            var coreVariables = mpgSoftware.manhattanplotTableHeader.getMySavedVariables();
            var loader = $('#rSpinner');
            loader.show();
            $.ajax({
                cache: false,
                type: "post",
                url: coreVariables.ajaxClumpDataUrl,
                data: {phenotype: phenotypeNamex, dataset: dataset},
                async: true,
                success: function (data) {
                    console.log(data);
                    data.variants

                    mpgSoftware.manhattanplotTableHeader.refreshManhattanplotTableView(data);

                },
                error: function (jqXHR, exception) {
                    loader.hide();
                    core.errorReporter(jqXHR, exception);
                }
            }).done(function (data, textStatus, jqXHR) {
                _.forEach(data.children, function (eachKey,val) {
                    console.log(data);
                })

            });

        };

        // var pickNewDataSet = function (){
        //     var sampleGroup = $('#manhattanSampleGroupChooser').val();
        //     $('#manhattanPlot1').empty();
        //     $('#traitTableBody').empty();
        //     $('#phenotypeTraits').DataTable().rows().remove();
        //     $('#phenotypeTraits').dataTable({"retrieve": true}).fnDestroy();
        //     mpgSoftware.manhattanplotTableHeader.fillRegionalTraitAnalysis(getMySavedVariables().phenotypeName,sampleGroup);
        //
        // }

        var fillRegionalTraitAnalysis = function (phenotype,sampleGroup) {
            var rememVars = mpgSoftware.manhattanplotTableHeader.getMySavedVariables();

            var loading = $('#spinner').show();
            $('[data-toggle="popover"]').popover();
            $.ajax({
                cache: false,
                type: "post",
                url:rememVars.phenotypeAjaxUrl,
                data: { trait: rememVars.phenotypeName,
                    significance: rememVars.requestedSignificance,
                    sampleGroup: sampleGroup  },
                async: true,
                success: function (data) {
                    $('#spinner').hide();
                    try{
                        mpgSoftware.manhattanplotTableHeader.refreshManhattanplotTableView(data);
                    }
                    catch (e){console.log("I tried calling refreshManhattanPlotTableView but failed",e)}

                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };

        var callFillClumpVariants = function() {
            var mysavevars = mpgSoftware.manhattanplotTableHeader.getMySavedVariables();
            var sampleGroup = $('#manhattanSampleGroupChooser').val();
            $('#manhattanPlot1').empty();
            $('#traitTableBody').empty();
            $('#phenotypeTraits').DataTable().rows().remove();
            $('#phenotypeTraits').dataTable({"retrieve": true}).fnDestroy();
            mpgSoftware.manhattanplotTableHeader.fillClumpVariants(mysavevars.phenotypeName,document.getElementById("manhattanSampleGroupChooser").value);
        }

        var pickNewDataSet = function (){
            var mySavedVars = mpgSoftware.manhattanplotTableHeader.getMySavedVariables();
            var sampleGroup = $('#manhattanSampleGroupChooser').val();
            $('#manhattanPlot1').empty();
            $('#traitTableBody').empty();
            $('#phenotypeTraits').DataTable().rows().remove();
            $('#phenotypeTraits').dataTable({"retrieve": true}).fnDestroy();
            mpgSoftware.manhattanplotTableHeader.fillRegionalTraitAnalysis(mySavedVars.phenotypeName,sampleGroup);

        }

        var refreshManhattanplotTableView = (function(data) {
            var savedVar = mpgSoftware.manhattanplotTableHeader.getMySavedVariables();
            var collector = [];
            var effectType = 'beta';
            if ((typeof data !== 'undefined') &&
                (data)) {
                if ((data.variant) &&
                    (data.variant.results)) {//assume we have data and process it

                    for (var i = 0; i < data.variant.results.length; i++) {
                        var d = {};
                        for (var j = 0; j < data.variant.results[i].pVals.length; j++) {
                            var key = data.variant.results[i].pVals[j].level;
                            var value = data.variant.results[i].pVals[j].count;
                            var splitKey = key.split('^');
                            if (splitKey.length>3) {
                                if (splitKey[2]=='P_VALUE') {
                                    d['P_VALUE'] = value;
                                } else if (splitKey[2]=='ODDS_RATIO') {
                                    d[key] = value;
                                    effectType = 'odds ratio'
                                } else if ((splitKey[2]=='BETA')||(splitKey[2]=='MAF')) {
                                    d[key] = value;
                                }
                            } else if (key==='POS') {
                                d[key] = parseInt(value);
                            } else {
                                d[key] = value;
                            }

                        }
                        collector.push(d);
                    }


                }
            }
            if ((data.variant) &&
                (data.variant.dataset))  {
//                        $('#traitTableDescription').text(data.variant.dataset);
                $('#manhattanSampleGroupChooser').val(data.variant.dataset);
            }

            var margin = {top: 0, right: 20, bottom: 0, left: 70},
                width = 1050 - margin.left - margin.right,
                height = 600 - margin.top - margin.bottom;

            var manhattan = baget.manhattan()
                .width(width)
                .height(height)
                .dataHanger("#manhattanPlot1", collector)
                .crossChromosomePlot(true)
                //                    .overrideYMinimum (0)
                //                    .overrideYMaximum (10)
                //                .overrideXMinimum (0)
                //                .overrideXMaximum (1000000000)
                .dotRadius(3)
                //.blockColoringThreshold(0.5)
                .significanceThreshold(- Math.log10(parseFloat(savedVar.requestedSignificance)))
                .xAxisAccessor(function (d) {
                    return d.POS
                })
                .yAxisAccessor(function (d) {
                    if (d.P_VALUE > 0) {
                        return (0 - Math.log10(d.P_VALUE));
                    } else {
                        return 0
                    }
                })
                .nameAccessor(function (d) {
                    return d.DBSNP_ID
                })
                .chromosomeAccessor(function (d) {
                    return d.CHROM
                })
                .includeXChromosome(true)
                .includeYChromosome(false)
                .dotClickLink(savedVar.variantInfoUrl)
            ;

            d3.select("#manhattanPlot1").call(manhattan.render);

            mpgSoftware.phenotype.iterativeTableFiller(collector,
                effectType,
                savedVar.local,
                savedVar.copyMsg,
                savedVar.printMsg);




        });










        return{
            refreshManhattanplotTableView:refreshManhattanplotTableView,
            fillClumpVariants:fillClumpVariants,
            fillSampleGroupDropdown: fillSampleGroupDropdown,
            unclickClumpCheckbox:unclickClumpCheckbox,
            pickNewDataSet:pickNewDataSet,
            fillRegionalTraitAnalysis:fillRegionalTraitAnalysis,
            callFillClumpVariants:callFillClumpVariants,
            setMySavedVariables:setMySavedVariables,
            getMySavedVariables:getMySavedVariables

        }


    }());


})();



