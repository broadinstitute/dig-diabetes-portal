<style>
rect.histogramHolder {
    fill: #6699cc;
}
rect.box {
    fill: #ccaaaa;
}
div.burden-test-wrapper-options {
    background-color: #eee;
    border: solid 1px #ddd;
    font-size: 16px;
    padding-top: 15px;
    padding-bottom: 15px;
}
div.burden-test-wrapper-options .row {
    margin: 0 0 1px 0;
}
div.burden-test-btn-wrapper {
    padding-top: 8px;
}

button.burden-test-btn {
    width: 100%;
}

div.burden-test-result {
    font-size: 18px;
    padding-top: 30px;
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
#person div.row div {
    padding: 0;
    line-height: 20px;
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
                            loading.hide();
                        },
                        error: function (jqXHR, exception) {
                            loading.hide();
                            core.errorReporter(jqXHR, exception);
                        }
                });
        };


        var retrieveSampleFilterMetadata = function (dropdownSel, dropDownSelector) {
            var loading = $('#spinner').show();

            var domSelector = $(dropdownSel);
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'VariantInfo', action:'sampleMetadataAjax')}",
                        data: {dataset:domSelector.val()},
                        async: true,
                        success: function (data) {
                            var phenotypeDropdown = $(dropDownSelector);
                            if ( ( data !==  null ) &&
                                    ( typeof data !== 'undefined') &&
                                    ( typeof data.filters !== 'undefined' ) &&
                                    (  data.filters !==  null ) ) {
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
                                   $("#person").append(output);
                                   refreshSampleData('#datasetFilter',mpgSoftware.burdenTestShared.utilizeSampleInfoForDistributionPlots);
                            }
                            loading.hide();
                        },
                        error: function (jqXHR, exception) {
                            loading.hide();
                            core.errorReporter(jqXHR, exception);
                        }
                });
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


        var filterAndRun = function (data){
            var filters = extractFilters();
            var relevantFilters = _.remove(filters,function(v){return (v.parm.length>0)})
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
            var displayableData = convertToBoxWhiskerPreferredObject(sampleInfo);
            runBurdenTest(samplesWeWant);
        };


        /**
         *  run the burden test, then display the results.  We will need to start by extracting
         *  the data fields we need from the DOM.
         */
        var runBurdenTest = function (samplesWeWant){




            var collectingCovariateValues = function (){
               var pcCovariates = [];
               for ( var i = 0 ; i < 10 ; i++ ) {
                  var pcId = 'PC'+(i+1);
                  var pcElement = $('#covariate_'+pcId);
                  if ((pcElement).is(':checked')){
                    pcCovariates.push(""+(i+1))
                  }
               }
               return "{\"covariates\":[\n" + pcCovariates.join(",") + "\n]}";
            }

            var fillInResultsSection = function (pValue, oddsRatio, stdError, isDichotomousTrait){
                // populate the data
                $('.pValue').text(pValue);
                $('.orValue').text(oddsRatio);
                $('.ciValue').text(stdError);

                // show the results
                if (isDichotomousTrait) {
                    $('#burden-test-some-results-large').hide();
                    $('#burden-test-some-results').show();
                } else {
                    $('#burden-test-some-results').hide();
                    $('#burden-test-some-results-large').show();
                }
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
            width = 500 - margin.left - margin.right,
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




       function extractAllFilterNames(){
            var allFilters =  $('.considerFilter')
            var requestedFilters = _.map( allFilters, function(filter){
                var  filterId = $(filter).attr('id');
                var partsOfFilterName = filterId.split("_");
                if (partsOfFilterName[1].indexOf("{{")==-1){
                   return  {"name":partsOfFilterName[1]};
                }
            } );
            return requestedFilters;
        };





        function extractFilters(){
            var allFilters =  $('.considerFilter')
            var requestedFilters = [];
            for  ( var i = 0 ; i < allFilters.length ; i++ )   {
                var filterRowDom = $(allFilters[i]);
                var  filterId = $(allFilters[i]).attr('id');
                var partsOfFilterName = filterId.split("_");
                var  filterName = partsOfFilterName[1];
                var filterCheck = filterRowDom.find('.utilize');
                var filterParm = filterRowDom.find('.filterParm');
                var filterCmp = filterRowDom.find('.filterCmp');
                if (filterCheck.is(':checked')&&(filterName.indexOf("{{")==-1)&&(filterParm.val().length>0)){
                     var  dataSetMap = {"name":filterName,
                        "parm":filterParm.val(),
                        "cmp":filterCmp.val()};
                    requestedFilters.push(dataSetMap);
                }
            }
            return requestedFilters;
        };


       var groupValuesByPhenotype = function(data){
           var sampleInfo = {};
           if ((typeof data !== 'undefined') && (data)){
               //first check for error conditions
                if (!data){
                    console.log('null return data from burdenTestTraitSelectionOptionsAjax');
                } else if (data.is_error) {
                    console.log('burdenTestAjax returned is_error ='+data.is_error +'.');
                }
                else if ((typeof data.metaData === 'undefined') ||
                         (typeof data.metaData.variants === 'undefined') ||
                         (data.metaData.variants.length <= 0)){
                     console.log('burdenTestAjax returned undefined (or length = 0) for options.');
               }else {
                    for ( var i = 0 ; i < data.metaData.variants.length ; i++ )  {
                       var sampleFields =  data.metaData.variants[i] ;
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




        var utilizeSampleInfoForDistributionPlots = function (data){
            var sampleInfo = groupValuesByPhenotype(data);
            var displayableData = convertToBoxWhiskerPreferredObject(sampleInfo);
            var plotHoldingStructure = $('#boxWhiskerPlot');
            plotHoldingStructure.empty();
            for ( var i = 0 ; i < displayableData.length ; i++ ){
                var singleElement = displayableData[i];
                var elementName = singleElement.name;
                var divElementName = 'bwp_'+elementName;
                plotHoldingStructure.append('<div id="'+divElementName+'"></div>');
                $('#'+divElementName).hide();
                buildBoxWhiskerPlot([singleElement],'#'+divElementName);
            }
        };






        var retrieveSampleInformation = function (data, callback){
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller: 'variantInfo', action: 'retrieveSampleListAjax')}",
                data: {'data':data},
                async: true,
                success: function (returnedData) {
                    callback(returnedData);
                },
                error: function (jqXHR, exception) {
                    core.errorReporter(jqXHR, exception);
                }
            });
        };







        // public routines are declared below
        return {
            retrieveExperimentMetadata:retrieveExperimentMetadata,
            retrieveSampleInformation:retrieveSampleInformation,
            filterAndRun:filterAndRun,
            runBurdenTest:runBurdenTest,
            utilizeSampleInfoForDistributionPlots: utilizeSampleInfoForDistributionPlots,
            retrieveMatchingDataSets:retrieveMatchingDataSets,
            retrieveSampleMetadata:retrieveSampleMetadata,
            refreshSampleData:refreshSampleData,
            retrieveSampleFilterMetadata:retrieveSampleFilterMetadata
        }

    }());

$( document ).ready( function (){
  mpgSoftware.burdenTestShared.retrieveExperimentMetadata( '#datasetFilter' );
} );

</g:javascript>

<div class="accordion-group">
<div class="accordion-heading">
    <a class="accordion-toggle  collapsed" data-toggle="collapse" href="#collapseBurden">
        <h2><strong><g:message code="variant.info.burden.test.title"
                               default="Test for association with quantitative traits"/></strong></h2>
    </a>
</div>

<div id="collapseBurden" class="accordion-body collapse">
<div class="accordion-inner">

<div class="container">
<h3>Select a trait to test for association.</h3>

<div class="row burden-test-wrapper-options">

    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist_for_chooseSamples">
        <li role="presentation"  class="active"><a href="#chooseSamples" aria-controls="chooseSamples" role="tab"
                                                  data-toggle="tab">Choose samples</a></li>
        <li role="presentation"><a href="#initiateAnalysis" aria-controls="initiateAnalysis" role="tab"
                                   data-toggle="tab">Initiate analysis</a></li>
    </ul>

    <div class="tab-content" style="border-top: 1px solid #ccc; padding: 4px 0 0 10px">
        <div  role="tabpanel" class="tab-pane active" id="chooseSamples">
            <div class="col-sm-8 col-xs-12 vcenter">
                <div class="row">
                    <div class="col-sm-4 col-xs-12 text-right"><label>Choose a data set:</label></div>

                    <div class="col-sm-8 col-xs-12 text-left">
                        <select id="datasetFilter" class="traitFilter form-control text-left"
                                onchange="mpgSoftware.burdenTestShared.retrieveSampleMetadata( this, '#phenotypeFilter' );"
                                onclick="mpgSoftware.burdenTestShared.retrieveSampleMetadata( this, '#phenotypeFilter' );">
                        </select>
                    </div>

                </div>

                <div class="row">
                    <div class="col-sm-4 col-xs-12 text-right"><label>Choose a phenotype:</label></div>

                    <div class="col-sm-8 col-xs-12 text-left">
                        <select id="phenotypeFilter" class="traitFilter form-control text-left"
                                onchange="mpgSoftware.burdenTestShared.retrieveSampleFilterMetadata( $('#datasetFilter'), '#phenotypeFilter' );">
                        </select>
                    </div>
                </div>


                <div class="row" id="sampleRow" style="display:none; padding: 10px 0 0 0">
                    <div class="col-sm-4 col-xs-12 text-right"><label>Sample filters:</label></div>
                    <div class="col-sm-8 col-xs-12 text-left">
                    <div class="row sampleFilterHeader" style="text-decoration: underline">
                        <div class="col-sm-1"  style="padding-left: 4px">
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
                    <div  style="height: 300px; padding: 4px 0 0 10px; overflow-y: scroll;">



                        <div  id="filters">
                            <div class="row">


                                    <div id="person"></div>

                            </div>
                        </div>
                    </div>
                    <div class="pull-right" style="padding: 10px 0 0 0">
                        <button class="btn btn-xs"
                                onClick="mpgSoftware.burdenTestShared.refreshSampleData  ( '#datasetFilter', mpgSoftware.burdenTestShared.utilizeSampleInfoForDistributionPlots  )">
                            Refresh distributions &gt;&gt;</button>
                    </div>




                    <div id="filterFloatTemplate" style="display: none;">
                        <div class="row considerFilter" id="filter_{{name}}">
                            <div class="col-sm-1">
                                <input class="utilize" id="use{{name}}" type="checkbox" name="use{{name}}" value="{{name}}" checked/></td>
                            </div>
                            <div class="col-sm-3">
                                <span>{{name}}</span>
                            </div>
                            <div class="col-sm-2">
                                <select id="cmp{{name}}" class="form-control filterCmp" data-selectfor="{{name}}Comparator">
                                    <option value="1">&lt;</option>
                                    <option value="2">&gt;</option>
                                    <option value="3">=</option>
                                </select>
                            </div>
                            <div class="col-sm-4">
                                <input  id="inp{{name}}" type="text" class="filterParm form-control" data-type="propertiesInput"
                                       data-prop="{{name}}Value" data-translatedname="{{name}}">

                            </div>
                            <div class="col-sm-1">
                                <span  onmouseover="displaySampleDistribution('{{name}}', '#boxWhiskerPlot')" class="glyphicon glyphicon-arrow-right pull-right"></span>
                            </div>

                        </div>
                    </div>


                    <div id="filterCategoricalTemplate" style="display: none;">
                        <div class="row">
                            <div class="col-sm-1">
                                <input id="use{{name}}" type="checkbox" name="use{{name}}" value="{{name}}" checked/></td>
                            </div>
                            <div class="col-sm-3">
                                <span>{{name}}</span>
                            </div>
                            <div class="col-sm-2" style="text-align: center">
                                =
                            </div>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" data-type="propertiesInput"
                                       data-prop="{{name}}Value" data-translatedname="{{name}}">
                            </div>
                            <div class="col-sm-1">
                                <span  onmouseover="displaySampleDistribution('{{name}}', '#boxWhiskerPlot')" class="glyphicon glyphicon-arrow-right pull-right"></span>
                            </div>

                        </div>


                    </div>


                    <div id="filterStringTemplate" style="display: none;"><p><span>str name={{name}},type={{type}}</span></p></div>
                </div>
            </div>


            </div>

            <div class="col-sm-4 col-xs-12 vcenter" style="padding-left: 0">
                <div id="boxWhiskerPlot">
                </div>
            </div>

        </div>
        <div  role="tabpanel" class="tab-pane" id="initiateAnalysis">

            <!-- Nav tabs -->
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active"><a href="#covariates" aria-controls="covariates" role="tab"
                                                          data-toggle="tab">Covariates</a></li>

                <li role="presentation" ><a href="#stratify" class="disabled" aria-controls="stratify" role="tab"
                                           data-toggle="tab" style="cursor: not-allowed; pointer-events: none;">Stratify</a></li>
            </ul>

            <!-- Tab panes -->
            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="covariates" style="border: 1px solid #ccc; height: 200px; padding: 4px 0 0 10px">
                    <div class="row">
                        <div class="col-md-10 col-sm-10 col-xs-12 vcenter">


                            <div id="covariate-form">
                                <div class="col-sm-4 col-xs-12 text-center">

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC1" type="checkbox" name="covariate" value="PC1"
                                                   checked/>
                                            PC1
                                        </label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC2" type="checkbox" name="covariate" value="PC2"
                                                   checked/>
                                            PC2</label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC3" type="checkbox" name="covariate" value="PC3"
                                                   checked/>
                                            PC3</label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC4" type="checkbox" name="covariate" value="PC4"
                                                   checked/>
                                            PC4</label>
                                    </div>

                                </div>

                                <div class="col-sm-4 col-xs-12 text-center">

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC5" type="checkbox" name="covariate" value="PC5"
                                                   checked/>
                                            PC5
                                        </label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC6" type="checkbox" name="covariate" value="PC6"
                                                   checked/>
                                            PC6</label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC7" type="checkbox" name="covariate" value="PC7"
                                                   checked/>
                                            PC7</label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC8" type="checkbox" name="covariate" value="PC8"
                                                   checked/>
                                            PC8</label>
                                    </div>

                                </div>

                                <div class="col-sm-4 col-xs-12 text-center">

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC9" type="checkbox" name="covariate" value="PC9"
                                                   checked/>
                                            PC9
                                        </label>
                                    </div>

                                    <div class="checkbox">
                                        <label>
                                            <input id="covariate_PC10" type="checkbox" name="covariate" value="PC10"
                                                   checked/>
                                            PC10</label>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <div class="col-md-2 col-sm-2 col-xs-12 burden-test-btn-wrapper vcenter">
                            <button id="singlebutton" name="singlebutton" style="height: 80px"
                                    class="btn btn-primary btn-lg burden-test-btn"
                                    onclick="mpgSoftware.burdenTestShared.refreshSampleData  ( '#datasetFilter', mpgSoftware.burdenTestShared.filterAndRun  )">Run</button>
                        </div>
                    </div>
                </div>

                <script>
                    var displaySampleDistribution = function (propertyName, holderSection) {
                        var kids = $(holderSection).children();
                        _.forEach(kids, function (d) {
                            console.log('d');
                            $(d).hide();
                        });
                        $('#bwp_' + propertyName).show();
                    }
                </script>

                <div role="tabpanel" class="tab-pane" id="stratify" style="border: 1px solid #ccc; height: 200px; padding: 4px 0 0 10px">
                    <h1 style="color: #ccc">Not yet implemented</h1>
                </div>
            </div>
        </div>


    </div>

    <div class="row burden-test-result" style="display:block">
        <div class="col-md-12 col-sm-6">

        </div>

    </div>


    <div id="burden-test-some-results" class="row burden-test-result">
        <div class="col-md-8 col-sm-6">
            <div id="variantFrequencyDiv">
                <div>
                    <p class="standardFont">Of the <span
                            id="traitSpan"></span> cases/controls, the following carry the variant ${variantIdentifier}.
                    </p>
                </div>

                <div class="barchartFormatter">
                    <div id="chart">

                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-2 col-sm-3">
        </div>

        <div class="col-md-2 col-sm-3">
            <div class="vertical-center">
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

</div>
</div>
</div>








