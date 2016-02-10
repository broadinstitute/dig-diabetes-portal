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



    // moved to utilities?
    var jsTreeDataRetriever = function (divId,tableId,phenotypeName,sampleGroupName){
        var dataPasser = {phenotype:phenotypeName,sampleGroup:sampleGroupName};
        $(divId).jstree({
            "core" : {
                "animation" : 0,
                "check_callback" : true,
                "themes" : { "stripes" : false },
                'data' : {
                    'type': "post",
                    'url' :  "${createLink(controller: 'VariantSearch', action: 'retrieveJSTreeAjax')}",
                    'data': function (c,i) {
                        return dataPasser;
                    },
                    'metadata': dataPasser
                }
            },
            "checkbox" : {
                "keep_selected_style" : false,
                "three_state": false
            },
            "plugins" : [  "themes","core", "wholerow", "checkbox", "json_data", "ui", "types"]
        });
        $(divId).on ('after_open.jstree', function (e, data) {
            for ( var i = 0 ; i < data.node.children.length ; i++ )  {
                $(divId).jstree("select_node", '#'+data.node.children[i]+' .jstree-checkbox', true);
            }
        }) ;
        $(divId).on ('load_node.jstree', function (e, data) {
            var existingNodes = $(tableId+' td.vandaRowTd div.vandaRowHdr');
            var sgsWeHaveAlready = [];
            for ( var i = 0 ; i < existingNodes.length ; i++ ){
                var currentDiv = $(existingNodes[i]);
                sgsWeHaveAlready.push(currentDiv.attr('datasetname'));
            }
            var listToDelete = [];
            for ( var i = 0 ; i < data.node.children_d.length ; i++ )  {
                var nodeId =  data.node.children_d[i];
                if (data.node.children.indexOf(nodeId)==-1){ // elements in children_d and NOT children are actual child nodes.
                    // Elements in children can be self pointers for a node, which we don't want to delete
                    var sampleGroupName = nodeId.substring(0,nodeId.indexOf('-'));
                    if (sgsWeHaveAlready.indexOf(sampleGroupName)>-1){
                        listToDelete.push(data.node.children_d[i]);
                    }
                }
            }
            for ( var i = 0 ; i < listToDelete.length ; i++ )  {
                $(divId).jstree("delete_node", listToDelete[i]);
            }

        });


    };







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
                        jsTreeDataRetriever ('#'+jqueryObj.attr('id'),'#traitsPerVariantTable',jqueryObj.attr('phenotypename'),jqueryObj.attr('datasetname'));
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
    function reviseTraitsTableRows(){
//        var phenotype = $('#phenotypeTableChooser option:selected').val();
        var clickedBoxes =  $('#traitsPerVariantTable .jstree-clicked');
        var dataSetNames  = [];
        var dataSetMaps  = [];
        for  ( var i = 0 ; i < clickedBoxes.length ; i++ )   {
            var  comboName  =  $(clickedBoxes[i]).attr('id');
            var partsOfCombo =   comboName.split("-");
            var  dataSetWithoutAnchor  =  partsOfCombo[0];
            dataSetNames.push(dataSetWithoutAnchor);
            var  dataSetMap = {"name":dataSetWithoutAnchor,
                "value":dataSetWithoutAnchor,
                "pvalue":partsOfCombo[1],
                "count":partsOfCombo[2].substring(0, partsOfCombo[2].length-7)};
            dataSetMaps.push(dataSetMap);
        }

      //  mpgSoftware.ancestryTable.loadAncestryTable('<%=geneName%>',dataSetMaps);
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
            <button id="reviser"  class="btn btn-primary pull-left" onclick="reviseTraitsTableRows()"  disabled>
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
