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
.filterCmp {
    padding: 0;
    font-size: 11px;
}
#gaitButtons a.dt-button{
    padding: 0 10px 0 10px;
}
input[type=checkbox][disabled] + label {
    color: #ccc;
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
//    background: #eee;
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

.stratsTabs a.filterCohort {
    margin-bottom: -3px;
    margin-right: 5px;
    border-top: solid 1px black;
    border-left: solid 1px black;
    border-right: solid 1px black;
    border-radius: 4px 4px 0px 0px;
}

.stratsTabs li.active {
    border-radius: 4px 4px 0px 0px;
    margin-right: 5px;
    /*border-top: solid 1px black;*/
    /*border-left: solid 1px black;*/
    /*border-right: solid 1px black;*/
}
.filterCohort {
    cursor: pointer;you
}
.stratsTabs a.filterCohort.ALL {
    margin-bottom: -3px;
    margin-right: 5px;
    border-top: solid 2px black;
    border-left: solid 2px black;
    border-right: solid 2px black;
    border-radius: 4px 4px 0px 0px;
}
.stratsTabs a.filterCohort.ALL:hover {
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
   // background-color: #eee;
}
div.burden-test-wrapper-options {
    //background-color: #eee;
    font-size: 16px;
    padding: 0;
}
div.burden-test-wrapper-options .row {
    margin: 0 0 1px 0;
}
div.burden-test-btn-wrapper {
    padding: 0px 10px 25px 10px;
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
    font-size: 14px;
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
span.metaAnalysis {
    font-size: 18px;
}
span.stratumName.meta {
    font-size: 20px;
}
.strat1.strataHolder {
    font-size: 18px;
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
                delayedBurdenDataPresentation = {functionToRun: mpgSoftware.geneInfo.fillUpBarChart,
                    barchartPtr: retainBarchartPtr,
                    launch: function () {
                        retainBarchartPtr = mpgSoftware.geneInfo.fillUpBarChart(caseNumerator, caseDenominator, controlNumerator, controlDenominator, traitName);
                        return retainBarchartPtr;
                    },
                    removeBarchart: function () {
                        if ((typeof retainBarchartPtr !== 'undefined') &&
                            (typeof retainBarchartPtr.clear !== 'undefined')) {
                            retainBarchartPtr.clear('T2D');
                        }
//                        $('#significanceDescriptorFormatter').empty();
//                        $('#possibleCarrierVariantsLink').empty();
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

    mpgSoftware.gaitBackgroundData = (function () {

        var fillVariantOptionFilterDropDown = function ( burdenProteinEffectFilterName ){
            var burdenProteinEffectFilter = burdenProteinEffectFilterName;
            var promise =  $.ajax({
                    cache: false,
                    type: "post",
                    url: "${createLink(controller:'gene',action: 'burdenTestVariantSelectionOptionsAjax')}",
                    data: {},
                    async: true
                });
                promise.done(
                 function (data) {
                       if ((typeof data !== 'undefined') && (data)){
                               //first check for error conditions
                                if (!data){
                                    console.log('null return data from burdenTestVariantSelectionOptionsAjax');
                                } else if (data.is_error) {
                                    console.log('burdenTestAjax returned is_error ='+data.is_error +'.');
                                }
                                else if ((typeof data.options === 'undefined') ||
                                         (data.options.length <= 0)){
                                     console.log('burdenTestAjax returned undefined (or length = 0) for options.');
                               }else {
                                   var optionList = data.options;
                                   var dropDownHolder = $(burdenProteinEffectFilter);
                                   for ( var i = 0 ; i < optionList.length ; i++ ){
                                        dropDownHolder.append('<option value="'+optionList[i].id+'">'+optionList[i].name+'</option>')
                                   }
                                }
                            }

                    });
                    promise.fail() ;
        }; // fillFilterDropDown


        return {
            // public routines
            fillVariantOptionFilterDropDown: fillVariantOptionFilterDropDown
        }
    }());

    mpgSoftware.burdenTestShared = (function () {
        var loading = $('#rSpinner');
        var storedSampleMetadata;
        var minimumNumberOfSamples = 100;
        var portalTypeWithAncestry = true;
        var geneForGaitStr = '';
        <g:if test="${g.portalTypeString()?.equals('stroke')}">
        portalTypeWithAncestry = false;
        </g:if>





 /***
 *  Get sample data from our local storage.  This routine presumably disappears in v0.2
 * @returns {*}
 */

var displayBurdenVariantSelector = function (){
     return true;
 };



 var storeGeneForGait = function (geneForGaitStr){
     geneForGait = geneForGaitStr;
 };


 var getGeneForGait  = function (){
     return geneForGait;
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
    }  else if (untranslatedPhenotype === 'CHOL'){
       convertedName = 'CHOL_ANAL';
    } else if (untranslatedPhenotype === 'DBP'){
       convertedName = 'DBP_ANAL';
    } else if (untranslatedPhenotype === 'SBP'){
       convertedName = 'SBP_ANAL';
    } else if (untranslatedPhenotype === 'FAST_GLU'){
       convertedName = 'FAST_GLU_ANAL';
    } else if (untranslatedPhenotype === 'FAST_INS'){
       convertedName = 'FAST_INS_ANAL';
    } else if (untranslatedPhenotype === 'HDL'){
       convertedName = 'HDL_ANAL';
    } else if (untranslatedPhenotype === 'LDL'){
       convertedName = 'LDL_ANAL';
    } else if (untranslatedPhenotype === 'TG'){
       convertedName = 'TG_ANAL';
    }else if (untranslatedPhenotype === 'Admission_CT_Available'){
       convertedName = 'Admission_CT_Available';
    }else if (untranslatedPhenotype === 'Aspirin'){
       convertedName = 'Aspirin';
    }else if (untranslatedPhenotype === 'Coronary_Artery_Disease'){
       convertedName = 'Coronary_Artery_Disease';
    }else if (untranslatedPhenotype === 'Deep_ICH'){
       convertedName = 'Deep_ICH';
    }else if (untranslatedPhenotype === 'Discharge_mRS_gt_2'){
       convertedName = 'Discharge_mRS_gt_2_readable';
    }else if (untranslatedPhenotype === 'Ethnicity'){
       convertedName = 'Ethnicity_readable';
    }else if (untranslatedPhenotype === 'Follow_up_mRS_gt_2'){
       convertedName = 'Follow_up_mRS_gt_2_readable';
    }else if (untranslatedPhenotype === 'Hemorrhage_Location'){
       convertedName = 'Hemorrhage_Location_readable';
    }else if (untranslatedPhenotype === 'History_of_Diabetes_mellitus'){
       convertedName = 'History_of_Diabetes_mellitus_readable';
    }else if (untranslatedPhenotype === 'History_of_Hypercholesterolemia'){
       convertedName = 'History_of_Hypercholesterolemia_readable';
    }else if (untranslatedPhenotype === 'History_of_Hypertension'){
       convertedName = 'History_of_Hypertension_readable';
    }else if (untranslatedPhenotype === 'History_of_TIA_Ischemic_Stroke'){
       convertedName = 'History_of_TIA_Ischemic_Stroke_readable';
    }else if (untranslatedPhenotype === 'ICH_Status'){
       convertedName = 'ICH_Status_readable';
    }else if (untranslatedPhenotype === 'INR_gt_2'){
       convertedName = 'INR_gt_2_readable';
    }else if (untranslatedPhenotype === 'Lobar_ICH'){
       convertedName = 'Lobar_ICH_readable';
    }else if (untranslatedPhenotype === 'MRI_Available'){
       convertedName = 'MRI_Available_readable';
    }else if (untranslatedPhenotype === 'Number_of_Previous_Hemhorrhages'){
       convertedName = 'Number_of_Previous_Hemhorrhages_readable';
    }else if (untranslatedPhenotype === 'Other_Antiplatelet'){
       convertedName = 'Other_Antiplatelet_readable';
    }else if (untranslatedPhenotype === 'Race'){
       convertedName = 'Race_readable';
    }else if (untranslatedPhenotype === 'SEX'){
       convertedName = 'SEX_readable';
    }else if (untranslatedPhenotype === 'Statins'){
       convertedName = 'Statins_readable';
    }else if (untranslatedPhenotype === 'Warfarin_readable'){
       convertedName = 'Warfarin';
    }
    return convertedName;
 };

 var undoConversionPhenotypeNames  = function (untranslatedPhenotype){
    var convertedName = untranslatedPhenotype;
    if (untranslatedPhenotype === 'T2D_readable'){
       convertedName = 't2d';
    } else if (untranslatedPhenotype === 'CASE'){
       convertedName = 'Yes';
    } else if (untranslatedPhenotype === 'CONTROL'){
       convertedName = 'No';
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
            var strataChooserMarker = [];
            if (portalTypeWithAncestry){
                strataChooserMarker.push(1);
            }

            // build the top of the GAIT display
            $("#chooseDataSetAndPhenotypeLocation").empty().append(Mustache.render( $('#chooseDataSetAndPhenotypeTemplate')[0].innerHTML,
                                    {strataChooser:strataChooserMarker,
                                    sectionNumber:1}));

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

                     refreshGaitDisplay ('#datasetFilter', '#phenotypeFilter', '#stratifyDesignation', '#caseControlFiltering');
                     displayTestResultsSection(false);
                     $('.caatSpinner').hide();

                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });



        };


        var refreshGaitDisplay = function (datasetFilter, phenotypeFilter,stratifyDesignation,caseControlDesignator) {
            var sampleMetadata = getStoredSampleMetadata();
            var phenotypeFilterValue = $(phenotypeFilter).val();
            var stratifyDesignationValue = $(stratifyDesignation).val();
            var convertedPhenotypeNames = convertPhenotypeNames(phenotypeFilterValue); // when phenotypes have been harmonized the step will be unnecessary...
            var filterDetails = _.find(sampleMetadata.filters,function(o){return o.name===convertedPhenotypeNames||o.name===phenotypeFilterValue;})
            if (typeof filterDetails !== 'undefined'){
                if (filterDetails.type === 'FLOAT') { // no case control switches in a real valued phenotype
                    $(caseControlDesignator).prop('checked', false);
                    $(caseControlDesignator).prop('disabled', true);
                } else {
                    $(caseControlDesignator).prop('disabled', false);
                }
            }
            //populateSampleAndCovariateSection($(datasetFilter), phenotypeFilterValue, stratifyDesignationValue, sampleMetadata.filters);
            $('#stratsTabs').empty();
            var caseControlFiltering = $('#caseControlFiltering').prop('checked');
            stratifiedSampleAndCovariateSection($(datasetFilter), phenotypeFilterValue, stratifyDesignationValue,  sampleMetadata.filters, caseControlFiltering);
            displayTestResultsSection(false);
        };


        /***
        *   We need to clone filter definitions so that we can change them and then pass them to mustache
        * @param incomingDefinition
        * @returns {{name: *, trans: (*|string), type: *}}
        */
        var filterDefinition = function (incomingDefinition){
            var returnValue = { name:incomingDefinition.name,
                                trans:incomingDefinition.trans,
                                type:incomingDefinition.type };
            if(typeof incomingDefinition.levels !== 'undefined'){
                returnValue['levels'] = [];
                _.forEach(incomingDefinition.levels, function(level){
                    returnValue['levels'].push({name:level.name, samples:level.samples});
                });
            }
            return returnValue;
        };



        /***
        *  Build the UI widgets which can be used to specify the filters for DAGA.  Once they are in place
        *  we can use fillCategoricalDropDownBoxes to create plots.
        *
        */
        var stratifiedSampleAndCovariateSection = function (dataSetId, phenotype, strataProperty, filterInfo, caseControlFiltering) {
            var stratumName;
            var multipleStrataExist = ((strataProperty !== 'none')&&( typeof strataProperty !== 'undefined'));
            if (!multipleStrataExist){
               stratumName = 'strat1';
            }


            var generateFilterRenderData = function(dataFilters,optionsPerFilter,stratumName, phenotype, strataCategory){
                var returnValue = {};
                if ( ( typeof dataFilters !== 'undefined' ) &&
                             (  dataFilters !==  null ) ) {
                    var categoricalFilters = [];
                    var realValuedFilters = [];
                    _.forEach(dataFilters,function(d,i){
                        var clonedFilter = new filterDefinition(d);
                        if (clonedFilter.type === 'FLOAT') {
                            if (convertPhenotypeNames(clonedFilter.name)===phenotype) {
                                clonedFilter['bold'] = "font-weight: bold";
                            }
                            realValuedFilters.push(clonedFilter);
                        } else {
                            var unconvertedPhenotype = undoConversionPhenotypeNames(clonedFilter.name);
                            if ((unconvertedPhenotype!==phenotype) &&(unconvertedPhenotype!=strataCategory)){ // categorical traits are displayed only if they are not the modeled phenotype AND we aren't stratifying on it
                                if ((optionsPerFilter[clonedFilter.name]!==undefined)&&
//                                    (optionsPerFilter[clonedFilter.name].length<3)&&
                                    (clonedFilter.name!==phenotype)){
                                        categoricalFilters.push(clonedFilter);
                                }
                            }
                        }

                    });
                    // put selected filter first.  Shouldn't there be a lodash function for this?
                    var sortedRealValuedFilters = [];
                    var phenoIndex = -1;
                    for( var i = 0 ; i < realValuedFilters.length ; i++ ){
                        if (convertPhenotypeNames(realValuedFilters[i].name) ===  phenotype) {
                            phenoIndex = i;
                            break;
                        }
                    }
                    if (phenoIndex>-1){
                        sortedRealValuedFilters.push(realValuedFilters[phenoIndex]);
                    }
                    for( var i = 0 ; i < realValuedFilters.length ; i++ ){
                        if(i!==phenoIndex){
                            sortedRealValuedFilters.push(realValuedFilters[i]);
                        }
                    }
                    returnValue = {
                        categoricalFilters: categoricalFilters,
                        realValuedFilters: sortedRealValuedFilters,
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



            var generateModeledPhenotypeElements = function ( optionsPerFilter, phenotype, caseControlFiltering, strataContentArray ){
                var modeledPhenotypeElements;
                var modeledPhenotype;
                if (caseControlFiltering){
                     modeledPhenotype = optionsPerFilter[convertPhenotypeNames(phenotype)];
                } else {
                    modeledPhenotype = [{name:"strata1",sample:999}];
                }
                if ((typeof modeledPhenotype !== 'undefined' ) && (modeledPhenotype.length>0)){
                    _.forEach(strataContentArray[0], function(strataContentElement){
                        strataContentElement["phenoName"] = convertPhenotypeNames(phenotype);
                    });
                    modeledPhenotypeElements = {name:convertPhenotypeNames(phenotype),
                                                phenoName:convertPhenotypeNames(phenotype),
                                                val:phenotype,
                                                strataContent: strataContentArray,
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
                        var modeledPhenotypeElementsLevelsCount = modeledPhenotypeElements.levels.length;
                        modeledPhenotypeElements.levels.push(
                                                    {   name:convertPhenotypeNames(phenotypeLevel.name),
                                                        phenoLevelName:convertPhenotypeNames(phenotypeLevel.name),
                                                        phenoLevelVal:phenotypeLevel.name,
                                                        val:phenotypeLevel.name,
                                                        samples:phenotypeLevel.samples,
                                                        category:convertPhenotypeNames(phenotype),
                                                        strataContent: currentStrataContent,
                                                        defaultDisplay: defaultDisplay,
                                                        firstPhenotypeModelLevel: function(){if (modeledPhenotypeElementsLevelsCount===0){return '';} else {return 'display:none';}},
                                                        undisplayedPhenotypeModelLevel: function(){if (modeledPhenotypeElementsLevelsCount===0){return '';} else {return 'display:none';}} }
                        );
                        defaultDisplay = '';
                    });
                }
            //}
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
                    var allPropertyIndex = _.findIndex(stratificationProperty, function(o) { return o.name== 'ALL'; });
                    if (allPropertyIndex === -1) { // we need an artificial strata to hold everything. However, don't insert it more than once!
                        stratificationProperty.splice(0,0,{name:'ALL',val:'ALL',samples:totalSamples, category:convertPhenotypeNames(strataProperty)});
                    }
                } else {
                     stratificationProperty = [{name:stratumName, val:stratumName, category:convertPhenotypeNames(phenotype) }];
                }
                return stratificationProperty;
            };



             var generateStrataContent = function(optionsPerFilter,stratificationProperty, phenotype, specificsAboutFilters, specificsAboutCovariates, multipleStrataExist){
                var strataContent = [];
                var strataCategory;
                if ((multipleStrataExist)  &&
                    (stratificationProperty) &&
                    (stratificationProperty.length>0)) {
                    strataCategory = stratificationProperty[0].category;
                }
                if (multipleStrataExist){
                    _.forEach(stratificationProperty,function(stratumHolder){
                       var stratum=stratumHolder.name;
                       var category=stratumHolder.category;
                       var val=stratumHolder.val;
                       strataContent.push({  name:stratum,
                                                        trans:stratum,
                                                        stratumName:stratum,
                                                        val:val,
                                                        category:category,
                                                        count:strataContent.length,
                                                        filterDetails:generateFilterRenderData(specificsAboutFilters,optionsPerFilter,stratum, phenotype,strataCategory),
                                                        covariateDetails:generateCovariateRenderData(specificsAboutCovariates,phenotype,stratum)});
                     });
                } else {
                   strataContent = [{name:'strat1',trans:'strat1',category:'strat1',count:0,
                                                        filterDetails:generateFilterRenderData(specificsAboutFilters,optionsPerFilter, 'strat1', phenotype,strataCategory),
                                                        covariateDetails:generateCovariateRenderData(specificsAboutCovariates,phenotype, 'strat1' ) }];

                }
                return strataContent;
            };



            // For each strata create the necessary data. Handle the case of a single strata as a special case.
            var generateRenderData = function(optionsPerFilter,strataProperty,stratificationProperty, phenotype, specificsAboutFilters, specificsAboutCovariates, modeledPhenotype){

                var defaultDisplayString  = '';
                var tabDisplayString;
                var displayBurdenVariantSelectorString = (displayBurdenVariantSelector())?[1]:[];
                if (!multipleStrataExist){
                    defaultDisplayString  = ' active';
                    tabDisplayString  = ' display: none';
                }

                var renderData  = {
                    strataProperty:strataProperty,
                    phenotypeProperty:convertPhenotypeNames(phenotype),
                    defaultDisplay : defaultDisplayString,
                    tabDisplay:tabDisplayString,
                    modeledPhenotype:modeledPhenotype,
                    modeledPhenotypeDisplay: function(){
                                    if ( ( typeof modeledPhenotype === 'undefined') ||
                                        (modeledPhenotype.levels.length<2)) {
                                        return 'display: none';
                                    } else {
                                        return '' ;
                                    }
                    },
                    displayBurdenVariantSelector:displayBurdenVariantSelectorString,
                    sectionNumber: 0
                };

                return renderData;
            };


            var sampleMetadata = getStoredSampleMetadata();
            if ( ( sampleMetadata !==  null ) &&
                 ( typeof sampleMetadata !== 'undefined') ){

                    var optionsPerFilter = generateOptionsPerFilter(filterInfo) ;
                    var stratificationProperty = generateNamesOfStrata(multipleStrataExist, optionsPerFilter, strataProperty, phenotype);
                    var strataContent1 = generateStrataContent(optionsPerFilter,stratificationProperty, phenotype, sampleMetadata.filters, sampleMetadata.covariates, multipleStrataExist);
                    var strataContent2 = generateStrataContent(optionsPerFilter,stratificationProperty, phenotype, sampleMetadata.filters, sampleMetadata.covariates, multipleStrataExist);
                    var modeledPhenotypeElements = generateModeledPhenotypeElements(optionsPerFilter, phenotype, caseControlFiltering, [strataContent1,strataContent2] );
                    var renderData = generateRenderData(optionsPerFilter,strataProperty,stratificationProperty, phenotype, sampleMetadata.filters, sampleMetadata.covariates, modeledPhenotypeElements);


                    $("#chooseFiltersLocation").empty();
                    $("#chooseCovariatesLocation").empty();



                    //
                    //  display the variant selection filtering tools
                    //
                    if (getGeneForGait().length>0){
                        renderData.sectionNumber++;
                        $("#chooseVariantFilterSelection").empty().append(Mustache.render( $('#variantFilterSelectionTemplate')[0].innerHTML,renderData));
                        mpgSoftware.gaitBackgroundData.fillVariantOptionFilterDropDown('#burdenProteinEffectFilter');
                        mpgSoftware.burdenTestShared.generateListOfVariantsFromFilters();
                     }



                    //
                    // set up the section where the filters will go
                    //
                    renderData.sectionNumber++;
                    $("#chooseFiltersLocation").empty().append(Mustache.render( $('#chooseFiltersTemplate')[0].innerHTML,renderData,
                                                                                {   allFiltersTemplate: $('#allFiltersTemplate')[0].innerHTML,
                                                                                    filterFloatTemplate:$('#filterFloatTemplate')[0].innerHTML,
                                                                                    filterCategoricalTemplate:$('#filterCategoricalTemplate')[0].innerHTML }));
                   if  ((typeof renderData.modeledPhenotype  !== 'undefined')  &&
                        (typeof renderData.modeledPhenotype.levels  !== 'undefined') &&
                        ( renderData.modeledPhenotype.levels.length > 0)){
                    _.forEach(renderData.modeledPhenotype.levels,function(level){
                          $('a[data-toggle="tab"].'+level.name).on('shown.bs.tab', function (e) {
                            var target = $(e.target).text(); // activated tab
                            displaySampleDistribution('ID',"_"+target,0,level.name);
                        });
                    });
                   } else {
                      $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                        var target = $(e.target).text(); // activated tab
                        displaySampleDistribution('ID',"_"+target,0,'');
                    });
                   }



                    //
                    // set up the section where the covariates will go
                    //
                    renderData.sectionNumber++;
                    $("#chooseCovariatesLocation").empty().append(Mustache.render( $('#chooseCovariatesTemplate')[0].innerHTML,renderData,
                                                                                {   allCovariateSpecifierTemplate: $('#allCovariateSpecifierTemplate')[0].innerHTML,
                                                                                    covariateTemplateC1:$('#covariateTemplateC1')[0].innerHTML,
                                                                                    covariateTemplateC2:$('#covariateTemplateC2')[0].innerHTML }));

                    // we only need to display one image, shared between cases and controls
                     _.forEach(stratificationProperty,function(stratumHolder){
                        var stratumName=stratumHolder.name;

                        $('.sampleNumberReporter').show();

                         // filters should be in place now.  Attach events
                         _.forEach(sampleMetadata.filters,function(d){
                              $("#multi_"+stratumName+"_"+d.name).bind("change", function(event, ui){
                                   mpgSoftware.burdenTestShared.displaySampleDistribution(d.name, '.boxWhiskerPlot_'+stratumName,0)
                              });
                         });


                        _.forEach(renderData.modeledPhenotype.levels,function(modPhenoHolder){

                            fillCategoricalDropDownBoxes({},phenotype,stratumName,modPhenoHolder.name,optionsPerFilter);

                        });

                    });

                    // Create a default display
                    $($('.distPlotter')[0]).click()

                    //
                    // display the results section
                    //
                    renderData.sectionNumber++;
                    $("#displayResultsLocation").empty().append(Mustache.render( $('#displayResultsTemplate')[0].innerHTML,renderData));

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




        var convertBifurcatedFiltersIntoArraysOfStrings = function(filterKey,filterGrouping){
           var filterStrings = [];
           var sampleMetadata = getStoredSampleMetadata();
           var optionsPerFilter = generateOptionsPerFilter(sampleMetadata.filters) ;
           _.forEach( extractFilters(filterKey,filterGrouping), function(filterObject){
               var oneFilter = [];
               var lastFilterName;
               var lastFilterParms = [];
               _.forEach( filterObject, function(value, key){
                   if (typeof value !== 'undefined'){
                        if (key==="cat"){
                            oneFilter.push("\""+key+"\": \""+value+"\"");
                        }else{
                            var propName;
                            var divider = value.indexOf('_');
                            if (divider>-1){
                                propName = value.substr(divider+1,value.length-divider);
                            } else {
                                propName = value;
                           }
                            if (key==="name"){
                                lastFilterName = propName;
                            } else if (key==="parm"){
                                lastFilterParms = propName
                            }
                            oneFilter.push("\""+key+"\": \""+propName+"\"");

                        }
                    }
                });
                // if every filter is checked then there is no need to add it
                var optionForFilter = optionsPerFilter[lastFilterName];
                var numberOfFilterOptions = ((lastFilterParms)?lastFilterParms:[]);
                if (!((optionForFilter)&&
                    ((optionForFilter.length==numberOfFilterOptions.length)||
                     (lastFilterParms.length===0)))){
                    filterStrings.push("{"+oneFilter.join(",\n")+"}");
                }

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



        var compoundingStrataFilterValues = function ( arrayOfFilterArrays ){
           var arrayOfArrayOfFilters = [];
           var filterStrings = [];
           var strataPropertyName = "";
           var stratumName = "";
            _.forEach( arrayOfFilterArrays, function(oneSetOfKeys){
                    var phenoPropertyName = oneSetOfKeys.phenoPropertyName;
                    var phenoPropertyNameExtracted;
                    var phenoPropertyInstanceExtracted;
                    var stratumPropertyNameExtracted;
                    if (phenoPropertyName.indexOf('_') > 0){
                         phenoPropertyInstanceExtracted = phenoPropertyName.substr(0,phenoPropertyName.indexOf('_'));
                         phenoPropertyNameExtracted = phenoPropertyName.substr(phenoPropertyName.indexOf('_')+1);
                    }
                    stratumName = oneSetOfKeys.stratumName;
                    strataPropertyName = oneSetOfKeys.strataPropertyName;
                    if (strataPropertyName.indexOf('_') > 0){
                         stratumPropertyNameExtracted = strataPropertyName.substr(strataPropertyName.indexOf('_')+1);
                    }
                    var arraysOfStrings = convertBifurcatedFiltersIntoArraysOfStrings(oneSetOfKeys.stratumName,phenoPropertyInstanceExtracted);
                    if (phenoPropertyInstanceExtracted !== 'strata1' ) { // placeholder implying we have no phenotype grouping
                        arraysOfStrings.push("{\"name\":\""+phenoPropertyNameExtracted+"\",\n\"parm\":\""+undoConversionPhenotypeNames(phenoPropertyInstanceExtracted)+"\",\n\"cmp\":\"3\",\n\"cat\":\"1\"}");
                    }
                    if ((stratumName !== 'strat1' )&&(stratumName !== 'ALL')) { // placeholder implying we have no strata
                        arraysOfStrings.push("{\"name\":\""+stratumPropertyNameExtracted+"\",\n\"parm\":\""+stratumName+"\",\n\"cmp\":\"3\",\n\"cat\":\"1\"}");
                    }
                   arrayOfArrayOfFilters.push(arraysOfStrings);
            });
            _.forEach( arrayOfArrayOfFilters, function(arrayOfFilters){
                    filterStrings.push("["+arrayOfFilters.join(",\n")+"]");
            } );
           return {
                strataPropertyName: strataPropertyName,
                stratumName: stratumName,
                strataFilters : "[\n" + filterStrings.join(",") + "\n]"
           };
           ;
        };



        /***
        *   pull all of the filters out of the Dom and put them into a JSON string suitable for transmission to the server
        *
        */
        var collectingFilterValues = function (additionalKey,additionalValue,alternateValue,modeledPropertyName,modeledPropertyInstance,modeledPropertyInstanceRaw){
           var filterStrings = [];
           var searchValue = additionalValue;
           if(typeof alternateValue !== 'undefined') {
                searchValue = alternateValue;
           }
           _.forEach( extractFilters(searchValue,modeledPropertyInstanceRaw), function(filterObject){
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
                    (additionalValue !== 'ALL')&&
                    (additionalValue !== modeledPropertyInstanceRaw)) {
                           var convertedAdditionalKey = additionalKey;
                           var divider = additionalKey.indexOf('_');
                           if (divider>-1){
                               convertedAdditionalKey = additionalKey.substr(divider+1);
                           }
                  filterStrings.push("{\"name\": \""+convertedAdditionalKey+"\","+
"\"parm\": \""+additionalValue+"\","+
"\"cmp\": \"3\",\"cat\": \"1\"}");
           }
           if ((typeof modeledPropertyName !== 'undefined') &&
                   (modeledPropertyName.length > 0) &&
                   (typeof modeledPropertyInstance !== 'undefined') &&
                   (modeledPropertyInstance.length > 0)&&
                   (modeledPropertyInstance!=='strata1')) {
                  filterStrings.push("{\"name\": \""+modeledPropertyName+"\","+
"\"parm\": \""+modeledPropertyInstance+"\","+
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
            var phenoPropertyName = _.find( $('div.phenoSplitTabs_property'), function(o){
                var id = $(o).attr("id");
                return (id.indexOf(modeledPhenotype)>-1);
            });
            var phenoPropertyNameId = $(phenoPropertyName).attr("id");
            phenoPropertyName = phenoPropertyNameId.substr(modeledPhenotype.length+1); // what is the phenotype we are modeling
            var phenoPropertyInstance = phenoPropertyNameId.substr(0,modeledPhenotype.length); // what is the phenotype we are modeling
            // name of 'readable' phenotype property

            var phenoPropertyNameDom = _.find( $('div.phenoRawSplitTabs_property'), function(o){
                var translatedId = convertPhenotypeNames($(o).attr("id"));
                return (translatedId.indexOf(modeledPhenotype)>-1);
            });
            var phenoRawPropertyName = $(phenoPropertyNameDom).attr("id");



            var strataName = '';
            var strataPropertyName = '';
            var phenoPropertySpecifier;
            var phenoInstanceSpecifier;
            if (modeledPhenotype){
                phenoPropertySpecifier = $('a[data-target=#'+params.strataName+'_'+modeledPhenotype+'].'+modeledPhenotype+'+div.strataPhenoIdent div.phenoCategory').text();
                phenoInstanceSpecifier = $('a[data-target=#'+params.strataName+'_'+modeledPhenotype+'].'+modeledPhenotype+'+div.strataPhenoIdent div.phenoInstance').text();
            } else {
                phenoPropertySpecifier = $('a[data-target=#'+params.strataName+']+div.strataPhenoIdent div.phenoCategory').text();
                phenoInstanceSpecifier = $('a[data-target=#'+params.strataName+']+div.strataPhenoIdent div.phenoInstance').text();
            }


            var jsonDescr;
            if (phenoPropertySpecifier === phenoPropertyName){ // this tab specifies an instance of the phenotype we are modeling
                strataPropertyName = phenoPropertyName;
                strataName = phenoInstanceSpecifier;
                jsonDescr = "{\"dataset\":\""+$(dataSetSel).val()+"\"," +
                              "\"requestedData\":"+collectingPropertyNames(params)+"," +
                              "\"filters\":"+collectingFilterValues(strataPropertyName,strataName,params.strataName)+"}";
             } else { // This can only be a strata tab, not a phenotype tab
                strataPropertyName = $('div.stratsTabs_property.'+params.modeledPhenotype).attr("id");
                if (strataPropertyName.indexOf(params.modeledPhenotype+'_')>-1){
                   strataPropertyName = strataPropertyName.substr((params.modeledPhenotype+'_').length);
                }
                strataName=params.strataName;
                var undef;
                jsonDescr = "{\"dataset\":\""+$(dataSetSel).val()+"\"," +
                              "\"requestedData\":"+collectingPropertyNames(params)+"," +
                              "\"filters\":"+collectingFilterValues(strataPropertyName,strataName,undef,phenoPropertyName,phenoRawPropertyName,modeledPhenotype)+"}";
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


          var printFullResultsSection = function(stats,pValue,beta,oddsRatio,ciLevel,ciLower,ciUpper,isDichotomousTrait,currentStratum,additionalText){

                if (currentStratum==='ALL'){// We may have to calculate an ALL stratum, but we don't want to display it
                    return;
                }
                var ciDisplay = '';
                if (!((typeof ciLower === 'undefined') ||
                    (typeof ciUpper === 'undefined') ||
                    (typeof ciLevel === 'undefined'))) {
                   var ciUpper = ciUpper;
                   var ciLower = ciLower;
                   var ciLevel = ciLevel;

                   if (isDichotomousTrait) {
                        ciLower = UTILS.realNumberFormatter(Math.exp(ciLower));
                        ciUpper = UTILS.realNumberFormatter(Math.exp(ciUpper));
                   } else {
                        ciLower = UTILS.realNumberFormatter(ciLower);
                        ciUpper = UTILS.realNumberFormatter(ciUpper);
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
           var listOfVariantsToCheck = [];
           if ($('#gaitTable').children().length>0){ // check that we have a table


                var gaitTableCheckboxes = $($('#gaitTable').DataTable().rows().nodes()).find('td input.geneGaitVariantSelector:checked');
                _.forEach(gaitTableCheckboxes,function(eachVariantId){
                    var gaitTableCheckboxId = $(eachVariantId).attr('id');
                    listOfVariantsToCheck.push('"'+gaitTableCheckboxId.substr(12)+'"');
                });
               }
           return $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller: 'variantInfo', action: 'burdenTestAjax')}",
                data: { variantName: '<%=variantIdentifier%>',
                        variantList: "["+listOfVariantsToCheck.join(',')+"]",
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
                            if (data.error_msg === "Variants must specify chromosome and position as in 10_19436862_G_A. Received: "){ // Replace with a message that make sense for users
                                $('.iatErrorText').text('Error: no valid variants provided for analysis');
                                $('.iatErrorFailure').show();
                            }
                            else { //if (data.error_msg !== "Regression results could not be retrieved"){ // Not a message users need to see
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
                            var ciLevel = data.stats.ciLevel;
                            var ciLower = UTILS.realNumberFormatter(data.stats.ciLower);
                            var ciUpper = UTILS.realNumberFormatter(data.stats.ciUpper);
                            var isCategorical = isCategoricalF (data.stats);
                            var numCases,numControls,numCaseCarriers,numControlCarriers;
                            if (isCategorical){
                                numCases=data.stats.numCases;
                                numControls=data.stats.numControls;
                                numCaseCarriers=data.stats.numCaseCarriers;
                                numControlCarriers=data.stats.numControlCarriers;
                            }

                            var currentStratum = 'stratum'; // 'strat1' marks no distinct strata used
                            if (typeof data.stratum !== 'undefined'){
                               currentStratum = data.stratum;
                            }
                            if (currentStratum==='strat1'){
                                $('.strataResults').empty();
                                $('.strataResults').append('<div class="'+currentStratum+' strataHolder"></div>');
                                var strataDomIdentifierClass = $('.'+currentStratum+'.strataHolder');
                                addStrataSection(strataDomIdentifierClass,currentStratum);
                                strataDomIdentifierClass.append('<div id="chart"></div>')
                                printFullResultsSection(data.stats,pValue,beta,oddsRatio,ciLevel,ciLower,ciUpper,isCategorical,currentStratum,'');
                                if ((typeof numCases !== 'undefined')  && (numCases!=='')){
                                       mpgSoftware.burdenInfo.fillBurdenBiologicalHypothesisTesting(numCaseCarriers, numCases, numControlCarriers, numControls, 'T2D');

                                       // launch
                                       mpgSoftware.burdenInfo.retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter().launch();
                                }
                            } else {
                                var fieldsToStoreInTheDom = '<div class="strataJar">'+
                                                                '<span class="hider stratum '+currentStratum+'">'+currentStratum+'</span>'+
                                                                '<span class="hider pv '+currentStratum+'">'+pValue+'</span>'+
                                                                '<span class="hider be '+currentStratum+'">'+beta+'</span>'+
                                                                '<span class="hider st '+currentStratum+'" >'+stdErr+'</span>';
                                if (isCategorical){
                                    fieldsToStoreInTheDom += ('<span class="hider numCases '+currentStratum+'">'+numCases+'</span>'+
                                                                '<span class="hider numControls '+currentStratum+'">'+numControls+'</span>'+
                                                                '<span class="hider numCaseCarriers '+currentStratum+'">'+numCaseCarriers+'</span>'+
                                                                '<span class="hider numControlCarriers '+currentStratum+'" >'+numControlCarriers+'</span>');
                                }
                                fieldsToStoreInTheDom += ('<span class="hider ciLevel '+currentStratum+'" >'+ciLevel+'</span>'+
                                                            '<span class="hider ciLower '+currentStratum+'" >'+ciLower+'</span>'+
                                                            '<span class="hider ciUpper '+currentStratum+'" >'+ciUpper+'</span>'+
                                                            '<span class="hider ca '+currentStratum+'" >'+(isCategorical?"1":"0")+'</span>'+
                                                            '</div>');
                                $('.strataResults').append(fieldsToStoreInTheDom);

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



            var generateListOfVariantsFromFilters = function (){

             var selectedFilterValue = $('.burdenProteinEffectFilter option:selected').val(),
             selectedFilterValueId = parseInt(selectedFilterValue),
             selectedMafOption = $('input[name=mafOption]:checked').val(),
             selectedMafOptionId =  parseInt(selectedMafOption),
             specifiedMafValue = $('#mafInput').val(),
             specifiedMafValueId  = parseFloat(specifiedMafValue),
             burdenTraitFilterSelectedOption = $('#burdenTraitFilter').val();
              var dataSet =  'samples_17k_mdv2';
               $('#rSpinner').show();
                var promise =  $.ajax({
                    cache: false,
                    type: "post",
                    url: "${createLink(controller: 'gene', action: 'generateListOfVariantsFromFiltersAjax')}",
                    data: {geneName: getGeneForGait(),
                       filterNum: selectedFilterValueId,
                       burdenTraitFilterSelectedOption: burdenTraitFilterSelectedOption,
                       mafValue: specifiedMafValueId,
                       mafOption: selectedMafOptionId,
                       dataSet: dataSet
                     },
                    async: true
                 });
                 promise.done(

                  function (data) {
                  $('#rSpinner').hide();
                    if ((typeof data !== 'undefined') &&
                         (data)){
                         var variantListHolder = [];
                         if ((typeof data.results !== 'undefined') &&
                         (data.results)){
                         var variantListHolder = [];
                             _.forEach(data.results, function(oneVariant){
                                var variant = {};
                                 _.forEach(oneVariant.pVals, function(fieldHolder){
                                    variant[fieldHolder.level] = fieldHolder.count;
                                 });
                                 variantListHolder.push(variant);
                             });
                         }
                         var gaitTable  = $('#gaitTable').DataTable({
                                "select": {
                                    style:    'none',
                                    selector: 'td:first-child'
                                },
                                dom:'<"#gaitButtons"B><"#gaitVariantTableLength"l>rtip',
                               "buttons": [
                                     {
                                        text: 'Select all',
                                        class: 'gaitButtons',
                                        action: function () {
                                            //gaitTable.rows().select();
                                            $(gaitTable.rows().nodes()).find('td input.geneGaitVariantSelector').prop("checked",true);
                                        }
                                    },
                                    {
                                        text: 'Select none',
                                        class: 'gaitButtons',
                                        action: function () {
                                           // gaitTable.rows().deselect();
                                            $(gaitTable.rows().nodes()).find('td input.geneGaitVariantSelector').prop("checked",false);
                                        }
                                    }
                                ],
                                "aLengthMenu":[[10, 50, -1], [10, 50, "All"]],
                                "bDestroy": true,
                                "bAutoWidth" : false,
                                "order": [[ 1, "asc" ]],
                                "columnDefs": [
                                        { "name": "IncludeCheckbox",   "targets": [0],  "type":"checkBoxGait",  "title":"Use?",
                                                    "render": function (data, type, full, meta){
                                                        if ((data)&&(data.indexOf('input')>-1)){
                                                        return data;
                                                        } else {
                                                        return "<input type='checkbox' id='variant_sel_"+data+"' class='geneGaitVariantSelector' checked>";
                                                        }

                                                    },
                                          "bSortable":false,
                                          "width": "50px"

                                        },
                                        { "name": "VAR_ID",   "targets": [1], "type":"allAnchor", "title":"Variant ID",
                                            "width": "auto"  },
                                        { "name": "DBSNP_ID",   "targets": [2], "title":"dbSNP ID",
                                            "width": "auto"  },
                                        { "name": "CHROM",   "targets": [3], "title":"Chrom.",
                                            "width": "40px"  },
                                        { "name": "POS",   "targets": [4], "title":"Position",
                                            "width": "auto" },
                                        { "name": "PolyPhen_PRED",   "targets": [5], "title":"Polyphen",
                                            "width": "auto" },
                                        { "name": "SIFT_PRED",   "targets": [6], "title":"SIFT",
                                            "width": "auto" },
                                        { "name": "Protein_change",   "targets": [7], "title":"Protein change",
                                          "width": "60px"  },
                                        { "name": "Consequence",   "targets": [8], "title":"Consequence",
                                          "width": "100px"  }

                                    ],
                                    "sPaginationType": "full_numbers",
                                    "iDisplayLength": 10,
                                    "bFilter": false,
                                    "bLengthChange" : true,
                                    "bInfo":true,
                                    "bProcessing": true
                            }
                         );
                        $('#gaitTable').DataTable().clear();
                         _.forEach(variantListHolder,function(variantRec){
                       //     $('#gaitTableDataHolder').append('<span class="variantsToCheck">'+variantRec.VAR_ID+'</span>')
                            var arrayOfRows = [];
                            var variantID = variantRec.VAR_ID;
                            if ((variantRec.CHROM)&&(variantRec.POS)){
                                variantID = variantRec.CHROM+":"+variantRec.POS;
                            }
                            arrayOfRows.push(variantRec.VAR_ID);
                            arrayOfRows.push('<a href="${createLink(controller: 'variantInfo', action: 'variantInfo')}/'+variantRec.VAR_ID+'" class="boldItlink">'+variantID+'</a>');
                            var DBSNP_ID = (variantRec.DBSNP_ID)?variantRec.DBSNP_ID:'';
                            arrayOfRows.push(DBSNP_ID);
                            arrayOfRows.push(variantRec.CHROM);
                            arrayOfRows.push(variantRec.POS);
                            arrayOfRows.push((variantRec.PolyPhen_PRED)?variantRec.PolyPhen_PRED:'');
                            arrayOfRows.push((variantRec.SIFT_PRED)?variantRec.SIFT_PRED:'');
                            //arrayOfRows.push('<a href="${createLink(controller: 'gene', action: 'geneInfo')}/'+variantRec.CLOSEST_GENE+'" class="boldItlink">'+variantRec.CLOSEST_GENE+'</a>');
                            var protein_change= (variantRec.Protein_change)?variantRec.Protein_change:'';
                            arrayOfRows.push(protein_change);
                            arrayOfRows.push(variantRec.Consequence);
                            $('#gaitTable').dataTable().fnAddData( arrayOfRows );
//                            $('#gaitTable').dataTable().rows().select();
                         });

                        }
                    }
                 );

                 promise.fail();
            }


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
                   'ciLevel': $(eachStratum).find('.ciLevel').text(),
                   'ciLower': $(eachStratum).find('.ciLower').text(),
                   'ciUpper': $(eachStratum).find('.ciUpper').text(),
                   'stratum': $(eachStratum).find('.stratum').text()});
               });
               // create JSON we can send to the server
               var jsonHolder = [];
                _.forEach(allElements, function(stratum){
                    if (stratum.stratum !== 'ALL'){
                        jsonHolder.push('{"pv":'+stratum.pv+',"be":'+stratum.be+',"st":'+stratum.st+',"ca":'+stratum.ca+
                        ',"ciLevel":'+stratum.ciLevel+',"ciLower":'+stratum.ciLower+',"ciUpper":'+stratum.ciUpper+
                        '}');
                    }
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
                    var ciLevel = UTILS.realNumberFormatter(el.ciLevel);
                    var ciLower = UTILS.realNumberFormatter(el.ciLower);
                    var ciUpper = UTILS.realNumberFormatter(el.ciUpper);
                    var isCategorical = el.ca;
                     $('.strataResults ul').append('<li><div class="'+currentStratum+' strataHolder"></div></li>');
                    var strataDomIdentifierClass = $('.'+currentStratum+'.strataHolder');
                    addStrataSection(strataDomIdentifierClass,currentStratum);
                    var isDichotomousTrait=(isCategorical==='1');
                    printFullResultsSection('',pValue,beta,oddsRatio,ciLevel,ciLower,ciUpper,isDichotomousTrait,currentStratum,currentStratum);
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
                            var numCases = $('.strataResults div.strataJar span.numCases.ALL').text();
                            var numControls = $('.strataResults div.strataJar span.numControls.ALL').text();
                            var numCaseCarriers = $('.strataResults div.strataJar span.numCaseCarriers.ALL').text();
                            var numControlCarriers = $('.strataResults div.strataJar span.numControlCarriers.ALL').text();

                             $('.strataResults').append( '<div clas="metana" style="text-align: center"><span class="stratumName meta">Meta-analysis:</span> &nbsp;&nbsp;&nbsp;<span class="pv metaAnalysis">pValue = '+pValue+'</span>'+
((categorical==='1')?('<span class="be metaAnalysis">Odds ratio='+oddsRatio+'</span>'):('<span class="be metaAnalysis">Beta='+beta+'</span>'))+
'<span class="st metaAnalysis">Std error='+stdErr+'</span>'+
'</div><div id="chart"></div>');
                            if ((typeof numCases !== 'undefined')  &&(numCases!=='')){
                                       mpgSoftware.burdenInfo.fillBurdenBiologicalHypothesisTesting(numCaseCarriers, numCases, numControlCarriers, numControls, 'T2D');

                                       // launch
                                       mpgSoftware.burdenInfo.retrieveDelayedBurdenBiologicalHypothesisOneDataPresenter().launch();
                            }
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
            var modeledPhenotypeTabs  = $('#modeledPhenotypeTabs li a');
            var modeledPhenotypes = [];
            _.forEach(modeledPhenotypeTabs,function(eachTab){
                modeledPhenotypes.push($(eachTab).text());
            });
            // we need to handle cases and controls in a single query, perhaps across each stratum.  So let's generate the maximum strata list
            var nonPhenotypeTabs = [];
            var phenotypeTabs = [];
            // compile unique strata names
            var uniqueStrataNames = [];
            _.forEach(modeledPhenotypes,function(modeledPhenotype){
                 var stratsTabs  = $('#'+modeledPhenotype+'_stratsTabs li a.filterCohort');
                for ( var i = 0 ; i < stratsTabs.length ; i++ ) {
                    var currentStratumName = $(stratsTabs[i]).text();
                    if (uniqueStrataNames.indexOf(currentStratumName)<0){
                       // if (currentStratumName !== 'ALL'){
                            uniqueStrataNames.push(currentStratumName);
                       // }
                    }
                }
            });

            $('.strataResults').empty(); // clear stata reporting section
            if (uniqueStrataNames.length>0){
                for ( var i = 0 ; i < uniqueStrataNames.length ; i++ ) {
                    var stratumName = uniqueStrataNames[i];
                    var strataPropertyName;
                    var phenoPropertyName;
                    var phenoPropertySpecifier;
                    var phenoInstanceSpecifier;
                    var caseAndControlArray = [];
                    if (modeledPhenotypes.length>0){
                        for ( var j = 0 ; j < modeledPhenotypes.length ; j++ ) {
                            var modeledPhenotype = modeledPhenotypes[j];

                            %{--var stratsTabs  = $('#'+modeledPhenotype+'_stratsTabs li a.filterCohort');--}%
                            %{--if (stratsTabs.length===0){--}%
                               %{--var f=executeAssociationTest(collectingFilterValues(),collectingCovariateValues(),'none','strat1');--}%
                               %{--$.when(f).then(function() {--}%
                                      %{--//alert('all done with 1');--}%
                                %{--});--}%
                            %{--} else {--}%
                                strataPropertyName = $('div.stratsTabs_property').attr("id");
                                phenoPropertyName = $('div.phenoSplitTabs_property.'+modeledPhenotype).attr("id");
                                phenoPropertySpecifier = $('a[data-target=#'+stratumName+'_'+modeledPhenotype+']+div.strataPhenoIdent div.phenoCategory').text();
                                phenoInstanceSpecifier = $('a[data-target=#'+stratumName+'_'+modeledPhenotype+']+div.strataPhenoIdent div.phenoInstance').text();
                                caseAndControlArray.push({
                                                        phenoPropertyName:phenoPropertyName,
                                                        phenoInstanceSpecifier:phenoInstanceSpecifier,
                                                        strataPropertyName: strataPropertyName,
                                                        stratumName:stratumName
                                    });
 //                          }

                        }
                        nonPhenotypeTabs.push(caseAndControlArray);
                    }

                }
            }
           // var compoundedFilterValues = compoundingFilterValues(phenotypeTabs);

            var deferreds = [];
            _.forEach(nonPhenotypeTabs,function (stratum){
                    var compoundedFilterValues =  compoundingStrataFilterValues(stratum);
                    var strataPropertyName = stratum[0].strataPropertyName;
                    var stratumName = stratum[0].stratumName;
                    deferreds.push(executeAssociationTest('{}',collectingCovariateValues(strataPropertyName,stratumName),strataPropertyName,stratumName,compoundedFilterValues.strataFilters));

            });
            $.when.apply($,deferreds).then(function() {
                  runMetaAnalysis();
                  $('#rSpinner').hide();
            });
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
            height = 475 - margin.top - margin.bottom;

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
            height = 440 - margin.top - margin.bottom;



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
                        var refinedFilterParm = filterParm.val();
                        if (filterCmp.val()==3){
                            refinedFilterParm = "["+ refinedFilterParm+"]";
                        } if (filterCmp.val()==4){
                            refinedFilterParm = "]"+ refinedFilterParm+"[";
                        }
                        var  dataSetMap = {"name":filterName,
                                           "parm":refinedFilterParm,
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
                        _.forEach($('#multi_'+filterName+'_'+strataCategory+' option:selected'),function(d){
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



        var fillCategoricalDropDownBoxes = function (sampleData,phenotype,stratum,modPhenoHolder,optionsPerFilter){
             // make dist plots
            var sampleMetadata = getStoredSampleMetadata();
            _.forEach(sampleMetadata.filters,function(d,i){
                if (d.type !== 'FLOAT') {
                    if (optionsPerFilter[d.name]!==undefined){
                       var dropdownId = '#multi_'+stratum+"_"+d.name+"_"+modPhenoHolder;
                       _.forEach(optionsPerFilter[d.name],function(filterVal){
                           if ('ALL'!==filterVal.name){ // we provide a 'select all' option, so there is never a call for a category == 'ALL'
                              $(dropdownId).append(new Option(filterVal.name,filterVal.name));
                           }
                       });
                       if ($(dropdownId).children().length>0){
                       $(dropdownId).multiselect({includeSelectAllOption: true,
                                                   allSelectedText: 'All Selected',
                                                   buttonWidth: '100%'
                                                   });
                        $(dropdownId).change(function(event, ui){
                                              // Begin kludge alert!----
                                              // I've spent a lot of time trying to figure out how to capture a jquery multi-select window close, but the event
                                              // never seems to get triggered.  Strange.  Until I can get a real answer here is a workaround: when we
                                              // see any change (an event I CAN capture for some reason)  pull the adjacent arrow to launch a redraw.
                                              // ----end kludge alert
                                              var holder = $(dropdownId).parent().parent().parent();
                                              var adjacentColumn = $(holder.children()[3]);
                                              var adjacentCorrespondingArrow = $(adjacentColumn.children()[0]);
                                              if (adjacentCorrespondingArrow) {
                                                eval(adjacentCorrespondingArrow.attr('onclick'));
                                              }
                                            });

                        $(dropdownId).multiselect('selectAll', false);
                        $(dropdownId).multiselect('updateButtonText');

                       }

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
                var plotHoldingStructure;
                if (params.modeledPhenotype){
                    plotHoldingStructure = $(params.holderSection+'_'+params.modeledPhenotype);
                } else {
                    plotHoldingStructure = $(params.holderSection);
                }
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
                    var divElementName = 'bwp_'+params.strataName+'_'+params.propertyName+'_'+params.modeledPhenotype;
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
        *  Taking apart the information contained in a div ID and breaking it into three pieces.  (I used to do most of this with a split,
        *    but some of the phenotype names have an under score in them which was leading to trouble)
        *
        * @param encodedFilterStrataName
        * @param modeledPhenotype
        * @returns {Array}
        */
        var parseEncodedFilterStrataName = function (encodedFilterStrataName,modeledPhenotype){
            var stringPrefix = "inp_";
            var stringPostfix = "_"+modeledPhenotype;
            var returnVals = [];
            if (encodedFilterStrataName.indexOf(stringPrefix)==0){
                var  encodedFilterName = encodedFilterStrataName.substr(stringPrefix.length);
                var nextDelim = encodedFilterName.indexOf("_");
                if ((nextDelim>-1)&&
                    (nextDelim<(encodedFilterName.length-stringPostfix.length))){
                    var strataName = encodedFilterName.substr(0,nextDelim);
                    var propertyName = encodedFilterName.substr(nextDelim+1,encodedFilterName.length-stringPostfix.length-nextDelim-1);
                    returnVals.push(stringPrefix.substr(0,stringPrefix.length-1));
                    returnVals.push(strataName);
                    returnVals.push(propertyName);
                 }
             }
            return returnVals;
        };

        /***
        * Sometimes these IDs have strata and or the modeled phenotype appended to them
        * @param className
        * @param propertyName
        * @param modeledPhenotype
        * @param delim
        * @returns {*}
        */
        var conditionallyAppendModeledPhenotype = function (className,propertyName,modeledPhenotype,delim){
            var returnValue = className+propertyName;
            if ((typeof modeledPhenotype !== 'undefined') &&
                ( modeledPhenotype.length > 0)){
                    returnValue += (delim+modeledPhenotype);
               }
            return returnValue;
        };



        /***
        * Change a comparator or on the ALL tab and see that change carried across the other strata
        *
        * @param modeledPhenotype
        * @param propertyName
        * @param locationOfFirstBreak
        * @param strataName
        * @param realValuedFilterClassName
        * @param realValuedFilterInputClassName
        * @param categoricalFilterClassName
        * @param categoricalFilterInputClassName
        * @param comparatorFilterClassName
        * @param comparatorFilterInputClassName
        */
        var carryTheAllFiltersAcrossStrata = function ( modeledPhenotype,propertyName,locationOfFirstBreak,strataName,
                                                        realValuedFilterClassName,realValuedFilterInputClassName,
                                                        categoricalFilterClassName,categoricalFilterInputClassName,
                                                        comparatorFilterClassName,comparatorFilterInputClassName){

            /***
            * change a real valued filter or on the ALL tab and see that change carried across the other strata
            * @param filterIdentifier
            * @param inputIdentifier
            * @param propertyName
            * @param modeledPhenotype
            */
            var carryALLFloatFiltersAcrossOtherStrata = function(filterIdentifier,inputIdentifier,propertyName, modeledPhenotype){
                var realValueFilters = $(filterIdentifier);
                _.forEach(realValueFilters,function(oneFilter){
                    var filterDom = $(oneFilter);
                    var id = filterDom.attr('id');
                    var idKeys = parseEncodedFilterStrataName(id,modeledPhenotype);
                    if (idKeys.length > 2){
                        if ((idKeys[0]==='inp') &&
                            (idKeys[1]!=='ALL')  &&
                            (idKeys[2]===propertyName)){
                                var templateFilter = $(inputIdentifier);
                                filterDom.val(templateFilter.val());
                        }
                   }
                });
            };


            /***
            * change a categorical filter or on the ALL tab and see that change carried across the other strata
            * @param filterIdentifier
            * @param inputIdentifier
            * @param propertyName
            * @param modeledPhenotype
            */
            var carryAllCategoricalFiltersAcrossOtherStrata = function(filterIdentifier,inputIdentifier,propertyName,modeledPhenotype){
                var categoricalValueFilters =   $(filterIdentifier);
                _.forEach(categoricalValueFilters,function(oneFilter){
                    var filterRowDom = $(oneFilter);
                    var  filterId = filterRowDom.attr('id');
                    if (filterId.indexOf("filter_")==0){
                       // var  filterName = filterId.substr(7);
                        var  filterName = conditionallyAppendModeledPhenotype(filterId.substr(7),'',modeledPhenotype,'_')
                        var locationOfSecondBreak = filterName.indexOf('_');
                        if ((locationOfSecondBreak>-1)&&
                            (locationOfSecondBreak<(filterName.length-1))&&
                            (filterName.substr(locationOfSecondBreak+1,propertyName.length)==propertyName)&&
                            (filterName.substr(0,3)!=='ALL')){
                            $('#multi_'+filterName).val($('.'+inputIdentifier).val());
                        }
                    }

                });
            };

            /***
            *  Change a comparator or on the ALL tab and see that change carried across the other strata
            * @param filterIdentifier
            * @param inputIdentifier
            * @param propertyName
            */
            var carryAllComparatorsAcrossOtherStrata = function (filterIdentifier,inputIdentifier,propertyName){
                var realValueComparators =   $(filterIdentifier);
                _.forEach(realValueComparators,function(oneComparator){
                    var cmpRowDom = $(oneComparator);
                    var  cmpId = cmpRowDom.attr('id');
                    if (cmpId.indexOf("cmp_")==0){
                        var  cmpName = cmpId.substr(4);
                        var locationOfSecondBreak = cmpName.indexOf('_');
                        if ((locationOfSecondBreak>-1)&&
                            (locationOfSecondBreak<(cmpName.length-1))&&
                            (cmpName.substr(locationOfSecondBreak+1,propertyName.length)==propertyName)&&
                            (cmpName.substr(0,3)!=='ALL')){
                            $('#cmp_'+cmpName).val($(inputIdentifier).val());
                            }
                    }
                });
            };

            // carry 'ALL' filters across to everyone else
            if ((locationOfFirstBreak> -1) &&(strataName==='ALL')) {

                //real valued
                carryALLFloatFiltersAcrossOtherStrata(  conditionallyAppendModeledPhenotype(realValuedFilterClassName,'',modeledPhenotype,'.'),
                                                        conditionallyAppendModeledPhenotype(realValuedFilterInputClassName,propertyName,modeledPhenotype,'_'),
                                                        propertyName, modeledPhenotype  );

                // categorical
                carryAllCategoricalFiltersAcrossOtherStrata(  conditionallyAppendModeledPhenotype(categoricalFilterClassName,'',modeledPhenotype,'.'),
                                                        conditionallyAppendModeledPhenotype(categoricalFilterInputClassName,propertyName,modeledPhenotype,'_'),
                                                        propertyName, modeledPhenotype );

                 // comparators
                carryAllComparatorsAcrossOtherStrata(  conditionallyAppendModeledPhenotype(comparatorFilterClassName,'',modeledPhenotype,'.'),
                                                        conditionallyAppendModeledPhenotype(comparatorFilterInputClassName,propertyName,modeledPhenotype,'_'),
                                                        propertyName, modeledPhenotype  );

           }
        }



        /***
        * The user has changed a filter.  We need to potentially update that filter across multiple strata. Then, we need
        * the performer round-trip with the revised filter ( plus any other existing filters) and generate a distribution plot
        * of all samples that satisfy this filter combination.
        *
        * @param propertyName
        * @param holderSection
        */
        var displaySampleDistribution = function (propertyName, holderSection, categorical,modeledPhenotype) { // for categorical, 0== float, 1== string or int
            var locationOfFirstBreak = holderSection.indexOf('_');
            var strataName = holderSection.substring(locationOfFirstBreak+1);

            carryTheAllFiltersAcrossStrata( modeledPhenotype,propertyName,locationOfFirstBreak,strataName,
                                            '.filterParm','.inp_ALL_',
                                            '.categoricalFilter','multi_ALL_',
                                            '.filterCmp','.cmp_ALL_');


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
            retrieveMatchingDataSets:retrieveMatchingDataSets, // retrieve data set matching phenotype.  not currently used
            refreshGaitDisplay: refreshGaitDisplay, // refresh the filters, covariates, and results sections
            carryCovChanges:carryCovChanges, // Terry across strata.  Similar to carryTheAllFiltersAcrossStrata but much simpler
            displayTestResultsSection: displayTestResultsSection,  // simply display results section (show() or hide()
            generateListOfVariantsFromFilters: generateListOfVariantsFromFilters,
            storeGeneForGait: storeGeneForGait
        }

    }());

$( document ).ready( function (){
    mpgSoftware.burdenTestShared.storeGeneForGait('<%=geneName%>');
    mpgSoftware.burdenTestShared.retrieveExperimentMetadata( '#datasetFilter' );
    mpgSoftware.burdenTestShared.preloadInteractiveAnalysisData();
} );

</g:javascript>

<div class="accordion-group">
    <div class="accordion-heading">
        <a class="accordion-toggle  collapsed" data-toggle="collapse" href="#collapseBurden">
            <g:if test="${modifiedTitle}">
                <h2><strong>${modifiedTitle}</strong></h2>
            </g:if>
            <g:else>
                <h2><strong>Genetic Association Interactive Tool</strong></h2>
            </g:else>

        </a>
    </div>

    <div id="collapseBurden" class="accordion-body collapse">
        <div class="accordion-inner">

            <div class="container">
                <h5>
                    <g:if test="${modifiedGaitSummary}">
                        ${modifiedGaitSummary}
                    </g:if>
                    <g:else>
                        The Genetic Association Interactive Tool allows you to compute custom association statistics for this
                variant by specifying the phenotype to test for association, a subset of samples to analyze based on specific phenotypic criteria, and a set of covariates to control for in the analysis.
                         GAIT queries the 17K exome sequence analysis data set. In order to protect patient privacy,
                            GAIT will only allow visualization or analysis of data from more than 100 individuals.
                    </g:else>

                </h5>


                <div class="row burden-test-wrapper-options">

                    <r:img class="caatSpinner" uri="/images/loadingCaat.gif" alt="Loading GAIT data"/>



                    <div class="user-interaction">

                        <div id="chooseDataSetAndPhenotypeLocation"></div>

                        <div class="stratified-user-interaction"></div>

                        <div class="panel-group" id="accordion_iat" style="margin-bottom: 0px">%{--start accordion --}%
                            <div id="chooseVariantFilterSelection"></div>
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
    <div class="">%{--should hold the Choose data set panel--}%

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

        <div class="col-sm-offset-5 col-sm-2 col-xs-12 vcenter center burden-test-btn-wrapper">
            <button name="singlebutton" style="height: 50px; z-index: 10" id="singleRunButton"
                                                   class="btn btn-primary btn-lg burden-test-btn vcenter"
                                                   onclick="mpgSoftware.burdenTestShared.immediateFilterAndRun()">Launch analysis</button>
        </div>


        <div class="col-sm-12 col-xs-12">
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


    </div>
</div>
</script>


%{--Choose the phenotype and stratification options. Currently the top section in the interface--}%
<script id="chooseDataSetAndPhenotypeTemplate"  type="x-tmpl-mustache">
    <div class="">%{--should hold the Choose data set panel--}%

        <div class="">
            <h3>
                Choose a phenotype and partitioning strategy
            </h3>
        </div>

        <div id="chooseSamples" class="">
            <div class="secBody">

                <div class="row secHeader"">
                    <div class="col-sm-12 col-xs-12 text-left"><label>Dataset</label></div>
                </div>

                <div class="row" style="display:none">
                    <div class="col-sm-12 col-xs-12">
                        <p>
                            Select a phenotype to test for association and optionally choose to stratify samples by ancestry and/or filter cases and controls separately.
                        </p>

                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12 col-xs-12 text-left">
                        <select id="datasetFilter" class="traitFilter form-control text-left"
                                onchange="mpgSoftware.burdenTestShared.refreshGaitDisplay ('#datasetFilter', '#phenotypeFilter', '#stratifyDesignation', '#caseControlFiltering');"
                                onclick="mpgSoftware.burdenTestShared.refreshGaitDisplay ('#datasetFilter', '#phenotypeFilter', '#stratifyDesignation', '#caseControlFiltering' );">
                                %{--onclick="mpgSoftware.burdenTestShared.retrieveSampleMetadata(this, '#phenotypeFilter');">--}%
                        </select>
                    </div>

                </div>

                <div class="row secHeader" style="padding: 0 0 5px 0">
                    <div class="col-sm-12 col-xs-12 text-left"><label>Phenotype</label></div>
                </div>

                <div class="row">
                    <div class="col-sm-12 col-xs-12 text-left">
                        <select id="phenotypeFilter" class="traitFilter form-control text-left"
                                onchange="mpgSoftware.burdenTestShared.refreshGaitDisplay ('#datasetFilter', '#phenotypeFilter', '#stratifyDesignation', '#caseControlFiltering' );">
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
                                onchange="mpgSoftware.burdenTestShared.refreshGaitDisplay ('#datasetFilter', '#phenotypeFilter', '#stratifyDesignation', '#caseControlFiltering' );">
                                    <option value="none">none</option>
                                    <option value="origin">ancestry</option>
                        </select>
                    </div>
                </div>
                {{ /strataChooser }}


                <div class="row">
                    <div class="col-sm-12 col-xs-12 text-left">
                        <div  id="caseControlFilteringWithLabel" class="checkbox" style="margin:20px 0 10px 0">
                                <span style="margin: 0 25px 0 0; font-weight: bold">Samples:</span>
                                <input id="caseControlFiltering" type="checkbox" name="caseControlFiltering"
                                       value="caseControlFiltering"
                                        onchange="mpgSoftware.burdenTestShared.refreshGaitDisplay ('#datasetFilter', '#phenotypeFilter', '#stratifyDesignation', '#caseControlFiltering' );">
                                        <label style="padding-left:0">Filter cases and controls separately</label>
                                </input>
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
                       href="#filterSamples">Step {{sectionNumber}}: Select a subset of samples based on phenotypic criteria</a>
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


                    <div class="row" style="{{modeledPhenotypeDisplay}}">
                        <div class="col-sm-12 col-xs-12">
                            <ul class="nav nav-pills modeledPhenotypeDisplay" id="modeledPhenotypeTabs">
                                {{ #modeledPhenotype }}
                                   {{ #levels }}
                                        <li class="{{defaultDisplay}}">
                                            <a data-target="#{{name}}" data-toggle="tab" class="filterCohort {{val}} {{phenoLevelName}}">{{name}}</a>
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
                                            <ul class="nav nav-tabs stratsTabs" id="{{name}}_stratsTabs">
                                                {{ #strataContent }}
                                                   <li class="{{defaultDisplay}}">
                                                       <a data-target="#{{name}}_{{phenoLevelName}}" data-toggle="tab" class="filterCohort {{trans}} {{phenoLevelName}}">{{trans}}</a>
                                                       <div class="strataPhenoIdent">
                                                           <div class="phenoCategory  {{phenoName}}" style="display: none">{{category}}</div>
                                                           <div class="phenoInstance  {{phenoLevelName}}" style="display: none">{{val}}</div>
                                                       </div>
                                                   </li>
                                                {{ /strataContent }}
                                                <div class="stratsTabs_property {{phenoLevelName}}" id="{{name}}_{{strataProperty}}" style="display: none"></div>
                                                <div class="phenoSplitTabs_property  {{phenoLevelName}}" id="{{name}}_{{phenotypeProperty}}" style="display: none"></div>
                                                <div class="phenoRawSplitTabs_property" id="{{phenoLevelVal}}" style="display: none"></div>
                                            </ul>
                                        </div>
                                    </div>


                                    <div class="tab-content">
                                        {{ #strataContent }}
                                            <div class="tab-pane {{defaultDisplay}}" id="{{name}}_{{phenoLevelName}}">
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

                                                                <div style="direction: rtl; max-height: 620px; padding: 4px 0 0 10px; overflow-y: auto;">
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

                                                            <div><span style="display:none"
                                                                    class="phenotypeSpecifier" style="font-weight:bold"></span><span
                                                                    class="numberOfPhenotypeSpecificSamples"></span></div>
                                                        </div>

                                                        <div class="boxWhiskerPlot boxWhiskerPlot_{{name}} boxWhiskerPlot_{{name}}_{{phenoLevelName}}"></div>

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
                                {{>filterFloatTemplate}}
                                {{>filterCategoricalTemplate}}
                            {{/filterDetails }}
            </script>

                    <script id="filterFloatTemplate"  type="x-tmpl-mustache">

                                {{ #realValuedFilters }}
                                <div class="row realValuedFilter {{stratum}} {{phenoLevelName}} considerFilter" id="filter_{{stratum}}_{{name}}">
                                    %{--<div class="col-sm-1">--}%
                                        <input class="utilize" id="use{{name}}" type="checkbox" name="use_{{stratum}}_{{name}}"
                                               value="{{stratum}}_{{name}}" checked style="display: none"/></td>
                                    %{--</div>--}%

                                    <div class="col-sm-6">
                                        <span style="{{bold}}">{{trans}}</span>
                                    </div>

                                    <div class="col-sm-2">
                                        <select id="cmp_{{stratum}}_{{name}}_{{phenoLevelName}}" class="form-control filterCmp cmp_{{stratum}}_{{name}}_{{phenoLevelName}} {{phenoLevelName}}"
                                                data-selectfor="{{stratum}}_{{name}}Comparator"
                                               onchange="mpgSoftware.burdenTestShared.displaySampleDistribution('{{name}}', '.boxWhiskerPlot_{{stratum}}',0,'{{phenoLevelName}}')">
                                            <option value="1">&lt;</option>
                                            <option value="2">&gt;</option>
                                            <option value="3">internal</option>
                                            <option value="4">external</option>
                                        </select>
                                    </div>

                                    <div class="col-sm-3">
                                        <input type="text" id="inp_{{stratum}}_{{name}}_{{phenoLevelName}}" class="filterParm form-control inp_{{stratum}}_{{name}}_{{phenoLevelName}} {{phenoLevelName}}"
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
                                <div class="row categoricalFilter considerFilter {{stratum}} {{phenoLevelName}}" id="filter_{{stratum}}_{{name}}">
                                   %{-- <div class="col-sm-1">--}%
                                        <input class="utilize" id="use_{{stratum}}_{{name}}" type="checkbox" name="use_{{stratum}}_{{name}}"
                                               value="{{stratum}}_{{name}}" checked  style="display: none"/></td>
                                   %{-- </div>--}%

                                    <div class="col-sm-6">
                                        <span>{{trans}}</span>
                                    </div>


                                    <div class="col-sm-5">
                                        <select id="multi_{{stratum}}_{{name}}_{{phenoLevelName}}" class="form-control multiSelect multi_{{stratum}}_{{name}}_{{phenoLevelName}} {{phenoLevelName}}"
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
                       href="#initiateAnalysis_{{stratum}}">Step {{sectionNumber}}: Control for covariates</a>
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
                                {{ #modeledPhenotype }}
                                    {{ #levels }}
                                        {{ #strataContent }}
                                           <li class="{{defaultDisplay}}" style="{{firstPhenotypeModelLevel}}"><a data-target="#cov_{{name}}" data-toggle="tab" class="covariateCohort {{name}}">{{trans}}</a></li>
                                        {{ /strataContent }}
                                    {{ /levels }}
                                {{ /modeledPhenotype }}
                            </ul>
                        </div>
                    </div>

                    <div class="tab-content">
                        {{ #modeledPhenotype }}
                            {{ #levels }}
                                {{ #strataContent }}
                                    <div class="tab-pane {{defaultDisplay}}" id="cov_{{name}}{{undisplayedPhenotypeModelLevel}}" style="{{firstPhenotypeModelLevel}}">

                                        <div class="row">
                                            <div class="col-sm-8 col-xs-12 vcenter covariate_holder">
                                                <div class="covariates">
                                                    <div class="row"  style="{{firstPhenotypeModelLevel}}">
                                                        <div class="col-md-10 col-sm-10 col-xs-12 vcenter" style="margin-top:0">

                                                            <div class="covariateHolder covariateHolder_{{name}}"  style="{{firstPhenotypeModelLevel}}">
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
                            {{ /levels }}
                        {{ /modeledPhenotype }}
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




<script id="variantFilterSelectionTemplate"  type="x-tmpl-mustache">
        <div class="panel panel-default">%{--should hold the initiate analysis set panel--}%

            <div class="panel-heading">
                <h4 class="panel-title">
                    <a data-toggle="collapse" data-parent="#variantFilterSelection"
                       href="#variantFilterSelection">Step {{sectionNumber}}: Manage variant selection</a>
                </h4>
            </div>


            <div id="variantFilterSelection" class="panel-collapse collapse">
                <div class="panel-body secBody">

                    <div class="row">
                        <div class="col-sm-12 col-xs-12">
                            <p>
                                Choose a collection of variants which will be analyzed together to assess disease burden.
                                You may choose a set of variants with a specific consequence or minor allele frequency, and
                                potentially remove variants from this set by using the check boxes at the left of the table.
                            </p>
                        </div>
                    </div>

                    <div class="row">
                    <div class="container">

                        <div class="row burden-test-wrapper-options">

                            <div class="col-md-11 col-sm-11 col-xs-12">
                                <div  class="row">

                                    <div class="col-md-12 col-sm-12 col-xs-12">
                                        <label><g:message code="gene.burdenTesting.label.available_variant_filter"/>:
                                            <select id= "burdenProteinEffectFilter" class="burdenProteinEffectFilter form-control"
                                            onchange="mpgSoftware.burdenTestShared.generateListOfVariantsFromFilters()">
                                                <option selected value="0"><g:message code="gene.burdenTesting.label.select_filter"/></option>
                                            </select>
                                        </label>
                                    </div>
                                </div>
                                <div  class="row">
                                      <div style="margin:15px 8px 15px 10px" class="separator"></div>
                                </div>
                                <div  class="row">
                                    <div class="col-md-6 col-sm-6 col-xs-6">
                                        <label for="mafInput"><g:message code="gene.burdenTesting.label.maf"/>:</label>
                                        <div class="labelAndInput">
                                            MAF &lt;&nbsp;
                                            <input style="display: inline-block" type="text" class="form-control" id="mafInput" placeholder="value"
                                            onkeyup="mpgSoftware.burdenTestShared.generateListOfVariantsFromFilters()">
                                        </div>

                                    </div>
                                    <div class="col-md-6 col-sm-6 col-xs-6">
                                        <label><g:message code="gene.burdenTesting.label.apply_maf"/>:&nbsp;&nbsp;</label>
                                        <div class="form-inline mafOptionChooser">
                                            <div class="radio">
                                                <label><input type="radio" name="mafOption" value="1" onclick="mpgSoftware.burdenTestShared.generateListOfVariantsFromFilters()"/>&nbsp;<g:message code="gene.burdenTesting.label.all_samples"/></label>
                                            </div>
                                            <div class="radio">
                                                <label><input type="radio" name="mafOption"  value="2" checked onclick="mpgSoftware.burdenTestShared.generateListOfVariantsFromFilters()"/>&nbsp;<g:message code="gene.burdenTesting.label.each_ancestry"/></label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div  class="col-md-1 col-sm-1 col-xs-12 burden-test-btn-wrapper vcenter">
                            </div>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-sm-12 col-xs-12">
                            <p>
                                <div id="gaitTableDataHolder" style="margin-top: 20px"></div>
                            </p>
                            <div id="gaitButtons"></div><div id="gaitVariantTableLength"></div>
                            <table id="gaitTable" class="table table-striped dk-search-result dataTable no-footer" style="border-collapse: collapse; width: 100%;" role="grid"
                            aria-describedby="variantTable_info">

                            </table>


                        </div>
                    </div>

                </div>
            </div>

        </div>%{--end id=initiateAnalysis panel--}%
</script>



