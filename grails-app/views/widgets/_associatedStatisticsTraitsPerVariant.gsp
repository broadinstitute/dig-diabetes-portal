<!-- inputs needed
    variantIdentifier: the variant id
    dbSnpId: for the snp id, if provided (from the trait info page)
    openOnLoad: if accordion closed at start
-->

<style>
tr.collapse.in {
    display: table-row;
}
tr.bestAssociation {

}

tr.otherAssociations {
    display: none;
}

div.sgIdentifierInTraitTable {
    text-align: left;
}

button.expandoButton {
    background-color: rgba(217, 246, 253, 0.51);
    font-size: 10px;
}

button.expandoButton:hover {
    color: black;
}

button.expandoButton:active {
    color: white;
}

button.expandoButton:visited {
    color: white;
}

#collapseVariantTraitAssociation th {
    vertical-align: middle;
}
</style>

<div class="accordion-group">
<div class="accordion-heading">
    <a class="accordion-toggle  collapsed" data-toggle="collapse" href="#collapseVariantTraitAssociation">
        <h2><strong><g:message code="widgets.variant.trait.associations.title"
                               default="Association statistics across 25 traits"/><g:if test="${dnSnpId}"> <g:message
                code="site.shared.phrases.for"/> ${dnSnpId}</g:if></strong></h2>
    </a>
</div>


<div id="collapseVariantTraitAssociation" class="accordion-body collapse" style="padding: 0 20px;">

    <div id="plot"></div>

    <div class="accordion-inner" id="traitAssociationInner">

    <r:require modules="core"/>
    <r:require modules="tableViewer,traitInfo"/>

    <script>
        var mpgSoftware = mpgSoftware || {};
        $( document ).ready(function(){
            $(".collapse").on('show.bs.collapse', function(a,b){
                console.log('The collapsible content is about to show.');
            });
        });


        // track if data table loaded yet; get reinitialization error
        var tableNotLoaded = true;
        var maximumDataSetsPerCall = 40;
        var dbSnpId;
        var sortingColumn = 0;
        var allowExpansionByCohort = function () {
            sortingColumn = 0;
            $('.jstree-ocl').show();
            $('div.glyphicon').hide();
        };
        var allowExpansionByTrait = function () {
            sortingColumn = 1;
            $('.jstree-ocl').show();
            $('div.glyphicon').hideshow();
        };
        var respondToPlusSignClick = function (drivingDom) {
            var jqueryElement = $(drivingDom);
            if (jqueryElement.find("span").hasClass('glyphicon-resize-full')){
                jqueryElement.find("span").removeClass('glyphicon-resize-full') ;
                jqueryElement.find("span").addClass('glyphicon-resize-small') ;
                jqueryElement.attr('title',"Click to remove additional associations for GIANT GWAS across other data sets");
            } else if (jqueryElement.find("span").hasClass('glyphicon-resize-small')) {
                jqueryElement.find("span").addClass('glyphicon-resize-full') ;
                jqueryElement.find("span").removeClass('glyphicon-resize-small') ;
                jqueryElement.attr('title',"Click to open additional associations for GIANT GWAS across other data sets");
            }
        };

        mpgSoftware.widgets = (function () {
           // mpgSoftware.locusZoom.phewasExperiment('<%=variantIdentifier%>','<g:createLink controller="trait" action="phewasAjaxCallInLzFormat" />');
            var loadAssociationTable = function () {
                var variant;
                var loading = $('#spinner').show();
                $.ajax({
                    cache: false,
                    type: "get",
                    url: '<g:createLink controller="trait" action="ajaxAssociatedStatisticsTraitPerVariant" />',
                    data: {variantIdentifier: '<%=variantIdentifier%>',
                        technology: ''},
                    async: true,
                    success: function (data) {
                        mpgSoftware.trait.fillTheTraitsPerVariantFields(data,
                                [],
                                '#traitsPerVariantTableBody',
                                '#traitsPerVariantTable',
                                '<g:createLink controller="trait" action="traitSearch" />',
                                "${locale}",
                                '<g:message code="table.buttons.copyText" default="Copy" />',
                                '<g:message code="table.buttons.printText" default="Print me!" />');
                        var sgLinks = $('.sgIdentifierInTraitTable');
                        var deferreds = [];
                        var defCount = [];
                        for (var i = 0; i < sgLinks.length; i++) {
                            var jqueryObj = $(sgLinks[i]);
                            // TODO: remove this work around
                            // prog note: there must be a way to to this with proper promises.  I'm not sure that
                            //  my hack below is any worse, but I'd rather use the standard technique.
                            var fwd = function(i,ewdArray){
                                ewdArray.push('done'+i);
                                if (ewdArray.length>=sgLinks.length){
                                   // $('#reviser').click(); // click button to refresh all rows
                                }

                            };
                            deferreds.push(UTILS.jsTreeDataRetrieverPhenoSpec('#' + jqueryObj.attr('id'), '#traitsPerVariantTable',
                                    jqueryObj.attr('phenotypename'),
                                    jqueryObj.attr('datasetname'),
                                    "${createLink(controller: 'VariantSearch', action: 'retrieveJSTreeAjax')}",fwd,i,defCount));
                        }
                        $.when.apply($,deferreds).then(function() {
                            //console.log('really, really done');
                        });

                        massageTraitsTable();
                        loading.hide();
                    },
                    error: function (jqXHR, exception) {
                        loading.hide();
                        core.errorReporter(jqXHR, exception);
                    }
                });
            };

            return {loadAssociationTable: loadAssociationTable}
        }());

        $("#collapseVariantTraitAssociation").on("show.bs.collapse", function () {
            if (tableNotLoaded) {
                mpgSoftware.widgets.loadAssociationTable();
                tableNotLoaded = false;
            }
        });
        $("#collapseVariantTraitAssociation").on("shown.bs.collapse", function () {
            mpgSoftware.locusZoom.rescaleSVG('#plot');
        });
        $('#traitsPerVariantTable').on('order.dt', UTILS.labelIndenter('traitsPerVariantTable'));


        var traitTable = function (variantIdentifier, datasetmaps, arrayOfOpenPhenotypes) {

            var addMoreValues = function (data, howManyGroups) {
                if (howManyGroups == 0) {
                    mpgSoftware.trait.fillTheTraitsPerVariantFields(data,
                            data.traitInfo.results[0].openPhenotypes,
                            '#traitsPerVariantTableBody',
                            '#traitsPerVariantTable',
                            '<g:createLink controller="trait" action="traitSearch" />',
                            "${locale}",
                            '<g:message code="table.buttons.copyText" default="Copy" />',
                            '<g:message code="table.buttons.printText" default="Print me!" />');
                } else {
                    mpgSoftware.trait.addMoreTraitsPerVariantFields(data,
                            data.traitInfo.results[0].openPhenotypes,
                            '#traitsPerVariantTableBody',
                            '#traitsPerVariantTable',
                            '<g:createLink controller="trait" action="traitSearch" />',
                            "${locale}",
                            '<g:message code="table.buttons.copyText" default="Copy" />',
                            '<g:message code="table.buttons.printText" default="Print me!" />',
                                    howManyGroups * maximumDataSetsPerCall);
                }
                var sgLinks = $('.sgIdentifierInTraitTable');

                for (var i = 0; i < sgLinks.length; i++) {
                    var jqueryObj = $(sgLinks[i]);
                    UTILS.jsTreeDataRetrieverPhenoSpec('#' + jqueryObj.attr('id'), '#traitsPerVariantTable',
                            jqueryObj.attr('phenotypename'),
                            jqueryObj.attr('datasetname'),
                            "${createLink(controller: 'VariantSearch', action: 'retrieveJSTreeAjax')}");
                }
            };


            var loading = $('#spinner').show();
            var jsonString = "";
            // workaround necessary because we can't have too many joins in a single request.  The goal is to
            //  fix this problem on the backend, but between now and then here is a trick we can use
            var numberOfTopLevelLoops = Math.floor(datasetmaps.length / maximumDataSetsPerCall);
            for (var dataSetGroupCount = 0; dataSetGroupCount < numberOfTopLevelLoops + 1; dataSetGroupCount++) {
                var dataSetCount = 0;
                var rowMap = [];
                var rowValues = [];
                while ((dataSetCount < maximumDataSetsPerCall) &&
                        (((maximumDataSetsPerCall * dataSetGroupCount) + dataSetCount) < datasetmaps.length)) {
                    rowMap.push(datasetmaps[(maximumDataSetsPerCall * dataSetGroupCount) + dataSetCount]);
                    dataSetCount++;
                }
                if ((typeof rowMap !== 'undefined') &&
                        (rowMap)) {
                    rowMap.map(function (d) {
                        rowValues.push("{\"ds\":\"" + d.name + "\",\"prop\":\"" + d.pvalue + "\",\"phenotype\":\"" + d.phenotype + "\"}");
                    });
                   // var suppArrayOfOpenPhenotypes = arrayOfOpenPhenotypes.map(function (d) {return ('"'+d+'"')});
                    jsonString = "{\"vals\":[\n" + rowValues.join(",\n") + "\n],\n" +
                            "\"phenos\":[\n" + arrayOfOpenPhenotypes.join(",\n") + "\n]}";

                }
                $.ajax({
                    cache: false,
                    type: "get",
                    url: '<g:createLink controller="trait" action="ajaxSpecifiedAssociationStatisticsTraitsPerVariant" />',
                    data: { variantIdentifier: variantIdentifier,
                        technology: '',
                        chosendataData: jsonString },
                    // datasetmaps:datasetmaps },
                    async: false,
                    success: function (data) {
                        var firstTime = (dataSetGroupCount == 0);
                        if (firstTime) {
                            if ($.fn.DataTable.isDataTable('#traitsPerVariantTable')) {
                                $('#traitsPerVariantTable').dataTable({"retrieve": true}).fnDestroy();
                            }

                            $('#traitsPerVariantTable').empty();
                            $('#traitsPerVariantTable').append('<thead>' +
                                    '<tr>' +
                                    '<th><g:message code="variantTable.columnHeaders.shared.dataSet" /></th>' +
                                    '<th><g:message code="informational.shared.header.trait" /></th>' +
                                    '<th><g:message code="variantTable.columnHeaders.sigma.pValue" /></th>' +
                                    '<th><g:message code="variantTable.columnHeaders.shared.direction" /></th>' +
                                    '<th><g:message code="variantTable.columnHeaders.shared.oddsRatio" /></th>' +
                                    '<th><g:message code="variantTable.columnHeaders.shared.maf" /></th>' +
                                    '<th><g:message code="variantTable.columnHeaders.shared.effect" /></th>' +
                                    '</tr>' +
                                    '</thead>');
                            $('#traitsPerVariantTable').append('<tbody id="traitsPerVariantTableBody">' +
                                    '</tbody>');

                        }
                        addMoreValues(data, dataSetGroupCount);
                        loading.hide();

                        massageTraitsTable();
                    },
                    error: function (jqXHR, exception) {
                        loading.hide();
                        core.errorReporter(jqXHR, exception);
                    }
                });
            }
            // get the indenting for now...
            UTILS.labelIndenter('traitsPerVariantTable');
        };


        function reviseTraitsTableRows() {
            // get the boxes for which the cohorts have been requested
            var clickedBoxes = $('#traitsPerVariantTable .jstree-clicked');

            var dataSetNames = [];
            var dataSetMaps = [];
            for (var i = 0; i < clickedBoxes.length; i++) {
                var comboName = $(clickedBoxes[i]).attr('id');
                var partsOfCombo = comboName.replace("--","-").split("-");
                var dataSetWithoutAnchor = partsOfCombo[0];
                dataSetNames.push(dataSetWithoutAnchor);
                var dataSetMap = {"name": dataSetWithoutAnchor,
                    "value": dataSetWithoutAnchor,
                    "pvalue": partsOfCombo[1],
                    "phenotype": partsOfCombo[3].substring(0, partsOfCombo[3].length - 7)};
                dataSetMaps.push(dataSetMap);
            }
            // remember which phenotypes have been opened with a +
            var openPhenotypes = $('.glyphicon-minus-sign');
            var arrayOfOpenPhenotypes = [];
            for ( var i = 0 ; i < openPhenotypes.length ; i++ ){
                arrayOfOpenPhenotypes.push('"'+$(openPhenotypes[i]).closest('tr').children('.vandaRowTd').children('.vandaRowHdr').attr('phenotypename')+'"');
            }
            traitTable('<%=variantIdentifier%>', dataSetMaps, arrayOfOpenPhenotypes);
        }


    </script>


    <div class="gwas-table-container">
        <table id="traitsPerVariantTable" class="table basictable gwas-table dk-t2d-general-table">

            <thead>
            <tr>
                <th><g:message code="variantTable.columnHeaders.shared.dataSet"/> <g:helpText title="variantTable.columnHeaders.shared.dataSet.help.header" placement="bottom" body="variantTable.columnHeaders.shared.dataSet.help.text"/></th>
                <th><g:message code="informational.shared.header.trait"/> <g:if test="${g.portalTypeString()?.equals('t2d')}"><g:helpText title="variantTable.columnHeaders.shared.trait.help.header" placement="bottom" body="variantTable.columnHeaders.shared.trait.help.text"/></th></g:if>
                <th><g:message code="variantTable.columnHeaders.sigma.pValue"/> <g:helpText title="variantTable.columnHeaders.sigma.pValue.help.header" placement="bottom" body="variantTable.columnHeaders.sigma.pValue.help.text"/></th>
                <th><g:message code="variantTable.columnHeaders.shared.direction"/> <g:helpText title="variantTable.columnHeaders.shared.direction.help.header" placement="bottom" body="variantTable.columnHeaders.shared.direction.help.text"/></th>
                <th><g:message code="variantTable.columnHeaders.shared.oddsRatio"/> <g:helpText title="variantTable.columnHeaders.shared.oddsRatio.help.header" placement="bottom" body="variantTable.columnHeaders.shared.oddsRatio.help.text"/></th>
                <th><g:message code="variantTable.columnHeaders.shared.maf"/> <g:helpText title="variantTable.columnHeaders.shared.maf.help.header" placement="bottom" body="variantTable.columnHeaders.shared.maf.help.text"/></th>
                <th><g:message code="variantTable.columnHeaders.shared.effect"/> <g:helpText title="variantTable.columnHeaders.shared.effect.help.header" placement="bottom" body="variantTable.columnHeaders.shared.effect.help.text"/></th>
            </tr>
            </thead>
            <tbody id="traitsPerVariantTableBody">
            </tbody>
        </table>
    </div>
    <div class="row clearfix">
        <div class="col-md-2">
            <div class="pull-left" style="margin: 0 0 0 0">
                <button id="reviser" class="btn btn-primary pull-left" onclick="reviseTraitsTableRows()">
                    <g:message code="gene.variantassociations.change.rows" default="Revise rows"/>
                </button>
            </div>

        </div>
        <div class="col-md-10"></div>
    </div>


    </div>
</div>


<g:if test="${openOnLoad}">
    <script>
        $('#collapseVariantTraitAssociation').collapse({hide: false})
    </script>
</g:if>
