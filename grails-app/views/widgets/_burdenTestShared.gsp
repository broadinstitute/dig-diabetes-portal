<style>
rect.histogramHolder {
    fill: #6699cc;
}
rect.box {
    fill: #fff;
}
.nav-tabs>li>a {
    cursor: pointer;
}
div.corvariateDisplay {
    overflow-x: auto;
    white-space: nowrap;
}
div.corvariateDisplay [class*="col"], /* TWBS v3 */
div.corvariateDisplay [class*="span"] {  /* TWBS v2 */
    display: inline-block;
    float: none; /* Very important */
}
.metana {
    text-align: center;
}
.stratumName{
    font-weight: bold;
}
.strataHolder {
    padding: 5px 10px 10px 5px;
}
.metaAnalysis{
    padding: 5px 10px 10px 5px;
}
.hider {
    display: none;
}
div.covariate_holder {
    margin: 0;
}
ul.strataResults {
    margin-bottom: 0;
    padding: 0;
    list-style-type: none;
}
.caatSpinner{
    position: absolute;
    z-index: 1;
    left: 30%;
    top: 50%;
}
.boxWhiskerPlot {
    margin: 50px 0 0 0;
}
.burden-test-some-results{
    background: #eee;
}
#stratsCovTabs li.active {
    border-radius: 4px 4px 0px 0px;
}
#stratsCovTabs a.covariateCohort {
    margin-bottom: -3px;
    margin-right: 5px;
    border-top: solid 1px black;
    border-left: solid 1px black;
    border-right: solid 1px black;
    border-radius: 4px 4px 0px 0px;
}

#stratsCovTabs a.covariateCohort.ALL {
    margin-bottom: -3px;
    margin-right: 5px;
    border-top: solid 2px black;
    border-left: solid 2px black;
    border-right: solid 2px black;
    border-radius: 4px 4px 0px 0px;
}
#stratsTabs li.active {
    border-radius: 4px 4px 0px 0px;
}
#stratsTabs a.filterCohort {
    margin-bottom: -3px;
    margin-right: 5px;
    border-top: solid 1px black;
    border-left: solid 1px black;
    border-right: solid 1px black;
    border-radius: 4px 4px 0px 0px;
}

#stratsTabs a.filterCohort.ALL {
    margin-bottom: -3px;
    margin-right: 5px;
    border-top: solid 2px black;
    border-left: solid 2px black;
    border-right: solid 2px black;
    border-radius: 4px 4px 0px 0px;
}
.tab-pane.active > div.row {
    background: #fff;
    padding: 20px 2px 20px 5px;
    border: 1px solid #000;
    -webkit-border-radius: 4px;
    -moz-border-radius: 4px;
    border-radius: 4px;
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
div.iatError {
    background-color: #ffffc9;
    -webkit-border-radius: 8px;
    -moz-border-radius: 8px;
    border-radius: 8px;
    padding: 2px 2px 2px 8px;
    border: 1px solid #888888;
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
.filterHolder div.row div {
    padding: 0;
    line-height: 20px;
}
.covariateHolder .row {
    line-height: 15px;
}
 text.box{
        display: none; /* if you don't want text labels on your boxes*/
 }
text.whisker{
      display: none; /*if you don't want text labels on your boxes*/
}
line.center{
      display: none; /*if you don't want text labels on your boxes*/
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
        var storedFilterData;
        var minimumNumberOfSamples = 100;
        var backendFiltering = true;
        var portalTypeWithAncestry = true;
        <g:if test="${g.portalTypeString()?.equals('stroke')}">
        portalTypeWithAncestry = false;
        </g:if>


var storeFilterData = function (data){
     storedFilterData = data;
 };

 var getStoredFilterData  = function (){
     return storedFilterData;
 };


 var storeSampleData = function (data){
     storedSampleData = data;
 };

 /***
 *  Get sample data from our local storage.  This routine presumably disappears in v0.2
 * @returns {*}
 */
 var getStoredSampleData  = function (){
     return storedSampleData;
 };

 var storeSampleMetadata = function (metadata){
     storedSampleMetadata = metadata;
 };


 var getStoredSampleMetadata  = function (){
     return storedSampleMetadata;
 };


 var convertPhenotypeNames  = function (untranslatedPhenotype){
    var convertedName = untranslatedPhenotype;
    if (untranslatedPhenotype === 't2d'){
       convertedName = 'T2D_readable';
    } else if (untranslatedPhenotype === 'Yes'){
       convertedName = 'CASE';
    } else if (untranslatedPhenotype === 'No'){
       convertedName = 'CONTROL';
    }
    return convertedName;
 };



 /***
 * Get back data sets based on phenotype and insert them into a drop-down box
 * @param selPhenotypeSelector
 * @param selDataSetSelector
 */
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
     UTILS.retrieveSampleGroupsbyTechnologyAndPhenotype(['GWAS','ExChip','ExSeq','WGS'],selPhenotypeSelector.value,
     "${createLink(controller: 'VariantSearch', action: 'retrieveTopSGsByTechnologyAndPhenotypeAjax')}",processReturnedDataSets );
        };



        /***
        * Retrieve sample metadata only to get the experiment list and insert it in a drop-down.  Seems wasteful...
        * @param dropDownSelector
        */
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

            if (portalTypeWithAncestry){
                $("#chooseDataSetAndPhenotypeLocation").empty().append(Mustache.render( $('#chooseDataSetAndPhenotypeTemplate')[0].innerHTML,
                                        {strataChooser:[1]}));

            } else {
                $("#chooseDataSetAndPhenotypeLocation").empty().append(Mustache.render( $('#chooseDataSetAndPhenotypeTemplate')[0].innerHTML,
                                            {strataChooser:[]}));
            }



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
                        var t2d = _.find(data.phenotypes, { 'name': 't2d'});  // force t2d first
                        var weHaveADefaultFirstElement = false;
                        if ((t2d) &&
                            (typeof t2d !== 'undefined') &&
                            (typeof t2d.trans !== 'undefined')){
                             weHaveADefaultFirstElement = true;
                        }
                        if (weHaveADefaultFirstElement){
                           phenotypeDropdown.append( new Option(t2d.trans, t2d.name));
                        }
                        _.forEach(data.phenotypes,function(d){
                           if (d.name !== 't2d'){
                              phenotypeDropdown.append( new Option(d.trans, d.name));
                           }
                        });
                    }

                     populateSampleAndCovariateSection($('#datasetFilter'), $('#phenotypeFilter').val(), $('#stratifyDesignation').val(),data.filters);
                     displayTestResultsSection(false);
                     $('.caatSpinner').hide();

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
           $('.caatSpinner').show();
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
                        var t2d = _.find(data.phenotypes, { 'name': 't2d'});  // force t2d first
                        var weHaveADefaultFirstElement = false;
                        if ((t2d) &&
                            (typeof t2d !== 'undefined') &&
                            (typeof t2d.trans !== 'undefined')){
                             weHaveADefaultFirstElement = true;
                        }
                        if (weHaveADefaultFirstElement){
                           phenotypeDropdown.append( new Option(t2d.trans, t2d.name));
                        }
                        _.forEach(data.phenotypes,function(d){
                           if (d.name !== 't2d'){
                              phenotypeDropdown.append( new Option(d.trans, d.name));
                           }
                        });
                    }
                     populateSampleAndCovariateSection($('#datasetFilter'), $('#phenotypeFilter').val(), $('#stratifyDesignation').val(),data.filters);
                     displayTestResultsSection(false);
                     $('.caatSpinner').hide();                        },
                        error: function (jqXHR, exception) {
                            loading.hide();
                            core.errorReporter(jqXHR, exception);
                        }
                });
        };



       var generateFilterRenderData = function(dataFilters,optionsPerFilter,stratumName, phenotype){
            var returnValue = {};
            if ( ( typeof dataFilters !== 'undefined' ) &&
                         (  dataFilters !==  null ) ) {
                var categoricalFilters = [];
                var realValuedFilters = [];
                var phenotypeUppercase  =   phenotype.toUpperCase();
                _.forEach(dataFilters,function(d,i){
                  if ((d.name!==phenotype)&&
                      (d.name.substr(0,phenotype.length)!==phenotypeUppercase)){
                      if (d.type === 'FLOAT') {
                         realValuedFilters.push(d);
                      } else {
                         if ((optionsPerFilter[d.name]!==undefined)&&
                             (optionsPerFilter[d.name].length<3)&&
                             (d.name!==phenotype)){
                                 categoricalFilters.push(d);
                         }
                      }

                  }

                });
                returnValue = {
                    categoricalFilters: categoricalFilters,
                    realValuedFilters: realValuedFilters,
                    stratum: stratumName
                };
            }
            return returnValue;
       }

       var generateCovariateRenderData = function(dataCovariates,phenotype,stratumName){
            var returnValue = {};
            if ( ( typeof dataCovariates !== 'undefined' ) &&
                         (  dataCovariates !==  null ) ) {
               var covariateSpecifiers = [];
               var covariateSpecifiersC1 = [];
               var covariateSpecifiersC2 = [];
                 _.forEach(dataCovariates,function(d,i){
                     if (d.name !== phenotype){
                        covariateSpecifiers.push(d);
                        if (d.trans.substr(0,2)==='PC'){
                            covariateSpecifiersC1.push(d);
                        } else {
                            covariateSpecifiersC2.push(d);

                        }
                     }
                });
                returnValue = {
                        covariateSpecifiers: covariateSpecifiers,
                        covariateSpecifiersC1: covariateSpecifiersC1,
                        covariateSpecifiersC2: covariateSpecifiersC2,
                        defaultCovariate: function(){
                             if (this.def) {
                                return " checked";
                             } else {
                                return "";
                             }
                        },
                        stratum: stratumName
                };
            }
            return returnValue;
       }


      var populateSampleAndCovariateSection = function (dataSetId, phenotype, stratificationProperty, filterSpec) {
          $('#stratsTabs').empty();
          var caseControlFiltering = $('#caseControlFiltering').prop('checked');
          stratifiedSampleAndCovariateSection(dataSetId, phenotype, stratificationProperty, filterSpec, caseControlFiltering);
      }



        /***
        *  Build the UI widgets which can be used to specify the filters for DAGA.  Once they are in place
        *  we can use fillCategoricalDropDownBoxes to create plots.
        *
        */
        var stratifiedSampleAndCovariateSection = function (dataSetId, phenotype, strataProperty, filterInfo, caseControlFiltering) {
            var stratumName;
            var multipleStrataExist = (strataProperty !== 'none');
            if (!multipleStrataExist){
               stratumName = 'strat1';
            }
            var data = getStoredSampleMetadata();

            var generateModeledPhenotypeElements = function ( optionsPerFilter, phenotype, caseControlFiltering, strataContentArray ){
                var modeledPhenotypeElements;
                if (caseControlFiltering){
                    var modeledPhenotype = optionsPerFilter[convertPhenotypeNames(phenotype)];
                    if ((typeof modeledPhenotype !== 'undefined' ) && (modeledPhenotype.length>0)){
                        _.forEach(strataContentArray[0], function(strataContentElement){
                            strataContentElement["phenoName"] = convertPhenotypeNames(phenotype);
                        });
                        modeledPhenotypeElements = {name:convertPhenotypeNames(phenotype),
                                                    phenoName:convertPhenotypeNames(phenotype),
                                                    val:phenotype,
                                                    strataContent: strataContentArray[0],
                                                    levels:[]};
                        var defaultDisplay = ' active';
                        var loopCounter = 0;
                        _.forEach(modeledPhenotype, function(phenotypeLevel){
                            var currentStrataContent = strataContentArray[loopCounter++];
                            var defaultStrataDisplay = ' active';
                            _.forEach(currentStrataContent, function(strataContentElement){
                                strataContentElement["phenoLevelName"] = convertPhenotypeNames(phenotypeLevel.name);
                                strataContentElement["defaultDisplay"] = defaultStrataDisplay;
                                defaultStrataDisplay = ' ';
                            });
                            modeledPhenotypeElements.levels.push(
                                                        {   name:convertPhenotypeNames(phenotypeLevel.name),
                                                        phenoLevelName:convertPhenotypeNames(phenotypeLevel.name),
                                                            val:phenotypeLevel.name,
                                                            samples:phenotypeLevel.samples,
                                                            category:convertPhenotypeNames(phenotype),
                                                            strataContent: currentStrataContent,
                                                            defaultDisplay: defaultDisplay }
                            );
                            defaultDisplay = '';
                        });
                }
            }
            return modeledPhenotypeElements;
        }



            // How many strata do we need to deal with? Create an array to list the names.
            var generateNamesOfStrata = function (multipleStrataExist, optionsPerFilter, strataProperty, phenotype){
                var stratificationProperty;
                if (multipleStrataExist){
                    stratificationProperty = optionsPerFilter[strataProperty];
                    _.forEach(stratificationProperty,function(oneRec){
                       oneRec.category = strataProperty;
                       oneRec.val = oneRec.name;
                    });
                    var totalSamples = 0;
                    _.forEach(stratificationProperty,function(stratumHolder){
                       totalSamples += stratumHolder.samples;
                    });
                    stratificationProperty.splice(0,0,{name:'ALL',val:'ALL',samples:totalSamples, category:convertPhenotypeNames(strataProperty)});
                } else {
                     stratificationProperty = [{name:stratumName, val:stratumName, category:convertPhenotypeNames(phenotype) }];
                }
                return stratificationProperty;
            };



             var generateStrataContent = function(optionsPerFilter,stratificationProperty, phenotype, specificsAboutFilters, specificsAboutCovariates, multipleStrataExist){
                var strataContent = [];
                if (multipleStrataExist){
                    _.forEach(stratificationProperty,function(stratumHolder){
                       var stratum=stratumHolder.name;
                       var category=stratumHolder.category;
                       var val=stratumHolder.val;
                       strataContent.push({  name:stratum,
                                                        trans:stratum,
                                                        val:val,
                                                        category:category,
                                                        count:strataContent.length,
                                                        filterDetails:generateFilterRenderData(specificsAboutFilters,optionsPerFilter,stratum, phenotype),
                                                        covariateDetails:generateCovariateRenderData(specificsAboutCovariates,phenotype,stratum)});
                     });
                } else {
                   strataContent = [{name:'strat1',trans:'strat1',category:'strat1',count:0,
                                                        filterDetails:generateFilterRenderData(specificsAboutFilters,optionsPerFilter, 'strat1', phenotype),
                                                        covariateDetails:generateCovariateRenderData(specificsAboutCovariates,phenotype, 'strat1' ) }];

                }
                return strataContent;
            };



            // For each strata create the necessary data. Handle the case of a single strata as a special case.
            var generateRenderData = function(optionsPerFilter,strataProperty,stratificationProperty, phenotype, specificsAboutFilters, specificsAboutCovariates, modeledPhenotype){
                var renderData;
                if (multipleStrataExist){
                    renderData  = {
                        strataProperty:strataProperty,
                        phenotypeProperty:convertPhenotypeNames(phenotype),
//                        strataContent:[],
                        tabDisplay:"",
                        modeledPhenotype:modeledPhenotype
                    };
//                    _.forEach(stratificationProperty,function(stratumHolder){
//                       var stratum=stratumHolder.name;
//                       var category=stratumHolder.category;
//                       var val=stratumHolder.val;
//                       renderData.strataContent.push({  name:stratum,
//                                                        trans:stratum,
//                                                        val:val,
//                                                        category:category,
//                                                        count:renderData.strataContent.length,
//                                                        filterDetails:generateFilterRenderData(specificsAboutFilters,optionsPerFilter,stratum, phenotype),
//                                                        covariateDetails:generateCovariateRenderData(specificsAboutCovariates,phenotype,stratum)});
//                     });
                } else {
                     renderData  = {
                        strataProperty:strataProperty,
                        phenotypeProperty:convertPhenotypeNames(phenotype),
//                        strataContent:[{name:'strat1',trans:'strat1',category:'strat1',count:0,
//                                                        filterDetails:generateFilterRenderData(specificsAboutFilters,optionsPerFilter, 'strat1', phenotype),
//                                                        covariateDetails:generateCovariateRenderData(specificsAboutCovariates,phenotype, 'strat1' ) }],
                        defaultDisplay: ' active',
                        tabDisplay: 'display: none',
                        modeledPhenotype:modeledPhenotype
                    };
                }
                return renderData;
            };


            if ( ( data !==  null ) &&
                 ( typeof data !== 'undefined') ){

                    var optionsPerFilter = generateOptionsPerFilter(filterInfo) ;
                    var stratificationProperty = generateNamesOfStrata(multipleStrataExist, optionsPerFilter, strataProperty, phenotype);
                    var strataContent1 = generateStrataContent(optionsPerFilter,stratificationProperty, phenotype, data.filters, data.covariates, multipleStrataExist);
                    var strataContent2 = generateStrataContent(optionsPerFilter,stratificationProperty, phenotype, data.filters, data.covariates, multipleStrataExist);
                    var modeledPhenotypeElements = generateModeledPhenotypeElements(optionsPerFilter, phenotype, caseControlFiltering, [strataContent1,strataContent2] );
                    var renderData = generateRenderData(optionsPerFilter,strataProperty,stratificationProperty, phenotype, data.filters, data.covariates, modeledPhenotypeElements);


                    $("#chooseFiltersLocation").empty();
                    $("#chooseCovariatesLocation").empty();

                    //
                    // set up the section where the filters will go
                    //
                    $("#chooseFiltersLocation").empty().append(Mustache.render( $('#chooseFiltersTemplate')[0].innerHTML,renderData,
                                                                                {   allFiltersTemplate: $('#allFiltersTemplate')[0].innerHTML,
                                                                                    filterFloatTemplate:$('#filterFloatTemplate')[0].innerHTML,
                                                                                    filterCategoricalTemplate:$('#filterCategoricalTemplate')[0].innerHTML }));

                    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                        var target = $(e.target).text(); // activated tab
                        displaySampleDistribution('ID',"_"+target,0);
                    });

                    //
                    // set up the section where the covariates will go
                    //
                    $("#chooseCovariatesLocation").empty().append(Mustache.render( $('#chooseCovariatesTemplate')[0].innerHTML,renderData,
                                                                                {   allCovariateSpecifierTemplate: $('#allCovariateSpecifierTemplate')[0].innerHTML,
                                                                                    covariateTemplateC1:$('#covariateTemplateC1')[0].innerHTML,
                                                                                    covariateTemplateC2:$('#covariateTemplateC2')[0].innerHTML }));

                    // do a few things in an old-fashioned, looping way
                     _.forEach(stratificationProperty,function(stratumHolder){
                        var stratumName=stratumHolder.name;

                        $('.sampleNumberReporter').show();

                         // filters should be in place now.  Attach events
                         _.forEach(data.filters,function(d){
                              $("#multi_"+stratumName+"_"+d.name).bind("change", function(event, ui){
                                   mpgSoftware.burdenTestShared.displaySampleDistribution(d.name, '.boxWhiskerPlot_'+stratumName,0)
                              });
                         });

                        fillCategoricalDropDownBoxes({},phenotype,stratumName,optionsPerFilter);

                    });

                    //
                    // display the results section
                    //
                    var renderRunData = {
                        strataProperty:strataProperty,
                        phenotypeProperty:convertPhenotypeNames(phenotype),
                        stratum:stratumName,
                        singleRunButtonDisplay: function(){
                                 var singleRunButton = $('#singleRunButton');
                                 if (singleRunButton.text().length===0) {
                                    return ('<button name="singlebutton" style="height: 80px; z-index: 10" id="singleRunButton" '+
                                                   'class="btn btn-primary btn-lg burden-test-btn vcenter" '+
                                                   'onclick="mpgSoftware.burdenTestShared.immediateFilterAndRun()">Run</button>');
                                 } else {
                                    return "";
                                 }
                            }
                    };
                    $("#displayResultsLocation").empty().append(Mustache.render( $('#displayResultsTemplate')[0].innerHTML,renderRunData));

                    if (multipleStrataExist) {
                        $('.filterCohort.ALL').click();
                        $('.covariateCohort.ALL').click();
                    }

              }


            $('.caatSpinner').hide();
        };


        var convertFiltersIntoArraysOfStrings = function(filterKey){
           var filterStrings = [];
           _.forEach( extractFilters(filterKey), function(filterObject){
               var oneFilter = [];
               _.forEach( filterObject, function(value, key){
                   if (typeof value !== 'undefined'){
                       if (key==="cat"){
                          oneFilter.push("\""+key+"\": \""+value+"\"");
                       }else{
                          var divider = value.indexOf('_');
                           if (divider>-1){
                               var propName = value.substr(divider+1,value.length-divider);
                               oneFilter.push("\""+key+"\": \""+propName+"\"");
                           } else {
                                oneFilter.push("\""+key+"\": \""+value+"\"");
                           }
                       }
                    }
                });

               filterStrings.push("{"+oneFilter.join(",\n")+"}");
           } );
        return filterStrings;
        };






        var compoundingFilterValues = function (arrayOfKeys){
           var arrayOfArrayOfFilters = [];
           var filterStrings = [];
            _.forEach( arrayOfKeys, function(oneSetOfKeys){
                    var arraysOfStrings = convertFiltersIntoArraysOfStrings(oneSetOfKeys.stratumName);
                    arraysOfStrings.push("{\"name\":\""+oneSetOfKeys.phenoPropertyName+"\",\n\"parm\":\""+oneSetOfKeys.phenoInstanceSpecifier+"\",\n\"cmp\":\"3\",\n\"cat\":\"1\"}");
                   arrayOfArrayOfFilters.push(arraysOfStrings);
            });
            _.forEach( arrayOfArrayOfFilters, function(arrayOfFilters){
                    filterStrings.push("["+arrayOfFilters.join(",\n")+"]");
            } );
           return "[\n" + filterStrings.join(",") + "\n]";
        };



        /***
        *   pull all of the filters out of the Dom and put them into a JSON string suitable for transmission to the server
        *
        */
        var collectingFilterValues = function (additionalKey,additionalValue,alternateValue){
           var filterStrings = [];
           var searchValue = additionalValue;
           if(typeof alternateValue !== 'undefined') {
                searchValue = alternateValue;
           }
           _.forEach( extractFilters(searchValue), function(filterObject){
               var oneFilter = [];
               _.forEach( filterObject, function(value, key){
                   if (typeof value !== 'undefined'){
                       if (key==="cat"){
                          oneFilter.push("\""+key+"\": \""+value+"\"");
                       }else{
                          var divider = value.indexOf('_');
                           if (divider>-1){
                               var propName = value.substr(divider+1,value.length-divider);
                               oneFilter.push("\""+key+"\": \""+propName+"\"");
                           } else {
                                oneFilter.push("\""+key+"\": \""+value+"\"");
                           }
                       }
                    }
                });

               filterStrings.push("{"+oneFilter.join(",\n")+"}");
           } );
           if ((typeof additionalKey !== 'undefined') &&
                   (additionalKey.length > 0) &&
                   (typeof additionalValue !== 'undefined') &&
                   (additionalValue !== 'strat1') &&
                   (additionalValue.length > 0) &&
                    (additionalValue !== 'ALL')) {
                  filterStrings.push("{\"name\": \""+additionalKey+"\","+
"\"parm\": \""+additionalValue+"\","+
"\"cmp\": \"3\",\"cat\": \"1\"}");
           }
           return "[\n" + filterStrings.join(",") + "\n]";
        };






        /***
        * Previously (V0.1) used to get sample data reflecting a set of filters. Presumably this is where we insert (v0.2)
        * the ability to pull back distributions based on filters
        *
        * @param dataSetSel
        * @param callback
        */
        var refreshSampleDistribution = function (dataSetSel,callback,params){

            var collectingPropertyNames = function (property){
               var propertyStrings = [];
               propertyStrings.push("{\"name\": \""+property.propertyName+"\",\"categorical\": "+property.categorical+"}");
               return "[\n" + propertyStrings.join(",") + "\n]";
            };

            // name of stratification property
            var modeledPhenotype = params.modeledPhenotype;
            phenoPropertyName = _.find( $('div.phenoSplitTabs_property'), function(o){
                var id = $(o).attr("id");
                return (id.indexOf(modeledPhenotype)>-1);
            });
            var phenoPropertyName = $(phenoPropertyName).attr("id").substr(modeledPhenotype.length+1); // what is the phenotype we are modeling

            var strataName = '';
            var strataPropertyName = '';
            var phenoPropertySpecifier = $('a[data-target=#'+params.strataName+']+div.strataPhenoIdent div.phenoCategory').text();
            var phenoInstanceSpecifier = $('a[data-target=#'+params.strataName+']+div.strataPhenoIdent div.phenoInstance').text();

            var jsonDescr;
            if (phenoPropertySpecifier === phenoPropertyName){ // this tab specifies an instance of the phenotype we are modeling
                strataPropertyName = phenoPropertyName;
                strataName = phenoInstanceSpecifier;
                jsonDescr = "{\"dataset\":\""+$(dataSetSel).val()+"\"," +
                              "\"requestedData\":"+collectingPropertyNames(params)+"," +
                              "\"filters\":"+collectingFilterValues(strataPropertyName,strataName,params.strataName)+"}";
             } else { // This can only be a strata tab, not a phenotype tab
                strataPropertyName = $('div.stratsTabs_property').attr("id");
                strataName=params.strataName;
                jsonDescr = "{\"dataset\":\""+$(dataSetSel).val()+"\"," +
                              "\"requestedData\":"+collectingPropertyNames(params)+"," +
                              "\"filters\":"+collectingFilterValues(strataPropertyName,strataName)+"}";
             }

            retrieveSampleDistribution  ( jsonDescr, callback, params  );
        }


        /***
        * filter our samples and then launch the IAT test
        */
        var immediateFilterAndRun = function (){
             runBurdenTest();
         };





        /***
        *   Determine whether or not we should see the section displaying IAT test results
        * @param display
        */
        var displayTestResultsSection = function (display)  {
            burdenTestResult = $('.burden-test-result');
            if (display){
                burdenTestResult.show () ;
            } else {
                burdenTestResult.hide () ;
            }
         }

                var addStrataSection = function(domElement,stratum){
                    domElement.append('<div class="stratum_'+stratum+' stratumName"></div>');
                    domElement.append('<div class="pValue_'+stratum+'"></div>');
                    domElement.append('<div class="orValue_'+stratum+'"></div>');
                    domElement.append('<div class="ciValue_'+stratum+'"></div>');
                };
          var printFullResultsSection = function(stats,pValue,beta,oddsRatio,currentStratum,additionalText){
                var isDichotomousTrait = false;
                if ((typeof stats.numCases === 'undefined') ||
                    (typeof stats.numControls === 'undefined') ||
                    (typeof stats.numCaseCarriers === 'undefined') ||
                    (typeof stats.numControlCarriers === 'undefined')) {
                   isDichotomousTrait = false;
                } else {
                   isDichotomousTrait = true;
                }


                var ciDisplay = '';
                if (!((typeof stats.ciLower === 'undefined') ||
                    (typeof stats.ciUpper === 'undefined') ||
                    (typeof stats.ciLevel === 'undefined'))) {
                   var ciUpper = stats.ciUpper;
                   var ciLower = stats.ciLower;
                   var ciLevel = stats.ciLevel;

                   if (isDichotomousTrait) {
                        ciLower = UTILS.realNumberFormatter(Math.exp(stats.ciLower));
                        ciUpper = UTILS.realNumberFormatter(Math.exp(stats.ciUpper));
                   } else {
                        ciLower = UTILS.realNumberFormatter(stats.ciLower);
                        ciUpper = UTILS.realNumberFormatter(stats.ciUpper);
                   }
                   ciDisplay = (ciLevel * 100) + '% CI: (' + ciLower + ' to ' + ciUpper + ')';
                }

                fillInResultsSection(currentStratum,'pValue = '+ pValue,
                    (isDichotomousTrait ? 'odds ratio = ' + oddsRatio : 'beta = ' + beta),
                    ciDisplay, isDichotomousTrait,additionalText);

           }







      var executeAssociationTest = function (filterValues,covariateValues,propertyName,stratum,compoundedFilterValues){

             var isCategoricalF = function (stats){
                       var isDichotomousTrait = false;
                        if ((typeof stats.numCases === 'undefined') ||
                            (typeof stats.numControls === 'undefined') ||
                            (typeof stats.numCaseCarriers === 'undefined') ||
                            (typeof stats.numControlCarriers === 'undefined')) {
                           isDichotomousTrait = false;
                        } else {
                           isDichotomousTrait = true;
                        }
                        return isDichotomousTrait;
                    };

           var phenotypeToPredict = $('#phenotypeFilter').val();
           var datasetUse = $('#datasetFilter').val();
           return $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller: 'variantInfo', action: 'burdenTestAjax')}",
                data: {variantName: '<%=variantIdentifier%>',
                       covariates: covariateValues,
                       samples: "{\"samples\":[]}",
                       filters: "{\"filters\":"+filterValues+"}",
                       compoundedFilterValues: compoundedFilterValues,
                       traitFilterSelectedOption: phenotypeToPredict,
                       dataset: datasetUse,
                       stratum: stratum
                },
                async: true
            }).success(
               function (data) {
                    if ((typeof data !== 'undefined') && (data)){
                    //first check for error conditions
                        if (!data){
                             $('.iatErrorText').text('No data returned from burden test module!');
                            $('.iatErrorFailure').show();
                        } else if (data.is_error) {
                            if (data.error_msg !== "Regression results could not be retrieved"){ // Not a message users need to see
                                $('.iatErrorText').text('Error: '+data.error_msg);
                                $('.iatErrorFailure').show();
                            }
                        } else if ((typeof data.stats === 'undefined') &&
                                 (typeof data.stratum !== 'undefined') ){
                             $('.iatErrorText').text('Insufficient number of samples.  Please broaden your filter criteria and try again.');
                             $('.iatErrorFailure').show();
                        } else if ((typeof data.stats.pValue === 'undefined') ||
                                 (typeof data.stats.beta === 'undefined') ||
                                 (typeof data.stats.stdError === 'undefined')){
                             console.log('burdenTestAjax returned undefined for P value, standard error or beta.');

                        } else {
                            $('.iatErrorText').text('');
                            $('.iatErrorFailure').hide();

                            var oddsRatio = UTILS.realNumberFormatter(Math.exp(data.stats.beta));
                            var beta = UTILS.realNumberFormatter(data.stats.beta);
                            var stdErr = UTILS.realNumberFormatter(data.stats.stdError);
                            var pValue = UTILS.realNumberFormatter(data.stats.pValue);
                            var isCategorical = isCategoricalF (data.stats);

                            var currentStratum = 'stratum'; // 'strat1' marks no distinct strata used
                            if (typeof data.stratum !== 'undefined'){
                               currentStratum = data.stratum;
                            }
                            if (currentStratum==='strat1'){
                                $('.strataResults').append('<div class="'+currentStratum+' strataHolder"></div>');
                                var strataDomIdentifierClass = $('.'+currentStratum+'.strataHolder');
                                addStrataSection(strataDomIdentifierClass,currentStratum);
                                printFullResultsSection(data.stats,pValue,beta,oddsRatio,currentStratum,'');
                            } else {

                                    $('.strataResults').append('<div class="strataJar">'+
                                                                '<span class="hider stratum '+currentStratum+'">'+currentStratum+'</span>'+
                                                                '<span class="hider pv '+currentStratum+'">'+pValue+'</span>'+
                                                                '<span class="hider be '+currentStratum+'">'+beta+'</span>'+
                                                                '<span class="hider st '+currentStratum+'" >'+stdErr+'</span>'+
                                                                '<span class="hider ca '+currentStratum+'" >'+(isCategorical?"1":"0")+'</span>'+
                                                                '</div>');

                            displayTestResultsSection(true);

                       }}
                    }
                    //$('#rSpinner').hide();
                    }
            ).fail(function (jqXHR, exception) {
                    $('#rSpinner').hide();
                    core.errorReporter(jqXHR, exception);
                }

            );
      }



            var fillInResultsSection = function (stratum,pValue, oddsRatio, stdError, isDichotomousTrait,additionalText){



                // populate the data
                if (additionalText.length>0){
                  $('.stratum_'+stratum).text(additionalText);
                }
                $('.pValue_'+stratum).text(pValue);
                $('.orValue_'+stratum).text(oddsRatio);
                $('.ciValue_'+stratum).text(stdError);

                displayTestResultsSection(true);

                $('.burden-test-some-results-large_'+stratum).hide();
                $('.burden-test-some-results '+stratum).show();
                $('.burden-test-result '+stratum).show();

            };





        /**
         *  run the burden test, then display the results.  We will need to start by extracting
         *  the data fields we need from the DOM.
         */
        var runBurdenTest = function (){

            var runMetaAnalysis = function (){
               var domHolder = $('.strataJar');
               var allElements = [];
               // collect the numbers we need from the Dom
               if (domHolder.length<1) return;
               _.forEach(domHolder, function(eachStratum){
                   allElements.push({'pv': $(eachStratum).find('.pv').text(),
                   'be': $(eachStratum).find('.be').text(),
                   'st': $(eachStratum).find('.st').text(),
                   'ca': $(eachStratum).find('.ca').text(),
                   'stratum': $(eachStratum).find('.stratum').text()});
               });
               // create JSON we can send to the server
               var jsonHolder = [];
                _.forEach(allElements, function(stratum){
                    jsonHolder.push('{"pv":'+stratum.pv+',"be":'+stratum.be+',"st":'+stratum.st+',"ca":'+stratum.ca+'}');
                });
                var json = '['+jsonHolder.join(',')+']';
                var sortedElements = allElements.sort(function(a, b) {
                    var nameA = a.stratum.toUpperCase();
                    var nameB = b.stratum.toUpperCase(); // ignore upper and lowercase
                      if (nameA < nameB) {
                        return -1;
                      }
                      if (nameA > nameB) {
                        return 1;
                      }
                      return 0;
                 });
                // now display all previously collected sessions
                $('.strataResults').append("<ul class='list-inline'></ul>")
                _.forEach(sortedElements,function(el){
                     var currentStratum  = el.stratum;
                    var oddsRatio = UTILS.realNumberFormatter(Math.exp(el.be));
                    var beta = UTILS.realNumberFormatter(el.be);
                    var stdErr = UTILS.realNumberFormatter(el.st);
                    var pValue = UTILS.realNumberFormatter(el.pv);
                    var isCategorical = el.ca;
                     $('.strataResults ul').append('<li><div class="'+currentStratum+' strataHolder"></div></li>');
                    var strataDomIdentifierClass = $('.'+currentStratum+'.strataHolder');
                    addStrataSection(strataDomIdentifierClass,currentStratum);
                    var isDichotomousTrait=(isCategorical==='1');
                    fillInResultsSection(currentStratum,'pValue = '+ pValue,
                    (isDichotomousTrait ? 'odds ratio = ' + oddsRatio : 'beta = ' + beta),
                    'std. err. = '+stdErr, isDichotomousTrait,currentStratum);
                    //printFullResultsSection(data.stats,pValue,beta,oddsRatio,currentStratum,'');
                });



                var promise =  $.ajax({
                    cache: false,
                    type: "post",
                    url: "${createLink(controller: 'variantInfo', action: 'metadataAjax')}",
                    data: {valueArray: json },
                    async: true
                 });
                 promise.done(
                  function (data) {
                    if ((typeof data !== 'undefined') &&
                         (data) &&
                         (!(data.is_error))&&
                         (data.stats)){
                            var categorical = data.categorical;
                            var oddsRatio = UTILS.realNumberFormatter(Math.exp(data.stats.beta));
                            var beta = UTILS.realNumberFormatter(data.stats.beta);
                            var stdErr = UTILS.realNumberFormatter(data.stats.stdError);
                            var pValue = UTILS.realNumberFormatter(data.stats.pValue);
                             $('.strataResults').append( '<div clas="metana" style="text-align: center"><span class="stratumName">Meta-analysis:</span> &nbsp;&nbsp;&nbsp;pValue = <span class="pv metaAnalysis">'+pValue+'</span>'+
((categorical==='1')?('<span class="be metaAnalysis">Odds ratio='+oddsRatio+'</span>'):('<span class="be metaAnalysis">Beta='+beta+'</span>'))+
'<span class="st metaAnalysis">Std error='+stdErr+'</span>'+
'</div>');
                       }
                    }
                 );

                 promise.fail();
            }

            var collectingCovariateValues = function (propertyName,stratumName){
               var pcCovariates = [];
               var selectedCovariates = $('#cov_'+stratumName+' .covariate:checked');
               _.forEach(selectedCovariates, function(d){
                  var covariateDom = $(d);
                  var covId = covariateDom.attr('id');
                  var covariateName = covId.substr(("covariate_"+stratumName+"_").length);
                  if (covariateName.indexOf("{{")===-1){
                     pcCovariates.push('"'+covariateName+'"');
                  }
               });
               return "{\"covariates\":[\n" + pcCovariates.join(",") + "\n]}";
            };


            $('#rSpinner').show();
            var traitFilterSelectedOption = $('#phenotypeFilter').val();
            var translatedPhenotypeName = convertPhenotypeNames(traitFilterSelectedOption);
            var stratsTabs  = $('#stratsTabs li a.filterCohort');
            if (stratsTabs.length===0){
               var f=executeAssociationTest(collectingFilterValues(),collectingCovariateValues(),'none','strat1');
               $.when(f).then(function() {
                      //alert('all done with 1');
                });
            } else {
                var propertyDesignationDom = $('div.stratsTabs_property'); // strata are tested independently
                var strataPropertyName = propertyDesignationDom.attr("id");
                var phenoSplitDesignationDom = $('div.phenoSplitTabs_property');  // case/control go together
                var phenoSplitPropertyName = phenoSplitDesignationDom.attr("id");
                $('.strataResults').empty(); // clear stata reporting section
                var nonPhenotypeTabs = [];
                var phenotypeTabs = [];
                var phenoPropertyName = $('div.phenoSplitTabs_property').attr("id");
                _.forEach(stratsTabs,function (stratum){
                    var stratumName = $(stratum).text();
                     var phenoPropertySpecifier = $('a[data-target=#'+stratumName+']+div.strataPhenoIdent div.phenoCategory').text();
                     var phenoInstanceSpecifier = $('a[data-target=#'+stratumName+']+div.strataPhenoIdent div.phenoInstance').text();
                     if (phenoPropertySpecifier!==translatedPhenotypeName){
                        nonPhenotypeTabs.push(stratum);
                     } else {
                        phenotypeTabs.push({
                                            phenoPropertyName:phenoPropertyName,
                                            phenoInstanceSpecifier:phenoInstanceSpecifier,
                                            stratumName:stratumName
                        });
                     }
                  });
                var compoundedFilterValues = compoundingFilterValues(phenotypeTabs);
                var deferreds = [];
                _.forEach(nonPhenotypeTabs,function (stratum){
                    var stratumName = $(stratum).text();
                    if (stratumName!=='ALL'){
                       deferreds.push(executeAssociationTest(collectingFilterValues(strataPropertyName,stratumName),collectingCovariateValues(strataPropertyName,stratumName),strataPropertyName,stratumName,compoundedFilterValues));
                    }
                });
                $.when.apply($,deferreds).then(function() {
                      runMetaAnalysis();
                      $('#rSpinner').hide();
                });
            }

        }; // runBurdenTest


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

        var predefinedBoxWhiskerPlot = function (inData,selector) {
            var margin = {top: 50, right: 50, bottom: 20, left: 50},
            width = 700 - margin.left - margin.right,
            height = 350 - margin.top - margin.bottom;

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
                    .initData([{data:[{d:'j',v:0.0}]}],width,height+50)            // the information that goes into the plot
                    .whiskers(chart.iqr(defaultInterquartileMultiplier))  // adjust the whiskers so that they go to the right initial  position
                    .histogramBarMultiplier(defaultHistogramBarSize)        // let's start with no histogram visible


                // Following settings if you want only an explicitly specified bar chart
                .histogramBarMultiplier(2)
                .leftShiftPlotWithinAxes(170)
                .outlierRadius(1e-6)
                .boxAndWhiskerWidthMultiplier(0)  // 0 to skip the box whisker presentation, 1 for default box size
                .explicitlySpecifiedHistogram( inData.distribution_array );


            //  Now we are ready to actually launch the box whisker plot
            d3.select(selector)
                    .selectAll('svg')
                    .call(chart.boxWhisker);

        };






        var buildBoxWhiskerPlot = function (inData,selector) {
            var margin = {top: 50, right: 50, bottom: 20, left: 50},
            width = 700 - margin.left - margin.right,
            height = 350 - margin.top - margin.bottom;

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
                    .histogramBarMultiplier(defaultHistogramBarSize)        // let's start with no histogram visible
                    .leftShiftPlotWithinAxes(130);

            //  Now we are ready to actually launch the box whisker plot
            d3.select(selector)
                    .selectAll('svg')
                    .call(chart.boxWhisker);

        };



        var predefinedCategoricalPlot = function (data,selector) {
           var roomForLabels = 50;

           if (typeof data === 'undefined') return;

    var margin = {top: 20, right: 50, bottom: 30, left: 15},
            width = 700 - margin.left - margin.right,
            height = 350 - margin.top - margin.bottom;



        var barChart = baget.mBar()
                .width(width)
                .height(height)
                .margin(margin)
                .valueAccessor(function (x) {return x.count})
                .colorAccessor(function (x) {return '#0082ca'})
                .categoryAccessor(function (x) {return x.value})
                .showGridLines (false)
                .blackTextAfterBar (true)
                .spaceForYAxisLabels (roomForLabels)
                .dataHanger(selector,data);

        d3.select(selector).call(barChart.render);
     };




     var buildCategoricalPlot = function (inData,selector) {

           data=[];
           _.forEach(inData,function(arrObj){
              data.push({ category: arrObj.name,
                    value: arrObj.samples,
                    color: '#0082ca'});
           });

           var roomForLabels = 50;

    var margin = {top: 50, right: 50, bottom: 20, left: 15},
            width = 700 - margin.left - margin.right,
            height = 350 - margin.top - margin.bottom;



        var barChart = baget.mBar()
                .width(width)
                .height(height)
                .margin(margin)
                .showGridLines (false)
                .blackTextAfterBar (true)
                .spaceForYAxisLabels (roomForLabels)
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





        function extractFilters(stratum,strataCategory){
            var stratumName = "";
            if (typeof stratum !== 'undefined') {
               stratumName += ('.'+stratum);
            }
            if (typeof strataCategory !== 'undefined') {
               stratumName += ('.'+strataCategory);
            }
            var allFilters =  $('.realValuedFilter'+stratumName);
            var requestedFilters = [];
            for  ( var i = 0 ; i < allFilters.length ; i++ )   {
                var filterRowDom = $(allFilters[i]);
                var  filterId = $(allFilters[i]).attr('id');
                if (filterId.indexOf("filter_")==0){
                    var  filterName = filterId.substr(7);
                    var filterCheck = filterRowDom.find('.utilize');
                    var filterParm = filterRowDom.find('.filterParm');
                    var filterCmp = filterRowDom.find('.filterCmp');
                    if (filterCheck.is(':checked')&&
                        (filterName.indexOf("{{")===-1)&&
                        (filterParm.val().length>0)){
                        var  dataSetMap = {"name":filterName,
                                           "parm":filterParm.val(),
                                           "cmp":filterCmp.val(),
                                           "cat":0};
                        requestedFilters.push(dataSetMap);
                    }
                }

            }
            allFilters =  $('.categoricalFilter'+stratumName);
            for  ( var i = 0 ; i < allFilters.length ; i++ )   {
                var filterRowDom = $(allFilters[i]);
                var  filterId = $(allFilters[i]).attr('id');
                if (filterId.indexOf("filter_")==0){
                    var  filterName = filterId.substr(7);
                    var filterCheck = filterRowDom.find('.utilize');
                    var multiParm = filterRowDom.find('.multiSelect');
                    if (filterCheck.is(':checked')&&(filterName.indexOf("{{")==-1)){
                        var allSelected = [];
                        _.forEach($('#multi_'+filterName+' option:selected'),function(d){
                            allSelected.push($(d).val());
                        });
                        var  dataSetMap = {"name":filterName,
                                "parm":allSelected,
                                "cmp": "3",
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



        var fillCategoricalDropDownBoxes = function (sampleData,phenotype,stratum,optionsPerFilter){
             // make dist plots
            var sampleMetadata = getStoredSampleMetadata();
            _.forEach(sampleMetadata.filters,function(d,i){
                if (d.type !== 'FLOAT') {
                    if (optionsPerFilter[d.name]!==undefined){
                       var dropdownId = '#multi_'+stratum+"_"+d.name;
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
                                                        },
                                                   buttonWidth: '100%'
                                                   });
                       $(dropdownId).multiselect('selectAll', false);
                       $(dropdownId).multiselect('updateButtonText');

                    }
                 }
            });
        };




        var retrieveSampleDistribution = function (data, callback,passThru){

                $.ajax({
                    cache: false,
                    type: "post",
                    url: "${createLink(controller: 'variantInfo', action: 'retrieveSampleSummary')}",
                    data: {'data':data},
                    async: true,
                    success: function (returnedData) {
                        storeSampleData(returnedData);
                        callback(returnedData,passThru);
                    },
                    error: function (jqXHR, exception) {
                        core.errorReporter(jqXHR, exception);
                    }
                });

        };



        /***
        *   generate a map with an array of values for each filter name.  The values represent every possible value
        *   the filter might hold.
        *
        * @param variants
        * @returns {{}}
        */
         var generateOptionsPerFilter = function (filterInfo) {
             var optionsPerFilter = {};
             _.forEach(filterInfo,function(oneFilter){
                if (typeof oneFilter.levels !== 'undefined') {
                         optionsPerFilter[oneFilter.name] = oneFilter.levels;
                }
             });
            return optionsPerFilter;
         };






        var utilizeDistributionInformationToCreatePlot = function (distributionInfo,params){
           if ((typeof distributionInfo !== 'undefined')&&
              (typeof distributionInfo.sampleData !== 'undefined')&&
              (distributionInfo.sampleData !== null)){
                var plotHoldingStructure = $(params.holderSection);
                plotHoldingStructure.empty();
                var sampleMetadata = getStoredSampleMetadata();
                var  sampleCount = 0;
                if (typeof distributionInfo.sampleData.distribution_array === 'undefined'){ return; }
                _.forEach(distributionInfo.sampleData.distribution_array,function(d){sampleCount += d.count;})
                if (sampleCount < minimumNumberOfSamples){
                    $('.sampleNumberReporter .numberOfSamples').text(" < "+minimumNumberOfSamples);
                    displayTestResultsSection(false);
                } else {
                    $('.sampleNumberReporter .numberOfSamples').text(sampleCount);
                    var divElementName = 'bwp_'+params.strataName+'_'+params.propertyName;
                    plotHoldingStructure.append('<div id="'+divElementName+'"></div>');
                       $('.sampleNumberReporter .phenotypeSpecifier').text(params.propertyName);
                    $('#'+divElementName).hide();
                    if (sampleMetadata.filters){
                      var filter = _.find(sampleMetadata.filters, {'name':params.propertyName});
                      if (filter){
                         if (filter.type === 'INTEGER'){
                            predefinedCategoricalPlot(distributionInfo.sampleData.distribution_array,'#'+divElementName);
                            $('#'+divElementName).show();
                         } else if (filter.type === 'STRING'){
                            predefinedCategoricalPlot(distributionInfo.sampleData.distribution_array,'#'+divElementName);
                            $('#'+divElementName).show();
                         } if (filter.type === 'FLOAT'){
                            predefinedBoxWhiskerPlot(distributionInfo.sampleData,'#'+divElementName);
                            $('#'+divElementName).show();
                         }
                      }
                    }

                }

             }
        };


       var carryCovChanges = function (propertyName, strataName){
           var covariateDetermination =   $('.covariate');
           if (strataName==='ALL'){
                _.forEach(covariateDetermination,function(oneComparator){
                    var cmpRowDom = $(oneComparator);
                    var  cmpId = cmpRowDom.attr('id');
                    if (cmpId.indexOf("covariate_")==0){
                        var  cmpName = cmpId.substr(10);
                        var locationOfSecondBreak = cmpName.indexOf('_');
                        if ((locationOfSecondBreak>-1)&&
                            (locationOfSecondBreak<(cmpName.length-1))&&
                            (cmpName.substr(locationOfSecondBreak+1)==propertyName)&&
                            (cmpName.substr(0,3)!=='ALL')){
                            $('#covariate_'+cmpName).prop('checked',$('#covariate_ALL_'+propertyName).prop('checked'));
                            }
                    }

                });
           }
       }




        /***
        * Make sure every distribution plot is hidden, then display the one we want
        *
        * @param propertyName
        * @param holderSection
        */
        var displaySampleDistribution = function (propertyName, holderSection, categorical,modeledPhenotype) { // for categorical, 0== float, 1== string or int
            var locationOfFirstBreak = holderSection.indexOf('_');
            var strataName = holderSection.substring(locationOfFirstBreak+1);
            if ((locationOfFirstBreak> -1) &&(strataName==='ALL')) {

               //real valued
               var realValueFilters = $('.filterParm');
               _.forEach(realValueFilters,function(oneFilter){
                    var filterDom = $(oneFilter);
                    var id = filterDom.attr('id');
                    var idKeys = id.split('_');
                    if (idKeys.length === 3){
                        if ((idKeys[0]==='inp') &&
                            (idKeys[1]!=='ALL')  &&
                            (idKeys[2]===propertyName)){
                                var templateFilter = $('#inp_ALL_'+propertyName);
                                filterDom.val(templateFilter.val());
                        }
                   }
               });



               // categorical
                var categoricalValueFilters =   $('.categoricalFilter');
                _.forEach(categoricalValueFilters,function(oneFilter){
                    var filterRowDom = $(oneFilter);
                    var  filterId = filterRowDom.attr('id');
                    if (filterId.indexOf("filter_")==0){
                        var  filterName = filterId.substr(7);
                        var locationOfSecondBreak = filterName.indexOf('_');
                        if ((locationOfSecondBreak>-1)&&
                            (locationOfSecondBreak<(filterName.length-1))&&
                            (filterName.substr(locationOfSecondBreak+1)==propertyName)&&
                            (filterName.substr(0,3)!=='ALL')){
                            $('#multi_'+filterName).val($('#multi_ALL_'+propertyName).val());
                            }
                    }

                });

                // comparators
               var realValueComparators =   $('.filterCmp');
                _.forEach(realValueComparators,function(oneComparator){
                    var cmpRowDom = $(oneComparator);
                    var  cmpId = cmpRowDom.attr('id');
                    if (cmpId.indexOf("cmp_")==0){
                        var  cmpName = cmpId.substr(4);
                        var locationOfSecondBreak = cmpName.indexOf('_');
                        if ((locationOfSecondBreak>-1)&&
                            (locationOfSecondBreak<(cmpName.length-1))&&
                            (cmpName.substr(locationOfSecondBreak+1)==propertyName)&&
                            (cmpName.substr(0,3)!=='ALL')){
                            $('#cmp_'+cmpName).val($('#cmp_ALL_'+propertyName).val());
                            }
                    }

                });

           }


            refreshSampleDistribution( '#datasetFilter', utilizeDistributionInformationToCreatePlot, {
                                                                                                        propertyName:propertyName,
                                                                                                        holderSection:holderSection,
                                                                                                        strataName:strataName,
                                                                                                        categorical:categorical,
                                                                                                        modeledPhenotype:modeledPhenotype
                                                                                                      } );
        };


        // public routines are declared below
        return {
            displaySampleDistribution:displaySampleDistribution,  // display a distribution plot based on the name of the filter
            preloadInteractiveAnalysisData:preloadInteractiveAnalysisData, // assuming there is only one data set we can get most everything at page load
            retrieveExperimentMetadata:retrieveExperimentMetadata, //Retrieve sample metadata only to get the experiment list
            immediateFilterAndRun:immediateFilterAndRun, // apply filters locally and then launch IAT
            retrieveMatchingDataSets:retrieveMatchingDataSets, // retrieve data set matching phenotype
            getStoredSampleData:getStoredSampleData, // retrieve stored sample data
            retrieveSampleMetadata:retrieveSampleMetadata, // if user changes data set reset phenotype (and potentially reload samples)
            carryCovChanges:carryCovChanges,
            populateSampleAndCovariateSection:populateSampleAndCovariateSection,
            displayTestResultsSection: displayTestResultsSection  // simply display results section (show() or hide()
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
            <h2><strong>Genetic Association Interactive Tool</strong></h2>
        </a>
    </div>

    <div id="collapseBurden" class="accordion-body collapse">
        <div class="accordion-inner">

            <div class="container">
                <h5>The Genetic Association Interactive Tool allows you to compute custom association statistics for this
                variant by specifying the phenotype to test for association, a subset of samples to analyze based on specific phenotypic criteria, and a set of covariates to control for in the analysis.</h5>


                <div class="row burden-test-wrapper-options">

                    <r:img class="caatSpinner" uri="/images/loadingCaat.gif" alt="Loading GAIT data"/>



                    <div class="user-interaction">

                        <div id="chooseDataSetAndPhenotypeLocation"></div>

                        <div class="stratified-user-interaction"></div>

                        <div class="panel-group" id="accordion_iat" style="margin-bottom: 0px">%{--start accordion --}%
                            <div id="chooseFiltersLocation"></div>
                            <div id="chooseCovariatesLocation"></div>
                        </div>

                    </div>
                    <div id="displayResultsLocation"></div>

                </div>

            </div>  %{--close container--}%

        </div>  %{--close accordion inner--}%
    <g:render template="/widgets/dataWarning" />
    </div>  %{--accordion body--}%
</div> %{--end accordion group--}%


%{--IAT results section--}%
<script id="displayResultsTemplate"  type="x-tmpl-mustache">
    <div class="panel panel-default">%{--should hold the Choose data set panel--}%

        <div class="panel-heading">
            <h4 class="panel-title">
                <a>Step 4: Launch analysis</a>
            </h4>
        </div>

    <div class="row burden-test-some-results burden-test-some-results_{{stratum}}">
        <div class="row iatErrorFailure" style="display:none">
            <div class="col-md-8 col-sm-6">
                <div class="iatError">
                    <div class="iatErrorText"></div>
                </div>
            </div>

            <div class="col-md-4 col-sm-6">

            </div>
        </div>

        <div class="col-sm-10 col-xs-12">
            <div class="row burden-test-specific-results burden-test-result">



                <div class="col-md-12 col-sm-12">
                    <div>
                        <div class="vertical-center">
                            <div class="strataResults">

                            </div>
                        </div>
                    </div>
                </div>


            </div>

            <div class="row burden-test-result-large burden-test-some-results-large_{{stratum}}">
                <div class="col-md-4 col-sm-3">
                </div>

                <div class="col-md-4 col-sm-6">
                    <div class="vertical-center">
                        <div class="pValue pValue_{{stratum}}"></div>

                        <div class="orValue orValue_{{stratum}}"></div>

                        <div class="ciValue ciValue_{{stratum}}"></div>
                    </div>
                </div>

                <div class="col-md-4 col-sm-3">
                </div>
            </div>
        </div>

        <div class="col-sm-2 col-xs-12 vcenter burden-test-btn-wrapper">
            {{{singleRunButtonDisplay}}}
        </div>

    </div>
</div>
</script>


%{--Choose the phenotype and stratification options. Currently the top section in the interface--}%
<script id="chooseDataSetAndPhenotypeTemplate"  type="x-tmpl-mustache">
    <div class="panel panel-default">%{--should hold the Choose data set panel--}%

        <div class="panel-heading">
            <h4 class="panel-title">
                <a>Step 1: Select a phenotype to test for association</a>
            </h4>
        </div>

        <div id="chooseSamples" class="panel-collapse collapse in">
            <div class="panel-body secBody">

                <div class="row secHeader" style="display:none">
                    <div class="col-sm-12 col-xs-12 text-left"><label>Dataset</label></div>
                </div>

                <div class="row">
                    <div class="col-sm-12 col-xs-12">
                        <p>
                            The Genetic Association Interactive Tool (GAIT) allows you to compute custom association statistics for this variant by specifying a phenotype to test,
                            a subset of samples, and a collection of covariates. GAIT queries the 17K exome sequence analysis data set. In order to protect patient privacy,
                            GAIT will only allow visualization or analysis of data from more than 100 individuals.
                        </p>

                    </div>
                </div>

                <div class="row" style="display:none">
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
                                onchange="mpgSoftware.burdenTestShared.retrieveSampleMetadata ($('#datasetFilter'), $('#phenotypeFilter').val(), $('#stratifyDesignation').val() );">
                        </select>
                    </div>
                </div>


                {{ #strataChooser }}
                <div class="row secHeader" style="margin: 20px 0 0 0">
                    <div class="col-sm-12 col-xs-12 text-left"><label>Stratify</label></div>
                </div>

                <div class="row">
                    <div class="col-sm-12 col-xs-12 text-left">
                        <select id="stratifyDesignation" class="stratifyFilter form-control text-left"
                                onchange="mpgSoftware.burdenTestShared.retrieveSampleMetadata  ($('#datasetFilter'), $('#phenotypeFilter').val(), $('#stratifyDesignation').val() );">
                                    <option value="none">none</option>
                                    <option value="origin">ancestry</option>
                        </select>
                    </div>
                </div>
                {{ /strataChooser }}


                <div class="row">
                    <div class="col-sm-12 col-xs-12 text-left">
                        <div class="checkbox" style="margin:0">
                            <label>
                                <input id="caseControlFiltering" type="checkbox" name="caseControlFiltering"
                                       value="caseControlFiltering"/>Filter cases and controls separately
                            </label>
                        </div>
                    </div>
                </div>


            </div>
        </div>

    </div>    %{--end accordion panel for id=chooseSamples--}%
</script>

%{--Handles the filters section, both with and without strata.  Note however that we do not fill in
the individual filters themselves. That work is handled later as part of a loop--}%
<script id="chooseFiltersTemplate"  type="x-tmpl-mustache">
<div class="panel panel-default">%{--should hold the Choose filters panel--}%

            <div class="panel-heading">
                <h4 class="panel-title">
                    <a data-toggle="collapse" data-parent="#filterSamples"
                       href="#filterSamples">Step 2: Select a subset of samples based on phenotypic criteria</a>
                </h4>
            </div>

            <div id="filterSamples" class="panel-collapse collapse">
                <div class="panel-body  secBody">

                    <div class="row">
                        <div class="col-sm-12 col-xs-12">
                            <p>
                                Each of the boxes below enables you to define a criterion for inclusion of samples in your analysis; each criterion is specified as a filter based on a single phenotype.
                                The final subset of samples used will be those that match all of the specified criteria; to omit a criterion leave the text box blank.
                            </p>

                            <p>
                                To guide selection of each criterion, you can click on the arrow to the right of the text box to view the distribution of phenotypic values for the samples currently included
                                in the analysis. The number of samples included, as well as the distributions, will update whenever you modify the value in the text box.
                            </p>
                        </div>
                    </div>


                    <div class="row" style="{{tabDisplay}}">
                        <div class="col-sm-12 col-xs-12">
                            <ul class="nav nav-tabs" id="modeledPhenotypeTabs">
                                {{ #modeledPhenotype }}
                                   {{ #levels }}
                                        <li class="{{defaultDisplay}}">
                                            <a data-target="#{{name}}" data-toggle="tab" class="filterCohort {{val}}">{{name}}</a>
                                                <div class="modelledPhenoIdent">

                                                </div>
                                        </li>
                                   {{ /levels }}
                                {{ /modeledPhenotype }}
                            </ul>
                        </div>
                    </div>



                    <div class="tab-content">
                         {{ #modeledPhenotype }}
                           {{ #levels }}
                            <div class="tab-pane  {{defaultDisplay}}" id="{{name}}">
                                <div class="row">

                                    <div class="row" style="{{tabDisplay}}">
                                        <div class="col-sm-12 col-xs-12">
                                            <ul class="nav nav-tabs" id="{{name}}_stratsTabs">
                                                {{ #strataContent }}
                                                   <li class="{{defaultDisplay}}">
                                                       <a data-target="#{{name}}" data-toggle="tab" class="filterCohort {{trans}}">{{trans}}</a>
                                                       <div class="strataPhenoIdent">
                                                           <div class="phenoCategory  {{phenoName}}" style="display: none">{{category}}</div>
                                                           <div class="phenoInstance  {{phenoLevelName}}" style="display: none">{{val}}</div>
                                                       </div>
                                                   </li>
                                                {{ /strataContent }}
                                                <div class="stratsTabs_property" id="{{name}}_{{strataProperty}}" style="display: none"></div>
                                                <div class="phenoSplitTabs_property" id="{{name}}_{{phenotypeProperty}}" style="display: none"></div>
                                            </ul>
                                        </div>
                                    </div>


                                    <div class="tab-content">
                                        {{ #strataContent }}
                                            <div class="tab-pane {{defaultDisplay}}" id="{{name}}">
                                                <div class="row">
                                                    <div class="col-sm-5 col-xs-12 vcenter" style="margin-top:0">
                                                        <div class="row secHeader" style="padding: 20px 0 0 0">
                                                            <div class="col-sm-6 col-xs-12 text-left"></div>

                                                            <div class="col-sm-6 col-xs-12 text-right"><label
                                                                    style="font-style: italic; font-size: 14px">Click arrows<br/> for distribution
                                                            </label>
                                                            </div>
                                                        </div>

                                                        <div class="row" style="padding: 10px 0 0 0">
                                                            <div class="col-sm-12 col-xs-12 text-left">

                                                                <div style="direction: rtl; height: 320px; padding: 4px 0 0 10px; overflow-y: auto;">
                                                                    <div style="direction: ltr; margin: 10px 0 0 5px">
                                                                        <div>
                                                                            <div class="row">

                                                                               <div class="user-interaction user-interaction-{{name}}">

                                                                                     <div class="filterHolder filterHolder_{{name}}">

                                                                                        {{ >allFiltersTemplate }}

                                                                                     </div>

                                                                                </div>

                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                            </div>
                                                        </div>

                                                    </div>

                                                    <div class="col-sm-7 col-xs-12 vcenter" style="padding: 0; margin: 0">
                                                        <div class="sampleNumberReporter text-center">
                                                            <div>Number of samples included in analysis:<span class="numberOfSamples"></span></div>

                                                            <div style="display:none">number of samples for <span
                                                                    class="phenotypeSpecifier"></span>: <span
                                                                    class="numberOfPhenotypeSpecificSamples"></span></div>
                                                        </div>

                                                        <div class="boxWhiskerPlot boxWhiskerPlot_{{name}}"></div>

                                                    </div>

                                                </div>
                                            </div>
                                        {{ /strataContent }}
                                    </div>




                                </div>
                            </div>
                           {{ /levels }}
                         {{ /modeledPhenotype }}
                    </div>



                </div>
            </div>

        </div>%{--end accordion panel for id=filterSamples--}%
</script>



            <script id="allFiltersTemplate"  type="x-tmpl-mustache">
                            {{ #filterDetails }}
                                {{>filterCategoricalTemplate}}
                                {{>filterFloatTemplate}}
                            {{/filterDetails }}
            </script>

                    <script id="filterFloatTemplate"  type="x-tmpl-mustache">

                                {{ #realValuedFilters }}
                                <div class="row realValuedFilter {{stratum}} considerFilter" id="filter_{{stratum}}_{{name}}">
                                    %{--<div class="col-sm-1">--}%
                                        <input class="utilize" id="use{{name}}" type="checkbox" name="use_{{stratum}}_{{name}}"
                                               value="{{stratum}}_{{name}}" checked style="display: none"/></td>
                                    %{--</div>--}%

                                    <div class="col-sm-6">
                                        <span>{{trans}}</span>
                                    </div>

                                    <div class="col-sm-2">
                                        <select id="cmp_{{stratum}}_{{name}}" class="form-control filterCmp"
                                                data-selectfor="{{stratum}}_{{name}}Comparator"
                                               onchange="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',0,'{{phenoLevelName}}')">
                                            <option value="1">&lt;</option>
                                            <option value="2">&gt;</option>
                                        </select>
                                    </div>

                                    <div class="col-sm-3">
                                        <input id="inp_{{stratum}}_{{name}}" type="text" class="filterParm form-control"
                                               data-type="propertiesInput"
                                               data-prop="{{stratum}}_{{name}}Value" data-translatedname="{{stratum}}_{{name}}"
                                               onfocusin="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',0,'{{phenoLevelName}}')"
                                               onkeyup="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',0,'{{phenoLevelName}}')">

                                    </div>

                                    <div class="col-sm-1">
                                        <span onclick="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',0,'{{phenoLevelName}}')"
                                              class="glyphicon glyphicon-arrow-right pull-right distPlotter" id="distPlotter_{{stratum}}_{{name}}"></span>
                                    </div>

                                </div>
                                {{ /realValuedFilters }}
                    </script>

                    <script id="filterCategoricalTemplate" type="x-tmpl-mustache">
                                {{ #categoricalFilters }}
                                <div class="row categoricalFilter considerFilter {{stratum}}" id="filter_{{stratum}}_{{name}}">
                                   %{-- <div class="col-sm-1">--}%
                                        <input class="utilize" id="use_{{stratum}}_{{name}}" type="checkbox" name="use_{{stratum}}_{{name}}"
                                               value="{{stratum}}_{{name}}" checked  style="display: none"/></td>
                                   %{-- </div>--}%

                                    <div class="col-sm-6">
                                        <span>{{trans}}</span>
                                    </div>


                                    <div class="col-sm-5">
                                        <select id="multi_{{stratum}}_{{name}}" class="form-control multiSelect"
                                                data-selectfor="{{stratum}}_{{name}}FilterOpts" multiple="multiple"
                                                onfocusin="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',1,'{{phenoLevelName}}')">
                                        </select>

                                    </div>

                                    <div class="col-sm-1">
                                        <span onclick="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',1,'{{phenoLevelName}}')"
                                              class="glyphicon glyphicon-arrow-right pull-right"  id="distPlotter_{{stratum}}_{{name}}"></span>
                                    </div>

                                </div>
                                {{ /categoricalFilters }}
                    </script>

                    <script id="filterStringTemplate" type="x-tmpl-mustache">
                                <p><span>str name={{name}},type={{type}}</span></p>
                    </script>



<script id="chooseCovariatesTemplate"  type="x-tmpl-mustache">
        <div class="panel panel-default">%{--should hold the initiate analysis set panel--}%

            <div class="panel-heading">
                <h4 class="panel-title">
                    <a data-toggle="collapse" data-parent="#initiateAnalysis_{{stratum}}"
                       href="#initiateAnalysis_{{stratum}}">Step 3: Control for covariates</a>
                </h4>
            </div>


            <div id="initiateAnalysis_{{stratum}}" class="panel-collapse collapse">
                <div class="panel-body secBody">

                    <div class="row">
                        <div class="col-sm-12 col-xs-12">
                            <p>
                                Select principal components and/or phenotypes to be used as covariates in your association analysis. Principal
                                components 1-4 are selected by default to minimize the influence of ancestry, though additional principal components
                                may be selected to control for finer grained substructure within a population. Selecting phenotypes as covariates
                                allows you to estimate the effects of the response phenotype independently of the covariate phenotypes.
                            </p>
                        </div>
                    </div>


                    <div class="row"  style="{{tabDisplay}}">
                        <div class="col-sm-12 col-xs-12">
                            <ul class="nav nav-tabs" id="stratsCovTabs">
                                {{ #strataContent }}
                                   <li class="{{defaultDisplay}}"><a data-target="#cov_{{name}}" data-toggle="tab" class="covariateCohort {{name}}">{{trans}}</a></li>
                                {{ /strataContent }}
                            </ul>
                        </div>
                    </div>

                    <div class="tab-content">
                        {{ #strataContent }}
                            <div class="tab-pane {{defaultDisplay}}" id="cov_{{name}}">

                                <div class="row">
                                    <div class="col-sm-8 col-xs-12 vcenter covariate_holder">
                                        <div class="covariates">
                                            <div class="row">
                                                <div class="col-md-10 col-sm-10 col-xs-12 vcenter" style="margin-top:0">

                                                    <div class="covariateHolder covariateHolder_{{name}}">
                                                        {{ >allCovariateSpecifierTemplate }}
                                                    </div>

                                                </div>

                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-sm-6 col-xs-12">
                                    </div>
                                 </div>
                            </div>
                        {{ /strataContent }}
                    </div>

                </div>
            </div>

        </div>%{--end id=initiateAnalysis panel--}%
</script>


        <script id="allCovariateSpecifierTemplate"  type="x-tmpl-mustache">
                                {{ #covariateDetails }}
                                <div class="row">
                                   <div class="col-sm-6">
                                   {{>covariateTemplateC1}}
                                   </div>
                                   <div class="col-sm-6">
                                   {{>covariateTemplateC2}}
                                   </div>
                                </div>
                                {{ /covariateDetails }}

        </script>


                <script id="covariateTemplateC1"  type="x-tmpl-mustache">
                                    {{ #covariateSpecifiersC1 }}
                                    <div class="row">
                                        <div class="checkbox" style="margin:0">
                                            <label>
                                                <input id="covariate_{{stratum}}_{{name}}" class="covariate" type="checkbox" name="covariate"
                                                       value="{{name}}" {{defaultCovariate}} onchange="mpgSoftware.burdenTestShared.carryCovChanges('{{name}}', '{{stratum}}')"/>
                                                {{trans}}
                                            </label>
                                        </div>
                                    </div>
                                    {{ /covariateSpecifiersC1 }}
                </script>

                <script id="covariateTemplateC2"  type="x-tmpl-mustache">
                                    {{ #covariateSpecifiersC2 }}
                                    <div class="row">
                                        <div class="checkbox" style="margin:0">
                                            <label>
                                                <input id="covariate_{{stratum}}_{{name}}" class="covariate" type="checkbox" name="covariate"
                                                       value="{{name}}" {{defaultCovariate}} onchange="mpgSoftware.burdenTestShared.carryCovChanges('{{name}}', '{{stratum}}')"/>
                                                {{trans}}
                                            </label>
                                        </div>
                                    </div>
                                    {{ /covariateSpecifiersC2 }}
                </script>







