
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



        var retrieveSpecifiedDataAndDisplayIt  = function(currentPhenotypeName,selectedDataset,currentPropertyName){
            var mySavedVariables = getMySavedVariables();
            $('#spinner').show();
            $.ajax({
                cache: false,
                type: "post",
                url: mySavedVariables.prioritizedGeneInfoAjaxUrl,
                data: {
                    trait: currentPhenotypeName,
                    sampleGroup:selectedDataset,
                    propertyName:currentPropertyName
                },
                async: true
            }).done ( function(data){
                var myLocalSavedVariables = getMySavedVariables();
                refreshGeneTableView(data);
                $('#spinner').hide();
            }).fail(function (jqXHR, textStatus, errorThrown) {
                $('#spinner').hide();
                core.errorReporter(jqXHR, errorThrown)
            });
        };



        var fillSubPhenotypeBoxBasedOnPhenotypeAndDataSet  = function( currentPhenotypeName,
                                                                       selectedDataset,
                                                                       phenotypeDropdownIdentifier,
                                                                       subphenotypeDropdownIdentifier ){
            var dataSetJson  = $.data($(phenotypeDropdownIdentifier)[0],'metadata',dataSetJson);
            var options = $(subphenotypeDropdownIdentifier);

            options.empty();

            // now restrict all options based on the two incoming parameters
            var matchingPhenotypeRecords =  _.filter(dataSetJson.pheotypeRecords, function(oneGroup){
                return (oneGroup.systemId === selectedDataset && oneGroup.name === currentPhenotypeName); // name here equals phenotype
            });
            if (matchingPhenotypeRecords.length > 0){  //I think this condition should always be unique  properties
                if (matchingPhenotypeRecords[0].properties.length > 0) { // we have at least one property to display
                    _.forEach(matchingPhenotypeRecords, function (oneElement) {
                        _.forEach(oneElement.properties, function (subElement){
                            var selectorOption = "";
                            if (subElement.name.indexOf('ynonymous')>-1){
                                selectorOption = " selected";
                            }
                            options.append($("<option "+selectorOption+"/>").val(subElement.name)
                                .html(subElement.translatedProperty));
                        });
                    });
                }
            }

            retrieveSpecifiedDataAndDisplayIt (currentPhenotypeName,selectedDataset,$(subphenotypeDropdownIdentifier+' option:selected').val());

        };




        var fillGenePhenotypeAndSubPhenotypeDropdown = function ( dataSetJson,
                                                                  currentPhenotypeName,
                                                                  phenotypeDropdownIdentifier,
                                                                  subphenotypeDropdownIdentifier ) { // help text for each row
            if ((typeof dataSetJson !== 'undefined')  &&
                (typeof dataSetJson["is_error"] !== 'undefined')&&
                (dataSetJson["is_error"] === false)&&
                (typeof dataSetJson["pheotypeRecords"]  !== 'undefined' )&&
                ( dataSetJson["pheotypeRecords"].length > 0 ))
            {
                var options = $(phenotypeDropdownIdentifier);
                $.data(options[0],'metadata',dataSetJson);

                options.empty();

                var keys = dataSetJson.preferredGroups;

                // begin by retrieving the most desirable phenotype groups
                var matchingPhenotypeRecords =  _.filter(dataSetJson.pheotypeRecords, function(oneGroup){
                    return oneGroup.name === currentPhenotypeName;

                });
                var dataSetRecordsForPhenotype = _.uniqBy(matchingPhenotypeRecords,'systemId');
                if (dataSetRecordsForPhenotype.length > 0){
                    _.forEach (dataSetRecordsForPhenotype, function (oneElement){
                        options.append($("<option />").val(oneElement.systemId)
                            .html(oneElement.translatedSystemId));
                    });
                }

                // enable the input
                options.prop('disabled', false);

                fillSubPhenotypeBoxBasedOnPhenotypeAndDataSet(  currentPhenotypeName,
                                                                $(phenotypeDropdownIdentifier+' option:selected').val(),
                                                                phenotypeDropdownIdentifier,
                                                                subphenotypeDropdownIdentifier );

            }
        }




        var fillDropdownsForGenePrioritization = function () {
            var mySavedVariables = getMySavedVariables();

            $.ajax({
                cache: false,
                type: "post",
                url: mySavedVariables.getGeneLevelResultsUrl,
                data: {phenotype: mySavedVariables.phenotypeName},
                async: true
            }).done ( function(data){
                    var myLocalSavedVariables = getMySavedVariables();
                    fillGenePhenotypeAndSubPhenotypeDropdown(data,
                        myLocalSavedVariables.phenotypeName,
                        myLocalSavedVariables.phenotypeDropdownIdentifier,
                        myLocalSavedVariables.subphenotypeDropdownIdentifier);
            }).fail(function (jqXHR, textStatus, errorThrown) {
                $('#spinner').hide();
                core.errorReporter(jqXHR, errorThrown)
            });

        };





        var pickNewGeneInfo = function (){
            var mySavedVars = getMySavedVariables();
            $('#spinner').show();
            var sampleGroup = $('#manhattanSampleGroupChooser').val();
            $('#manhattanPlot1').empty();
            $('#traitTableBody').empty();
            $('#phenotypeTraits').DataTable().rows().remove();
            $('#phenotypeTraits').dataTable({"retrieve": true}).fnDestroy();
            retrieveSpecifiedDataAndDisplayIt (mySavedVars.phenotypeName,
                $(mySavedVars.phenotypeDropdownIdentifier+' option:selected').val(),
                $(mySavedVars.subphenotypeDropdownIdentifier+' option:selected').val());
            //mpgSoftware.manhattanplotTableHeader.fillRegionalTraitAnalysis(mySavedVars.phenotypeName,sampleGroup);

        };

        var refreshGeneTableView = (function(data) {
            var savedVar = mpgSoftware.manhattanplotTableHeader.getMySavedVariables();
            var collector = [];
            var effectType = 'beta';
            if ((typeof data !== 'undefined') &&
                (data)) {
                if ((data.variant) &&
                    (data.variant.results)) {//assume we have data and process it

                    for (var i = 0; i < data.variant.results.length; i++) {
                        var skipIt = false;
                        var d = {};
                        for (var j = 0; j < data.variant.results[i].pVals.length; j++) {
                            var key = data.variant.results[i].pVals[j].level;
                            var value = data.variant.results[i].pVals[j].count;
                            var splitKey = key.split('^');
                            if (splitKey.length>3) {
                                if (splitKey[2]=='P_VALUE') {
                                    if (value===null) {
                                        skipIt=true;
                                    }
                                    d['P_VALUE'] = value;
                                } else if (splitKey[2]=='ODDS_RATIO') {
                                    d['ODDS_RATIO'] = value;
                                    effectType = 'odds ratio'
                                } else if ( (splitKey[2]!==null)&&
                                            (splitKey[2].length>3)&&
                                            (splitKey[2].substring(0, 3)==='ACA')) {
                                    d['ACA'] = value;
                                } else if ( (splitKey[2]!==null)&&
                                    (splitKey[2].length>3)&&
                                    (splitKey[2].substring(0, 3)==='ACU')) {
                                    d['ACU'] = value;
                                }
                            } else if (key==='START') {
                                d['POS'] = parseInt(value);
                            } else {
                                d[key] = value;
                            }

                        }
                        if (!skipIt){
                            collector.push(d);
                        }

                    }


                }
            }
            if ((data.variant) &&
                (data.variant.dataset))  {
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
                .significanceThreshold(undefined)
                .xAxisAccessor(function (d) {
                    return d.POS
                })
                .yAxisAccessor(function (d) {
                    var retVal;
                    // if (d.P_VALUE > 0) {
                    //     return (0 - Math.log10(d.P_VALUE));
                    // } else {
                    //     return 0
                    // }
                    if (d.P_VALUE > 0) {
                        retVal = (0 - Math.log10(d.P_VALUE));
                    } else {
                        retVal = 0;
                    }
                    if (isNaN(retVal)){
                        console.log('isNaN=true for Manhattan data!');
                        return 0;
                    } else {
                        return retVal;
                    }

                })
                .nameAccessor(function (d) {
                    return d.GENE
                })
                .chromosomeAccessor(function (d) {
                    return d.CHROM
                })
                .includeXChromosome(true)
                .includeYChromosome(false)
                .dotClickLink(savedVar.variantInfoUrl)
                ;

            d3.select("#manhattanPlot1").call(manhattan.render);
            var mySavedVariables = getMySavedVariables();
            iterativeTableFiller(collector,
                effectType,
                mySavedVariables.local,
                savedVar.copyMsg,
                savedVar.printMsg);

        });

        var convertLineForPhenotypicTraitTable = function (variant, effectsField) {
                var retVal = [];
                var pValueGreyedOut = (variant.P_VALUE > .05) ? "greyedout" : "normal";
                var pValue='';
                var orValue='';
                var acaValue='';
                var acuValue='';
                var geneName='';
                var position='';
                var chromosome = '';
                var positionIndicator = {'start':'','end':'','chrom':''};
                _.forEach(variant, function(value, key) {

                    if (key.indexOf('^')>-1){
                        ;

                    }   else if (key === 'P_VALUE')  {
                        pValue=UTILS.realNumberFormatter(value);
                    } else if  (key==='ACA'){
                        if (value===null){
                            acaValue=0;
                        } else {
                            acaValue=value;
                        }
                    } else if (key==='ACU'){
                        if (value===null){
                            acuValue=0;
                        } else {
                            acuValue=value;
                        }
                    } else if (key === 'ODDS_RATIO'){
                        orValue=UTILS.realNumberFormatter(value);
                    } else if (key === 'GENE'){
                        geneName=value;
                    } else if (key === 'POS'){
                        positionIndicator['start']=value;
                    }else if (key === 'END'){
                        positionIndicator['end']=value;
                    }else if (key === 'CHROM'){
                        chromosome = value;
                    }
                });
                position = positionIndicator['start']+" - "+positionIndicator['end'];
                retVal.push( geneName );
                retVal.push( chromosome );
                retVal.push(position);
                retVal.push( pValue );
                retVal.push( orValue );
                retVal.push(acuValue);
                retVal.push(acaValue);
                return retVal;
            };

          var  iterativeTableFiller = function (variant, effectType, locale, copyText, printText) {
                $('#effectTypeHeader').empty();
                $('#effectTypeHeader').append(effectType);
                var languageSetting = {}
                // check if the browser is using Spanish
                if (locale.startsWith("es")) {
                    languageSetting = {url: '../js/lib/i18n/table.es.json'}
                }
                var table = $('#phenotypeTraits').dataTable({
                    pageLength: 25,
                    filter: false,
                    order: [[1, "asc"]],
                    columnDefs: [ {type: "scientific", targets: [3, 4]},{type: "allnumeric", targets: [5, 6]}],
                    language: languageSetting,
                    buttons: [
                        { extend: 'copy', text: copyText },
                        'csv',
                        'pdf',
                        { extend: 'print', text: printText }
                    ]
                });
                var dataLength = variant.length;
                var effectsField = UTILS.determineEffectsTypeString('#phenotypeTraits');
                for (var i = 0; i < dataLength; i++) {
                    var array = convertLineForPhenotypicTraitTable(variant[i], effectsField);
                    $('#phenotypeTraits').dataTable().fnAddData(array, (i == 25) || (i == (dataLength - 1)));
                }
            };

        return{
            fillDropdownsForGenePrioritization: fillDropdownsForGenePrioritization,
            pickNewGeneInfo:pickNewGeneInfo,
            setMySavedVariables:setMySavedVariables,
            getMySavedVariables:getMySavedVariables

        }


    }());


})();

