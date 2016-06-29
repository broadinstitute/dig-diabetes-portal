var mpgSoftware = mpgSoftware || {};

(function () {
    "use strict";

    mpgSoftware.variantSearchResults = (function () {
        // hoisted here
        var translationFunction;
        var loading = $('#spinner');

        // this gets the data that builds the table structure. the table is populated via a later call to
        // variantProcessing.iterativeVariantTableFiller
        var loadVariantTableViaAjax = function (queryFilters, additionalProps, searchUrl) {
            additionalProps = encodeURIComponent(additionalProps.join(':'));
            loading.show();
            return $.ajax({
                type: 'POST',
                cache: false,
                data: {
                    'filters': queryFilters,
                    'properties': additionalProps
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

        var dynamicFillTheFields = function (data) {
            /**
             * This function exists to avoid having to do
             * "if translationDictionary[string] defined, return that, else return string"
             */
            translationFunction = function (stringToTranslate) {
                return data.translationDictionary[stringToTranslate] || stringToTranslate
            };
            // clear out the table
            if ( $.fn.DataTable.isDataTable( '#variantTable' ) ) {
                $('#variantTable').DataTable().destroy();
            }
            $('#variantTableHeaderRow').html('<th colspan=5 class="datatype-header dk-common"/>');
            $('#variantTableHeaderRow2').html('<th colspan=5 class="datatype-header dk-common"><g:message code="variantTable.columnHeaders.commonProperties"/></th>');
            $('#variantTableHeaderRow3, #variantTableBody').empty();

            // common props section
            var sortCol = 0;
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
                    $('#variantTableHeaderRow3').append(newHeaderElement);
                    commonWidth++;
                }

            }

            $('#variantTableHeaderRow').children().first().attr('colspan', commonWidth);
            $('#variantTableHeaderRow2').children().first().attr('colspan', commonWidth);
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
                        $('#variantTableHeaderRow3').append(newHeaderElement);
                    }
                    for (var i = 0; i < data.columns.pproperty[pheno][dataset].length; i++) {
                        var column = data.columns.pproperty[pheno][dataset][i];
                        var columnDisp = translationFunction(column);
                        pheno_width++;
                        dataset_width++;
                        //HACK HACK HACK HACK HACK
                        // this causes the default sorted column to be the rightmost p-value column
                        if (column.substring(0, 2) == "P_") {
                            sortCol = totCol + pheno_width - 1;
                        }
                        // the data-colname attribute is used in the table generation function
                        var newHeaderElement = $('<th>', {class: 'datatype-header ' + thisPhenotypeColor, html: columnDisp}).attr('data-colName', column + '.' + dataset + '.' + pheno);
                        $('#variantTableHeaderRow3').append(newHeaderElement);
                    }
                    if (dataset_width > 0) {
                        var newTableHeader = document.createElement('th');
                        newTableHeader.setAttribute('class', 'datatype-header ' + thisPhenotypeColor);
                        newTableHeader.setAttribute('colspan', dataset_width);
                        $(newTableHeader).append(datasetDisp);
                        $('#variantTableHeaderRow2').append(newTableHeader);
                    }
                }
                if (pheno_width > 0) {
                    var newTableHeader = document.createElement('th');
                    newTableHeader.setAttribute('class', 'datatype-header ' + thisPhenotypeColor);
                    newTableHeader.setAttribute('colspan', pheno_width);
                    $(newTableHeader).append(phenoDisp);
                    $('#variantTableHeaderRow').append(newTableHeader);
                }
                totCol += pheno_width;
            });

            // used to provide info to the table loader
            return {
                totCol: totCol,
                sortCol: sortCol
            };
            
        };

        function generateModal(data, phenotypeUrl, commonPropsHeader) {
            // populate the modals to add/remove properties
            // first do some processing on the search queries, so we know what can't
            // be removed
            var phenotypesInQueries = _.chain(filtersAsJson).map('phenotype').uniq().value();
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
            $.ajax({
                cache: false,
                type: "post",
                url: phenotypeUrl,
                // url: "${g.createLink(controller: 'VariantSearch', action: 'retrievePhenotypesAjax')}",
                data: {getNonePhenotype: true},
                async: true,
                success: function (data) {
                    if ( data && data.datasets ) {
                        UTILS.fillPhenotypeCompoundDropdown(data.datasets, '#phenotypeAddition', true);
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
                // see if this tab has already been generated--if so, don't do anything
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
                $('#datasetTabList').append(tabItem);

                // create the list of datasets
                var displayedDatasets = _.keys(data.columns.pproperty[phenotype]);
                var allAvailableDatasetsForPhenotype = _.keys(data.metadata[phenotype]);
                // pull out the datasets that shouldn't be checked, and order them according to
                // their translated name
                var datasetsAvailableButNotDisplayed = _.chain(allAvailableDatasetsForPhenotype).difference(displayedDatasets).sortBy(function(d) {
                    return translationFunction(d);
                }).value();

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
                $('#datasetSelections').append(tabPanel);

            });

            // now check if any datasets got removed, so we can remove their tabs
            _.forEach($('#datasetTabList li'), function(tab) {
                var tabPhenotype = $(tab).attr('data-phenotype');
                if(! displayedPhenotypes.includes(tabPhenotype)) {
                    $(tab).remove();
                }
            });

            // end add/subtract datasets -------------------------------------------

            // add/subtract properties -------------------------------------------
            // make a tab for each displayed phenotype, plus common properties
            // first clear out any existing tabs
            $('#propertiesTabList, #propertiesTabPanes').empty();
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
                $('#propertiesTabList').append(tabItem);

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
                $('#propertiesTabPanes').append(rendered);
            });

            // common properties
            var tabAnchor = $('<a/>').attr({
                href: '#commonPropertiesSelection',
                'aria-controls': 'commonPropertiesSelection',
                role: 'tab',
                'data-toggle': 'tab'
            }).html(commonPropsHeader);
            var tabItem = $('<li />').attr({
                role: 'presentation'
            });
            tabItem.append(tabAnchor);
            $('#propertiesTabList').append(tabItem);

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
            $('#propertiesTabPanes').append(rendered);

            // add/subtract properties -------------------------------------------
        };

        return {
            loadVariantTableViaAjax: loadVariantTableViaAjax,
            dynamicFillTheFields: dynamicFillTheFields,
            generateModal: generateModal
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
