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
<style>
table.dataTable th.niceHeaders {
    font-size: 14px;
    font-weight: bold;
    padding: 4px;
    border-bottom: 1px solid #8AB8E6;
    color: #000;
    text-decoration: none;
    cursor: pointer;

    /*filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#E0F4FC', endColorstr='#9BC5F4'); !* for IE *!*/
    background: -webkit-gradient(linear, left top, left bottom, from(#E0F4FC), to(#9BC5F4)); /* for webkit browsers */
    background: -moz-linear-gradient(top,  #E0F4FC, #9BC5F4); /* for firefox 3.6+ */
}
table.dataTable th.niceHeadersBackdrop {
    background-color: #E0F4FC;
}
table.dataTable th.niceHeadersInvisible {
    background-color: #FFFFFF;
}
table.dataTable th.niceHeaders.sorting_asc {
    background-image: url('../../css/lib/datatables/sort_asc.png');
    background-repeat: no-repeat;
    background-position:center right;
}
table.dataTable th.niceHeaders.sorting_desc {
    background-image: url('../../css/lib/datatables/sort_desc.png');
    background-repeat: no-repeat;
    background-position:center right;
}
table.dataTable th.sorting_asc {
    background-color: #84e171;
    color: black;
}
table.dataTable th.sorting_desc {
    background-color: #84e171;
    color: black;
}
</style>

<script>
    <g:applyCodec encodeAs="none">
    var filtersAsJson = ${listOfQueries};
    var translatedFilters  = "<%= translatedFilters %>";
    </g:applyCodec>

    $(document).ready(function () {
        var domSelectors = {

            interfaceGoesHere: '#variantSearchResultsInterface',//  everything in the interface will be hanging off here

            // control the way the table is utilized
            variantResultsTableHeader:[1],
            makeAggregatedDataCall: false,
            chooseAdSubtractPhenotype: [1],
            chooseAdSubtractDataSets: [1],
            chooseAdSubtractCommonProperties: [1],
            returnToTheVariantResultsTable: [1],

            // a bunch of URLs we need to pass around
            retrieveTopVariantsAcrossSgs:'<g:createLink controller="variantSearch" action="retrieveTopVariantsAcrossSgs" />',
            retrievePhenotypesAjaxUrl:'<g:createLink controller="variantSearch" action="retrievePhenotypesAjax" />',
            geneInfoUrl:'<g:createLink controller="gene" action="geneInfo" />',
            variantInfoUrl:'<g:createLink controller="variantInfo" action="variantInfo" />',
            variantSearchAndResultColumnsDataUrl:'<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsData" />',
            variantSearchAndResultColumnsInfoUrl:'<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsInfo" />',
            launchAVariantSearchUrl: "<g:createLink absolute="true" controller="variantSearch" action="launchAVariantSearch" params="[filters: "${filtersForSharing}"]"/>",
            retrieveDatasetsAjaxUrl:"${g.createLink(controller: 'VariantSearch', action: 'retrieveDatasetsAjax')}",
            linkBackToSearchDefinitionPage:'<a href="<g:createLink controller='variantSearch' action='variantSearchWF' params='[encParams: "${encodedParameters}"]'/>">',

            // information we need to pass into the routine.  We should keep this strictly minimal
            queryFiltersInfo:"<%=queryFilters%>",
            proteinEffectsListInfo:"${proteinEffectsList}",
            localeInfo:"${locale}",
            translatedFiltersInfo:"<%= translatedFilters %>",
            additionalPropertiesInfo:"<%=additionalProperties%>",
            filtersAsJsonInfo:filtersAsJson,
            geneNamesToDisplay:"${geneNamesToDisplay}",
            regionSpecification:'${regionSpecification}',

            // message strings
            copyMsg:'<g:message code="table.buttons.copyText" default="Copy" />',
            printMsg:'<g:message code="table.buttons.printText" default="Print me!" />',
            commonPropsMsg:'<g:message code="variantTable.columnHeaders.commonProperties"/>',

            //  The string must be unique for every instantiation on a single page
            uniqueRoot:"x"};
        mpgSoftware.variantSearchResults.buildVariantResultsTable(domSelectors);

    });

</script>


<div id="variantSearchResultsInterface"></div>

</body>
</html>
