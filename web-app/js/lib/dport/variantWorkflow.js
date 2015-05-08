var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.variantWF = (function () {
        // private variables
        var currentInteractivity = 1, // 0->defining a filter, 1-> potentially manipulating our  list of existing filters
        activeColor = '#0008b',
        inactiveColor = '#808080';
        /***
         * private methods
         * @param indexNumber
         */
        // getter/setter
        var existingFiltersManipulators = function(x){ // 0 deactivates, 1 activates
            var filterActivator = $('.filterActivator');
            if (x){
                filterActivator.css('color',activeColor);
                filterActivator.css('cursor', 'pointer');
            }else {
                filterActivator.css('color',inactiveColor);
                filterActivator.css('cursor', 'default');
            }
        };
        var numberExistingFilters = function (x){
            var filterCount = $('#totalFilterCount');
            if (!arguments.length) {//no argument, this is a getter call
                var returnValue = 0;
                if (typeof filterCount !== 'undefined') {
                    returnValue =  parseInt (filterCount.attr('value'));
                }
                return returnValue;
            } else {// we received an argument, treat this as a setter
                if (typeof filterCount !== 'undefined') {
                    filterCount.attr('value',x)
                }
            }

        };
         var handleBlueBoxVisibility = function (){
            var blueBox = $('.bluebox');
            if (numberExistingFilters() > 0){
                blueBox.show();
            } else {
                blueBox.hide();
            }
        };
        // getter/setter.
        // 0 === we are working on a single filter
        // 1 === all of the existing filters can be manipulated, since single filter is not in play
        var currentInteractivityState = function(newValue){
            if (!arguments.length) return currentInteractivity;
           // if (currentInteractivity  !==  newValue){ // the state of things is changing. Make sure the interface is up-to-date
                existingFiltersManipulators (newValue);
           // }
        };
        var forgetThisFilter = function  (indexNumber){
            if(typeof indexNumber !== 'undefined'){
                $('#savedValue'+indexNumber).remove ();
                $('#filterBlock'+indexNumber).remove ();
            }
        };
        var retrieveDataSets = function (phenotype, experiment) {
            var loading = $('#spinner').show();
            $.ajax({
                cache: false,
                type: "post",
                url: "./retrieveDatasetsAjax",
                data: {phenotype: phenotype,
                    experiment:experiment},
                async: true,
                success: function (data) {
                    if (( data !==  null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.datasets !== 'undefined' ) &&
                        (  data.datasets !==  null ) ) {
                        fillDataSetDropdown(data.datasets);
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
         * public methods
         * @param currentObject
         */
        var removeThisClause = function (currentObject){
            if (currentInteractivityState()){
                var filterIndex;
                var label = 'remover';
                var id = $(currentObject).attr ('id');
                var desiredLocation = id.indexOf (label);
                if ((desiredLocation > -1) &&
                    (typeof id !== 'undefined') ){
                    var filterIndexString = id.substring(id.indexOf(label)+ label.length);
                    filterIndex = parseInt(filterIndexString);
                    forgetThisFilter (filterIndex);
                    numberExistingFilters(numberExistingFilters()-1);
                    handleBlueBoxVisibility ();
                }
            }
        };
        var editThisClause = function (currentObject){
            if (currentInteractivityState()){
                var filterIndex;
                var label = 'remover';
                var id = $(currentObject).attr ('id');
                var desiredLocation = id.indexOf (label);
                if ((desiredLocation > -1) &&
                    (typeof id !== 'undefined') ){
                    var filterIndexString = id.substring(id.indexOf(label)+ label.length);
                    filterIndex = parseInt(filterIndexString);
                    forgetThisFilter (filterIndex);
                    numberExistingFilters(numberExistingFilters()-1);
                    handleBlueBoxVisibility ();
                }
            }
        };

        var removeThisFilter = function (currentObject){
            if (typeof currentObject !== 'undefined') {
                var currentObjectId = currentObject.id;
                var targetName = currentObjectId.split("_")[1];
                var target = $('#'+targetName);
                if (typeof target !== 'undefined')  {
                    target.remove ();
                }
            }
         };
        var fillDataSetDropdown = function (dataSetJson) { // help text for each row
            if ((typeof dataSetJson !== 'undefined')  &&
                (typeof dataSetJson["is_error"] !== 'undefined')&&
                (dataSetJson["is_error"] === false))
            {
                var numberOfRecords = parseInt (dataSetJson ["numRecords"]);
                var options = $("#dataSet");
                options.empty();
                var dataSetList = dataSetJson ["dataset"];
                for ( var i = 0 ; i < numberOfRecords ; i++ ){
                    options.append($("<option />").val(dataSetList[i]).text(dataSetList[i]));
                }
            }
        };
        var gatherFieldsAndPostResults = function (){
            var varsToSend = {};
            var phenotypeInput = UTILS.extractValsFromCombobox(['phenotype']);
            var datasetInput = UTILS.extractValsFromCombobox(['dataSet']);
            var pvEquivalence = UTILS.extractValsFromCombobox(['pvEquivalence']);
            var orEquivalence = UTILS.extractValsFromCombobox(['orEquivalence']);
            var esEquivalence = UTILS.extractValsFromCombobox(['esEquivalence']);
            var variantFilters = UTILS.extractValFromTextboxes(['pvValue','orValue','esValue']);
            var totalFilterCount = UTILS.extractValFromTextboxes(['totalFilterCount']);
            var experimentChoice = UTILS.extractValFromCheckboxes(['datasetExomeChip','datasetExomeSeq','datasetGWAS']);
            var restrictToRegion = UTILS.extractValFromTextboxes(['region_gene_input','region_chrom_input','region_start_input','region_stop_input']);
            var missensePredictions = [];
            varsToSend["predictedEffects"]  = $("input:radio[name='predictedEffects']:checked").val();
            if (varsToSend["predictedEffects"]==='missense'){
                missensePredictions = UTILS.extractValsFromCombobox(['polyphenSelect','siftSelect','condelSelect']);
            }
            var savedValuesList = [];
            var savedValue = {};
            if (typeof totalFilterCount['totalFilterCount'] !== 'undefined') {
                var valueCount = parseInt(totalFilterCount['totalFilterCount']);
                if (valueCount>0){
                    for ( var i = 0 ; i < valueCount ; i++ ){
                        savedValuesList.push ('savedValue'+i);
                    }
                    savedValue = UTILS.extractValFromTextboxes(savedValuesList);
                }
            }
            //var savedValue = UTILS.extractValFromTextboxes(['savedValue']);
            varsToSend = UTILS.concatMap(varsToSend,restrictToRegion) ;
            varsToSend = UTILS.concatMap(varsToSend,missensePredictions) ;
            varsToSend = UTILS.concatMap(varsToSend,phenotypeInput) ;
            varsToSend = UTILS.concatMap(varsToSend,datasetInput) ;
            varsToSend = UTILS.concatMap(varsToSend,pvEquivalence) ;
            varsToSend = UTILS.concatMap(varsToSend,orEquivalence) ;
            varsToSend = UTILS.concatMap(varsToSend,esEquivalence) ;
            varsToSend = UTILS.concatMap(varsToSend,variantFilters) ;
            varsToSend = UTILS.concatMap(varsToSend,savedValue) ;
            varsToSend = UTILS.concatMap(varsToSend,experimentChoice) ;
            UTILS.postQuery('./variantVWRequest',varsToSend);
        };
        var cancelThisFieldCollection = function (){
            var varsToSend = {};
            var savedValue = {};
            var savedValuesList = [];
            var totalFilterCount = UTILS.extractValFromTextboxes(['totalFilterCount']);
            if (typeof totalFilterCount['totalFilterCount'] !== 'undefined') {
                var valueCount = parseInt(totalFilterCount['totalFilterCount']);
                if (valueCount>0){
                    for ( var i = 0 ; i < valueCount ; i++ ){
                        savedValuesList.push ('savedValue'+i);
                    }
                    savedValue = UTILS.extractValFromTextboxes(savedValuesList);
                }
            }
            varsToSend = UTILS.concatMap(varsToSend,savedValue) ;
            UTILS.postQuery('./variantVWRequest',varsToSend);
        };
        var initializePage = function (){
            handleBlueBoxVisibility ();
            currentInteractivityState(1);
            $("#phenotype").prepend("<option value='' selected='selected'></option>");
        };
        return {
            cancelThisFieldCollection:cancelThisFieldCollection,
            fillDataSetDropdown:fillDataSetDropdown,
            gatherFieldsAndPostResults:gatherFieldsAndPostResults,
            initializePage:initializePage,
            removeThisClause:removeThisClause,
            editThisClause:editThisClause,
            removeThisFilter:removeThisFilter,
            existingFiltersManipulators:existingFiltersManipulators,
            currentInteractivityState:currentInteractivityState,
            retrieveDataSets:retrieveDataSets
        }

    }());

    mpgSoftware.firstResponders = (function () {
        /***
         * private
         */
        var appendValueWithEquivalenceChooser = function (currentDiv,holderId,sectionName,equivalenceId,valueId,helpTitle,helpText){
            currentDiv.append("<div id='"+holderId+"' class='row clearfix'>"+
                "<div class='primarySectionSeparator'>"+
                "<div class='col-sm-offset-1 col-md-3' style='text-align: right'>"+sectionName+"</div>"+
                "<div class='col-md-2'>"+
                "<select id='"+equivalenceId+"' class='form-control btn-group btn-input clearfix'>"+
                "<option value='lessThan'>&lt;</option>"+
                "<option value='greaterThan'>&gt;</option>"+
                "</select>"+
                "</div>"+
                "<div class='col-md-3'><input type='text' class='form-control' id='"+valueId+"'></div>"+
                "<div class='col-md-1'>"+
                "<span style='padding:10px 0 0 0' class='glyphicon glyphicon-question-sign pop-right' aria-hidden='true' data-toggle='popover' animation='true' "+
                "trigger='hover' data-container='body' data-placement='right' title='' data-content='"+helpText + "' data-original-title='"+helpTitle + "'></span>"+
                "</div>"+
                "<div class='col-md-2'>"+
                "<span class='glyphicon glyphicon-remove-circle filterCanceler filterRefiner' aria-hidden='true' onclick='mpgSoftware.variantWF.removeThisFilter(this)' id='remove_"+holderId+"'></span>"+
                "</div>"+
                "</div>");

        };


        var appendGeneChooser = function (currentDiv,holderId,sectionName,geneInputId,valueId,helpTitle,helpText){
            currentDiv.append("<div id='"+holderId+"' class='row clearfix'>"+
                "<div class='primarySectionSeparator'>"+
                "<div class='col-sm-offset-1 col-md-3' style='text-align: right'>"+sectionName+"</div>"+
                "<div class='col-md-5'>"+
                "<input type='text' class='form-control' id='region_gene_input' style='display: inline-block'/>"+
                "</div>"+
                "<div class='col-md-1'>"+
                "<span style='padding:10px 0 0 0' class='glyphicon glyphicon-question-sign pop-right' aria-hidden='true' data-toggle='popover' animation='true' "+
                "trigger='hover' data-container='body' data-placement='right' title='' data-content='"+helpText + "' data-original-title='"+helpTitle + "'></span>"+
                "</div>"+
                "<div class='col-md-2'>"+
                "<span class='glyphicon glyphicon-remove-circle filterCanceler filterRefiner' aria-hidden='true' onclick='mpgSoftware.variantWF.removeThisFilter(this)' id='remove_"+holderId+"'></span>"+
                "</div>"+
                "</div>");

        };


        var appendPositionChooser = function (currentDiv,holderId,sectionName,chromosomeId,startHere,endHere,helpTitle,helpText){
            currentDiv.append("<div id='"+holderId+"' class='row clearfix'>"+
                "<div class='primarySectionSeparator'>"+
                "<div class='col-sm-offset-1 col-md-3' style='text-align: right'>"+sectionName+"</div>"+
                "<div class='col-md-5'>"+
                "<div class='row'>"+
                "<div class='col-xs-4'>"+
                "<input class='form-control' type='text' id='" + chromosomeId+ "' placeholder='chrom'/>"+
                "</div>"+
                "<div class='col-xs-1'></div>"+
                "<div class='col-xs-3'>"+
                "<input class='form-control' type='text' id='" + startHere+ "' style='display: inline-block' placeholder='start'/>"+
                "</div>"+
                "<div class='col-xs-1'></div>"+
                "<div class='col-xs-3'>"+
                "<input class='form-control' type='text' id='" + endHere+ "' style='display: inline-block' placeholder='stop'/>"+
                "</div>"+
                "</div>"+
                "<div class='col-md-1'>"+
                "<span style='padding:10px 0 0 0' class='glyphicon glyphicon-question-sign pop-right' aria-hidden='true' data-toggle='popover' animation='true' "+
                "trigger='hover' data-container='body' data-placement='right' title='' data-content='"+helpText + "' data-original-title='"+helpTitle + "'></span>"+
                "</div>"+
                "</div>"+
                "<div class='col-md-2'>"+
                "<span class='glyphicon glyphicon-remove-circle filterCanceler filterRefiner' aria-hidden='true' onclick='mpgSoftware.variantWF.removeThisFilter(this)' id='remove_"+holderId+"'></span>"+
                "</div>"+
                "</div>");

        };

var appendProteinEffectsButtons = function (currentDiv,holderId,sectionName,allFunctionsCheckbox,proteinTruncatingCheckbox,missenseCheckbox,missenseOptions,
                                            polyphenSelect,siftSelect,condelSelect,synonymousCheckbox,noncodingCheckbox,    helpTitle,helpText){
    currentDiv.append("<div id='"+holderId+"' class='row clearfix'>"+
        "<div class='primarySectionSeparator'>"+
        "<div class='col-sm-offset-1 col-md-3' style='text-align: right'>"+sectionName+"</div>"+
        "<div class='col-md-5'>"+
    "<div class='row clearfix'>"+
    "<div class='col-md-12'>"+
    "<div id='biology-form'>"+
    "<div class='radio'>"+
    "<input type='radio' name='predictedEffects' value='all-effects' id='" +allFunctionsCheckbox + "' onClick=\"chgRadioButton('all-effects')\" checked='checked'/>"+
    "all effects"+
    "</div>"+
    "<div class='radio'>"+
    "<input type='radio' name='predictedEffects' value='protein-truncating' id='" +proteinTruncatingCheckbox + "' onClick=\"chgRadioButton('protein-truncating')\"/>"+
    "protein-truncating"+
    "</div>"+
    "<div class='radio'>"+
    "<input type='radio' name='predictedEffects' value='missense'  id='" +missenseCheckbox + "' onClick=\"chgRadioButton('missense')\"/>"+
    "missense"+
    "</div>"+
    "<div id='" + missenseOptions+ "' >"+
    "<div class='checkbox'>"+
    "PolyPhen-2 prediction"+
    "<select name='polyphen' id='" +polyphenSelect+ "'>"+
    "<option value=''>---</option>"+
    "<option value='probably_damaging'>probably damaging</option>"+
    "<option value='possibly_damaging'>possibly damaging</option>"+
    "<option value='benign'>benign</option>"+
    "</select>"+
    "</div>"+
    "<div class='checkbox'>"+
    "SIFT prediction"+
    "<select name='sift' id='" +siftSelect+ "'>"+
    "<option value=''>---</option>"+
    "<option value='deleterious'>deleterious</option>"+
    "<option value='tolerated'>tolerated</option>"+
    "</select>"+
    "</div>"+
    "<div class='checkbox'>"+
    "CONDEL prediction"+
    "<select name='condel' id='" +condelSelect+ "'>"+
    "<option value=''>---</option>"+
    "<option value='deleterious'>deleterious</option>"+
    "<option value='benign'>benign</option>"+
    "</select>"+
    "</div>"+
    "</div>"+
    "<div class='radio'>"+
    "<input type='radio' name='predictedEffects' value='noEffectSynonymous'  id='" +synonymousCheckbox + "' onClick=\"chgRadioButton('noEffectSynonymous')\"/>"+
    "no effect (synonymous coding)"+
    "</div>"+
    "<div class='radio'>"+
    "<input type='radio' name='predictedEffects' value='noEffectNoncoding'  id='" +noncodingCheckbox + " onClick=\"chgRadioButton('noEffectNoncoding')\"/>"+
    "no effect (non-coding)"+
    "</div>"+
    "</div>"+
    "</div>"+
    "</div>"+
    "</div>"+
        "</div>"+
        "<div class='col-md-1'>"+
        "<span style='padding:10px 0 0 0' class='glyphicon glyphicon-question-sign pop-right' aria-hidden='true' data-toggle='popover' animation='true' "+
        "trigger='hover' data-container='body' data-placement='right' title='' data-content='"+helpText + "' data-original-title='"+helpTitle + "'></span>"+
        "</div>"+
        "<div class='col-md-2'>"+
        "<span class='glyphicon glyphicon-remove-circle filterCanceler filterRefiner' aria-hidden='true' onclick='mpgSoftware.variantWF.removeThisFilter(this)' id='remove_"+holderId+"'></span>"+
        "</div>"+
        "</div>");
    $('#all_functions_checkbox').click()

}




        var displayPVChooser = function (holder){

            appendValueWithEquivalenceChooser (holder,'pvHolder','p value','pvEquivalence','pvValue',
                'P value help title','everything there is to say about P values');
        };
        var displayORChooser = function (holder){
            appendValueWithEquivalenceChooser (holder,'pvHolder','odds ratio','orEquivalence','orValue',
                'Odds ratio help title','everything there is to say about an odds ratio');
        };
        var displayESChooser = function (holder){
            appendValueWithEquivalenceChooser (holder,'esHolder','beta','esEquivalence','esValue',
                'Effect size help title','everything there is to say about an effect sizes');
        };
        var displayGeneChooser = function (holder){
            appendGeneChooser(holder,'geneHolder','gene','region_gene_input',
                'Gene chooser help title','everything there is to say about choosing a gene');
        };
        var displayPosChooser = function (holder){
            appendPositionChooser(holder,'geneHolder','position','region_chrom_input','region_start_input','region_stop_input',
                'position specification help title','everything there is to say about an specifying a position');
        };
        var displayPEChooser = function (holder){
            appendProteinEffectsButtons (holder,'peHolder','proteinEffect','all_functions_checkbox','protein_truncating_checkbox','missense_checkbox',
                'missense-options','polyphenSelect','siftSelect','condelSelect','synonymous_checkbox','noncoding_checkbox',
                'protein effect help title','everything there is to say about a protein effect');
        };
        var displayDSChooser = function (){

        };

        /***
         * public
         */
        var respondToPhenotypeSelection = function (){
            var phenotypeComboBox = UTILS.extractValsFromCombobox(['phenotype']);
            mpgSoftware.variantWF.retrieveDataSets(phenotypeComboBox['phenotype']);
            $('#dataSetChooser').show ();
            $('#filterInstructions').text('Choose a sample set  (or click GO for all sample sets):');
            mpgSoftware.variantWF.currentInteractivityState(0);  // but the other widgets know that the user is working on a single filter
        };

        var respondToDataSetSelection = function (){
            $('#additionalFilterSelection').show ();
            $('#filterInstructions').text('Add filters, if any:');
            mpgSoftware.variantWF.currentInteractivityState(0);
        };

        var respondToRequestForMoreFilters = function (x){
            var holder = $('#filterHolder');
            var choice = $("#additionalFilters option:selected");
            var selection = choice.val();
            switch (selection){
                case 'pvalue':displayPVChooser(holder);
                        break;
                case 'oddsratio':displayORChooser(holder);
                    break;
                case 'effectsize':displayESChooser(holder);
                    break;
                case 'gene':displayGeneChooser(holder);
                    break;
                case 'position':displayPosChooser(holder);
                    break;
                case 'predictedeffect':displayPEChooser(holder);
                    break;
                case 'dataset':displayDSChooser();
                    break;

            }
        };
        return {
            respondToPhenotypeSelection:respondToPhenotypeSelection,
            respondToDataSetSelection:respondToDataSetSelection,
            respondToRequestForMoreFilters:respondToRequestForMoreFilters
        }

    }());


})();




