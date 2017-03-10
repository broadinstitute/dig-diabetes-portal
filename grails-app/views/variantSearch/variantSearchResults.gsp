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

    mpgSoftware.variantSearchResults.initializeAdditionalProperties ("<%=additionalProperties%>");

    var domSelectors = {
        retrievePhenotypesAjaxUrl:'<g:createLink controller="variantSearch" action="retrievePhenotypesAjax" />',
        geneInfoUrl:'<g:createLink controller="gene" action="geneInfo" />',
        variantInfoUrl:'<g:createLink controller="variantInfo" action="variantInfo" />',
        variantSearchAndResultColumnsDataUrl:'<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsData" />',
        variantSearchAndResultColumnsInfoUrl:'<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsInfo" />',
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
        linkToSave: '#linkToSave',
        queryFilterInfo:"<%=queryFilters%>",
        proteinEffectsListInfo:"${proteinEffectsList}",
        localeInfo:"${locale}",
        queryFiltersInfo:"<%= queryFilters %>",
        translatedFiltersInfo:"<%= translatedFilters %>",
        filtersAsJsonInfo:filtersAsJson,
        copyMsg:'<g:message code="table.buttons.copyText" default="Copy" />',
        printMsg:'<g:message code="table.buttons.printText" default="Print me!" />',
        commonPropsMsg:'<g:message code="variantTable.columnHeaders.commonProperties"/>'};




    $(document).ready(function () {

        $("#variantSearchResultsInterface").empty().append(Mustache.render( $('#variantResultsMainStructuralTemplate')[0].innerHTML,
                {'holderForVariantSearchResults':'holdAllVariantSearchResults'}));
        $("#holdAllVariantSearchResults").append(
                Mustache.render( $('#variantSearchResultsTemplate')[0].innerHTML,{variantTableResults:'variantTableResults',
                            variantTableHeaderRow:'variantTableHeaderRow',
                            variantTableHeaderRow2:'variantTableHeaderRow2',
                            variantTableHeaderRow3:'variantTableHeaderRow3',
                            variantTableBody:'variantTableBody'}

                ));
        $(".dk-t2d-back-to-search").empty().append(
                Mustache.render( $('#topOfVariantResultsPageTemplate')[0].innerHTML,{encodedParameters:
                                '<a href="<g:createLink controller='variantSearch' action='variantSearchWF' params='[encParams: "${encodedParameters}"]'/>">'}

                ));
        mpgSoftware.variantSearchResults.loadTheTable(domSelectors);

        $('[data-toggle="tooltip"]').tooltip();

        $("#dataModalGoesHere").empty().append(
                Mustache.render( $('#dataModalTemplate')[0].innerHTML));
        var allGenes = "${geneNamesToDisplay}".replace("[","").replace("]","").split(',');
        if ((allGenes.length>0)&&
                (allGenes[0].length>0)){
            var namedGeneArray = _.map(allGenes,function(o){return {'name':o}});
            $(".regionDescr").empty().append(
                    Mustache.render( $('#dataRegionTemplate')[0].innerHTML,
                            { geneNamesToDisplay: namedGeneArray,
                                regionSpecification:'${regionSpecification}'}));
        }
        var translatedFilterArray = "${translatedFilters}".split(',');
        var namedTranslatedFilterArray = _.map(translatedFilterArray,function(o){return {'name':o}});
        $(".variantResultsFilterHolder").empty().append(
                Mustache.render( $('#variantResultsFilterHolderTemplate')[0].innerHTML,
                        { 'translatedFilters': namedTranslatedFilterArray})
        );
    });

</script>


<div id="variantSearchResultsInterface"></div>

</body>
</html>
