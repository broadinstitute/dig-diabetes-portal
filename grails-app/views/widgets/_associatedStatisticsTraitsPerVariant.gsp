<!-- inputs needed
    variantIdentifier: the variant id
    dbSnpId: for the snp id, if provided (from the trait info page)
    openOnLoad: if accordion closed at start
-->

<script>
    var phenotypeDatasetMapping = {};
    <g:applyCodec encodeAs="none">
    phenotypeDatasetMapping = ${phenotypeDatasetMapping};
    </g:applyCodec>
    $( document ).ready(function() {
        mpgSoftware.associationStatistics.setAssociationStatisticsVariables({
            retrieveJSTreeAjaxUrl: "${createLink(controller: 'VariantSearch', action: 'retrieveJSTreeAjax')}",
            ajaxAssociatedStatisticsTraitPerVariantUrl: "${createLink(controller: 'trait', action: 'ajaxAssociatedStatisticsTraitPerVariant')}",
            traitSearchUrl: "${createLink(controller: 'trait', action: 'traitSearch')}",
            locale:"${locale}",
            copyText:'<g:message code="table.buttons.copyText" default="Copy" />',
            printText: '<g:message code="table.buttons.printText" default="Print me!" />',
            dataSet:'<g:message code="variantTable.columnHeaders.shared.dataSet" />',
            trait:'<g:message code="informational.shared.header.trait" />',
            pValue:'<g:message code="variantTable.columnHeaders.sigma.pValue" />',
            direction:'<g:message code="variantTable.columnHeaders.shared.direction" />',
            oddsRatio:'<g:message code="variantTable.columnHeaders.shared.oddsRatio" />',
            maf:'<g:message code="variantTable.columnHeaders.shared.maf" />',
            effect:'<g:message code="variantTable.columnHeaders.shared.effect" />',
            variantIdentifier: '<%=variantIdentifier%>'
        });
        mpgSoftware.associationStatistics.initializePage({  exposePhewasModule:${portalVersionBean.getExposePhewasModule()},
                                                            exposeForestPlot:${portalVersionBean.getExposeForestPlot()}    });
       // mpgSoftware.associationStatistics.loadAssociationTable();
    });

</script>
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

    <div class="accordion-inner" id="traitAssociationInner">

        <g:if test="${portalVersionBean.getExposeTraitDataSetAssociationView()}">
            <p><g:message code="variant.traitTableGraphicHelp1"></g:message></p>
        </g:if>
    <div class='phenotype-searchbox-wrapper row'></div>

        <div id="pheplot">

            <div id="dkPhePlot"></div>
        </div>

    <r:require modules="core"/>
    <r:require modules="tableViewer,traitInfo"/>


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
    %{--<div class="row clearfix">--}%
        %{--<div class="col-md-2">--}%
            %{--<div class="pull-left" style="margin: 0 0 0 0">--}%
                %{--<button id="reviser" class="btn btn-primary pull-left" onclick="reviseTraitsTableRows()">--}%
                    %{--<g:message code="gene.variantassociations.change.rows" default="Revise rows"/>--}%
                %{--</button>--}%
            %{--</div>--}%

        %{--</div>--}%
        %{--<div class="col-md-10"></div>--}%
    %{--</div>--}%


    </div>
</div>

<script>
</script>
<g:if test="${openOnLoad}">
    <script>
        $( document ).ready(function() {
            $('#collapseVariantTraitAssociation').collapse({hide: false})
        });
    </script>
</g:if>
