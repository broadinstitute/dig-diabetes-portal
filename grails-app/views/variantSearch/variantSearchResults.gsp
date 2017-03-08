<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core, mustache"/>
    <r:require modules="variantSearchResults"/>
    <r:layoutResources/>
</head>

<body>

<g:render template="../templates/variantSearchResultsTemplate" />

<script>
    <g:applyCodec encodeAs="none">
    var filtersAsJson = ${listOfQueries};
    </g:applyCodec>

    mpgSoftware.variantSearchResults.initializeAdditionalProperties ("<%=additionalProperties%>");

    var domSelectors = {
        launchAVariantSearchUrl: "<g:createLink absolute="true" controller="variantSearch" action="launchAVariantSearch" params="[filters: "${filtersForSharing}"]"/>",
        retrieveDatasetsAjaxUrl:"${g.createLink(controller: 'VariantSearch', action: 'retrieveDatasetsAjax')}",
        phenotypeAddition:'#phenotypeAddition',
        phenotypeAdditionDataset: '#phenotypeAdditionDataset',
        phenotypeAdditionCohort: '#phenotypeAdditionCohort',
        phenotypeCohorts:'#phenotypeCohorts',
        variantTableResults:'#variantTableResults',
        variantTableHeaderRow:'#variantTableHeaderRow',
        variantTableHeaderRow2:'#variantTableHeaderRow2',
        variantTableHeaderRow3:'#variantTableHeaderRow3',
        variantTableBody:'#variantTableBody',
        linkToSave: '#linkToSave'};

    // when this is called, the table is generated/regenerated
    // it's here because of all the URLs/data that need to be filled in
    function loadTheTable(variantTableSelector) {
        mpgSoftware.variantSearchResults.loadVariantTableViaAjax("<%=queryFilters%>",
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
                    var additionalProps = encodeURIComponent(mpgSoftware.variantSearchResults.getAdditionalProperties().join(':'));
                    var totCol = mpgSoftware.variantSearchResults.dynamicFillTheFields(data,variantTableSelector);

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


    $(document).ready(function () {
        // this kicks everything off
        $(".holderForVariantSearchResults").empty().append(
                Mustache.render( $('#variantSearchResultsTemplate')[0].innerHTML,{variantTableResults:'variantTableResults',
                            variantTableHeaderRow:'variantTableHeaderRow',
                            variantTableHeaderRow2:'variantTableHeaderRow2',
                            variantTableHeaderRow3:'variantTableHeaderRow3',
                            variantTableBody:'variantTableBody'}

                ));

        loadTheTable({variantTableResults:'#variantTableResults',
            variantTableHeaderRow:'#variantTableHeaderRow',
            variantTableHeaderRow2:'#variantTableHeaderRow2',
            variantTableHeaderRow3:'#variantTableHeaderRow3',
            variantTableBody:'#variantTableBody'});

        $('[data-toggle="tooltip"]').tooltip();

        $("#dataModalGoesHere").empty().append(
                Mustache.render( $('#dataModalTemplate')[0].innerHTML));
        var allGenes = "${geneNamesToDisplay}".replace("[","").replace("]","").split(',');
        if ((allGenes.length>0)&&
                (allGenes[0].length>0)){
            var namedGeneArray = _.map(allGenes,function(o){return {'name':o}})
            $(".regionDescr").empty().append(
                    Mustache.render( $('#dataRegionTemplate')[0].innerHTML,
                            { geneNamesToDisplay: namedGeneArray,
                                regionSpecification:'${regionSpecification}'}));
        }
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
            <a id="linkToSaveText" href="#" onclick="mpgSoftware.variantSearchResults.saveLink(domSelectors)">Click here to copy the current search URL to the clipboard</a>
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

        <div class="regionDescr">

        </div>

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
    </div>
    <div id="dataModalGoesHere"></div>


</div>

</body>
</html>
