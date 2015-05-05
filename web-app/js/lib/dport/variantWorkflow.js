var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.variantWF = (function () {
        // private variables
        var customLegend = 0; // 0->defining a filter, 1-> potentially manipulating our  list of existing filters

        /***
         * private methods
         * @param indexNumber
         */
        // getter/setter
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
        // getter/setter
        var currentInteractivityState = function(x){
            if (!arguments.length) return customLegend;
            customLegend = x;
            return instance;
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
        var removeThisFilterSet = function (currentObject){
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
        var respondToPhenotypeSelection = function (){
            var phenotypeComboBox = UTILS.extractValsFromCombobox(['phenotype']);
            retrieveDataSets(phenotypeComboBox['phenotype']);
            $('#dataSetChooser').show ();
            $('#filterInstructions').text('Choose a sample set  (or click GO for all sample sets):')
        };
        var respondToDataSetSelection = function (){
            $('#variantFilter').show ();
            $('#filterInstructions').text('Add filters, if any:')
        };
        var gatherFieldsAndPostResults = function (){
            var varsToSend = {};
            var phenotypeInput = UTILS.extractValsFromCombobox(['phenotype']);
            var datasetInput = UTILS.extractValsFromCombobox(['dataSet']);
            var variantFilters = UTILS.extractValFromTextboxes(['pValue','orValue']);
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
            if (currentInteractivityState() === 0){

            }else if (currentInteractivityState() === 1){

            }
            //$("#phenotype").prepend("<option value='' selected='selected'></option>");
        };
        return {
            cancelThisFieldCollection:cancelThisFieldCollection,
            fillDataSetDropdown:fillDataSetDropdown,
            respondToPhenotypeSelection:respondToPhenotypeSelection,
            respondToDataSetSelection:respondToDataSetSelection,
            gatherFieldsAndPostResults:gatherFieldsAndPostResults,
            initializePage:initializePage,
            removeThisFilterSet:removeThisFilterSet
        }

    }());

})();




