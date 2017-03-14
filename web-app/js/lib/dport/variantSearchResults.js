
var mpgSoftware = mpgSoftware || {};

(function () {
    "use strict";

    mpgSoftware.variantSearchResults = (function () {
        // function for selecting strings
        var translationFunction;
        // dom node responsible for spinner
        var loading;
        // default variable to hold a load of URLs, dom selectors, and other variables to remember.  Better yet,
        //  however, is to hang everything off of the DOM element defined by .uniqueRoot
        var varsToRemember;
        // this is how requested properties beyond what's included in the search get added
        var additionalProperties = [];

        var getAdditionalProperties = function(){
            return additionalProperties;
        };

        var setVarsToRemember = function(myVarsToRemember){
            if (typeof myVarsToRemember !== 'undefined'){
                if (typeof myVarsToRemember.uniqueRoot === 'undefined'){
                    varsToRemember = myVarsToRemember;
                } else {
                    myVarsToRemember["variantTableResults"] = myVarsToRemember.uniqueRoot+'variantTableResults';
                    myVarsToRemember["variantTableHeaderRow"] = myVarsToRemember.uniqueRoot+'variantTableHeaderRow';
                    myVarsToRemember["variantTableHeaderRow2"] = myVarsToRemember.variantTableHeaderRow+"2";
                    myVarsToRemember["variantTableHeaderRow3"] = myVarsToRemember.variantTableHeaderRow+"3";
                    myVarsToRemember["variantTableBody"] = myVarsToRemember.uniqueRoot+"variantTableBody";
                    myVarsToRemember["dataModalGoesHere"] = myVarsToRemember.uniqueRoot+"dataModalGoesHere";
                    myVarsToRemember["dataModal"] = myVarsToRemember.uniqueRoot+"dataModal";
                    myVarsToRemember["phenotypeModal"] = myVarsToRemember.uniqueRoot+"phenotypeModal";
                    myVarsToRemember["datasetModal"] = myVarsToRemember.uniqueRoot+"datasetModal";
                    myVarsToRemember["propertiesModal"] = myVarsToRemember.uniqueRoot+"propertiesModal";
                    myVarsToRemember["datasetTabList"] = myVarsToRemember.uniqueRoot+"datasetTabList";
                    myVarsToRemember["datasetSelections"] = myVarsToRemember.uniqueRoot+"datasetSelections";
                    myVarsToRemember["propertiesTabList"] = myVarsToRemember.uniqueRoot+"propertiesTabList";
                    myVarsToRemember["propertiesTabPanes"] = myVarsToRemember.uniqueRoot+"propertiesTabPanes";
                    myVarsToRemember["add_phenotype"] = myVarsToRemember.uniqueRoot+"add_phenotype";
                    myVarsToRemember["subtract_phenotype"] = myVarsToRemember.uniqueRoot+"subtract_phenotype";
                    myVarsToRemember["holderForVariantSearchResults"] = myVarsToRemember.uniqueRoot+"holderForVariantSearchResults";
                    myVarsToRemember["phenotypeAddition"] = myVarsToRemember.uniqueRoot+"phenotypeAddition";
                    myVarsToRemember["phenotypeAdditionDataset"] = myVarsToRemember.uniqueRoot+"phenotypeAdditionDataset";
                    myVarsToRemember["phenotypeAdditionCohort"] = myVarsToRemember.uniqueRoot+"phenotypeAdditionCohort";
                    myVarsToRemember["phenotypeCohorts"] = myVarsToRemember.uniqueRoot+"phenotypeCohorts";
                    myVarsToRemember["linkToSave"] = myVarsToRemember.uniqueRoot+"linkToSave";
                    var dataNodeName = myVarsToRemember.uniqueRoot+"_data";
                    var dataNode = $('#'+dataNodeName);
                    if (!$.contains($('body'),dataNode[0])){
                        $('body').append('<div id="'+dataNodeName+'">');
                        dataNode = $('#'+dataNodeName);
                    }
                    $.data(dataNode[0],"variantResultsTableData",myVarsToRemember);
                }
            }

        };
        var getVarsToRemember = function(overrideVarsToRemember,specificVarsRootName){
            var returnValue;
            if (typeof overrideVarsToRemember === 'undefined') {
                if (typeof specificVarsRootName === 'undefined') {
                    returnValue = varsToRemember;
                } else {
                    var dataNodeName = specificVarsRootName+"_data";
                    var dataNode = $('#'+dataNodeName);
                    if (!dataNode.length){
                        console.log('ERROR: data structure holder named '+dataNodeName+' was unexpectedly missing');
                    } else {
                        returnValue = $.data(dataNode[0],"variantResultsTableData");
                    }
                }
            } else {
                returnValue = overrideVarsToRemember;
            }
            if (typeof returnValue === 'undefined') {
                console.log('ERROR: null data structure passed to Variant Results Table functions');
            }
            return returnValue;
        };

        // the URL may specify properties to add (so that users can share searches). if this is
        // the case, those properties will be passed down in string format via the additionalProperties
        // variable. then, set additionalProperties appropriately, so it can be modified later
        var initializeAdditionalProperties  = function  (additionalPropertiesFromServer){
            if(additionalPropertiesFromServer.length > 0) {
                additionalProperties = additionalPropertiesFromServer.split(':');
            }
        };

        // this gets the data that builds the table structure. the table is populated via a later call to
        // variantProcessing.iterativeVariantTableFiller
        var loadVariantTableViaAjax = function (queryFilters, searchUrl) {
            //additionalProperties = encodeURIComponent(additionalProperties.join(':'));
            loading = $('#spinner').show();
            return $.ajax({
                type: 'POST',
                cache: false,
                data: {
                    'filters': queryFilters,
                    'properties': encodeURIComponent(additionalProperties.join(':'))
                },
                url: searchUrl,
                timeout: 90 * 1000,
                async: true,
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    if(errorThrown == 'timeout') {
                        // attach the data for the error message so we know what queries are taking a long time
                        XMLHttpRequest.data = this.data;
                        var errorMessage = $('<h4></h4>').text('The query you requested took too long to perform. Please try restricting your criteria and searching again.').css('color', 'red');
                        $('#variantTable').html(errorMessage);
                    }
                    loading.hide();
                    core.errorReporter(XMLHttpRequest, errorThrown);
                }
            });
        };

        var dynamicFillTheFields = function (data,variantTableSelector,variantTableSelectorName) {
            variantTableSelector = getVarsToRemember(variantTableSelector,variantTableSelectorName);

            /**
             * This function exists to avoid having to do
             * "if translationDictionary[string] defined, return that, else return string"
             */
            translationFunction = function (stringToTranslate) {
                return data.translationDictionary[stringToTranslate] || stringToTranslate
            };
            // clear out the table
            if ( $.fn.DataTable.isDataTable( /*'#variantTable'*/ '#'+variantTableSelector.variantTableResults ) ) {
                $( '#'+variantTableSelector.variantTableResults).DataTable().destroy();
            }
            $('#'+variantTableSelector.variantTableHeaderRow).html('<th colspan=5 class="datatype-header dk-common"/>');
            $('#'+variantTableSelector.variantTableHeaderRow2).html('<th colspan=5 class="datatype-header dk-common"><g:message code="variantTable.columnHeaders.commonProperties"/></th>');
            $('#'+variantTableSelector.variantTableHeaderRow3+', #'+variantTableSelector.variantTableBody).empty();

            // common props section
            var totCol = 0;
            var varIdIndex = data.columns.cproperty.indexOf('VAR_ID');
            if (varIdIndex > 0) {
                data.columns.cproperty.splice(varIdIndex, 1);
            }
            var commonWidth = 0;
            for (var common in data.columns.cproperty) {
                var colName = data.columns.cproperty[common];
                var translatedColName = translationFunction(colName);
                if (!((colName === 'VAR_ID') && (commonWidth > 0))) { // VAR_ID never shows up other than in the first column
                    // the data-colname attribute is used in the table generation function
                    var newHeaderElement = $('<th>', {class: 'datatype-header dk-common', html: translatedColName}).attr('data-colName', colName);
                    $('#'+variantTableSelector.variantTableHeaderRow3).append(newHeaderElement);
                    commonWidth++;
                }

            }

            $('#'+variantTableSelector.variantTableHeaderRow).children().first().attr('colspan', commonWidth);
            $('#'+variantTableSelector.variantTableHeaderRow2).children().first().attr('colspan', commonWidth);
            totCol += commonWidth;

            // dataset props and pheno specific props
            _.forEach(_.keys(data.columns.pproperty), function(pheno, index) {
                var pheno_width = 0;
                // generate the class name for this phenotype. class names are only defined up
                // to dk-property-100, so if we have more than 10 phenotypes, just use 100 for all
                // of the extras
                var thisPhenotypeColor = 'dk-property-' + Math.min((index + 1) * 10, 100);
                var phenoDisp = translationFunction(pheno);
                for (var dataset in data.columns.pproperty[pheno]) {
                    var dataset_width = 0;
                    var datasetDisp = translationFunction(dataset);
                    // this first for-loop makes it so that dprops are displayed with each phenotype, even
                    // though they're technically independent. it is done this way because of how the column information
                    // is generated on the server.
                    for (var i = 0; i < data.columns.dproperty[pheno][dataset].length; i++) {
                        var column = data.columns.dproperty[pheno][dataset][i];
                        var columnDisp = translationFunction(column);
                        pheno_width++;
                        dataset_width++;
                        // the data-colname attribute is used in the table generation function
                        var newHeaderElement = $('<th>', {class: 'datatype-header ' + thisPhenotypeColor, html: columnDisp}).attr('data-colName', column + '.' + dataset);
                        $('#'+variantTableSelector.variantTableHeaderRow3).append(newHeaderElement);
                    }
                    for (var i = 0; i < data.columns.pproperty[pheno][dataset].length; i++) {
                        var column = data.columns.pproperty[pheno][dataset][i];
                        var columnDisp = translationFunction(column);
                        pheno_width++;
                        dataset_width++;
                        // the data-colname attribute is used in the table generation function
                        var newHeaderElement = $('<th>', {class: 'datatype-header ' + thisPhenotypeColor, html: columnDisp}).attr('data-colName', column + '.' + dataset + '.' + pheno);
                        $('#'+variantTableSelector.variantTableHeaderRow3).append(newHeaderElement);
                    }
                    if (dataset_width > 0) {
                        var newTableHeader = document.createElement('th');
                        newTableHeader.setAttribute('class', 'datatype-header ' + thisPhenotypeColor);
                        newTableHeader.setAttribute('colspan', dataset_width);
                        $(newTableHeader).append(datasetDisp);
                        $('#'+variantTableSelector.variantTableHeaderRow2).append(newTableHeader);
                    }
                }
                if (pheno_width > 0) {
                    var newTableHeader = document.createElement('th');
                    newTableHeader.setAttribute('class', 'datatype-header ' + thisPhenotypeColor);
                    newTableHeader.setAttribute('colspan', pheno_width);
                    $(newTableHeader).append(phenoDisp);
                    $('#'+variantTableSelector.variantTableHeaderRow).append(newTableHeader);
                }
                totCol += pheno_width;
            });


            // used to provide info to the table loader
            return totCol;

        };

        var displayPropertiesForDataset = function (dataset) {
            $('div[data-dataset]').hide();
            $('div[data-dataset="' + dataset + '"]').show();
        };

        // given the dataset map that reflects the structure of datasets and cohorts,
        // flatten it into an array of objects containing the id and name fields.
        // the order is that produced by a depth-first search.
        function flattenDatasetStructure(datasetMap) {
            var toReturn = [];
            _.forEach(datasetMap, function(children, dataset) {
                toReturn.push(dataset);
                toReturn = toReturn.concat(flattenDatasetStructure(_.omit(children, 'name')));
            });

            return toReturn;
        };

        function generateModal( data, passedInVars,passedInVarsName ) {
            passedInVars = getVarsToRemember(passedInVars,passedInVarsName);

            // populate the modals to add/remove properties
            // first do some processing on the search queries, so we know what can't
            // be removed
            var phenotypesInQueries = _.chain(filtersAsJson).map('phenotype').uniq().filter().value();
            var datasetsInQueries = _.chain(filtersAsJson).map(function(q) {
                return q.phenotype + '-' + q.dataset;
            }).uniq().value();
            var propertiesInQueries = _.chain(filtersAsJson).map(function(q) {
                return q.phenotype + '-' + q.dataset + '-' + q.prop;
            }).uniq().value();

            // add/subtract phenotypes modal -------------------------------------------
            // first get the phenotypes displayed so we know what we can remove--we approximate this
            // by looking at the data.columns.pproperty object
            var displayedPhenotypes = _.keys(data.columns.pproperty);

            // subtract phenotypes tab
            // first, remove any phenotypes listed that are no longer displayed
            _.forEach($('#subtractPhenotypesCheckboxes > div'), function(item) {
                if(! displayedPhenotypes.includes($(item).attr('data-phenotype'))) {
                    $(item).remove();
                }
            });
            var listedPhenotypes = _.map($('#subtractPhenotypesCheckboxes > div'), function(item) {
                return $(item).attr('data-phenotype');
            });
            // phenotypesToAdd is any phenotype that wasn't previously displayed
            var phenotypesToAdd = _.difference(displayedPhenotypes, listedPhenotypes);
            // then, go add any new phenotypes being displayed
            _.forEach(phenotypesToAdd, function(phenotype) {
                var newBox = $('<input />').attr({
                    type: 'checkbox',
                    checked: true,
                    disabled: phenotypesInQueries.includes(phenotype),
                    'data-category': 'phenotype'
                }).val(phenotype);
                var label = $('<label />').append(newBox);
                label.append(translationFunction(phenotype));
                var checkboxDiv = $('<div />').addClass('checkbox').attr({'data-phenotype': phenotype}).append(label);
                $('#subtractPhenotypesCheckboxes').append(checkboxDiv);
            });

            // add phenotypes tab
            var rememberPhenotypeAddition = passedInVars.phenotypeAddition;
            $.ajax({
                cache: false,
                type: "post",
                url: passedInVars.retrievePhenotypesAjaxUrl,
                data: {getNonePhenotype: true},
                async: true,
                success: function (data) {
                    if ( data && data.datasets ) {
                        UTILS.fillPhenotypeCompoundDropdown(data.datasets, '#'+rememberPhenotypeAddition, true, displayedPhenotypes);
                    }
                },
                error: function (jqXHR, exception) {
                    core.errorReporter(jqXHR, exception);
                }
            });

            // end add/subtract phenotypes modal -------------------------------------------

            // add/subtract datasets -------------------------------------------
            // use data.metadata[<phenotype>] (where <phenotype> is from the displayedPhenotypes array) to
            // get the list of all datasets for that phenotype. use data.columns.dproperty to get the list
            // of datasets currently being displayed

            _.forEach(displayedPhenotypes, function(phenotype, index) {
                // see if this tab has already been generated
                // if it has, we need to
                if($('a[href="#' + phenotype + 'DatasetSelection"]').length) {
                    return;
                }
                // create the tab
                var tabAnchor = $('<a/>').attr({
                    href: '#' + phenotype + 'DatasetSelection',
                    'aria-controls': phenotype + 'DatasetSelection',
                    role: 'tab',
                    'data-toggle': 'tab',
                    'data-phenotype': phenotype
                }).html(translationFunction(phenotype));
                var tabItem = $('<li />').attr({
                    'data-phenotype': phenotype,
                    role: 'presentation'
                });
                if( index == 0 ) {
                    tabItem.addClass('active');
                }
                tabItem.append(tabAnchor);
                $('#'+passedInVars.datasetTabList).append(tabItem);

                // create the list of datasets
                var displayedDatasets = _.keys(data.columns.pproperty[phenotype]);

                // pull out the datasets that shouldn't be checked
                var allAvailableDatasetsForPhenotype = flattenDatasetStructure(data.datasetStructure[phenotype]);
                var datasetsAvailableButNotDisplayed = _.chain(allAvailableDatasetsForPhenotype).difference(displayedDatasets).value();

                var datasetsHolder = $('<div />').addClass('dk-modal-form-input-group');
                _.forEach(displayedDatasets, function(dataset) {
                    var input = $('<input />').val(phenotype + '-' + dataset).attr({type: 'checkbox', checked: true, disabled: true, 'data-category': 'datasets'});
                    var label = $('<label />').append(input).append(translationFunction(dataset));
                    var holder = $('<div />').addClass('checkbox').append(label);
                    datasetsHolder.append(holder);
                });
                _.forEach(datasetsAvailableButNotDisplayed, function(dataset) {
                    var input = $('<input />').val(phenotype + '-' + dataset).attr({type: 'checkbox', 'data-category': 'datasets'});
                    var label = $('<label />').append(input).append(translationFunction(dataset));
                    var holder = $('<div />').addClass('checkbox').append(label);
                    datasetsHolder.append(holder);
                });

                var formHolder = $('<form />').addClass('dk-modal-form').append('<h4>Available datasets</h4>');
                formHolder.append(datasetsHolder);
                var tabPanel = $('<div />').addClass('tab-pane').attr({role: 'tabpanel', id: phenotype + 'DatasetSelection'});
                if( index == 0) {
                    tabPanel.addClass('active');
                }
                tabPanel.append(formHolder);
                $('#'+passedInVars.datasetSelections).append(tabPanel);

            });

            // now check if any phenotypes got removed, so we can remove their tabs
            _.forEach($('#'+passedInVars.datasetTabList+' li'), function(tab) {
                var tabPhenotype = $(tab).attr('data-phenotype');
                if(! displayedPhenotypes.includes(tabPhenotype)) {
                    $(tab).remove();
                }
            });

            // end add/subtract datasets -------------------------------------------

            // add/subtract properties -------------------------------------------
            // make a tab for each displayed phenotype, plus common properties
            // first clear out any existing tabs
            $('#'+passedInVars.propertiesTabList+', #'+passedInVars.propertiesTabPanes).empty();
            _.forEach(displayedPhenotypes, function(phenotype, index) {
                // build tab
                var tabAnchor = $('<a/>').attr({
                    href: '#' + phenotype + 'PropertiesSelection',
                    'aria-controls': phenotype + 'PropertiesSelection',
                    role: 'tab',
                    'data-toggle': 'tab'
                }).html(translationFunction(phenotype));
                var tabItem = $('<li />').attr({
                    role: 'presentation'
                });
                if( index == 0 ) {
                    tabItem.addClass('active');
                }
                tabItem.append(tabAnchor);
                $('#'+passedInVars.propertiesTabList).append(tabItem);

                // break the datasets and their properties into two separate arrays
                // this is because they're displayed in two different lists, so we can't
                // easily use a mustache template without breaking them apart
                var availableDatasets = _.chain(data.columns.pproperty[phenotype]).keys().orderBy(function(d) {
                    return translationFunction(d);
                }).value();
                var renderData = {
                    phenotype: phenotype,
                    active: index == 0 ? 'active' : '',
                    datasets: _.map(availableDatasets, function(dataset) {
                        return {
                            name: dataset,
                            displayName: translationFunction(dataset)
                        };
                    }),
                    propertiesGroup: []
                };
                _.forEach(availableDatasets, function(dataset) {
                    var availableProperties = data.metadata[phenotype][dataset];
                    // figure out what properties are already displayed--if none are displayed, then
                    // data.columns.pproperty[phenotype][dataset] is undefined, so default to the empty array
                    var displayedProperties = _.union(data.columns.pproperty[phenotype][dataset], data.columns.dproperty[phenotype][dataset]);
                    // there are three categories of properties. the first two are displayed in the table, the last is not
                    // 1. propertiesInherentToTheSearch: these are properties that are included by the nature of the search--
                    //      generally speaking, this includes p-value and OR. others may be included depending on how the backend works
                    // 2. addedProperties: these are properties being displayed in the table because the user selected them to
                    //      be displayed. general examples include EAF. these are broken out so that the user can unselect them.
                    // 3. propertiesAvailableButNotDisplayed: these are properties that can be displayed, but the user has not
                    //      added them to the table
                    var groupedProperties = _.groupBy(displayedProperties, function(property) {
                        var propertyValue = phenotype + '-' + dataset + '-' + property;
                        if(_.includes(propertiesInQueries, propertyValue)) {
                            return 'propertiesInherentToSearch';

                        } else {
                            return 'addedProperties';
                        }
                    });
                    var propertiesAvailableButNotDisplayed = _.difference(availableProperties, displayedProperties);
                    var properties = _.map(groupedProperties.propertiesInherentToSearch, function(prop) {
                        return {
                            checked: 'checked',
                            disabled: 'disabled',
                            name: phenotype + '-' + dataset + '-' + prop,
                            displayName: translationFunction(prop),
                            category: 'properties'
                        };
                    });
                    var checkedProperties = _.map(groupedProperties.addedProperties, function(prop) {
                        return {
                            checked: 'checked',
                            disabled: '',
                            name: phenotype + '-' + dataset + '-' + prop,
                            displayName: translationFunction(prop),
                            category: 'properties'
                        };
                    });
                    var uncheckedProperties = _.map(propertiesAvailableButNotDisplayed, function(prop) {
                        return {
                            checked: '',
                            disabled: '',
                            name: phenotype + '-' + dataset + '-' + prop,
                            displayName: translationFunction(prop),
                            category: 'properties'
                        };
                    });
                    properties = properties.concat(checkedProperties, uncheckedProperties);
                    var thisDatasetGrouping = {
                        dataset: dataset,
                        properties: properties
                    };
                    renderData.propertiesGroup.push(thisDatasetGrouping);
                });
                var propertiesInputsTemplate = $('#propertiesInputsTemplate').html();
                Mustache.parse(propertiesInputsTemplate);
                var rendered = Mustache.render(propertiesInputsTemplate, renderData);
                $('#'+passedInVars.propertiesTabPanes).append(rendered);
            });

            // common properties
            var tabAnchor = $('<a/>').attr({
                href: '.commonPropertiesSelection',
                'aria-controls': '.commonPropertiesSelection',
                role: 'tab',
                'data-toggle': 'tab'
            }).html(passedInVars.commonPropsMsg);
            var tabItem = $('<li />').attr({
                role: 'presentation'
            });
            tabItem.append(tabAnchor);
            $('#'+passedInVars.propertiesTabList).append(tabItem);

            var commonProps = _.map(data.cProperties.dataset, function(prop) {
                return {
                    checked: _.includes(data.columns.cproperty, prop) ? 'checked' : '',
                    name: 'common-common-' + prop,
                    displayName: translationFunction(prop),
                    category: 'properties'
                };
            });

            var commonPropsInputTemplate = $('#commonPropertiesInputsTemplate').html();
            Mustache.parse(commonPropsInputTemplate);
            var rendered = Mustache.render(commonPropsInputTemplate, {properties: commonProps});
            $('#'+passedInVars.propertiesTabPanes).append(rendered);

            // add/subtract properties -------------------------------------------
        };

        // when this is called, the table is generated/regenerated
        // it's here because of all the URLs/data that need to be filled in
        var loadTheTable = function (variantTableSelector,domHolderName) {
            variantTableSelector = getVarsToRemember(variantTableSelector,domHolderName);
            mpgSoftware.variantSearchResults.loadVariantTableViaAjax( variantTableSelector.queryFiltersInfo,
                variantTableSelector.variantSearchAndResultColumnsInfoUrl ).then(function (data, status) {
                if (status != 'success') {
                    // just give up
                    return;
                }
                if (data.errorMsg != ''){
                    alert(data.errorMsg);
                    var loader = $('#spinner');
                    loader.hide();
                    return;
                }
                var additionalProps = encodeURIComponent(additionalProperties.join(':'));
                var totCol = mpgSoftware.variantSearchResults.dynamicFillTheFields(data,variantTableSelector,domHolderName);

                var proteinEffectList = new UTILS.proteinEffectListConstructor(decodeURIComponent(variantTableSelector.proteinEffectsListInfo));
                variantProcessing.iterativeVariantTableFiller(data, totCol, variantTableSelector.filtersAsJsonInfo, '#'+variantTableSelector.variantTableResults,
                    variantTableSelector.variantSearchAndResultColumnsDataUrl,
                    variantTableSelector.variantInfoUrl,
                    variantTableSelector.geneInfoUrl,
                    proteinEffectList.proteinEffectMap,
                    variantTableSelector.localeInfo,
                    variantTableSelector.copyMsg,
                    variantTableSelector.printMsg,
                    {
                        filters: variantTableSelector.queryFiltersInfo,
                        properties: additionalProps
                    },
                    variantTableSelector.translatedFiltersInfo,
                    variantTableSelector
                );
                generateModal(data,variantTableSelector,domHolderName);

            });
        }

        // the following functions are here (instead of in a separate JS file or something) because
        // they either update the page state (in the form of additionalProperties), or need server-
        // generated URLs/strings
        var  confirmAddingProperties  = function(target,domSelectors,domSelectorName) {
            domSelectors = getVarsToRemember(domSelectors,domSelectorName);
            var matchingSelectedInputs = $('input[data-category="' + target + '"]:checked:not(:disabled)').get();
            var matchingUnselectedInputs = $('input[data-category="' + target + '"]:not(:checked,:disabled)').get();
            var valuesToInclude = _.map(matchingSelectedInputs, function (input) {
                return $(input).val();
            });
            var valuesToRemove = _.map(matchingUnselectedInputs, function (input) {
                return $(input).val();
            });

            // if we're coming off the phenotype tab, we need to see if the user selected a dataset
            // to add
            if(target == 'phenotype' ) {
                var phenotypeSelection = $('#'+domSelectors.phenotypeAddition).val();
                var datasetSelection = $('#'+domSelectors.phenotypeAdditionDataset).val();
                if(phenotypeSelection != 'default' && datasetSelection != 'default') {
                    // first see if a cohort was selected
                    var cohortSelection = $('#'+domSelectors.phenotypeAdditionCohort).val();
                    if(cohortSelection != 'default' && cohortSelection) {
                        datasetSelection = cohortSelection;
                    }

                    var propertyToAdd = phenotypeSelection + '-' + datasetSelection;
                    valuesToInclude.push(propertyToAdd);
                }

                // the other part of this is removing datasets/properties for phenotypes that have been
                // unselected. this isn't handled above because we don't add just a phenotype to
                // additionalProperties, it's always a phenotype+dataset. therefore, for the phentoypes
                // that have been unselected, go through additionalProperties and remove any dataset/property
                // that is from that phenotype.
                _.forEach(additionalProperties, function(prop) {
                    var propComponents = prop.split('-');
                    if(_.includes(valuesToRemove, propComponents[0])) {
                        valuesToRemove.push(prop);
                    }
                });
            }
            additionalProperties = _.difference(additionalProperties, valuesToRemove);
            additionalProperties = _.union(additionalProperties, valuesToInclude);

            loadTheTable(domSelectors,domSelectorName);

            // any necessary clean up
            // reset the dataset/cohort dropdowns on the phenotype addition tab
            $('#'+domSelectors.phenotypeAdditionDataset).empty();
            $('#'+domSelectors.phenotypeCohorts).hide();
        };
        var datasetSelected = function(domSelectors,domSelectorsHolder) {
            domSelectors = getVarsToRemember(domSelectors,domSelectorsHolder);
            var selectedDataset = $('#'+domSelectors.phenotypeAdditionDataset+' option:selected');
            var cohorts = selectedDataset.data();
            if(! _.isEmpty(cohorts)) {
                $('#'+domSelectors.phenotypeCohorts).show();
                var cohortOptions = $('#'+domSelectors.phenotypeAdditionCohort);
                cohortOptions.empty();
                cohortOptions.append("<option selected value=default>-- &nbsp;&nbsp;all cohorts&nbsp;&nbsp; --</option>");
                var displayData = UTILS.flattenDatasetMap(cohorts, 0);
                _.forEach(displayData, function(cohort) {
                    var newOption = $("<option />").val(cohort.value).html(cohort.name);
                    cohortOptions.append(newOption);
                });
            } else {
                $('#'+domSelectors.phenotypeCohorts).hide();
            }
        };
        var phenotypeSelected = function (domSelectors,domSelectorsName){
            domSelectors = getVarsToRemember(domSelectors,domSelectorsName);
            var phenotype = $('#'+domSelectors.phenotypeAddition).val();
            var rememberPhenotypeAdditionDataset = domSelectors.phenotypeAdditionDataset;
            $.ajax({
                cache: false,
                type: "post",
                url: domSelectors.retrieveDatasetsAjaxUrl,
                data: {phenotype: phenotype},
                async: true,
                success: function (data) {
                    if (data) {
                        var sampleGroupMap = data.sampleGroupMap;
                        var options = $('#'+rememberPhenotypeAdditionDataset);
                        options.empty();

                        options.append("<option selected hidden value=default>-- &nbsp;&nbsp;select a dataset&nbsp;&nbsp; --</option>");

                        var datasetList = _.keys(sampleGroupMap);
                        _.each(datasetList, function(dataset) {
                            var newOption = $("<option />").val(dataset).html(sampleGroupMap[dataset].name);
                            // check to see if this dataset has any values besides "name" defined--if so, then
                            // it has child cohorts. in that case, attach them as data (via jquery) so that we
                            // can easily access them if the user chooses this dataset.
                            var childDatasets = _.chain(sampleGroupMap[dataset]).omit('name').value();
                            if(_.keys(childDatasets).length > 0) {
                                newOption.data(childDatasets);
                            }
                            options.append(newOption);
                        });
                    }
                },
                error: function (jqXHR, exception) {
                    core.errorReporter(jqXHR, exception);
                }
            });
        };
        var saveLink = function (domSelectors,dataHolderName){
            domSelectors = getVarsToRemember(domSelectors,dataHolderName);
            var url = domSelectors.launchAVariantSearchUrl;
            url = url.concat('&props=' + encodeURIComponent(additionalProperties.join(':')));

            var reference = $('#'+domSelectors.linkToSave);
            // it appears the the browser may interrupt the copy if the element that's being
            // copied isn't visible, so show the element long enough to grab the url
            reference.show();
            // save the url
            reference.val(url);
            reference.focus();
            reference.select();
            var success = document.execCommand('copy');
            reference.hide();
            // if for whatever reason that fails (browser doesn't support it?), then display an error
            // and the URL
            if(! success ) {
                $('#'+domSelectors.linkToSave).show();
                alert('Sorry, this functionality isn\'t supported on your browser. Please copy the link from the text box.')
            }
        };

        var buildVariantResultsTable = function (drivingVariables,geneNamesToDisplay){
            setVarsToRemember(drivingVariables); // since this is our first Variant Results Table call, store the driving variables here
            var root = drivingVariables.uniqueRoot;
            initializeAdditionalProperties (drivingVariables.additionalPropertiesInfo);
            $("#variantSearchResultsInterface").empty().append(Mustache.render( $('#variantResultsMainStructuralTemplate')[0].innerHTML,
                drivingVariables));
            $("#"+drivingVariables.holderForVariantSearchResults).empty().append(
                Mustache.render( $('#variantSearchResultsTemplate')[0].innerHTML,drivingVariables));
            $(".dk-t2d-back-to-search").empty().append(
                Mustache.render( $('#topOfVariantResultsPageTemplate')[0].innerHTML,drivingVariables));
            loadTheTable(drivingVariables,root);

            $('[data-toggle="tooltip"]').tooltip();

            $("#"+drivingVariables.dataModalGoesHere).empty().append(
                Mustache.render( $('#dataModalTemplate')[0].innerHTML,drivingVariables));
            var allGenes = geneNamesToDisplay.replace("[","").replace("]","").split(',');
            if ((allGenes.length>0)&&
                (allGenes[0].length>0)){
                var namedGeneArray = _.map(allGenes,function(o){return {'name':o}});
                $(".regionDescr").empty().append(
                    Mustache.render( $('#dataRegionTemplate')[0].innerHTML,
                        { geneNamesToDisplay: namedGeneArray,
                            regionSpecification:'${regionSpecification}'}));
            }
            var translatedFilterArray = drivingVariables.translatedFiltersInfo.split(',');
            var namedTranslatedFilterArray = _.map(translatedFilterArray,function(o){return {'name':o}});
            $(".variantResultsFilterHolder").empty().append(
                Mustache.render( $('#variantResultsFilterHolderTemplate')[0].innerHTML,
                    { 'translatedFilters': namedTranslatedFilterArray})
            );
        };

        return {
            loadVariantTableViaAjax: loadVariantTableViaAjax,
            dynamicFillTheFields: dynamicFillTheFields,
            generateModal: generateModal,
            displayPropertiesForDataset: displayPropertiesForDataset,
            initializeAdditionalProperties:initializeAdditionalProperties,
            getAdditionalProperties: getAdditionalProperties,
            confirmAddingProperties:confirmAddingProperties,
            datasetSelected:datasetSelected,
            phenotypeSelected:phenotypeSelected,
            saveLink:saveLink,
            loadTheTable:loadTheTable,
            buildVariantResultsTable:buildVariantResultsTable,
            setVarsToRemember:setVarsToRemember
        }

    }());

    /***
     * methods that respond directly to user interaction
     */
    mpgSoftware.variantSearchResults.firstResponders = (function () {

        return {
        }

    }());


})();
