<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core, mustache"/>
    <r:require modules="variantSearchResults"/>
    <r:layoutResources/>
    <style>
    /* sorting_asc/desc/1 are classes applied by datatables to the column that is being sorted on  */
    th.sorting_asc, th.sorting_desc {
        background-color: #84e171;
        color: black;
    }
    td.sorting_1 {
        background-color: #ddf7d7 !important;
    }

    /* override the default styling of the buttons div */
    div.dt-buttons {
        float: right;
    }

    .modal-body {
        /* we have a lot of datasets, so make the modal fit in the screen
           and add scrolling */
        max-height: 80vh;
        overflow-y: scroll;
    }

    #propertiesModal .modal-dialog {
        /* this is all to override the default bootstrap sizing */
        width: auto;
        min-width: 600px;
        max-width: 90%;
    }

    </style>

</head>

<body>

<g:render template="../templates/variantSearchResultsTemplate" />

<script>
    <g:applyCodec encodeAs="none">
    var filtersAsJson = ${listOfQueries};
    </g:applyCodec>

    // hoisted here
    var translationFunction;

    // we only want to generate the "add datasets/properties" modal once
    var modalHasBeenGenerated = false;

    // this is how requested properties beyond what's included in the search get added
    var additionalProperties = [];

    // the URL may specify properties to add (so that users can share searches). if this is
    // the case, those properties will be passed down in string format via the additionalProperties
    // variable. then, set additionalProperties appropriately, so it can be modified later
    var serverLoadedAdditionalProperties = "<%=additionalProperties%>";
    if(serverLoadedAdditionalProperties.length > 0) {
        additionalProperties = serverLoadedAdditionalProperties.split(':');
    }

    // when this is called, the table is generated/regenerated
    // it's here because of all the URLs/data that need to be filled in
    function loadTheTable(variantTableSelector) {
        mpgSoftware.variantSearchResults.loadVariantTableViaAjax("<%=queryFilters%>",
                additionalProperties,
                '<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsInfo" />').then(function (data, status) {
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
            var totCol = mpgSoftware.variantSearchResults.dynamicFillTheFields(data);

            var proteinEffectList = new UTILS.proteinEffectListConstructor(decodeURIComponent("${proteinEffectsList}"));
            variantProcessing.iterativeVariantTableFiller(data, totCol, filtersAsJson, variantTableSelector.variantTableResults,
                    '<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsData" />',
                    '<g:createLink controller="variantInfo" action="variantInfo" />',
                    '<g:createLink controller="gene" action="geneInfo" />',
                    proteinEffectList.proteinEffectMap,
                    "${locale}",
                    '<g:message code="table.buttons.copyText" default="Copy" />',
                    '<g:message code="table.buttons.printText" default="Print me!" />',
                    {
                        filters: "<%=queryFilters%>",
                        properties: additionalProps
                    },
                    <g:applyCodec encodeAs="none">
                        "<%= translatedFilters %>"
                    </g:applyCodec>
            );
            mpgSoftware.variantSearchResults.generateModal(data,
                    '<g:createLink controller="variantSearch" action="retrievePhenotypesAjax" />',
                    '<g:message code="variantTable.columnHeaders.commonProperties"/>')
        });
    }

    // the following functions are here (instead of in a separate JS file or something) because
    // they either update the page state (in the form of additionalProperties), or need server-
    // generated URLs/strings
    function confirmAddingProperties(target) {
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
            var phenotypeSelection = $('#phenotypeAddition').val();
            var datasetSelection = $('#phenotypeAdditionDataset').val();
            if(phenotypeSelection != 'default' && datasetSelection != 'default') {
                // first see if a cohort was selected
                var cohortSelection = $('#phenotypeAdditionCohort').val();
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

        loadTheTable({variantTableResults:'#variantTableResults',
            variantTableHeaderRow:'#variantTableHeaderRow',
            variantTableHeaderRow2:'#variantTableHeaderRow2',
            variantTableHeaderRow3:'#variantTableHeaderRow3',
            variantTableBody:'#variantTableBody'});

        // any necessary clean up
        // reset the dataset/cohort dropdowns on the phenotype addition tab
        $('#phenotypeAdditionDataset').empty();
        $('#phenotypeCohorts').hide();
    }

    function saveLink() {
        var url = "<g:createLink absolute="true" controller="variantSearch" action="launchAVariantSearch" params="[filters: "${filtersForSharing}"]"/>";
        url = url.concat('&props=' + encodeURIComponent(additionalProperties.join(':')));

        var reference = $('#linkToSave');
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
            $('#linkToSave').show();
            alert('Sorry, this functionality isn\'t supported on your browser. Please copy the link from the text box.')
        }
    }

    // called when a phenotype is selected on the "add phenotype" tab
    function phenotypeSelected() {
        var phenotype = $('#phenotypeAddition').val();
        $.ajax({
            cache: false,
            type: "post",
            url: "${g.createLink(controller: 'VariantSearch', action: 'retrieveDatasetsAjax')}",
            data: {phenotype: phenotype},
            async: true,
            success: function (data) {
                if (data) {
                    var sampleGroupMap = data.sampleGroupMap;
                    var options = $('#phenotypeAdditionDataset');
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
    }

    function datasetSelected() {
        var selectedDataset = $('#phenotypeAdditionDataset option:selected');
        var cohorts = selectedDataset.data();
        if(! _.isEmpty(cohorts)) {
            $('#phenotypeCohorts').show();
            var cohortOptions = $('#phenotypeAdditionCohort');
            cohortOptions.empty();
            cohortOptions.append("<option selected value=default>-- &nbsp;&nbsp;all cohorts&nbsp;&nbsp; --</option>");
            var displayData = UTILS.flattenDatasetMap(cohorts, 0);
            _.forEach(displayData, function(cohort) {
                var newOption = $("<option />").val(cohort.value).html(cohort.name);
                cohortOptions.append(newOption);
            });
        } else {
            $('#phenotypeCohorts').hide();
        }
    }

    $(document).ready(function () {
        // this kicks everything off
        $(".holderForVariantSearchResults").empty().append(
                Mustache.render( $('#variantSearchResultsTemplate')[0].innerHTML,{variantTableResults:'#variantTableResults',
                        variantTableHeaderRow:'#variantTableHeaderRow',
                        variantTableHeaderRow2:'#variantTableHeaderRow2',
                        variantTableHeaderRow3:'#variantTableHeaderRow3',
                        variantTableBody:'#variantTableBody'}

        ));
        loadTheTable({variantTableResults:'#variantTableResults',
            variantTableHeaderRow:'#variantTableHeaderRow',
            variantTableHeaderRow2:'#variantTableHeaderRow2',
            variantTableHeaderRow3:'#variantTableHeaderRow3',
            variantTableBody:'#variantTableBody'});

        $('[data-toggle="tooltip"]').tooltip();
    });

</script>


<div id="main">

    <div class="container dk-t2d-back-to-search">
        <div style="text-align: right;">
            <a href="https://s3.amazonaws.com/broad-portal-resources/Variant_results_table_guide_09-15-2016.pdf" target="_blank">
                <g:message code="variantSearch.results.helpText" />
            </a>
        </div>
        <div>
            <a href="<g:createLink controller='variantSearch' action='variantSearchWF'
                                   params='[encParams: "${encodedParameters}"]'/>">
                <button class="btn btn-primary btn-xs">
                    &laquo; <g:message code="variantTable.searchResults.backToSearchPage" />
                </button></a>
            <g:message code="variantTable.searchResults.editCriteria" />
        </div>
        <div style="margin-top: 5px;">
            <a id="linkToSaveText" href="#" onclick="saveLink()">Click here to copy the current search URL to the clipboard</a>
            <input type="text" id="linkToSave" style="display: none; margin-left: 5px; width: 500px;" />
        </div>

    </div>

    <div class="container dk-t2d-content">

        <h1><g:message code="variantTable.searchResults.title" default="Variant search results"/></h1>

        <h3><g:message code="variantTable.searchResults.searchCriteriaHeader" default="Search criteria"/></h3>

        <table class="table table-striped dk-search-collection">
            <tbody>
                <g:each in="${translatedFilters.split(',')}">
                    <tr>
                        <td>${it}</td>
                    </tr>
                </g:each>
            </tbody>
        </table>

        <div id="warnIfMoreThan1000Results"></div>

        <g:if test="${regionSearch}">
            <g:render template="geneSummaryForRegion"/>
        </g:if>

        <p><em><g:message code="variantTable.searchResults.oddsRatiosUnreliable" default="odds ratios unreliable" /></em></p>
        <p><g:message code="variantTable.searchResults.guide" default="variant results table guide" /></p>

    </div>

    <div class="container dk-variant-table-header">
        <div class="row">
            <div class="text-right">
                <button class="btn btn-primary btn-xs" style="margin-bottom: 5px;" data-toggle="modal" data-target="#dataModal">Add / Subtract Data</button>
            </div>
        </div>
    </div>
    <hr />
    <div class="container-fluid holderForVariantSearchResults" >
        %{--<g:render template="../region/newCollectedVariantsForRegion"/>--}%
    </div>

    <g:render template="addDataModal" />

</div>

</body>
</html>
