
var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";
    mpgSoftware.genePrioritization = (function () {

        var mySavedVariables = {};
        var setMySavedVariables = function(saveTheseVariables){
            mySavedVariables = saveTheseVariables;
        }

        var getMySavedVariables = function(){
            return mySavedVariables;
        }




        var fillGenePhenotypeAndSubPhenotypeDropdown = function ( dataSetJson,
                                                                  phenotypeDropdownIdentifier,
                                                                  subphenotypeDropdownIdentifier ) { // help text for each row
            if ((typeof dataSetJson !== 'undefined')  &&
                (typeof dataSetJson["is_error"] !== 'undefined')&&
                (dataSetJson["is_error"] === false)&&
                (typeof dataSetJson["pheotypeRecords"]  !== 'undefined' )&&
                ( dataSetJson["pheotypeRecords"].length > 0 ))
            {
                var options = $(phenotypeDropDownIdentifier);
                option.data('metadata',dataSetJson);

                options.empty();

                var keys = dataSetJson.preferredGroups;

                // begin by retrieving the most desirable phenotype groups
                _.forEach(keys,function(key){
                    var groupObjectPointer;
                    var groupContents =  _.filter(dataSetJson.pheotypeRecords, function(oneGroup){
                        return oneGroup.group === key;

                    });
                    var groupObjectPointer = _.find(dataSetJson.pheotypeRecords, function(oneGroup){
                        return oneGroup.group === key;
                    });
                    var uniquePhenotypeIdentifier = "";
                    if (groupContents.length > 0){
                        options.append("<optgroup label='"+key+"'>");
                        _.forEach (groupContents, function (oneElement){
                            options.append($("<option />").val(oneElement.name)
                                .html("&nbsp;&nbsp;&nbsp;" + oneElement.name));
                        });
                        options.append("</optgroup label='"+key+"'>");;
                    }
                });


                // enable the input
                options.prop('disabled', false);

            }
        }




        var fillDropdownsForGenePrioritization = function (phenotypeDropdownIdentifier, subphenotypeDropdownIdentifier) {
            var coreVariables = getMySavedVariables();
            var loader = $('#rSpinner');
            loader.show();

            $.ajax({
                cache: false,
                type: "post",
                url: coreVariables.ajaxSampleGroupsPerTraitUrl,
                data: {phenotype: phenotype},
                async: false
            }).done (
                fillGenePhenotypeAndSubPhenotypeDropdown(data,phenotypeDropdownIdentifier, subphenotypeDropdownIdentifier)
            ).fail(function (jqXHR, textStatus, errorThrown) {
                loading.hide();
                core.errorReporter(jqXHR, errorThrown)
            });

        };



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




        })


        return{
            refreshManhattanplotTableView:refreshManhattanplotTableView,
            fillDropdownsForGenePrioritization: fillDropdownsForGenePrioritization,
            pickNewDataSet:pickNewDataSet,
            fillRegionalTraitAnalysis:fillRegionalTraitAnalysis,
            setMySavedVariables:setMySavedVariables,
            getMySavedVariables:getMySavedVariables

        }


    }());


})();

