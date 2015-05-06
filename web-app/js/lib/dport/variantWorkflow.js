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
            var variantFilters = UTILS.extractValFromTextboxes(['pvValue','orValue']);
            var totalFilterCount = UTILS.extractValFromTextboxes(['totalFilterCount']);
            var experimentChoice = UTILS.extractValFromCheckboxes(['datasetExomeChip','datasetExomeSeq','datasetGWAS']);
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
            varsToSend = UTILS.concatMap(varsToSend,phenotypeInput) ;
            varsToSend = UTILS.concatMap(varsToSend,datasetInput) ;
            varsToSend = UTILS.concatMap(varsToSend,pvEquivalence) ;
            varsToSend = UTILS.concatMap(varsToSend,orEquivalence) ;
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
                "<div class='primarySectionSeparator' id='dataSetChooser'>"+
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

        var displayPVChooser = function (holder){

            appendValueWithEquivalenceChooser (holder,'pvHolder','p value','pvEquivalence','pvValue','P value help title','everything there is to say about P values');
        };
        var displayORChooser = function (holder){
            appendValueWithEquivalenceChooser (holder,'pvHolder','odds ratio','orEquivalence','orValue','Odds ratio help title','everything there is to say about an odds ratio');
        };
        var displayESChooser = function (holder){
            appendValueWithEquivalenceChooser (holder,'esHolder','beta','esEquivalence','esValue','Effect size help title','everything there is to say about an effect sizes');
        };
        var displayGeneChooser = function (){

        };
        var displayPosChooser = function (){

        };
        var displayPEChooser = function (){

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
                case 'gene':displayGeneChooser();
                    break;
                case 'position':displayPosChooser();
                    break;
                case 'predictedeffect':displayPEChooser();
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




