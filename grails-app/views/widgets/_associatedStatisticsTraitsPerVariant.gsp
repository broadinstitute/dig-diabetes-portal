<!-- inputs needed
    variantIdentifier: the variant id
    dbSnpId: for the snp id, if provided (from the trait info page)
    openOnLoad: if accordion closed at start
-->
<style>
    tr.bestAssociation {

    }
    tr.otherAssociations {
       display: none;
    }
</style>



<div class="accordion-group">
    <div class="accordion-heading">
        <a class="accordion-toggle  collapsed" data-toggle="collapse" href="#collapseVariantTraitAssociation">
            <h2><strong><g:message code="widgets.variant.trait.associations.title" default="Association statistics across 25 traits"/><g:if test="${dnSnpId}"> <g:message code="site.shared.phrases.for" /> ${dnSnpId}</g:if></strong></h2>
        </a>
    </div>


<div id="collapseVariantTraitAssociation" class="accordion-body collapse">
    <div class="accordion-inner" id="traitAssociationInner">

        <r:require modules="core"/>
        <r:require modules="tableViewer,traitInfo"/>

<script>
    var mpgSoftware = mpgSoftware || {};


    // track if data table loaded yet; get reinitialization error
    var tableNotLoaded = true;
    var dbSnpId;

    mpgSoftware.widgets = (function () {
        var loadAssociationTable = function () {
            var variant;
            var loading = $('#spinner').show();
            $.ajax({
                cache: false,
                type: "get",
                url: '<g:createLink controller="trait" action="ajaxAssociatedStatisticsTraitPerVariant" />',
                data: {variantIdentifier: '<%=variantIdentifier%>',
                       technology:''},
                async: true,
                success: function (data) {
                    mpgSoftware.trait.fillTheTraitsPerVariantFields(data,
                            '#traitsPerVariantTableBody',
                            '#traitsPerVariantTable',
                            data['show_gene'],
                            data['show_exseq'],
                            data['show_exchp'],
                            '<g:createLink controller="trait" action="traitSearch" />',
                            "${locale}",
                            '<g:message code="table.buttons.copyText" default="Copy" />',
                            '<g:message code="table.buttons.printText" default="Print me!" />');
                    var sgLinks = $('.sgIdentifierInTraitTable');

                    for ( var i = 0 ; i < sgLinks.length ; i++ ){
                        var jqueryObj = $(sgLinks[i]);
                        UTILS.jsTreeDataRetriever ('#'+jqueryObj.attr('id'),'#traitsPerVariantTable',
                                jqueryObj.attr('phenotypename'),
                                jqueryObj.attr('datasetname'),
                                "${createLink(controller: 'VariantSearch', action: 'retrieveJSTreeAjax')}");
                    }

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

    $("#collapseVariantTraitAssociation").on("show.bs.collapse", function() {
        if (tableNotLoaded) {
            mpgSoftware.widgets.loadAssociationTable();
            tableNotLoaded = false;
        }
    });



    var traitTable = function (variantIdentifier,datasetmaps) {

            var variant;
            var loading = $('#spinner').show();
        var rowValues = [];
        var jsonString = "";
        var rowMap = datasetmaps;
        if ((typeof rowMap !== 'undefined') &&
                (rowMap)){
            rowMap.map(function (d) {
             //   rowValues.push("{\"ds\":\""+d.name+"\",\"prop\":\""+d.pvalue+"\",\"phenotype\":\""+d.phenotype+"\",\"otherFields\":\""+d.otherFields+"\"}");
                rowValues.push("{\"ds\":\""+d.name+"\",\"prop\":\""+d.pvalue+"\",\"phenotype\":\""+d.phenotype+"\"}");
            });
            jsonString = "{\"vals\":[\n"+rowValues.join(",\n")+"\n]}";

        }
            $.ajax({
                cache: false,
                type: "get",
                url: '<g:createLink controller="trait" action="ajaxSpecifiedAssociationStatisticsTraitsPerVariant" />',
                data: { variantIdentifier: variantIdentifier,
                        technology:'',
                        chosendataData: jsonString },
                       // datasetmaps:datasetmaps },
                async: true,
                success: function (data) {
                    if ($.fn.DataTable.isDataTable( '#traitsPerVariantTable' )){
                        $('#traitsPerVariantTable').dataTable({"bRetrieve":true}).fnDestroy();
                    }

                    $('#traitsPerVariantTable').empty();
                    $('#traitsPerVariantTable').append('<thead>'+
                    '<tr>'+
                    '<th><g:message code="variantTable.columnHeaders.shared.dataSet" /></th>'+
                    '<th><g:message code="informational.shared.header.trait" /></th>'+
                    '<th><g:message code="variantTable.columnHeaders.sigma.pValue" /></th>'+
                    '<th><g:message code="variantTable.columnHeaders.shared.direction" /></th>'+
                    '<th><g:message code="variantTable.columnHeaders.shared.oddsRatio" /></th>'+
                    '<th><g:message code="variantTable.columnHeaders.shared.maf" /></th>'+
                    '<th><g:message code="variantTable.columnHeaders.shared.effect" /></th>'+
                    '</tr>'+
                    '</thead>');
                    $('#traitsPerVariantTable').append('<tbody id="traitsPerVariantTableBody">'+
                      '</tbody>');
                    mpgSoftware.trait.fillTheTraitsPerVariantFields(data,
                            '#traitsPerVariantTableBody',
                            '#traitsPerVariantTable',
                            data['show_gene'],
                            data['show_exseq'],
                            data['show_exchp'],
                            '<g:createLink controller="trait" action="traitSearch" />',
                            "${locale}",
                            '<g:message code="table.buttons.copyText" default="Copy" />',
                            '<g:message code="table.buttons.printText" default="Print me!" />');
                    var sgLinks = $('.sgIdentifierInTraitTable');

                    for ( var i = 0 ; i < sgLinks.length ; i++ ){
                        var jqueryObj = $(sgLinks[i]);
                        UTILS.jsTreeDataRetriever ('#'+jqueryObj.attr('id'),'#traitsPerVariantTable',
                                jqueryObj.attr('phenotypename'),
                                jqueryObj.attr('datasetname'),
                                "${createLink(controller: 'VariantSearch', action: 'retrieveJSTreeAjax')}");
                    }

                    loading.hide();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });

    };







    function reviseTraitsTableRows(){

        var clickedBoxes =  $('#traitsPerVariantTable .jstree-clicked');
        var dataSetNames  = [];
        var dataSetMaps  = [];
        for  ( var i = 0 ; i < clickedBoxes.length ; i++ )   {
            var  comboName  =  $(clickedBoxes[i]).attr('id');
            var otherSections = $('#GWAS_GIANT_mdv2-P_VALUE-253288-BMI_anchor').closest('tr').children();
//            var otherFields = ((otherFields[3]!=='')?'DIR':'NONE')+'^'+
//                    ((otherFields[4]!=='')?'ODDS_RATIO':'NONE')+'^'+
//                    ((otherFields[5]!=='')?'MAF':'NONE')+'^'+
//                    ((otherFields[6]!=='')?'BETA':'NONE');
            var partsOfCombo =   comboName.split("-");
            var  dataSetWithoutAnchor  =  partsOfCombo[0];
            dataSetNames.push(dataSetWithoutAnchor);
            var  dataSetMap = {"name":dataSetWithoutAnchor,
                "value":dataSetWithoutAnchor,
                "pvalue":partsOfCombo[1],
                "phenotype":partsOfCombo[3].substring(0, partsOfCombo[3].length-7)};
 //               "otherFields":otherFields};
            dataSetMaps.push(dataSetMap);
        }


        traitTable('<%=variantIdentifier%>',dataSetMaps);
    }


    </script>


        <div class="gwas-table-container">
            <table id="traitsPerVariantTable" class="table basictable gwas-table">

                <thead>
                <tr>
                    <th><g:message code="variantTable.columnHeaders.shared.dataSet" /></th>
                    <th><g:message code="informational.shared.header.trait" /></th>
            		<th><g:message code="variantTable.columnHeaders.sigma.pValue" /></th>
            		<th><g:message code="variantTable.columnHeaders.shared.direction" /></th>
            		<th><g:message code="variantTable.columnHeaders.shared.oddsRatio" /></th>
            		<th><g:message code="variantTable.columnHeaders.shared.maf" /></th>
            		<th><g:message code="variantTable.columnHeaders.shared.effect" /></th>
                </tr>
                </thead>
                <tbody id="traitsPerVariantTableBody">
                </tbody>
            </table>
        </div>
        <div class="pull-left" style="margin: -25px 0 0 0">
            <button id="reviser"  class="btn btn-primary pull-left" onclick="reviseTraitsTableRows()">
                <g:message code="gene.variantassociations.change.rows" default="Revise rows"/>
            </button>
        </div>
</div>
</div>
</div>

<g:if test="${openOnLoad}">
    <script>
        $('#collapseVariantTraitAssociation').collapse({hide: false})
    </script>
</g:if>
