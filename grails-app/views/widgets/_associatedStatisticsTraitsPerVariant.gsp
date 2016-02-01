<!-- inputs needed
    variantIdentifier: the variant id
    dbSnpId: for the snp id, if provided (from the trait info page)
    openOnLoad: if accordion closed at start
-->
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
                url: "../../trait/ajaxAssociatedStatisticsTraitPerVariant",
                data: {variantIdentifier: '<%=variantIdentifier%>'},
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

</script>


        <div class="gwas-table-container">
            <table id="traitsPerVariantTable" class="table table-striped basictable gwas-table">
                <thead>
                <tr>
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
</div>
</div>
</div>

<g:if test="${openOnLoad}">
    <script>
        $('#collapseVariantTraitAssociation').collapse({hide: false})
    </script>
</g:if>
