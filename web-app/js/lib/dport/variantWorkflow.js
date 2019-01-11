var mpgSoftware = mpgSoftware || {};

(function () {
    "use strict";

    mpgSoftware.variantWF = (function () {
        // private variables
        var listOfSavedQueries = [];

        /***
         * private methods
         * @param indexNumber
         */
        var JSON_VARIANT_MOST_DEL_SCORE_KEY = "MOST_DEL_SCORE",
            JSON_VARIANT_CHROMOSOME_KEY = "CHROM",
            JSON_VARIANT_POLYPHEN_PRED_KEY = "PolyPhen_PRED",
            JSON_VARIANT_SIFT_PRED_KEY = "SIFT_PRED",
            JSON_VARIANT_CONDEL_PRED_KEY = "Condel_PRED";

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

            _.each(listOfQueries, function (query) {
                _.each(keysToCheck, function (key) {
                    if (query[key]) {
                        query[key] = query[key].replace(/\+/g, ' ');
                    }
                });
                listOfSavedQueries.push(query);
            });

            // unset the "all effects" protein effect button, which is checked by default
            // for the situation where you're coming to the variant finder for a fresh search
            document.getElementById('allProteinEffects').removeAttribute('checked');

            updatePageWithNewQueryList();
            // calling resetInputFields() will disable any inputs for which we have
            // an existing query
            resetInputFields();
        }

        // called when page loads
        var retrievePhenotypes = function (portaltype) {
            var loading = $('#spinner').show();
            var rememberportaltype = portaltype;
            $.ajax({
                cache: false,
                type: "post",
                url: "./retrievePhenotypesAjax",
                data: {getNonePhenotype: false},
                async: true,
                success: function (data) {
                    if (( data !== null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.datasets !== 'undefined' ) &&
                        (  data.datasets !== null )) {

                        console.log(data);
                        UTILS.fillPhenotypeCompoundDropdown(data.datasets, '#phenotype', true, [], rememberportaltype);
                    }
                    loading.hide();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };

        // called when page loads
        var retrievePhenotypeIndependentDatasets = function (phenotype) {
            retrieveDatasets(phenotype, 'dependent');
        };

        // query is a passthrough value, and may be undefined
        var retrieveDatasets = function (phenotype, target, query) {
            // prevent requests being sent with pointless data
            if (phenotype == 'default') {
                return;
            }
            var loading = $('#spinner').show();
            $.ajax({
                cache: false,
                type: "post",
                url: "./retrieveDatasetsAjax",
                data: {phenotype: phenotype},
                async: true,
                success: function (data) {
                    if (data) {
                        fillDatasetDropdown(data.sampleGroupMap, target, query);
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
         * we need to go back to the server to get a list of properties. This can happen
         * into conditions:
         * 1) when the user has specified a phenotype and we need to pull back all associated properties.
         *    In this case none of the properties have values
         * 2) when the user is seeking to edit an existing filter.  In this case the property, equiv,
         *    and value fields must be defined, and are used to load the inputs
         * @param phenotype     the selected phenotype value
         * @param dataset       the selected dataset value
         * @param target        states whether this is tied to the dependent or independent search--may be 'dependent' or 'independent'
         * @param query         if editing an existing criteria, the object containing the criteria data--may be undefined
         */
        var retrievePropertiesPerDataSet = function (phenotype, dataset, target, query) {
            // prevent requests being sent with pointless data
            if (phenotype == 'default' || dataset == 'default' || _.isUndefined(dataset)) {
                return;
            }
            var loading = $('#spinner').show();

            $.ajax({
                cache: false,
                type: "post",
                url: "./retrievePropertiesAjax",
                data: {phenotype: phenotype, dataset: dataset},
                async: true,
                success: function (data) {
                    if (data && data.datasets) {
                        fillPropertiesDropdown(data.datasets, target);

                        // only force a property selection if query is defined
                        if (query) {
                            mpgSoftware.firstResponders.forceToPropertySelection(query);
                            // because of the async nature of the ajax call, the text boxes would
                            // be filled after updateBuildSearchRequestButton called if this
                            // call wasn't here
                            mpgSoftware.firstResponders.updateBuildSearchRequestButton(target);
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
        // target is the indicator for the select element to be filled--'dependent' or 'independent'
        var fillDatasetDropdown = function (sampleGroupMap, target, query) {
            var targetSelect = target == 'dependent' ? '#datasetDependent' : '#datasetIndependent';

            var numberOfTopLevelDatasets = _.keys(sampleGroupMap).length;

            if(numberOfTopLevelDatasets == 0 && target == 'independent') {
                // if we have no phenotype-independent datasets, hide this option
                $('#datasetChooserIndependent').hide();
                return;
            }

            var options = $(targetSelect);
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

            // clear out the properties list
            fillPropertiesDropdown({is_error: false}, target);

            // if there's only one record, just click it to make the property inputs appear
            if (numberOfTopLevelDatasets === 1) {
                $(targetSelect).val(datasetList[0].name);
                $(targetSelect).change();
            }

            options.prop('disabled', false);

            if (query) {
                // we need to check if any of the options available match the query's
                // dataset--if not, we're dealing with a cohort. in that case, we need to
                // figure out the right parent dataset, set the dataset selector to that,
                // then set the cohort selector correctly.
                var availableDatasetOptions = _.map($(targetSelect + ' option'), function(ele) {
                    return $(ele).val();
                });

                if(availableDatasetOptions.includes(query.dataset)) {
                    $(targetSelect).val(query.dataset);
                } else {
                    // do string prefix matching. strip off the "_mdv#" from the query.dataset field
                    var indexOfLastUnderscore = query.dataset.lastIndexOf('_');
                    var datasetPrefix = query.dataset.substring(0, indexOfLastUnderscore);
                    // save this for later
                    var dataVersion = query.dataset.substring(indexOfLastUnderscore);
                    var trimmedDatasetOptions = _.map(availableDatasetOptions, function(d) {
                        var indexOfLastUnderscore = d.lastIndexOf('_');
                        return d.substring(0, indexOfLastUnderscore);
                    });
                    var parentDataset = _.find(trimmedDatasetOptions, function(d) {
                        // the 'default' option ends up as the empty string, which always matches,
                        // but we don't want that
                        if(d == '') {
                            return false;
                        }
                        return datasetPrefix.indexOf(d) > -1;
                    });

                    // set the dataset selector to the determined parent dataset
                    $(targetSelect).val(parentDataset + dataVersion);
                    // to get the cohorts to load
                    $(targetSelect).change();
                    var cohortTargetSelect = targetSelect == '#datasetDependent' ? '#datasetCohortDependent' : '#datasetCohortIndependent';
                    $(cohortTargetSelect).val(query.dataset);
                }

                retrievePropertiesPerDataSet(query.phenotype, query.dataset, target, query);
            }
        };
        var fillPropertiesDropdown = function (data, target) { // help text for each row
            if (data && data.is_error == false) {
                var rowsToDisplay = _.flatMap(data.dataset, function (v) {
                    return {
                        translatedName: v.translatedName,
                        propName: v.prop
                    };
                });

                var targetedElement = target.toLowerCase().indexOf('independent') > -1 ? 'datasetIndependent' : 'datasetDependent';

                var renderData = {
                    row: rowsToDisplay,
                    helpText: function () {
                        if (this.propName === 'P_VALUE' || this.propName === 'P_EMMAX') {
                            return 'Examples: 0.005, 5.0E-4';
                        }
                    },
                    category: function () {
                        return targetedElement;
                    }
                };
                var rowTemplate = document.getElementById("rowTemplate").innerHTML;
                Mustache.parse(rowTemplate);
                var rendered = Mustache.render(rowTemplate, renderData);
                var targetElement;
                if(target.toLowerCase().indexOf('independent') > -1 ) {
                    targetElement = 'independentRowTarget';
                } else {
                    targetElement = 'dependentRowTarget';
                }

                document.getElementById(targetElement).innerHTML = rendered;
            }
        };

        var launchAVariantSearch = function () {
            // process the queries to remove fields the server won't use
            var listOfProcessedQueries = [];
            _.each(listOfSavedQueries, function (query) {
                var keysToOmit = [
                    'translatedPhenotype',
                    'translatedName',
                    'translatedDataset'
                ];
                listOfProcessedQueries.push(_.omit(query, keysToOmit));
            });

            var encodedListOfQueries = encodeURIComponent(JSON.stringify(listOfProcessedQueries));
            window.location = './launchAVariantSearch/?filters=' + encodedListOfQueries

        };

        /**
         * User has clicked "Build Search Request" button. Grab all the current
         * inputs, save them to an object, then reset the builder to build the
         * next part of the query.
         * group is either 'dependent' or 'independent'--which builder did the request
         * come from, so that the appropriate fields can be gathered
         */
        var gatherCurrentQueryAndSave = function (category) {
            var dataset, translatedDataset, propertiesInputs;
            if (category == 'dependent') {
                var phenoAndDS = UTILS.extractValsFromCombobox(['phenotype', 'datasetDependent', 'datasetCohortDependent']);
                if (phenoAndDS.phenotype !== 'default') {
                    var phenotype = phenoAndDS.phenotype;
                    var translatedPhenotype = $('#phenotype option:selected').text().trim();
                }
                // if no dataset is selected, then phenoAndDS will not have a dataset key
                if (phenoAndDS.datasetDependent) {
                    dataset = phenoAndDS.datasetDependent;
                    translatedDataset = $('#datasetDependent option:selected').html();
                }
                // in the case that the user has selected a specific cohort, the previous dataset info
                // will be overwritten
                if (phenoAndDS.datasetCohortDependent && phenoAndDS.datasetCohortDependent != 'default' ) {
                    dataset = phenoAndDS.datasetCohortDependent;
                    translatedDataset = $('#datasetCohortDependent option:selected').html();
                    // get rid of the leading hyphens for display
                    translatedDataset = translatedDataset.replace(/^-*/, '');
                }

                propertiesInputs = $('input[data-type=propertiesInput][data-category=datasetDependent],input[data-type=propertiesInput][data-category=datasetCohortDependent]');
                _.forEach(propertiesInputs, function (input) {
                    if (input.value !== "") {
                        // get the comparator value
                        var comparator = $('select[data-selectfor=' + input.dataset.prop + ']')[0].value;
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
                        listOfSavedQueries.push(newQuery);
                    }
                });

            } else if (category == 'independent') {
                propertiesInputs = $('input[data-type=propertiesInput][data-category=datasetIndependent],input[data-type=propertiesInput][data-category=datasetCohortIndependent]');

                dataset = UTILS.extractValsFromCombobox(['datasetIndependent']).datasetIndependent;
                translatedDataset = $('#datasetIndependent option:selected').html();
                var cohortSelection = $('#datasetCohortIndependent option:selected').val();
                if(cohortSelection != undefined && cohortSelection != 'default') {
                    // then the user has selected a cohort, so override the previous dataset selection
                    dataset = cohortSelection;
                    translatedDataset = $('#datasetCohortIndependent option:selected').html();
                    // get rid of the leading hyphens for display
                    translatedDataset = translatedDataset.replace(/^-*/, '');
                }
                _.forEach(propertiesInputs, function (input) {
                    if (input.value !== "") {
                        // get the comparator value
                        var comparator = $('select[data-selectfor=' + input.dataset.prop + ']')[0].value;
                        var newQuery = {
                            // the phenotype field is needed on the server, but not on the client
                            phenotype: 'none',
                            dataset: dataset,
                            translatedDataset: translatedDataset,
                            prop: input.dataset.prop,
                            translatedName: input.dataset.translatedname,
                            // this parsing/toStringing is because the backend doesn't
                            // like decimal values without leading zeros
                            value: parseFloat(input.value).toString(),
                            comparator: comparator
                        };
                        listOfSavedQueries.push(newQuery);
                    }
                });
                // get the current query types so that we can prevent the user
                // from adding both a gene input and a chromosome input
                var currentlyDefinedQueryTypes = _.map(listOfSavedQueries, 'prop');
                var geneInputAlreadyDefined = currentlyDefinedQueryTypes.indexOf('gene') > -1;
                var chromosomeInputAlreadyDefined = currentlyDefinedQueryTypes.indexOf('chromosome') > -1;

                var advancedFilterInputs = $('input[data-type=advancedFilterInput]');
                _.forEach(advancedFilterInputs, function (input) {
                    if (input.value !== "") {
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
                        if (input.dataset.prop === 'gene' && geneRangeInputSetting != '') {
                            newQuery.value += ' ± ' + geneRangeInputSetting;
                        }
                        listOfSavedQueries.push(newQuery);
                    }
                });

                // this handles just the predicted effect high-level selection, not
                // the polyphen/sift/condel selections
                // first check to see if something was selected in the first place
                var selectedProteinEffect = document.querySelector('input[name="predictedEffects"]:checked');
                if (!_.isNull(selectedProteinEffect)) {
                    var proteinEffectSelection = selectedProteinEffect.value;
                    var newQuery = {
                        prop: JSON_VARIANT_MOST_DEL_SCORE_KEY,
                        translatedName: 'Deleteriousness category',
                        value: proteinEffectSelection,
                        comparator: '='
                    };
                    // if we already have a missense query, no need to add another one
                    if (propsWithQueries().indexOf(JSON_VARIANT_MOST_DEL_SCORE_KEY) === -1) {
                        listOfSavedQueries.push(newQuery);
                    }
                }

                // if the "missense" predicted effect is selected, need to grab the
                // polyphen/sift/condel selections here
                if (proteinEffectSelection == 2) {
                    var missenseSelections = $('select[data-type="proteinEffectSelection"]');
                    _.each(missenseSelections, function (input) {
                        // if the user has selected something other than the default, then
                        // .value will not be the empty string
                        if (input.value !== '') {
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

            }

            // reset all of the inputs
            resetInputFields();

            var targetToUpdate = category == 'dependent' ? 'datasetDependent' : 'datasetIndependent';
            mpgSoftware.firstResponders.updateBuildSearchRequestButton(targetToUpdate);

            // make call to update list of saved queries
            updatePageWithNewQueryList();

        };

        /**
         * this function is called after the list of queries is updated,
         * so that the page is updated appropriately
         */
        var updatePageWithNewQueryList = function () {
            var searchDetailsTemplate = document.getElementById("searchDetailsTemplate").innerHTML;
            Mustache.parse(searchDetailsTemplate);
            var renderData = {
                listOfSavedQueries: listOfSavedQueries,
                // use this to support editing queries
                index: function () {
                    return listOfSavedQueries.indexOf(this);
                },
                // translate certain values into human-readable form
                displayValue: function () {
                    if (this.prop === JSON_VARIANT_MOST_DEL_SCORE_KEY) {
                        switch (this.value) {
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
                },
                shouldSubmitBeEnabled: function () {
                    return this.listOfSavedQueries.length > 0;
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
            // updateBuildSearchRequestButton will get called twice if the edited criteria
            // is something involving a dataset--because all the dropdowns have to be repopulated,
            // there's some asynchronous calls, and this call to updateBuildSearchRequestButton
            // fires before those calls have finished
            var targetSection;
            if(queryToEdit.phenotype) {
                targetSection = 'datasetDependent';
            } else {
                targetSection = 'datasetIndependent';
            }
            mpgSoftware.firstResponders.updateBuildSearchRequestButton(targetSection);
        };

        var deleteQuery = function (indexToDelete) {
            var deletedQuery = listOfSavedQueries.splice(indexToDelete, 1)[0];
            // if the deleted query was a chromosome or gene query, reenable
            // the chromosome and gene inputs
            if (['chromosome', 'gene'].indexOf(deletedQuery.prop) > -1) {
                document.getElementById('geneInput').removeAttribute('disabled');
                document.getElementById('geneRangeInput').removeAttribute('disabled');
                document.getElementById('chromosomeInput').removeAttribute('disabled');
            }
            // same thing with a protein input
            if(deletedQuery.prop == 'MOST_DEL_SCORE') {
                var predictedEffectOptions = $('input[name="predictedEffects"]');
                _.each(predictedEffectOptions, function (option) {
                    option.removeAttribute('disabled');
                    option.checked = false;
                });

            }
            updatePageWithNewQueryList();
        };

        /**
         * Given the input query, adjust the appropriate inputs to reflect the
         * query
         * @param query
         */
        var resetInputsToQuery = function (query) {
            switch (query.prop) {
                case 'gene':
                    // the gene value could be the gene name, or the gene name
                    // along with a +/- setting
                    if (query.value.indexOf('±') === -1) {
                        // just the gene name
                        document.getElementById('geneInput').value = query.value;
                    } else {
                        var geneSplit = query.value.split(' ± ');
                        document.getElementById('geneInput').value = geneSplit[0];
                        document.getElementById('geneRangeInput').value = geneSplit[1];
                    }
                    document.getElementById('geneInput').removeAttribute('disabled');
                    $('#independentTab').tab('show');
                    break;
                case 'chromosome':
                    document.getElementById('chromosomeInput').value = query.value;
                    document.getElementById('chromosomeInput').removeAttribute('disabled');
                    $('#independentTab').tab('show');

                    break;
                case JSON_VARIANT_MOST_DEL_SCORE_KEY:
                    document.querySelector('input[name="predictedEffects"][value="' + query.value + '"]').checked = true;
                    $('#independentTab').tab('show');
                    break;
                case JSON_VARIANT_POLYPHEN_PRED_KEY:
                case JSON_VARIANT_SIFT_PRED_KEY:
                case JSON_VARIANT_CONDEL_PRED_KEY:
                    document.querySelector('input[name="predictedEffects"][value="2"]').checked = true;
                    document.querySelector('select[name="' + query.prop + '"]').value = query.value;
                    mpgSoftware.firstResponders.updateProteinEffectSelection('2');
                    $('#independentTab').tab('show');
                    break;
                // this catches all of the queries that deal with datasets (e.g. p-value, odds ratio)
                // they can be from the phenotype-dependent OR phenotype-independent tabs
                default:
                    if (query.phenotype == 'none') {
                        // this is phenotype-independent
                        // show independent tab
                        $('#independentTab').tab('show');
                        mpgSoftware.variantWF.retrieveDatasets(query.phenotype, 'independent', query);
                    } else {
                        // phenotype-dependent
                        // show dependent tab
                        $('#dependentTab').tab('show');
                        mpgSoftware.firstResponders.forceToPhenotypeSelection(query);
                    }
                    break;
            }
        };

        // use this after submitting a query or resetting
        var resetInputFields = function () {
            // dependent section
            // clear out the phenotype and dataset dropdowns
            var options = document.getElementById("datasetDependent");
            $(options).empty();
            fillPropertiesDropdown({is_error: false}, 'dependent');
            document.getElementById('phenotype').value = 'default';
            document.getElementById('datasetDependent').disabled = true;
            $('#datasetChooserCohortDependent').hide();

            // independent section
            fillPropertiesDropdown({is_error: false}, 'independent');
            document.getElementById('datasetIndependent').value = 'default';
            $('#datasetChooserCohortIndependent').hide();

            document.getElementById('geneInput').value = '';
            document.getElementById('geneRangeInput').value = '';
            document.getElementById('chromosomeInput').value = '';

            // if we have a gene or chromosome input, disable both of them
            var propsWithQs = propsWithQueries();
            if (propsWithQs.indexOf('chromosome') > -1 || propsWithQs.indexOf('gene') > -1) {
                document.getElementById('geneInput').setAttribute('disabled', 'true');
                document.getElementById('geneRangeInput').setAttribute('disabled', 'true');
                document.getElementById('chromosomeInput').setAttribute('disabled', 'true');
            } else {
                // enable all of the inputs
                document.getElementById('geneInput').removeAttribute('disabled');
                document.getElementById('geneRangeInput').removeAttribute('disabled');
                document.getElementById('chromosomeInput').removeAttribute('disabled');
            }

            // if we have a protein effect input, we should disable the protein effect inputs
            var disableProteinEffectInputs = propsWithQs.indexOf('MOST_DEL_SCORE') > -1;
            var predictedEffectOptions = $('input[name="predictedEffects"]');
            _.each(predictedEffectOptions, function (option) {
                // if an effect is selected, clear it; disable all inputs if necessary
                if (disableProteinEffectInputs) {
                    option.setAttribute('disabled', true);
                } else {
                    option.removeAttribute('disabled');
                }
                option.checked = false;
            });

            var additionalPredictedEffects = $('select[data-type="proteinEffectSelection"]');
            _.each(additionalPredictedEffects, function (dropdown) {
                dropdown.value = '';
            });

            $('#missense-options').hide(300);
            mpgSoftware.firstResponders.updateBuildSearchRequestButton('independent');
            mpgSoftware.firstResponders.updateBuildSearchRequestButton('dependent');
        };

        /**
         * helper function that returns the props that have queries built
         */
        function propsWithQueries() {
            return _.map(listOfSavedQueries, 'prop');
        }

        return {
            fillDatasetDropdown: fillDatasetDropdown,
            fillPropertiesDropdown: fillPropertiesDropdown,
            launchAVariantSearch: launchAVariantSearch,
            retrievePhenotypes: retrievePhenotypes,
            retrievePhenotypeIndependentDatasets: retrievePhenotypeIndependentDatasets,
            retrieveDatasets: retrieveDatasets,
            retrievePropertiesPerDataSet: retrievePropertiesPerDataSet,
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

        var forceToPropertySelection = function (query) {
            if (query) {
                var prop = query.prop;
                var comparator = query.comparator;
                var value = query.value;
                // need to select the right area to input
                var category = query.phenotype == 'none' ? 'datasetIndependent' : 'datasetDependent';
                document.querySelector('select[data-selectfor="' + prop + '"][data-category="' + category + '"]').value = comparator;
                document.querySelector('input[data-prop="' + prop + '"][data-category="' + category + '"]').value = value;
            }
        };
        // this is called when there's a query being edited. It sets the phenotype input,
        // then begins the chain to fill in the rest of the inputs.
        var forceToPhenotypeSelection = function (query) {
            $('#phenotype').val(query.phenotype);
            mpgSoftware.variantWF.retrieveDatasets(query.phenotype, 'dependent', query);
        };
        var respondToPhenotypeSelection = function (portaltype) {
            var phenotype = UTILS.extractValsFromCombobox(['phenotype']).phenotype;

            // phenotype is changed.  Before we get to the asynchronous parts let's wipe out the properties
            mpgSoftware.variantWF.retrieveDatasets(phenotype, 'dependent');
        };
        
        // target can be 'datasetDependent', 'datasetDependentCohort', 'datasetIndependent', or 'datasetIndependentCohort'
        var respondToDataSetSelection = function (target) {
            // we need to see if there's cohort information available
            // if so, display the cohort selector
            if(['datasetDependent', 'datasetIndependent'].includes(target)) {
                // we have to do this in a roundabout way--figure out the selected value,
                // then use that to get the actual DOM node, then pull the data from that
                var currentValue = $('#' + target).val();
                var selectedOptionElement = $('#' + target + ' option[value="'+ currentValue + '"]');
                var data = selectedOptionElement.data();
                var cohortChooserHolder = target == 'datasetDependent' ? 'datasetChooserCohortDependent' : 'datasetChooserCohortIndependent'
                var cohortChooserTarget = target == 'datasetDependent' ? 'datasetCohortDependent' : 'datasetCohortIndependent'
                var cohortOptions = $('#' + cohortChooserTarget);
                cohortOptions.empty();
                if(! _.isEmpty(data)) {
                    // we have cohorts
                    $('#' + cohortChooserHolder).show();
                    cohortOptions.append("<option selected value=default>-- &nbsp;&nbsp;all cohorts&nbsp;&nbsp; --</option>");
                    var displayData = UTILS.flattenDatasetMap(data, 0);
                    _.forEach(displayData, function(cohort) {
                        var newOption = $("<option />").val(cohort.value).html(cohort.name);
                        cohortOptions.append(newOption);
                    });
                } else {
                    $('#' + cohortChooserHolder).hide();
                }
            }

            // if we're looking at the dependent tab, then get the phenotype from the dropdown,
            // otherwise it's just 'none'
            var phenotype;
            if(target.toLowerCase().indexOf('independent') > -1) {
                phenotype = 'none';
            } else {
                phenotype = $('#phenotype').val();
            }
            // getting the dataset via this call handles the case where a user selects a cohort
            var dataset = $('#' + target).val();
            // if the user has selected "all cohorts" again, then we need to go back
            // and retrieve properties for the parent dataset
            if(dataset == 'default') {
                var selector = target == 'datasetCohortDependent' ? 'datasetDependent' : 'datasetIndependent';
                dataset = $('#' + selector).val();
            }
            mpgSoftware.variantWF.retrievePropertiesPerDataSet(phenotype, dataset, target);
        };

        /**
         * Given a change in the contents of any of the inputs, update the
         * "build search request" button to be enabled/disabled. The button
         * should be enabled if any of the following conditions are met:
         *      * any of properties fields (e.g. p-value, odds ratio) have a value, OR
         *      * the gene is specified in the advanced filter, OR
         *      * the region is specified in the advanced filter
         * The button should be disabled otherwise.
         * Note that the dependent and independent tabs have buttons that work independently
         * of each other--so if the dependent tab has some values filled in, its button will be enabled,
         * but the independent tab button will be disabled
         */
        var updateBuildSearchRequestButton = function (target) {
            if(target == 'dependent') {
                target = 'datasetDependent';
            }
            if(target == 'independent') {
                target = 'datasetIndependent';
            }
            var areInputValuesPresent = false;
            var targetButtonId = '';
            if (['datasetDependent', 'datasetCohortDependent'].includes(target)) {
                var propertiesInputsAreEmpty = _.every($('input[data-type=propertiesInput][data-category=datasetDependent],input[data-type=propertiesInput][data-category=datasetCohortDependent]'), function (input) {
                    return input.value === "";
                });

                areInputValuesPresent = !propertiesInputsAreEmpty;
                targetButtonId = 'buildSearchRequestDependent'
            } else {
                var propertiesInputsAreEmpty = _.every($('input[data-type=propertiesInput][data-category=datasetIndependent],input[data-type=propertiesInput][data-category=datasetCohortIndependent]'), function (input) {
                    return input.value === "";
                });
                var regionInputsAreEmpty = _.every($('input[data-type=advancedFilterInput]'), function (input) {
                    return input.value === "";
                });

                var proteinEffectsAreUnselected = _.every($('input[name="predictedEffects"]'), function (input) {
                    return !input.checked;
                });

                areInputValuesPresent = !( propertiesInputsAreEmpty && regionInputsAreEmpty && proteinEffectsAreUnselected );
                targetButtonId = 'buildSearchRequestIndependent'
            }

            var button = document.getElementById(targetButtonId);
            if (areInputValuesPresent) {
                // enable the button
                button.classList.remove('dk-search-btn-inactive');
                button.disabled = false
            } else {
                // disable the button
                button.classList.add('dk-search-btn-inactive');
                button.disabled = true
            }
        };

        /**
         * Validates a property input--matches any number, including scientific notation
         * @param input
         */
        function validatePropertyInput(input) {
            var numberRegex = /^((?:0|[1-9]\d*)?(?:\.\d*)?(?:[eE][+\-]?\d+)?)?$/
            if (!numberRegex.test(input.value)) {
                input.classList.add('redBorder');
            } else {
                input.classList.remove('redBorder');
            }
        }

        /**
         * If the missense protein effect option is selected, show the extended
         * options
         */
        function updateProteinEffectSelection(buttonLabel) {
            // also update the build search button
            mpgSoftware.firstResponders.updateBuildSearchRequestButton('independent');

            // 2 comes from the definition of PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE
            if (buttonLabel == 2) {
                $('#missense-options').show(200);
            } else {
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
            if (!doesChromosomeInputMakeSense) {
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
            if (geneInputValue === '' && queryProps.indexOf('chromosome') === -1) {
                document.getElementById('chromosomeInput').removeAttribute('disabled');
            } else {
                document.getElementById('chromosomeInput').setAttribute('disabled', 'true');
            }
            // if we have no chromosome input, AND there's not already a gene query defined
            if (chromosomeInputValue === '' && queryProps.indexOf('gene') === -1) {
                document.getElementById('geneInput').removeAttribute('disabled');
                document.getElementById('geneRangeInput').removeAttribute('disabled');
            } else {
                document.getElementById('geneInput').setAttribute('disabled', 'true');
                document.getElementById('geneRangeInput').setAttribute('disabled', 'true');
            }
        }

        return {
            forceToPhenotypeSelection: forceToPhenotypeSelection,
            respondToPhenotypeSelection: respondToPhenotypeSelection,
            respondToDataSetSelection: respondToDataSetSelection,
            forceToPropertySelection: forceToPropertySelection,
            updateBuildSearchRequestButton: updateBuildSearchRequestButton,
            validatePropertyInput: validatePropertyInput,
            updateProteinEffectSelection: updateProteinEffectSelection,
            validateChromosomeInput: validateChromosomeInput,
            controlGeneAndChromosomeInputs: controlGeneAndChromosomeInputs
        }

    }());


})();
