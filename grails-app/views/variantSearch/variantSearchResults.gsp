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
    var translatedFilters  = "<%= translatedFilters %>";
    </g:applyCodec>

    $(document).ready(function () {
        var domSelectors = {
            retrievePhenotypesAjaxUrl:'<g:createLink controller="variantSearch" action="retrievePhenotypesAjax" />',
            geneInfoUrl:'<g:createLink controller="gene" action="geneInfo" />',
            variantInfoUrl:'<g:createLink controller="variantInfo" action="variantInfo" />',
            variantSearchAndResultColumnsDataUrl:'<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsData" />',
            variantSearchAndResultColumnsInfoUrl:'<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsInfo" />',
            launchAVariantSearchUrl: "<g:createLink absolute="true" controller="variantSearch" action="launchAVariantSearch" params="[filters: "${filtersForSharing}"]"/>",
            retrieveDatasetsAjaxUrl:"${g.createLink(controller: 'VariantSearch', action: 'retrieveDatasetsAjax')}",
            linkBackToSearchDefinitionPage:'<a href="<g:createLink controller='variantSearch' action='variantSearchWF' params='[encParams: "${encodedParameters}"]'/>">',
            phenotypeAddition:'phenotypeAddition',
            phenotypeAdditionDataset: 'phenotypeAdditionDataset',
            phenotypeAdditionCohort: 'phenotypeAdditionCohort',
            phenotypeCohorts:'#phenotypeCohorts',
            variantTableResults:'variantTableResults',
            variantTableHeaderRow:'variantTableHeaderRow',
            variantTableHeaderRow2:'variantTableHeaderRow2',
            variantTableHeaderRow3:'variantTableHeaderRow3',
            variantTableBody:'variantTableBody',
            linkToSave: '#linkToSave',
            queryFilterInfo:"<%=queryFilters%>",
            proteinEffectsListInfo:"${proteinEffectsList}",
            localeInfo:"${locale}",
            queryFiltersInfo:"<%= queryFilters %>",
            translatedFiltersInfo:"<%= translatedFilters %>",
            additionalPropertiesInfo:"<%=additionalProperties%>",
            filtersAsJsonInfo:filtersAsJson,
            copyMsg:'<g:message code="table.buttons.copyText" default="Copy" />',
            printMsg:'<g:message code="table.buttons.printText" default="Print me!" />',
            commonPropsMsg:'<g:message code="variantTable.columnHeaders.commonProperties"/>',
            uniqueRoot:"x"};
        mpgSoftware.variantSearchResults.buildVariantResultsTable(domSelectors,"${geneNamesToDisplay}");

    });

</script>


<div id="variantSearchResultsInterface"></div>

</body>
</html>
