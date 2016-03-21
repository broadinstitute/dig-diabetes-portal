var mpgSoftware = mpgSoftware || {};

(function () {
    "use strict";

    mpgSoftware.variantWF = (function () {
        // private variables
        var MAXIMUM_NUMBER_OF_FILTERS = 1000;
        var listOfSavedQueries = []

        /***
         * private methods
         * @param indexNumber
         */
        var JSON_VARIANT_MOST_DEL_SCORE_KEY      = "MOST_DEL_SCORE",
            JSON_VARIANT_CHROMOSOME_KEY      = "CHROM",
            JSON_VARIANT_POLYPHEN_PRED_KEY      = "PolyPhen_PRED",
            JSON_VARIANT_SIFT_PRED_KEY      = "SIFT_PRED",
            JSON_VARIANT_CONDEL_PRED_KEY    = "Condel_PRED";

        /**
         * If the page is provided a list of queries on load, then this function is called
         * to load those queries into the page display
         * @param listOfQueries
         */
        function initializePage(listOfQueries) {
            // we need to process each object, because the URI encoding/decoding
            // does some damage--so far, spaces are replaced with +, so change out those
            listOfSavedQueries = [];

            var keysToCheck = ['translatedName', 'translatedDataset', 'translatedPhenotype'];

            _.each(listOfQueries, function(query) {
                _.each(keysToCheck, function(key) {
                    if(query[key]) {
                        query[key] = query[key].replace(/\+/g, ' ');
                    }
                });
                listOfSavedQueries.push(query);
            });

            updatePageWithNewQueryList();
        }

        var retrievePhenotypes = function () {
            var loading = $('#spinner').show();
            $.ajax({
                cache: false,
                type: "post",
                url: "./retrievePhenotypesAjax",
                data: {},
                async: true,
                success: function (data) {
                    if (( data !==  null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.datasets !== 'undefined' ) &&
                        (  data.datasets !==  null ) ) {
                        UTILS.fillPhenotypeCompoundDropdown(data.datasets,'#phenotype',true);
                    }
                    loading.hide();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };

        var retrieveDataSets = function (phenotype, dataset,dropdownAlreadyPresent) {
            if (!dropdownAlreadyPresent) { // it may be that we already did this round-trip, in which case we don't need to do it again
                var loading = $('#spinner').show();
                $.ajax({
                    cache: false,
                    type: "post",
                    url: "./retrieveDatasetsAjax",
                    data: {phenotype: phenotype,
                        dataset: dataset},
                    async: true,
                    success: function (data) {
                        if (( data !== null ) &&
                            ( typeof data !== 'undefined') &&
                            ( typeof data.datasets !== 'undefined' ) &&
                            (  data.datasets !== null )) {
                            fillDataSetDropdown(data.datasets,data.sampleGroup.sampleGroup);
                        }
                        loading.hide();
                    },
                    error: function (jqXHR, exception) {
                        loading.hide();
                        core.errorReporter(jqXHR, exception);
                    }
                });
            }
        };
        /***
         * we need to go back to the server to get a list of properties. This can happen
         * into conditions:
         * 1) when the user has specified a phenotype and we need to pull back all associated properties.
         *    In this case none of the properties have values
         * 2) when the user is seeking to edit an existing filter.  In this case one or more of those properties
         *    may have an associated value. In this case this routine will be called once for each property
         * @param phenotype
         * @param dataset
         * @param property
         * @param equiv
         * @param value
         */
        var retrievePropertiesPerDataSet = function (phenotype,dataset,property,equiv,value) {
            var loading = $('#spinner').show();
            if (typeof property  === 'undefined') { // we are in case #1 as described above, and should therefore wipe out all existing properties
                $('.propertyHolderBox').remove();
            }
            $.ajax({
                cache: false,
                type: "post",
                url: "./retrievePropertiesAjax",
                data: {phenotype: phenotype,dataset: dataset},
                async: true,
                success: function (data) {
                    if (( data !==  null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.datasets !== 'undefined' ) &&
                        (  data.datasets !==  null ) ) {

                        fillPropertiesDropdown(data.datasets);

                        // only force a property selection if property is defined
                        if(property) {
                            mpgSoftware.firstResponders.forceToPropertySelection(property, equiv, value);
                            // because of the async nature of the ajax call, the text boxes would
                            // be filled after updateBuildSearchRequestButton called if this
                            // call wasn't here
                            mpgSoftware.firstResponders.updateBuildSearchRequestButton();
                        }
                        // make sure that the data set drop-down choice points to the right thing
                        if (typeof data.chosenDataset !== 'undefined'){
                            $('#dataSet').val(data.chosenDataset);
                        }
                    }
                    loading.hide();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };
        var fillDataSetDropdown = function (dataSetJson, sampleGroup) { // help text for each row
            if ((typeof dataSetJson !== 'undefined')  &&
                (typeof dataSetJson["is_error"] !== 'undefined')&&
                (dataSetJson["is_error"] === false))
            {
                var numberOfRecords = parseInt (dataSetJson ["numRecords"]);
                var options = $("#dataSet");
                options.empty();
                var dataSetList = dataSetJson ["dataset"];
                var rememberLastValue;
                for ( var i = 0 ; i < numberOfRecords ; i++ ){
                    var preceedingUnderscores = 0;
                    for (var j=0; j<dataSetList[i].length;j++ ){
                        if (dataSetList[i][j]!='-') break;
                        preceedingUnderscores++;
                    }
                    var replaceUnderscores = dataSetList[i].displayName.substr(0,preceedingUnderscores);
                    rememberLastValue = dataSetList[i].displayName.substr(preceedingUnderscores);
                    options.append($("<option />").val(dataSetList[i].name.substr(preceedingUnderscores))
                        .text(replaceUnderscores+dataSetList[i].displayName.substr(preceedingUnderscores)));
                }
                // if there's only one record, just click it to make the value
                // inputs appear
                if (numberOfRecords===1){
                    $("#dataSet").val(rememberLastValue);
                    $("#dataSet").click();
                }
                if (((typeof sampleGroup !== 'undefined')  &&
                    (sampleGroup !== 'null') &&
                    (sampleGroup !== ''))){
                    $("#dataSet").val(sampleGroup);
                }

            }
        };
        var fillPropertiesDropdown = function (dataSetJson) { // help text for each row
            if ((typeof dataSetJson !== 'undefined')  &&
                (typeof dataSetJson["is_error"] !== 'undefined')&&
                (dataSetJson["is_error"] === false))
            {
                var rowsToDisplay = _.flatMap(dataSetJson.dataset, function(v) {
                    return {
                        translatedName: v.translatedName,
                        propName: v.prop
                    };
                });

                var renderData = {
                    row: rowsToDisplay,
                    helpText: function() {
                        if( this.propName === 'P_VALUE' ) {
                            return 'Required. Examples: 0.005, 5.0E-4';
                        }
                    }
                }
                var rowTemplate = document.getElementById("rowTemplate").innerHTML;
                Mustache.parse(rowTemplate);
                var rendered = Mustache.render(rowTemplate, renderData);
                document.getElementById("rowTarget").innerHTML = rendered;
            }
        };

        var launchAVariantSearch = function (){
            console.log('listOfSavedQueries', listOfSavedQueries);

            // process the queries to remove fields the server won't use
            var listOfProcessedQueries = []
            _.each(listOfSavedQueries, function(query) {
                var keysToOmit = [
                    'translatedPhenotype',
                    'translatedName',
                    'translatedDataset'
                ];
                listOfProcessedQueries.push(_.omit(query, keysToOmit));
            });

            var encodedListOfQueries = encodeURIComponent(JSON.stringify(listOfProcessedQueries));
            window.location = './launchAVariantSearch/?' + encodedListOfQueries

        };

        /**
         * User has clicked "Build Search Request" button. Grab all the current
         * inputs, save them to an object, then reset the builder to build the
         * next part of the query.
         */
        var gatherCurrentQueryAndSave = function(event) {

            var phenoAndDS = UTILS.extractValsFromCombobox(['phenotype', 'dataSet']);
            if( phenoAndDS.phenotype !== 'default' ) {
                var phenotype = phenoAndDS.phenotype;
                var translatedPhenotype = $('#phenotype option:selected').text();
            }
            // if no dataset is selected, then phenoAndDS will not have a dataset key
            if( phenoAndDS.dataSet ) {
                var dataset = phenoAndDS.dataSet;
                var translatedDataset = $('#dataSet option:selected').html();
            }

            var propertiesInputs = $('input[data-type=propertiesInput]');
            _.forEach(propertiesInputs, function(input) {
                if( input.value !== "" ) {
                    // get the comparator value
                    var comparator = $('select[data-selectfor=' + input.dataset.prop +']')[0].value;
                    console.log('value is', input.value, parseFloat(input.value), parseFloat(input.value).toString());
                    var newQuery = {
                        phenotype: phenotype,
                        translatedPhenotype: translatedPhenotype,
                        dataset: dataset,
                        translatedDataset: translatedDataset,
                        prop: input.dataset.prop,
                        translatedName: input.dataset.translatedname,
                        // this parsing/toStringing is because the backend doesn't
                        // like decimal values without leading zeros
                        value: parseFloat(input.value).toString(),
                        comparator: comparator
                    };
                    console.log(newQuery);
                    listOfSavedQueries.push(newQuery);
                }
            });

            // get the current query types so that we can prevent the user
            // from adding both a gene input and a chromosome input
            var currentlyDefinedQueryTypes = _.map(listOfSavedQueries, 'prop');
            var geneInputAlreadyDefined = currentlyDefinedQueryTypes.indexOf('gene') > -1;
            var chromosomeInputAlreadyDefined = currentlyDefinedQueryTypes.indexOf('chromosome') > -1;

            var advancedFilterInputs = $('input[data-type=advancedFilterInput]');
            _.forEach(advancedFilterInputs, function(input) {
                if( input.value !== "" ) {
                    // if this input is a gene, and there's a chromosome query,
                    // or vice versa, ignore the input
                    if ((geneInputAlreadyDefined && input.dataset.prop == 'chromosome') ||
                        (chromosomeInputAlreadyDefined && input.dataset.prop == 'gene')) {
                        return
                    }
                    var newQuery = {
                        prop: input.dataset.prop,
                        translatedName: input.dataset.translatedname,
                        value: input.value,
                        comparator: '='
                    };
                    // If we have a gene input, check to see if the +/- dropdown
                    // has been set. If so, tack on that value to newQuery.value
                    var geneRangeInputSetting = document.getElementById('geneRangeInput').value;
                    if( input.dataset.prop === 'gene' && geneRangeInputSetting != '' ) {
                        newQuery.value += ' ± ' + geneRangeInputSetting;
                    }
                    listOfSavedQueries.push(newQuery);
                }
            });

            // this handles just the predicted effect high-level selection, not
            // the polyphen/sift/condel selections
            // first check to see if something was selected in the first place
            var selectedProteinEffect = document.querySelector('input[name="predictedEffects"]:checked');
            if( !_.isNull(selectedProteinEffect) ) {
                var proteinEffectSelection = selectedProteinEffect.value;
                var newQuery = {
                    prop: JSON_VARIANT_MOST_DEL_SCORE_KEY,
                    translatedName: 'Deleteriousness category',
                    value: proteinEffectSelection,
                    comparator: '='
                };
                // if we already have a missense query, no need to add another one
                if( propsWithQueries().indexOf(JSON_VARIANT_MOST_DEL_SCORE_KEY) === -1 ) {
                    listOfSavedQueries.push(newQuery);
                }
            }

            // if the "missense" predicted effect is selected, need to grab the
            // polyphen/sift/condel selections here
            if( proteinEffectSelection == 2 ) {
                var missenseSelections = $('select[data-type="proteinEffectSelection"]');
                _.each(missenseSelections, function(input) {
                    // if the user has selected something other than the default, then
                    // .value will not be the empty string
                    if(input.value !== '') {
                        var newQuery = {
                            prop: input.name,
                            translatedName: input.dataset.translatedname,
                            value: input.value,
                            comparator: '='
                        };
                        listOfSavedQueries.push(newQuery);
                    }
                });
            }

            // make call to update list of saved queries
            updatePageWithNewQueryList();

            // reset all of the inputs
            resetInputFields();

            // disable the build search request button
            mpgSoftware.firstResponders.updateBuildSearchRequestButton();
        };

        /**
         * this function is called after the list of queries is updated,
         * so that the page is updated appropriately
         */
        var updatePageWithNewQueryList = function() {
            var searchDetailsTemplate = document.getElementById("searchDetailsTemplate").innerHTML;
            Mustache.parse(searchDetailsTemplate);
            var renderData = {
                listOfSavedQueries: listOfSavedQueries,
                // use this to support editing queries
                index: function() {
                    return listOfSavedQueries.indexOf(this);
                },
                // translate certain values into human-readable form
                displayValue: function() {
                    if( this.prop === JSON_VARIANT_MOST_DEL_SCORE_KEY ) {
                        switch(this.value) {
                            case '0':
                                return 'all effects';
                            case '1':
                                return 'protein-truncating';
                            case '2':
                                return 'missense';
                            case '3':
                                return 'no effect (synonymous coding)';
                            case '4':
                                return 'no effect (non-coding)';
                        }
                    }
                    return this.value;
                }
            };
            var rendered = Mustache.render(searchDetailsTemplate, renderData);
            document.getElementById("searchDetailsHolder").innerHTML = rendered;
        };

        /**
         * removes the query from the list, and puts it back in the inputs
         * @param indexToEdit
         */
        function editQuery(indexToEdit) {
            // delete the query
            var queryToEdit = listOfSavedQueries.splice(indexToEdit, 1)[0];
            // clear the current inputs
            resetInputFields();
            // reset inputs to match this query
            resetInputsToQuery(queryToEdit);
            // update the displayed list of queries
            updatePageWithNewQueryList();
            // reenable the build search button
            mpgSoftware.firstResponders.updateBuildSearchRequestButton();
        };

        var deleteQuery = function(indexToDelete) {
            var deletedQuery = listOfSavedQueries.splice(indexToDelete, 1)[0];
            // if the deleted query was a chromosome or gene query, reenable
            // the chromosome and gene inputs
            if( ['chromosome', 'gene'].indexOf(deletedQuery.prop) > -1 ) {
                document.getElementById('geneInput').removeAttribute('disabled');
                document.getElementById('chromosomeInput').removeAttribute('disabled');
            }
            updatePageWithNewQueryList();
        };

        /**
         * Given the input query, adjust the appropriate inputs to reflect the
         * query
         * @param query
         */
        var resetInputsToQuery = function (query){
            switch(query.prop) {
                case 'gene':
                    // the gene value could be the gene name, or the gene name
                    // along with a +/- setting
                    if(query.value.indexOf('±') === -1) {
                        // just the gene name
                        document.getElementById('geneInput').value = query.value;
                    } else {
                        var geneSplit = query.value.split(' ± ');
                        document.getElementById('geneInput').value = geneSplit[0];
                        document.getElementById('geneRangeInput').value = geneSplit[1];
                    }
                    $('#advanced_filter').show();
                    document.getElementById('geneInput').removeAttribute('disabled');
                    break;
                case 'chromosome':
                    document.getElementById('chromosomeInput').value = query.value;
                    $('#advanced_filter').show();
                    document.getElementById('chromosomeInput').removeAttribute('disabled');
                    break;
                case JSON_VARIANT_MOST_DEL_SCORE_KEY:
                    document.querySelector('input[name="predictedEffects"][value="'+query.value+'"]').checked = true;
                    $('#advanced_filter').show();
                    break;
                case JSON_VARIANT_POLYPHEN_PRED_KEY:
                case JSON_VARIANT_SIFT_PRED_KEY:
                case JSON_VARIANT_CONDEL_PRED_KEY:
                    document.querySelector('input[name="predictedEffects"][value="2"]').checked = true;
                    document.querySelector('select[name="' + query.prop + '"]').value = query.value;
                    $('#advanced_filter').show();
                    mpgSoftware.firstResponders.updateProteinEffectSelection('2');
                    break;
                // this catches all of the basic queries (e.g. p-value, odds ratio)
                default:
                    document.getElementById('phenotype').value = query.phenotype;
                    mpgSoftware.firstResponders.forceToPhenotypeSelection(query.phenotype,query.dataset);
                    mpgSoftware.firstResponders.forceToDataSetSelection(query.dataset,query.phenotype,query.prop,query.comparator,query.value);
                    break;
            }
        };

        // use this after submitting a query or resetting
        // justAdvancedFiltering is true if only the advanced filters should be cleared
        var resetInputFields = function(justAdvancedFiltering) {
            if( ! justAdvancedFiltering ) {
                // clear out the phenotype and dataset dropdowns
                var options = document.getElementById("dataSet");
                $(options).empty();
                fillPropertiesDropdown({is_error: false});
                document.getElementById('phenotype').value = 'default';
            }

            // advanced filters
            document.getElementById('geneInput').value = '';
            document.getElementById('chromosomeInput').value = '';
            document.getElementById('geneRangeInput').value = '';

            // if we have a gene or chromosome input, disable both of them
            var propsWithQs = propsWithQueries();
            if( propsWithQs.indexOf('chromosome') > -1 || propsWithQs.indexOf('gene') > -1 ) {
                document.getElementById('geneInput').setAttribute('disabled', 'true');
                document.getElementById('chromosomeInput').setAttribute('disabled', 'true');
            }

            var selectedPredictedEffect = document.querySelector('input[name="predictedEffects"]:checked');
            // if an effect is selected, clear it, otherwise do nothing
            if( selectedPredictedEffect ) {
                selectedPredictedEffect.checked = false;
            }

            var additionalPredictedEffects = $('select[data-type="proteinEffectSelection"]');
            _.each(additionalPredictedEffects, function(dropdown) {
                dropdown.value = '';
            });

            $('#missense-options').hide(300);
            $('#advanced_filter').hide(300);
        };

        /**
         * helper function that returns the props that have queries built
         */
        function propsWithQueries() {
            return _.map(listOfSavedQueries, 'prop');
        }

        return {
            fillDataSetDropdown:fillDataSetDropdown,
            fillPropertiesDropdown:fillPropertiesDropdown,
            launchAVariantSearch:launchAVariantSearch,
            retrievePhenotypes:retrievePhenotypes,
            retrieveDataSets:retrieveDataSets,
            retrievePropertiesPerDataSet:retrievePropertiesPerDataSet,
            gatherCurrentQueryAndSave: gatherCurrentQueryAndSave,
            editQuery: editQuery,
            deleteQuery: deleteQuery,
            resetInputFields: resetInputFields,
            propsWithQueries: propsWithQueries,
            initializePage: initializePage
        }

    }());

    /***
     * lots of callbacks, and other methods that respond directly to user interaction
     */
    mpgSoftware.firstResponders = (function () {

        var forceToPropertySelection = function (sectionName, equivalence, value){
            // this function sometimes gets called with all 3 arguments being 'undefined',
            // which would cause this function to throw a few errors
            if( sectionName ) {
                document.querySelector('select[data-selectfor="' + sectionName + '"]').value = equivalence;
                document.querySelector('input[data-prop="' + sectionName + '"]').value = value;
            }
        };
        var forceToPhenotypeSelection = function (phenotypeComboBox,dataset){
            mpgSoftware.variantWF.retrieveDataSets(phenotypeComboBox,dataset);
            $('#dataSetChooser').show ();
        };
        var respondToPhenotypeSelection = function (){
            var phenotypeComboBox = UTILS.extractValsFromCombobox(['phenotype']);

            // phenotype is changed.  Before we get to the asynchronous parts let's wipe out the properties
            forceToPhenotypeSelection(phenotypeComboBox['phenotype']);
        };

        var forceToDataSetSelection = function (dataSetComboBox,phenotypeComboBox,property,equiv,value ){
            mpgSoftware.variantWF.retrievePropertiesPerDataSet(phenotypeComboBox,dataSetComboBox,property,equiv,value);
        };

        var respondToDataSetSelection = function (){
            var dataSetComboBox = UTILS.extractValsFromCombobox(['dataSet']);
            var phenotypeComboBox = UTILS.extractValsFromCombobox(['phenotype']);
            forceToDataSetSelection(dataSetComboBox["dataSet"],phenotypeComboBox["phenotype"]);
        };

        /**
         * Given a change in the contents of any of the inputs, update the
         * "build search request" button to be enabled/disabled. The button
         * should be enabled if any of the following conditions are met:
         *      * any of properties fields (e.g. p-value, odds ratio) have a value, OR
         *      * the gene is specified in the advanced filter, OR
         *      * the region is specified in the advanced filter
         * The button should be disabled otherwise.
         */
        var updateBuildSearchRequestButton = function () {
            var propertiesInputsAreEmpty = _.every($('input[data-type=propertiesInput]'), function(input) {
                return input.value === "";
            });

            var advancedFilterInputsAreEmpty = _.every($('input[data-type=advancedFilterInput]'), function(input) {
                return input.value === "";
            });

            var proteinEffectsAreUnselected = _.every($('input[name="predictedEffects"]'), function(input) {
                return ! input.checked;
            });

            var areInputValuesPresent = ! ( propertiesInputsAreEmpty &&
                                            advancedFilterInputsAreEmpty &&
                                            proteinEffectsAreUnselected )

            var button = document.getElementById('buildSearchRequest');
            if(areInputValuesPresent) {
                // enable the button
                button.classList.remove('dk-search-btn-inactive')
                button.disabled = false
            } else {
                // disable the button
                button.classList.add('dk-search-btn-inactive')
                button.disabled = true
            }
        };

        /**
         * If the missense protein effect option is selected, show the extended
         * options
         */
        function updateProteinEffectSelection(buttonLabel){
            // also update the build search button
            mpgSoftware.firstResponders.updateBuildSearchRequestButton();

            // 2 comes from the definition of PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE
            if (buttonLabel == 2)  {
                $('#missense-options').show(200);
            }  else {
                $('#missense-options').hide(200);
            }
        }

        /**
         * Give the user a heads up if the chromosome input is a valid format--does not
         * prevent a nonsense input where the end is before the start, or a non-existant
         * chromosome is input.
         * Won't prevent them from submitting, but they can figure it out when they
         * get an empty response
         */
        function validateChromosomeInput() {
            var chromosomeInputValue = document.getElementById('chromosomeInput').value;
            // matches: '1', '1:2-3', and ''
            var doesChromosomeInputMakeSense = /^(\d{1,2}(:\d+-\d+)?)?$/.test(chromosomeInputValue);
            if( !doesChromosomeInputMakeSense ) {
                document.getElementById('chromosomeInput').classList.add('redBorder');
            } else {
                document.getElementById('chromosomeInput').classList.remove('redBorder');
            }
        };

        /**
         * Given the gene and chromosome inputs, disable one if the other has
         * an input in it
         */
        function controlGeneAndChromosomeInputs() {
            var geneInputValue = document.getElementById('geneInput').value;
            var chromosomeInputValue = document.getElementById('chromosomeInput').value;

            // get the props that already have queries associated with them
            var queryProps = mpgSoftware.variantWF.propsWithQueries();

            // if we have no gene input, AND there's not already a chromosome query defined
            if( geneInputValue === '' && queryProps.indexOf('chromosome') === -1 ) {
                document.getElementById('chromosomeInput').removeAttribute('disabled');
            } else {
                document.getElementById('chromosomeInput').setAttribute('disabled', 'true');
            }
            // if we have no chromosome input, AND there's not already a gene query defined
            if( chromosomeInputValue === '' && queryProps.indexOf('gene') === -1) {
                document.getElementById('geneInput').removeAttribute('disabled');
            } else {
                document.getElementById('geneInput').setAttribute('disabled', 'true');
            }
        }

        return {
            forceToPhenotypeSelection:forceToPhenotypeSelection,
            respondToPhenotypeSelection:respondToPhenotypeSelection,
            forceToDataSetSelection:forceToDataSetSelection,
            respondToDataSetSelection:respondToDataSetSelection,
            forceToPropertySelection:forceToPropertySelection,
            updateBuildSearchRequestButton:updateBuildSearchRequestButton,
            updateProteinEffectSelection: updateProteinEffectSelection,
            validateChromosomeInput: validateChromosomeInput,
            controlGeneAndChromosomeInputs: controlGeneAndChromosomeInputs
        }

    }());


})();
