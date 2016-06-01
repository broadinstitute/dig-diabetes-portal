<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="tableViewer"/>
    <r:require modules="variantWF"/>
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

    </style>

</head>

<body>

<script>
    // this gets the data that builds the table structure. the table is populated via a later call to
    // variantProcessing.iterativeVariantTableFiller
    var loadVariantTableViaAjax = function (queryFilters, additionalProperties) {
        var loading = $('#spinner').show();
        loading.show();
        $.ajax({
            type: 'POST',
            cache: false,
            data: {
                'keys': queryFilters,
                'properties': additionalProperties
            },
            url: '<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsInfo" />',
            timeout: 90 * 1000,
            async: true,
            success: function (data, textStatus) {
                dynamicFillTheFields(data);

                loading.hide();
            },
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
    }
    // this kicks everything off
    loadVariantTableViaAjax("<%=queryFilters%>", "<%=additionalProperties%>");

    var encodedParameters = decodeURIComponent("<%=encodedParameters%>");

    function dynamicFillTheFields(data) {
        /**
         * This function exists to avoid having to do
         * "if translationDictionary[string] defined, return that, else return string"
         */
        var translationFunction = function (stringToTranslate) {
            return data.translationDictionary[stringToTranslate] || stringToTranslate
        };
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

        // dataset specific props
//        for (var pheno in data.columns.dproperty) {
//            var pheno_width = 0;
//            for (var dataset in data.columns.dproperty[pheno]) {
//                var thisDatasetColor = 'dk-property-' + columnColoring.pop();
//                var dataset_width = 0;
//                var datasetDisp = translationFunction(dataset);
//                for (var i = 0; i < data.columns.dproperty[pheno][dataset].length; i++) {
//                    var column = data.columns.dproperty[pheno][dataset][i];
//                    var columnDisp = translationFunction(column);
//                    pheno_width++;
//                    dataset_width++;
//                    // the data-colname attribute is used in the table generation function
//                    var newHeaderElement = $('<th>', {class: 'datatype-header ' + thisDatasetColor, html: columnDisp}).attr('data-colName', column + '.' + dataset);
//                    $('#variantTableHeaderRow3').append(newHeaderElement);
//                }
//                if (dataset_width > 0) {
//                    var newTableHeader = document.createElement('th');
//                    newTableHeader.setAttribute('class', 'datatype-header ' + thisDatasetColor);
//                    newTableHeader.setAttribute('colspan', dataset_width);
//                    $(newTableHeader).append(datasetDisp);
//                    $('#variantTableHeaderRow2').append(newTableHeader);
//                }
//            }
//            if (pheno_width > 0) {
//                $('#variantTableHeaderRow').append("<th colspan=" + pheno_width + " class=\"datatype-header " + thisDatasetColor + "\"></th>")
//            }
//            totCol += pheno_width
//        }

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

        var proteinEffectList = new UTILS.proteinEffectListConstructor(decodeURIComponent("${proteinEffectsList}"));
//        debugger
        variantProcessing.iterativeVariantTableFiller(data, totCol, sortCol, '#variantTable',
                '<g:createLink controller="variantInfo" action="variantInfo" />',
                '<g:createLink controller="gene" action="geneInfo" />',
                proteinEffectList,
                "${locale}",
                '<g:message code="table.buttons.copyText" default="Copy" />',
                '<g:message code="table.buttons.printText" default="Print me!" />',
                {   keys: "<%=queryFilters%>",
                    properties: "<%=additionalProperties%>"
                });
    }

    $(document).ready(function () {
        $('[data-toggle="tooltip"]').tooltip();
    });

</script>


<div id="main">

    <div class="container dk-t2d-back-to-search">
        <a href="<g:createLink controller='variantSearch' action='variantSearchWF'
                               params='[encParams: "${encodedParameters}"]'/>">
            <button class="btn btn-primary btn-xs">
                &laquo; <g:message code="variantTable.searchResults.backToSearchPage" />
            </button></a>
        <g:message code="variantTable.searchResults.editCriteria" />
    </div>

    <div class="container dk-t2d-content">

        <h1><g:message code="variantTable.searchResults.title" default="Variant search results"/></h1>

        <h3><g:message code="variantTable.searchResults.searchCriteriaHeader" default="Search criteria"/></h3>

        <table class="table table-striped dk-search-collection">
            <tbody>
                <g:renderUlFilters encodedFilters='${encodedFilters}'/>
            </tbody>
        </table>

        <div id="warnIfMoreThan1000Results"></div>

        <g:if test="${regionSearch}">
            <g:render template="geneSummaryForRegion"/>
        </g:if>

        <p><em><g:message code="variantTable.searchResults.oddsRatiosUnreliable" default="odds ratios unreliable" /></em></p>

    </div>

    <div class="container dk-variant-table-header">
        <div class="row">
            <div class="text-right">
                <button class="btn btn-primary btn-xs" style="margin-bottom: 5px;">Add / Subtract Data</button>
            </div>
        </div>
    </div>

    <div class="container-fluid">
        <g:render template="../region/newCollectedVariantsForRegion"/>
    </div>

</div>

</body>
</html>
