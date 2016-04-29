<style>
rect.histogramHolder {
    fill: #6699cc;
}
rect.box {
    fill: #ccaaaa;
}
.caatSpinner{
    position: absolute;
    z-index: 1;
    left: 30%;
    top: 50%;
}
div.sampleNumberReporter {
    display: none;
    font-weight: bold;
}
div.secHeader {
    font-weight: bold;
    font-size: 18px;
    text-decoration: underline;
}
div.secBody {
    background-color: #eee;
}
div.burden-test-wrapper-options {
    background-color: #eee;
    font-size: 16px;
    padding: 0;
}
div.burden-test-wrapper-options .row {
    margin: 0 0 1px 0;
}
div.burden-test-btn-wrapper {
    padding: 0 10px 10px;
    margin-top: 0;
}
div.burden-test-specific-results{
    background-color: #ffffff;
    -webkit-border-radius: 10px;
    -moz-border-radius: 10px;
    border-radius: 10px;
    padding: 10px;
    border: 1px solid;
}
span.distPlotter{
    color: #000;
    cursor: pointer;
}
span.activeDistPlotter{
    color: #0082ca;
}
button.burden-test-btn {
    width: 100%;
}

div.burden-test-result {
    font-size: 18px;
    padding: 0 0 5px 0;
    display: none;
}

div.burden-test-result-large {
    font-size: 25px;
    padding-top: 10px;
    display: none;
}

.burden-test-result .pValue {
    white-space: nowrap;
}

div.labelAndInput {
    white-space: nowrap;
}

div.labelAndInput > input {
    width: 150px;
}

.burden-test-result .orValue {
    white-space: nowrap;
}

.burden-test-result .ciValue {
    white-space: nowrap;
}

.mafOptionChooser div.radio {
    padding: 0 20px 0 0;
}

.vcenter {
    margin-top: 2em;
}

.vertical-center {
    margin-top: 1em;
}

.variantList {
    border: 1px solid darkgrey;
    padding: 2px;
    max-height: 140px;
    overflow-y: auto;
    font-size: 14px;
}

.variantsListLabel {
    text-align: center;
}

.burdenTestResultHolder {
    height: 140px;
}
#filterHolder div.row div {
    padding: 0;
    line-height: 20px;
}
#covariateHolder .row {
    line-height: 15px;
}
</style>


<g:javascript>
    var mpgSoftware = mpgSoftware || {};

    mpgSoftware.burdenInfo = (function () {

        var delayedBurdenDataPresentation = {};

        // burden testing hypothesis testing section
        var fillBurdenBiologicalHypothesisTesting = function (caseNumerator, caseDenominator, controlNumerator, controlDenominator, traitName) {
            var retainBarchartPtr;

            // The bar chart graphic
            if ((caseNumerator) ||
                (caseDenominator) &&
                (controlNumerator) &&
                (controlDenominator)) {
                delayedBurdenDataPresentation = {functionToRun: mpgSoftware.variantInfo.fillUpBarChart,
                    barchartPtr: retainBarchartPtr,
                    launch: function () {
//                        retainBarchartPtr = mpgSoftware.variantInfo.fillUpBarChart(caseNumerator, caseDenominator, controlNumerator, controlDenominator, traitName);
//                        return retainBarchartPtr;
                    },
                    removeBarchart: function () {
//                        if ((typeof retainBarchartPtr !== 'undefined') &&
//                            (typeof retainBarchartPtr.clear !== 'undefined')) {
//                            retainBarchartPtr.clear('T2D');
//                        }
                    }
                };
            }
        };

        var retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter = function () {
            return delayedBurdenDataPresentation;
        };

        return {
            // public routines
            fillBurdenBiologicalHypothesisTesting: fillBurdenBiologicalHypothesisTesting,
            retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter: retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter
        }
    }());

    mpgSoftware.burdenTestShared = (function () {
        var loading = $('#rSpinner');
        var storedSampleMetadata;
        var storedSampleData;


        var storeSampleData = function (data){
            storedSampleData = data;
        };


        var getStoredSampleData  = function (){
            return storedSampleData;
        };

        var storeSampleMetadata = function (metadata){
            storedSampleMetadata = metadata;
        };


        var getStoredSampleMetadata  = function (){
            return storedSampleMetadata;
        };

        var retrieveMatchingDataSets = function (selPhenotypeSelector,selDataSetSelector){
            var processReturnedDataSets = function (phenotypeName,matchingDataSets){
               var dataSetDropDown = $(selDataSetSelector);
               if ((typeof dataSetDropDown !== 'undefined') &&
                 (typeof matchingDataSets !== 'undefined') &&
                 (matchingDataSets.length > 0)) {
                 for ( var i = 0 ; i < matchingDataSets.length; i++ )
                    dataSetDropDown.append(new Option(matchingDataSets[i].translation,matchingDataSets[i].name,matchingDataSets[i].translation));
                 }
            };
            UTILS.retrieveSampleGroupsbyTechnologyAndPhenotype(['GWAS','ExChip','ExSeq'],selPhenotypeSelector.value,
            "${createLink(controller: 'VariantSearch', action: 'retrieveTopSGsByTechnologyAndPhenotypeAjax')}",processReturnedDataSets );
        };


        var retrieveExperimentMetadata = function (dropDownSelector) {
            var loading = $('#spinner').show();
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller: 'VariantInfo', action: 'sampleMetadataExperimentAjax')}",
                data: {},
                async: true,
                success: function (data) {
                    var experimentDropdown = $(dropDownSelector);
                    if ( ( data !==  null ) &&
                            ( typeof data !== 'undefined') &&
                            ( typeof data.sampleGroups !== 'undefined' ) &&
                            (  data.sampleGroups !==  null ) ) {
                        _.forEach(data.sampleGroups,function(d){
                           experimentDropdown.append( new Option(d.trans, d.name));
                        });
                    }
                    loading.hide();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };

        /***
        *  Use this if you have only one data set, since then we don't need to burden the user with the choice
        */
        var preloadInteractiveAnalysisData = function () {
           $('.caatSpinner').show();
            var dropDownSelector = '#phenotypeFilter';
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller: 'VariantInfo', action: 'sampleMetadataAjaxWithAssumedExperiment')}",
                data: {},
                async: true,
                success: function (data) {
                    storeSampleMetadata(data);
                    var phenotypeDropdown = $(dropDownSelector);
                    phenotypeDropdown.empty();
                    if ( ( data !==  null ) &&
                            ( typeof data !== 'undefined') &&
                            ( typeof data.phenotypes !== 'undefined' ) &&
                            (  data.phenotypes !==  null ) ) {
                        _.forEach(data.phenotypes,function(d){
                           phenotypeDropdown.append( new Option(d.trans, d.name));
                        });
                    }
                    var filtersSpecs = [];
                    _.forEach(data.filters,function(filterObjs){
                       filtersSpecs.push("{\"name\": \""+filterObjs.name+"\"}");
                    });
                    var domSelector = $(datasetFilter);
                    var jsonDescr = "{\"dataset\":\""+data.dataset+"\"," +
                                      "\"requestedData\":["+filtersSpecs.join(',')+"]," +
                                      "\"filters\":[]}";
                    mpgSoftware.burdenTestShared.retrieveSampleInformation  ( jsonDescr, function(){
                             mpgSoftware.burdenTestShared.retrieveSampleFilterMetadata($('#datasetFilter'), '#phenotypeFilter');
                             displayTestResultsSection(false);
                             $('.caatSpinner').hide();
                         } );
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };


        /***
        *
        * If the user must choose between different data sets then use this call instead of preloadInteractiveAnalysisData
        *
        * @param dropdownSel
        * @param dropDownSelector
        */
        var retrieveSampleMetadata = function (dropdownSel, dropDownSelector) {
            var loading = $('#spinner').show();
            var domSelector = $(dropdownSel);
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'VariantInfo', action:'sampleMetadataAjax')}",
                        data: {dataset:domSelector.val()},
                        async: true,
                        success: function (data) {
                            storeSampleMetadata(data);
                            var phenotypeDropdown = $(dropDownSelector);
                            phenotypeDropdown.empty();
                            if ( ( data !==  null ) &&
                                    ( typeof data !== 'undefined') &&
                                    ( typeof data.phenotypes !== 'undefined' ) &&
                                    (  data.phenotypes !==  null ) ) {
                                _.forEach(data.phenotypes,function(d){
                                   phenotypeDropdown.append( new Option(d.trans, d.name));
                                });
                            }
                            var filtersSpecs = [];
                            _.forEach(data.filters,function(filterObjs){
                               filtersSpecs.push("{\"name\": \""+filterObjs.name+"\"}");
                            });
                            var jsonDescr = "{\"dataset\":\""+$(dropdownSel).val()+"\"," +
                                      "\"requestedData\":["+filtersSpecs.join(',')+"]," +
                                      "\"filters\":[]}";
                            mpgSoftware.burdenTestShared.retrieveSampleInformation  ( jsonDescr, function(){} );
                            loading.hide();
                        },
                        error: function (jqXHR, exception) {
                            loading.hide();
                            core.errorReporter(jqXHR, exception);
                        }
                });
        };



        var retrieveSampleFilterMetadata = function (dropdownSel, dropDownSelector) {
            var data = getStoredSampleMetadata();
            var phenotype = $(dropDownSelector).val();
            if ( ( data !==  null ) &&
                 ( typeof data !== 'undefined') ){
                    if ( ( typeof data.filters !== 'undefined' ) &&
                         (  data.filters !==  null ) ) {
                            var filterHolderElement = $("#filterHolder");

                            var output = '';
                            var floatTemplate = $('#filterFloatTemplate')[0].innerHTML;
                            var categoricalTemplate = $('#filterCategoricalTemplate')[0].innerHTML;
                            _.forEach(data.filters,function(d,i){
                              if (d.type === 'FLOAT') {
                                 output = (output + Mustache.render(floatTemplate, d));
                              } else {
                                 output = (output+Mustache.render(categoricalTemplate, d));
                              }

                            });
                            $("#sampleRow").show();
                           $('.sampleNumberReporter').show();
                           if (_.trim(filterHolderElement.text()).length===0){
                              filterHolderElement.append(output);
                           }
                          // mpgSoftware.burdenTestShared.retrieveSampleInformation  ( jsonDescr, fillDistributionPlotsAndDropdowns, phenotype );
                           var sampleData = getStoredSampleData();
                           fillDistributionPlotsAndDropdowns(sampleData.metaData.variants,phenotype);
                           displayTestResultsSection(false);

                    }
                     if ( ( typeof data.covariates !== 'undefined' ) &&
                         (  data.covariates !==  null ) ) {
                        var covariateHolderElement = $("#covariateHolder");
                        covariateHolderElement.text("");
                        output = '';
                        var covariateTemplate = $('#covariateTemplate')[0].innerHTML;
                        var covariateTemplateChecked = $('#covariateTemplateChecked')[0].innerHTML;
                         _.forEach(data.covariates,function(d,i){
                             if (d.name !== phenotype){
                                if (d.def === 1){
                                   output = (output + Mustache.render(covariateTemplateChecked, d));
                                } else {
                                   output = (output + Mustache.render(covariateTemplate, d));
                                }
                             }
                        });
                        covariateHolderElement.append(output);


                    }

             }


            $('.caatSpinner').hide();
        };



        var refreshSampleData = function (dataSetSel,callback){

           var collectingFilterNames = function (){
               var filterStrings = [];
               _.forEach( extractAllFilterNames(), function(filterObject){
                   var oneFilter = [];
                   _.forEach( filterObject, function(value, key){
                       oneFilter.push("\""+key+"\": \""+value+"\"");
                   });
                   filterStrings.push("{"+oneFilter.join(",\n")+"}");
               } );
               return "[\n" + filterStrings.join(",") + "\n]";
            };




            var collectingFilterValues = function (){
               var filterStrings = [];
               _.forEach( extractFilters(), function(filterObject){
                   var oneFilter = [];
                   _.forEach( filterObject, function(value, key){
                       oneFilter.push("\""+key+"\": \""+value+"\"");
                   });
                   filterStrings.push("{"+oneFilter.join(",\n")+"}");
               } );
               return "[\n" + filterStrings.join(",") + "\n]";
            };

            var domSelector = $(dataSetSel);
            var dataSetName = domSelector.val();
            var jsonDescr = "{\"dataset\":\""+dataSetName+"\"," +
                              "\"requestedData\":"+collectingFilterNames()+"," +
                              "\"filters\":"+collectingFilterValues()+"}";

            mpgSoftware.burdenTestShared.retrieveSampleInformation  ( jsonDescr, callback  );
        }

        var immediateFilterAndRun = function (){
            var filteredSamples = generateFilterSamples();
            var filteredSamplesAsStrings = _.map(filteredSamples,function(d){
               return('"'+d+'"');
            });
            runBurdenTest(filteredSamplesAsStrings);
        };





        var filterAndRun = function (data){
            var filters = extractFilters();
            var relevantFilters = _.remove(filters,function(v){return (v.parm.length>0)})
            var groupedBySampleId =  _.groupBy(data,
                                               function(inv){
                                                    return _.find(_.find(inv,
                                                                  function(o,i){
                                                                       return _.find(o,function(v,k){
                                                                            return k==="ID"
                                                                       })
                                                                  })["ID"],
                                                                  function(key,val){
                                                                      return val;
                                                                  })
                                               });
            var samplesWeWant = [];
            _.forEach(groupedBySampleId,function(sampleVals,sampleId){
                 var rejectSample = false;
                 _.forEach(sampleVals,function(propObject){
                     _.forEach(propObject,function(propVal){
                         _.forEach(propVal,function(dsObject,propName){
                            var filter = _.find(relevantFilters,function(filt){return (filt.name===propName)});
                            if (filter){
                                var propertyValue;
                                 _.forEach(dsObject,function(propVal,dsName){
                                    propertyValue = propVal;
                                })
                                var numericalFilterValue = parseFloat(filter.parm);
                                if (filter.cmp==="1"){
                                   if (propertyValue>=numericalFilterValue){
                                      rejectSample = true;
                                   }
                                } else if (filter.cmp==="2"){
                                   if (propertyValue<=numericalFilterValue){
                                      rejectSample = true;
                                   }
                                }
                            }

                         })
                     })
                 })
                 if (!rejectSample){
                    samplesWeWant.push('"'+sampleId+'"');
                 }
            });
            //var displayableData = convertToBoxWhiskerPreferredObject(sampleInfo);
            runBurdenTest(samplesWeWant);
        };



         var displayTestResultsSection = function (display)  {
            burdenTestResult = $('.burden-test-result');
            if (display){
                burdenTestResult.show () ;
            } else {
                burdenTestResult.hide () ;
            }
         }

        /**
         *  run the burden test, then display the results.  We will need to start by extracting
         *  the data fields we need from the DOM.
         */
        var runBurdenTest = function (samplesWeWant){




            var collectingCovariateValues = function (){
               var pcCovariates = [];
               var selectedCovariates = $('.covariate:checked');
               _.forEach(selectedCovariates, function(d){
                  var covariateDom = $(d);
                  var covId = covariateDom.attr('id');
                  var covariateName = covId.substr("covariate_".length);
                  if (covariateName.indexOf("{{")===-1){
                     pcCovariates.push('"'+covariateName+'"');
                  }
               });
               return "{\"covariates\":[\n" + pcCovariates.join(",") + "\n]}";
            }

            var fillInResultsSection = function (pValue, oddsRatio, stdError, isDichotomousTrait){
                // populate the data
                $('.pValue').text(pValue);
                $('.orValue').text(oddsRatio);
                $('.ciValue').text(stdError);

                // show the results
//                if (isDichotomousTrait) {

                    displayTestResultsSection(true);

                    $('#burden-test-some-results-large').hide();
                    $('#burden-test-some-results').show();
                    $('.burden-test-result').show();

//                } else {
//                    $('#burden-test-some-results').hide();
//                    $('#burden-test-some-results-large').show();
//                }
            };

            $('#rSpinner').show();
            var traitFilterSelectedOption = $('#phenotypeFilter').val();

            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller: 'variantInfo', action: 'burdenTestAjax')}",
                data: {variantName: '<%=variantIdentifier%>',
                       covariates: collectingCovariateValues(),
                       samples: "{\"samples\":[\n" + samplesWeWant.join(",") + "\n]}",
                       traitFilterSelectedOption: traitFilterSelectedOption
                },
                async: true,
                success: function (data) {
                    if ((typeof data !== 'undefined') && (data)){
                    //first check for error conditions
                        if (!data){
                            console.log('null return data from burdenTestAjax');

                        } else if (data.is_error) {
                            console.log('burdenTestAjax returned is_error =' + data.is_error +'.');

                        } else if ((typeof data.stats.pValue === 'undefined') ||
                                 (typeof data.stats.beta === 'undefined') ||
                                 (typeof data.stats.stdError === 'undefined')){
                             console.log('burdenTestAjax returned undefined for P value, standard error or beta.');

                        } else {
                            var isDichotomousTrait = false;
                            if ((typeof data.stats.numCases === 'undefined') ||
                                (typeof data.stats.numControls === 'undefined') ||
                                (typeof data.stats.numCaseCarriers === 'undefined') ||
                                (typeof data.stats.numControlCarriers === 'undefined')) {
                               isDichotomousTrait = false;
                            } else {
                               isDichotomousTrait = true;
                            }

                            //var oddsRatio = data.stats.oddsRatio; // must remove oddsRatio ref due to API change
                            var oddsRatio = UTILS.realNumberFormatter(Math.exp(data.stats.beta));
                            var beta = UTILS.realNumberFormatter(data.stats.beta);
                            var stdError = UTILS.realNumberFormatter(data.stats.stdError);
                            var pValue = UTILS.realNumberFormatter(data.stats.pValue);
                            var numberVariants = data.stats.numInputVariants;

                            var ciDisplay = '';
                            if (!((typeof data.stats.ciLower === 'undefined') ||
                                (typeof data.stats.ciUpper === 'undefined') ||
                                (typeof data.stats.ciLevel === 'undefined'))) {
                               var ciUpper = data.stats.ciUpper;
                               var ciLower = data.stats.ciLower;
                               var ciLevel = data.stats.ciLevel;

                               if (isDichotomousTrait) {
                                    ciLower = UTILS.realNumberFormatter(Math.exp(data.stats.ciLower));
                                    ciUpper = UTILS.realNumberFormatter(Math.exp(data.stats.ciUpper));
                               } else {
                                    ciLower = UTILS.realNumberFormatter(data.stats.ciLower);
                                    ciUpper = UTILS.realNumberFormatter(data.stats.ciUpper);
                               }
                               ciDisplay = (ciLevel * 100) + '% CI: (' + ciLower + ' to ' + ciUpper + ')';
                            }

                            fillInResultsSection('p-Value = '+ pValue,
                                (isDichotomousTrait ? 'odds ratio = ' + oddsRatio : 'beta = ' + beta),
                                ciDisplay, isDichotomousTrait);

                            // now see if we fill the hypothesis section
                            if (!isDichotomousTrait) {
                             console.log('burdenTestAjax returned undefined for case/control number, so not displaying hypothesis graphic.');

                            } else {
                               // fill in the hypothesis graphic
                               var caseCount = data.stats.numCases;
                               var controlCount = data.stats.numControls;
                               var caseCarrierCount = data.stats.numCaseCarriers;
                               var controlCarrierCount = data.stats.numControlCarriers;

                               // first clear any existing bar chart
                               if ((typeof mpgSoftware.burdenInfo.retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter() !== 'undefined') &&
                                    (typeof mpgSoftware.burdenInfo.retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter().launch !== 'undefined')) {
                                    mpgSoftware.burdenInfo.retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter().removeBarchart();
                               }

                               // populate the bar legend
                               $("#traitSpan").text('T2D');
                               $("#variantNumberSpan").text(numberVariants);

                               /// fill up the bar chart
                               mpgSoftware.burdenInfo.fillBurdenBiologicalHypothesisTesting(caseCarrierCount, caseCount, controlCarrierCount, controlCount, 'T2D');

                               // launch
                               mpgSoftware.burdenInfo.retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter().launch();
                            }

                       }
                    }
                    $('#rSpinner').hide();
                },
                error: function (jqXHR, exception) {
                    $('#rSpinner').hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        }; // runBurdenTest

        var sampleInfo = {};
        var convertToBoxWhiskerPreferredJsonString = function (inData) {
           var elementAccumulator = [];
           for (var phenotype in inData){
                if(!inData.hasOwnProperty(phenotype)) continue;
                if((phenotype === 'ANCESTRY') ||
                   (phenotype === 'ID')) continue;
                var arrayOfValues = [];
                inData [phenotype].map(function(d){
                   arrayOfValues.push('{"d":"m","v":'+d+'}');
                });
                var element = '{"name":"'+ phenotype+'",'+
                '"data": ['+arrayOfValues.join(',')+']}\n';
                elementAccumulator.push (element) ;
           }
           return '['+elementAccumulator.join(',')+']';
        };
        var convertToBoxWhiskerPreferredObject = function (inData) {
           var elementAccumulator = [];
           for (var phenotype in inData){
                if(!inData.hasOwnProperty(phenotype)) continue;
                if((phenotype === 'ANCESTRY') ||
                   (phenotype === 'ID')) continue;
                var arrayOfValues = [];
                inData [phenotype].map(function(d){
                   arrayOfValues.push({"d":"m","v":d});
                });
                elementAccumulator.push ({"name": phenotype,
                                           "data": arrayOfValues}) ;
           }
           return elementAccumulator;
        };
        var buildBoxWhiskerPlot = function (inData,selector) {
            var margin = {top: 50, right: 50, bottom: 20, left: 50},
            width = 700 - margin.left - margin.right,
            height = 350 - margin.top - margin.bottom;

            // initial value of the interquartile multiplier. Note that this value
            //  is adjustable via a UI slider
            var defaultInterquartileMultiplier = 1.5,
                    defaultHistogramBarSize = 1;

            /***
             *   Initial data-independent initializations oof the box whisker plot.  Note that this initialization has to take place
             *   so that we have something to which we can connect the slider
             */
            var chart = baget.boxWhiskerPlot()
                    .width(width)
                    .height(height);

            chart.selectionIdentifier(selector) // the Dom element from which we will hang the plot
                    .initData(inData,width,height+50)            // the information that goes into the plot
                    .whiskers(chart.iqr(defaultInterquartileMultiplier))  // adjust the whiskers so that they go to the right initial  position
                    .histogramBarMultiplier(defaultHistogramBarSize);        // let's start with no histogram visible

            //  Now we are ready to actually launch the box whisker plot
            d3.select(selector)
                    .selectAll('svg')
                    .call(chart.boxWhisker);

        };



        var buildCategoricalPlot = function (inData,selector) {

        //UTILS.distributionMapper
           // var binInfo = UTILS.distributionMapper(inData[0].data,20,function(d){return d.v})
           data=[];
           _.forEach(inData,function(arrObj){
              data.push({ category: arrObj.name,
                    value: arrObj.samples,
                    color: '#0082ca'});
           });
//            var data = [
//                { category: 'male',
//                    value: 230,
//                    color: '#0000b4'},
//                { category: 'female',
//                    value: 245,
//                    color: '#0082ca'}
//            ],
            roomForLabels = 120,
            maximumPossibleValue = 1,
            labelSpacer = 10;

    var margin = {top: 50, right: 50, bottom: 20, left: 30},
            width = 700 - margin.left - margin.right,
            height = 350 - margin.top - margin.bottom;



        var barChart = baget.mBar()
                .width(width)
                .height(height)
                .margin(margin)
                .showGridLines (false)
                .blackTextAfterBar (true)
                .labelSpacer (labelSpacer)
                .dataHanger(selector,data);

        d3.select(selector).call(barChart.render);

     };






       function extractAllFilterNames(){
            var allFilters =  $('.considerFilter')
            var requestedFilters = _.map( allFilters, function(filter){
                var  filterId = $(filter).attr('id');
                var nonConstantPartOfFilterName = filterId.substring(7);
                if (nonConstantPartOfFilterName.indexOf("{{")==-1){
                   return  {"name":nonConstantPartOfFilterName};
                }
            } );
            return requestedFilters;
        };





        function extractFilters(){
            var allFilters =  $('.realValuedFilter');
            var requestedFilters = [];
            for  ( var i = 0 ; i < allFilters.length ; i++ )   {
                var filterRowDom = $(allFilters[i]);
                var  filterId = $(allFilters[i]).attr('id');
                if (filterId.indexOf("filter_")==0){
                    var  filterName = filterId.substr(7);
                    var filterCheck = filterRowDom.find('.utilize');
                    var filterParm = filterRowDom.find('.filterParm');
                    var filterCmp = filterRowDom.find('.filterCmp');
                    if (filterCheck.is(':checked')&&(filterName.indexOf("{{")==-1)&&(filterParm.val().length>0)){
                        var  dataSetMap = {"name":filterName,
                                           "parm":filterParm.val(),
                                           "cmp":filterCmp.val(),
                                           "cat":0};
                        requestedFilters.push(dataSetMap);
                    }
                }

            }
            allFilters =  $('.categoricalFilter');
            for  ( var i = 0 ; i < allFilters.length ; i++ )   {
                var filterRowDom = $(allFilters[i]);
                var  filterId = $(allFilters[i]).attr('id');
                if (filterId.indexOf("filter_")==0){
                    var  filterName = filterId.substr(7);
                    var filterCheck = filterRowDom.find('.utilize');
                    var multiParm = filterRowDom.find('.multiSelect');
                    if (filterCheck.is(':checked')&&(filterName.indexOf("{{")==-1)){
                        var allSelected = [];
                        _.forEach($('#multi'+filterName+' option:selected'),function(d){
                            allSelected.push($(d).val());
                        });
                        var  dataSetMap = {"name":filterName,
                                "parm":allSelected,
                                "cat":1};
                          requestedFilters.push(dataSetMap);
                    }
                }
            }
            return requestedFilters;
        };


       var groupValuesByPhenotype = function(data){
           var sampleInfo = {};
           if ((typeof data !== 'undefined') && (data)){
               //first check for error conditions
                if (data.length<1){
                    console.log('no samples to work with');
               }else {
                    for ( var i = 0 ; i < data.length ; i++ )  {
                       var sampleFields =  data[i] ;
                       for ( var j = 0 ; j < sampleFields.length ; j++ ) {
                           var fieldObject =  sampleFields[j];
                           for (var dataSetName in fieldObject) {
                               if(!fieldObject.hasOwnProperty(dataSetName)) continue;
                               var dataSetObject =  fieldObject[dataSetName];
                               for (var propertyName in dataSetObject) {
                                   if(!dataSetObject.hasOwnProperty(propertyName)) continue;
                                   var dataSetValue =  dataSetObject[propertyName];
                                   if (dataSetName in sampleInfo)  {
                                       sampleInfo [dataSetName].push(dataSetValue);
                                   } else {
                                       sampleInfo [dataSetName]   = [dataSetValue] ;
                                   }
                               }
                           }
                       }
                    }
                }
            }
            return sampleInfo;
       }



        var fillDistributionPlotsAndDropdowns = function (sampleData,phenotype){
             // make dist plots
            utilizeSampleInfoForDistributionPlots(sampleData,phenotype);
            var optionsPerFilter = generateOptionsPerFilter(sampleData) ;
            var sampleMetadata = getStoredSampleMetadata();
            _.forEach(sampleMetadata.filters,function(d,i){
                if (d.type !== 'FLOAT') {
                    if (optionsPerFilter[d.name]!==undefined){
                       var dropdownId = '#multi'+d.name;
                       _.forEach(optionsPerFilter[d.name],function(filterVal){
                           $(dropdownId).append(new Option(filterVal.name,filterVal.name));
                       });
                       $(dropdownId).multiselect({includeSelectAllOption: true,
                                                   allSelectedText: 'All Selected',
                                                   multiselectclose: function(event, ui){
                                                            console.log('event');
                                                        },
                                                   open: function(event, ui){
                                                            console.log('event2');
                                                        }
                                                   });
                       $(dropdownId).multiselect('selectAll', false);
                       $(dropdownId).multiselect('updateButtonText');

                    }
                 }
            });
        };






        var utilizeSampleInfoForDistributionPlots = function (variantData,phenotype){
            var sampleInfo = groupValuesByPhenotype(variantData);
            var optionsPerFilter = generateOptionsPerFilter(variantData) ;
            var displayableData = convertToBoxWhiskerPreferredObject(sampleInfo);
            var plotHoldingStructure = $('#boxWhiskerPlot');
            plotHoldingStructure.empty();
            var sampleMetadata = getStoredSampleMetadata();
            $('.sampleNumberReporter .numberOfSamples').text(variantData.length);
            for ( var i = 0 ; i < displayableData.length ; i++ ){
                var singleElement = displayableData[i];
                var elementName = singleElement.name;
                var divElementName = 'bwp_'+elementName;
                plotHoldingStructure.append('<div id="'+divElementName+'"></div>');
                if (elementName === phenotype){
                   $('.sampleNumberReporter .numberOfPhenotypeSpecificSamples').text(singleElement.data.length);
                   $('.sampleNumberReporter .phenotypeSpecifier').text(phenotype);
                }
                $('#'+divElementName).hide();
                if (sampleMetadata.filters){
                  var filter = _.find(sampleMetadata.filters, ['name',elementName]);
                  if (filter){
                     if (filter.type === 'INTEGER'){
                        buildCategoricalPlot(optionsPerFilter[elementName],'#'+divElementName);
                     } else if (filter.type === 'STRING'){
                        buildCategoricalPlot(optionsPerFilter[elementName],'#'+divElementName);
                     } if (filter.type === 'FLOAT'){
                        buildBoxWhiskerPlot([singleElement],'#'+divElementName);
                     }
                  }
                }
            }
        };




        var retrieveSampleInformation = function (data, callback,passThru){
            var returnedData = getStoredSampleData();
            if (typeof returnedData === 'undefined') {
                $.ajax({
                    cache: false,
                    type: "post",
                    url: "${createLink(controller: 'variantInfo', action: 'retrieveSampleListAjax')}",
                    data: {'data':data},
                    async: true,
                    success: function (returnedData) {
                        storeSampleData(returnedData);
                        callback(returnedData.metaData.variants,passThru);
                    },
                    error: function (jqXHR, exception) {
                        core.errorReporter(jqXHR, exception);
                    }
                });
            } else {
               callback(returnedData.metaData.variants,passThru);
            }
        };




        var determineEachFiltersType = function (){
             var returnValue = {};
            var sampleMetadata = getStoredSampleMetadata();
            for ( var i = 0 ; i < sampleMetadata.filters.length ; i++ ){
                var singleElement = sampleMetadata.filters[i];
                var elementName = singleElement.name;
                if (sampleMetadata.filters){
                  var filter = _.find(sampleMetadata.filters, ['name',elementName]);
                  if (filter){
                     returnValue[singleElement.name] = singleElement.type;
                  }
                }
            }
            return returnValue;
        }


        /***
        *   generate a map with an array of values for each filter name.  The values represent every possible value
        *   the filter might hold.
        *
        * @param variants
        * @returns {{}}
        */
         var generateOptionsPerFilter = function (variants) {
             var optionsPerFilter = {};
             var filterTypeMap = determineEachFiltersType();
               _.forEach(filterTypeMap,function(filtType,filtName){
                  if ((filtType === 'STRING')||(filtType === 'INTEGER')){
                     if (!(filtName in optionsPerFilter)){
                        optionsPerFilter[filtName] = [];
                     }
                    _.forEach(variants,function(filterHolder){
                        _.forEach(filterHolder,function(val,key){
                           _.forEach(val,function(filterObj,filterKey){
                               if (filtName === filterKey){
                                  _.forEach(val,function(valueObject){
                                      _.forEach(valueObject,function(valueOfFilter,dsOfFilter){
                                         var refToLevel = _.find(optionsPerFilter[filterKey],function(d){return d.name==valueOfFilter});
                                         if (refToLevel===undefined){
                                             optionsPerFilter[filterKey].push({name:valueOfFilter,samples:1});
                                         } else {
                                             refToLevel.samples++;
                                         }
                                      });

                                  })
                               }
                           });
                        })
                    })
                  }
               });
            return optionsPerFilter;
         }











        /***
        *   get the sample data and apply real valued filters. Apply categorical filters.  Pass back the filtered list of IDs.
        *
        * @returns {Array}
        */
        var generateFilterSamples = function (){
            var data = getStoredSampleData();
            if (typeof data === 'undefined') return;
            var filters = extractFilters();
            var relevantFilters = _.remove(filters,function(v){return ((v.cat===1)||(v.parm.length>0))});
            var groupedBySampleId =  _.groupBy(data.metaData.variants,
                                               function(inv){
                                                    return _.find(_.find(inv,
                                                                  function(o,i){
                                                                       return _.find(o,function(v,k){
                                                                            return k==="ID"
                                                                       })
                                                                  })["ID"],
                                                                  function(key,val){
                                                                      return val;
                                                                  })
                                               });
            var samplesWeWant = [];
            var samplesValuesWeWant = [];
            _.forEach(groupedBySampleId,function(sampleVals,sampleId){
                 var rejectSample = false;
                 _.forEach(sampleVals,function(propObject){
                     _.forEach(propObject,function(propVal){
                         _.forEach(propVal,function(dsObject,propName){
                            var filter = _.find(relevantFilters,function(filt){return (filt.name===propName)});
                            if (filter){
                                var propertyValue;
                                _.forEach(dsObject,function(propVal,dsName){
                                    propertyValue = propVal;
                               });
                                    var numericalFilterValue = parseFloat(filter.parm);
                                    if (filter.cmp==="1"){
                                       if (propertyValue>=numericalFilterValue){
                                          rejectSample = true;
                                       }
                                    } else if (filter.cmp==="2"){
                                       if (propertyValue<=numericalFilterValue){
                                          rejectSample = true;
                                       }
                                    }
                            }

                         })
                     })
                 })
                 if (!rejectSample){
                    samplesValuesWeWant.push(sampleId);
                 }
            });

            var filteredSampleObjects = {};
            _.map(groupedBySampleId,function(v,k){
                    if (samplesValuesWeWant.indexOf(k)!==-1) {
                        filteredSampleObjects[k]=v;} return false;
                        });

             _.forEach(filteredSampleObjects,function(sampleVals,sampleId){
                 var rejectSample = false;
                 _.forEach(sampleVals,function(propObject){
                     _.forEach(propObject,function(propVal){
                         _.forEach(propVal,function(dsObject,propName){
                            var filter = _.find(relevantFilters,function(filt){return (filt.name===propName)});
                            if (filter){
                                var propertyValue;
                                _.forEach(dsObject,function(propVal,dsName){
                                    propertyValue = propVal;
                               });
                               if ((filter.cat===1)&&(typeof propertyValue !== 'undefined')) { // categorical filter
                                    var catFilterValues = filter.parm;
                                    var matcher = _.find(catFilterValues,function(d){return d===(""+propertyValue)});
                                    if (!matcher){
                                          rejectSample = true;
                                        }
                                }

                            }

                         })
                     });
                     if (!rejectSample){
                        samplesWeWant.push(sampleId);
                     }
                 })
            });
            return samplesWeWant;

        };




        var dynamicallyFilterSamples = function (){
            var data = getStoredSampleData();
            var samplesWeWant = generateFilterSamples();
            var filteredVariants = [];
            _.forEach(data.metaData.variants,
                   function(d){
                          _.find(d,
                              function(el){
                                  if (el["ID"]) {
                                     _.forEach(el["ID"],
                                         function(v,k){
                                           if (samplesWeWant.indexOf(v)>-1){
                                              filteredVariants.push(d);
                                           }
                                         });
                                  }
                              }
                          )
                   }
             );
            return filteredVariants;
        };






        var displaySampleDistribution = function (propertyName, holderSection) {
            var filteredVariants = mpgSoftware.burdenTestShared.dynamicallyFilterSamples();
            var caller = $("#distPlotter_" +propertyName);
            utilizeSampleInfoForDistributionPlots(filteredVariants,propertyName);
            var kids = $(holderSection).children();
            _.forEach(kids, function (d) {
                $(d).hide();
            });
            $('.activeDistPlotter').removeClass('activeDistPlotter');
            $(caller).addClass('activeDistPlotter');
            $('#bwp_' + propertyName).show();
        };

        var filterSamples = function (propertyName, holderSection) {
            var filteredVariants = mpgSoftware.burdenTestShared.dynamicallyFilterSamples();
            utilizeSampleInfoForDistributionPlots(filteredVariants,propertyName);
            var kids = $(holderSection).children();
            _.forEach(kids, function (d) {
                $(d).hide();
            });
            $('.activeDistPlotter').removeClass('activeDistPlotter');
        };




        // public routines are declared below
        return {
            filterSamples : filterSamples,
            displaySampleDistribution:displaySampleDistribution,
            preloadInteractiveAnalysisData:preloadInteractiveAnalysisData,
            retrieveExperimentMetadata:retrieveExperimentMetadata,
            retrieveSampleInformation:retrieveSampleInformation,
            filterAndRun:filterAndRun,
            immediateFilterAndRun:immediateFilterAndRun,
            runBurdenTest:runBurdenTest,
            utilizeSampleInfoForDistributionPlots: utilizeSampleInfoForDistributionPlots,
            retrieveMatchingDataSets:retrieveMatchingDataSets,
            getStoredSampleData:getStoredSampleData,
            retrieveSampleMetadata:retrieveSampleMetadata,
            refreshSampleData:refreshSampleData,
            retrieveSampleFilterMetadata:retrieveSampleFilterMetadata,
            getStoredSampleMetadata: getStoredSampleMetadata,
            dynamicallyFilterSamples: dynamicallyFilterSamples,
            displayTestResultsSection: displayTestResultsSection
        }

    }());

$( document ).ready( function (){
  mpgSoftware.burdenTestShared.retrieveExperimentMetadata( '#datasetFilter' );
  mpgSoftware.burdenTestShared.preloadInteractiveAnalysisData();
} );

</g:javascript>

<div class="accordion-group">
<div class="accordion-heading">
    <a class="accordion-toggle  collapsed" data-toggle="collapse" href="#collapseBurden">
        <h2><strong>Custom analysis tool</strong></h2>
    </a>
</div>

<div id="collapseBurden" class="accordion-body collapse">
<div class="accordion-inner">

<div class="container">
<h4>The custom analysis tool allows you to compute custom association statistics for this
variant by specifying the phenotype to test for association, a subset of samples to analyze based on specific phenotypic criteria, and a set of covariates to control for in the analysis.</h4>


<div class="row burden-test-wrapper-options">

%{--<r:img class="caatSpinner" uri="/images/InternetSlowdown_Day.gif" alt="Loading CAAT data"/>--}%
<r:img class="caatSpinner" uri="/images/loadingCaat.gif" alt="Loading CAAT data"/>


<div class="user-interaction">

<div class="panel-group" id="accordion_iat" style="margin-bottom: 10px">

<div class="panel panel-default">%{--should hold the Choose data set panel--}%

    <div class="panel-heading">
        <h4 class="panel-title">
            <a data-toggle="collapse" data-parent="#accordion_iat" href="#chooseSamples">Step 1: Select a phenotype to test for association</a>
        </h4>
    </div>

    <div id="chooseSamples" class="panel-collapse collapse in">
        <div class="panel-body secBody">

                    <div class="row secHeader" style="display:none">
                        <div class="col-sm-12 col-xs-12 text-left"><label>Dataset</label></div>
                    </div>

                    <div class="row"  style="display:none">
                        <div class="col-sm-12 col-xs-12 text-left">
                            <select id="datasetFilter" class="traitFilter form-control text-left"
                                    onchange="mpgSoftware.burdenTestShared.retrieveSampleMetadata(this, '#phenotypeFilter');"
                                    onclick="mpgSoftware.burdenTestShared.retrieveSampleMetadata(this, '#phenotypeFilter');">
                            </select>
                        </div>

                    </div>

                    <div class="row secHeader" style="padding: 0 0 5px 0">
                        <div class="col-sm-12 col-xs-12 text-left"><label>Phenotype</label></div>
                    </div>

                    <div class="row">
                        <div class="col-sm-12 col-xs-12 text-left">
                            <select id="phenotypeFilter" class="traitFilter form-control text-left"
                                    onchange="mpgSoftware.burdenTestShared.retrieveSampleFilterMetadata($('#datasetFilter'), '#phenotypeFilter');">
                            </select>
                        </div>
                    </div>

        </div>
    </div>

</div>%{--end accordion panel for id=chooseSamples--}%


<div class="panel panel-default">%{--should hold the Choose data set panel--}%

    <div class="panel-heading">
        <h4 class="panel-title">
            <a data-toggle="collapse" data-parent="#accordion_iat" href="#filterSamples">Step 2: Select a subset of samples based on phenotypic criteria</a>
        </h4>
    </div>

    <div id="filterSamples" class="panel-collapse collapse">
        <div class="panel-body  secBody">

            <div class="row">
                <div class="col-sm-12 col-xs-12">
                    <p>
                        Each of the boxes below enables you to define a criterion for inclusion of samples in your analysis; each criterion is specified as a filter based on a single phenotype.
                        The final subset of samples used will be those that match all of the specified criteria; to omit a criterion either leave the text box blank or unselect the checkbox on the left.
                    </p>
                    <p>
                        To guide selection of each criterion, you can click on the arrow to the right of the text box to view the distribution of phenotypic values for the samples currently included
                        in the analysis. The number of samples included, as well as the distributions, will update whenever you modify the value in the text box.
                    </p>
                </div>
            </div>

            <hr width="25%"/>

            <div class="row">
                <div class="col-sm-6 col-xs-12 vcenter" style="margin-top:0">
                    <div class="row secHeader" style="padding: 20px 0 0 0">
                        <div class="col-sm-6 col-xs-12 text-left"></div>

                        <div class="col-sm-6 col-xs-12 text-right"><label
                                style="font-style: italic; font-size: 14px">Mouse-over arrows<br/> for distribution</label>
                        </div>
                    </div>

                    <div class="row" id="sampleRow" style="display:none; padding: 10px 0 0 0">
                        <div class="col-sm-12 col-xs-12 text-left">
                            <div class="row sampleFilterHeader" style="text-decoration: underline">
                                <div class="col-sm-1" style="padding-left: 4px">
                                    Use
                                </div>

                                <div class="col-sm-3">
                                    Filter
                                </div>

                                <div class="col-sm-3" style="padding-left: 4px">
                                    Cmp
                                </div>

                                <div class="col-sm-4">
                                    Parameter
                                </div>
                            </div>

                            <div style="direction: rtl; height: 300px; padding: 4px 0 0 10px; overflow-y: scroll;">
                                <div style="direction: ltr">
                                    <div id="filters">
                                        <div class="row">

                                            <div id="filterHolder"></div>

                                        </div>
                                    </div>
                                </div>
                            </div>


                            <div id="filterFloatTemplate" style="display: none;">
                                <div class="row realValuedFilter considerFilter" id="filter_{{name}}">
                                    <div class="col-sm-1">
                                        <input class="utilize" id="use{{name}}" type="checkbox" name="use{{name}}"
                                               value="{{name}}" checked/></td>
                                    </div>

                                    <div class="col-sm-5">
                                        <span>{{trans}}</span>
                                    </div>

                                    <div class="col-sm-2">
                                        <select id="cmp{{name}}" class="form-control filterCmp"
                                                data-selectfor="{{name}}Comparator">
                                            <option value="1">&lt;</option>
                                            <option value="2">&gt;</option>
                                            <option value="3">=</option>
                                        </select>
                                    </div>

                                    <div class="col-sm-3">
                                        <input id="inp{{name}}" type="text" class="filterParm form-control"
                                               data-type="propertiesInput"
                                               data-prop="{{name}}Value" data-translatedname="{{name}}"
                                               onfocusin="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '#boxWhiskerPlot')"
                                               onkeyup="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '#boxWhiskerPlot')">

                                    </div>

                                    <div class="col-sm-1">
                                        <span onclick="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '#boxWhiskerPlot')"
                                              class="glyphicon glyphicon-arrow-right pull-right distPlotter" id="distPlotter_{{name}}"></span>
                                    </div>

                                </div>
                            </div>


                            <div id="filterCategoricalTemplate" style="display: none;">
                                <div class="row categoricalFilter considerFilter" id="filter_{{name}}">
                                    <div class="col-sm-1">
                                        <input class="utilize" id="use{{name}}" type="checkbox" name="use{{name}}"
                                               value="{{name}}" checked/></td>
                                    </div>

                                    <div class="col-sm-5">
                                        <span>{{trans}}</span>
                                    </div>

                                    <div class="col-sm-2" style="text-align: center">
                                        =
                                    </div>

                                    <div class="col-sm-3">
                                        <select id="multi{{name}}" class="form-control multiSelect"
                                                data-selectfor="{{name}}FilterOpts" multiple="multiple"
                                                onfocusin="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '#boxWhiskerPlot')">
                                        </select>
                                        %{--<g:javascript>--}%
                                            %{--$("#multi{{name}}").bind("multiselectclose", function(event, ui){--}%
                                                %{--mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '#boxWhiskerPlot')--}%
                                            %{--});--}%
                                        %{--</g:javascript>--}%

                                    </div>

                                    <div class="col-sm-1">
                                        <span onclick="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '#boxWhiskerPlot')"
                                              class="glyphicon glyphicon-arrow-right pull-right"  id="distPlotter_{{name}}"></span>
                                    </div>

                                </div>

                            </div>


                            <div id="filterStringTemplate"
                                 style="display: none;"><p><span>str name={{name}},type={{type}}</span></p></div>
                        </div>
                    </div>

                </div>

                <div class="col-sm-6 col-xs-12 vcenter" style="padding-left: 0; margin-top: 0">
                    <div class="sampleNumberReporter text-center">
                        <div>Number of samples included in analysis:<span class="numberOfSamples"></span></div>
                        <div style="display:none">number of samples for <span class="phenotypeSpecifier"></span>: <span class="numberOfPhenotypeSpecificSamples"></span></div>
                    </div>

                    <div id="boxWhiskerPlot">
                    </div>
                </div>

            </div>
        </div>
    </div>

</div>%{--end accordion panel for id=filterSamples--}%


<div class="panel panel-default">%{--should hold the initiate analysis set panel--}%

    <div class="panel-heading">
        <h4 class="panel-title">
            <a data-toggle="collapse" data-parent="#accordion_iat" href="#initiateAnalysis">Step 3: Control for covariates</a>
        </h4>
    </div>


    <div id="initiateAnalysis" class="panel-collapse collapse">
        <div class="panel-body secBody">
            <div class="row">
                <div class="col-sm-9 col-xs-12 vcenter">
                    <p>Select the phenotypes to be used as covariates in your association analysis. The recommended default covariates are pre-selected</p>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-9 col-xs-12 vcenter">
                    <div id="covariates"
                         style="border: 1px solid #ccc; height: 200px; padding: 4px 0 0 10px;overflow-y: scroll;">
                        <div class="row">
                            <div class="col-md-10 col-sm-10 col-xs-12 vcenter" style="margin-top:0">

                                <div id="covariateHolder">

                                </div>

                                <div id="covariateTemplate" style="display: none;">
                                    <div class="row">
                                        <div class="checkbox" style="margin:0">
                                            <label>
                                                <input id="covariate_{{name}}" class="covariate" type="checkbox" name="covariate"
                                                       value="{{name}}"/>
                                                {{trans}}
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <div id="covariateTemplateChecked" style="display: none;">
                                    <div class="row">
                                        <div class="checkbox" style="margin:0">
                                            <label>
                                                <input id="covariate_{{name}}" class="covariate" type="checkbox" name="covariate"
                                                       value="{{name}}" checked/>
                                                {{trans}}
                                            </label>
                                        </div>
                                    </div>
                                </div>


                            </div>

                         </div>
                    </div>
                </div>
                <div class="col-sm-3 col-xs-12">
                </div>
            </div>

        </div>
    </div>

</div>%{--end id=initiateAnalysis panel--}%




</div>%{--end accordion --}%
</div>


<div id="burden-test-some-results" class="row">
    <div class="col-sm-8 col-xs-12">
        <div class="row burden-test-specific-results burden-test-result">

            <div class="col-md-8 col-sm-6">
                <div id="variantFrequencyDiv">
                    <div class="vertical-center">
                        <p class="standardFont">Results of your analysis:
                        </p>
                    </div>

                    %{--<div class="barchartFormatter">--}%
                        %{--<div id="chart">--}%

                        %{--</div>--}%
                    %{--</div>--}%
                </div>
            </div>

            <div class="col-md-4 col-sm-3">
                <div>
                    <div id="pValue" class="pValue"></div>

                    <div id="orValue" class="orValue"></div>

                    <div id="ciValue" class="ciValue"></div>
                </div>
            </div>
        </div>

        <div id="burden-test-some-results-large" class="row burden-test-result-large">
            <div class="col-md-4 col-sm-3">
            </div>

            <div class="col-md-4 col-sm-6">
                <div class="vertical-center">
                    <div id="pValue2" class="pValue"></div>

                    <div id="orValue2" class="orValue"></div>

                    <div id="ciValue2" class="ciValue"></div>
                </div>
            </div>

            <div class="col-md-4 col-sm-3">
            </div>
        </div>
    </div>
    <div class="col-sm-4 col-xs-12 vcenter burden-test-btn-wrapper ">
        <button id="singlebutton" name="singlebutton" style="height: 80px"
                class="btn btn-primary btn-lg burden-test-btn"

                onclick="mpgSoftware.burdenTestShared.immediateFilterAndRun()">Run</button>
    </div>

</div>
</div>

</div>
</div>
</div>








