
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
                    loader.hide();
                    var rowDataStructure = [];
                    if ((typeof data !== 'undefined') &&
                        (data)) {
                        if ((data.sampleGroups) &&
                            (data.sampleGroups.length > 0)) {
                            //first empty the old one
                            $('#manhattanSampleGroupChooser').empty()
                            //assume we have data and process it
                            for (var i = 0; i < data.sampleGroups.length; i++) {
                                var sampleGroup = data.sampleGroups[i];
                                $('#manhattanSampleGroupChooser').append(new Option(sampleGroup.sgn, sampleGroup.sg, sampleGroup.default))
                            }
                            mpgSoftware.manhattanplotTableHeader.callFillClumpVariants(phenotype);
                            window.history.pushState('page2', 'Title', coreVariables.traitSearchUrl + "?trait=" + phenotype + "&significance=" + 0.0005);

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



        var fillClumpVariants = function (phenotype, dataset, r2) {
            var coreVariables = mpgSoftware.manhattanplotTableHeader.getMySavedVariables();
            var loading = $('#spinner').show();
            $.ajax({
                cache: false,
                type: "post",
                url: coreVariables.ajaxClumpDataUrl,
                data: {phenotype: phenotype, dataset: dataset,r2:r2},
                async: true,
                success: function (data) {
                    loading.hide();
                    if(data.variant.results[0].isClump == false){
                        document.getElementById("r2dropdown").style.display = "none";
                        mpgSoftware.manhattanplotTableHeader.fillRegionalTraitAnalysis(phenotype,dataset);
                    }
                    //if(data.isClump) is true then refresh the manhattan plot
                    //else (get the id of the r2 dropdown and disable the dropdown.
                    else{
                        mpgSoftware.manhattanplotTableHeader.refreshManhattanplotTableView(data);
                        document.getElementById("r2dropdown").style.display = "block";
                    }
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            }).done(function (data, textStatus, jqXHR) {
                _.forEach(data.children, function (eachKey,val) {
                    console.log(data);
                })
            });

        };

        var fillRegionalTraitAnalysis = function (phenotype,sampleGroup) {
            var rememVars = mpgSoftware.manhattanplotTableHeader.getMySavedVariables();
            var loading = $('#spinner').show();
            var phenotypeName = phenotype
            $('[data-toggle="popover"]').popover();
            $.ajax({
                cache: false,
                type: "post",
                url:rememVars.phenotypeAjaxUrl,
                data: { trait: phenotypeName,
                    significance: rememVars.requestedSignificance,
                    sampleGroup: sampleGroup  },
                async: true,
                success: function (data) {
                    loading.hide();

                    try{
                        mpgSoftware.manhattanplotTableHeader.refreshManhattanplotTableView(data);
                        loading.hide();
                    }
                    catch (e){console.log("fillRegionalTraitAnalysis tried calling refreshManhattanPlotTableView but failed",e)}

                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };

        var callFillClumpVariants = function() {
            var mySavedVars = mpgSoftware.manhattanplotTableHeader.getMySavedVariables();
            var sampleGroup = $('#manhattanSampleGroupChooser').val();
            var r2 = $('#rthreshold').val();
            var selectedPhenotype = $('#phenotypeVFChoser').val();

            //phenotype is null when its not selected from the manhattan plot page
            if(selectedPhenotype == null){
                selectedPhenotype = mySavedVars.phenotypeName;
            }
            var selectedDataset = document.getElementById("manhattanSampleGroupChooser").value;
                $('#manhattanPlot1').empty();
                $('#traitTableBody').empty();
                $('#phenotypeTraits').DataTable().rows().remove();
                $('#phenotypeTraits').dataTable({"retrieve": true}).fnDestroy();
                mpgSoftware.manhattanplotTableHeader.fillClumpVariants(selectedPhenotype,selectedDataset,r2);
        };


        // called when page loads
        var fillPhenotypesDropdown = function (portaltype) {
            var rememVars = mpgSoftware.manhattanplotTableHeader.getMySavedVariables();
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
                        UTILS.fillPhenotypeCompoundDropdown(data.datasets, '#phenotypeVFChoser', true, [], rememberportaltype);
                    }
                    loading.hide();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };

        // called when page loads
        var fillPhenotypesDropdownNew = function (portaltype, selectedHomePagePhenotype) {
            var rememVars = mpgSoftware.manhattanplotTableHeader.getMySavedVariables();
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
                        UTILS.fillPhenotypeCompoundDropdownNew(data.datasets, '#phenotypeVFChoser', true, [], rememberportaltype, selectedHomePagePhenotype);
                    }
                    loading.hide();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };



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
                            } else if (key == 'ODDS_RATIO'){
                                    d[key] = value;
                                    effectType = 'odds ratio'
                            }
                            else if(key==='BETA'){
                                d[key] = value;
                                effectType = 'beta'
                            }
                            else if(key==='MAF'){
                                d[key] = value;
                            }
                            d[key] = value;

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
                    return parseInt (d.POS);
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
            fillRegionalTraitAnalysis:fillRegionalTraitAnalysis,
            callFillClumpVariants:callFillClumpVariants,
            setMySavedVariables:setMySavedVariables,
            getMySavedVariables:getMySavedVariables,
            fillPhenotypesDropdown: fillPhenotypesDropdown,
            fillPhenotypesDropdownNew: fillPhenotypesDropdownNew
        }

    }());


})();



