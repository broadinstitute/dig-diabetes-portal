<p><em><g:message code="variantTable.searchResults.oddsRatiosUnreliable" default="odds ratios unreliable" /></em></p>


<table id="variantTable" class="table table-striped basictable">
    <thead>
        <tr>
<g:if test="${show_gene}">
<th></th>
</g:if>
<th></th>
<th></th>
<th></th>
<th></th>
<g:if test="${show_sigma}">
<th colspan="5" class="datatype-header"><g:message code="variantTable.columnHeaders.sigma.title" default="SIGMA" /></th>
</g:if>
<g:if test="${show_exseq}">
<th colspan="5" class="datatype-header">exome sequencing</th>
</g:if>
<g:if test="${show_exchp}">
<th colspan="2" class="datatype-header">exome chip</th>
</g:if>
<th colspan="2" class="datatype-header">DIAGRAM</th>
</tr>
<tr>
<g:if test="${show_gene}"><th><g:message code="variantTable.columnHeaders.shared.nearestGene" default="nearest gene" /></th></g:if>
    <th><g:message code="variantTable.columnHeaders.shared.variant" default="variant" /></th>
    <th><g:message code="variantTable.columnHeaders.shared.rsid" default="rsid" /></th>
    <th><g:message code="variantTable.columnHeaders.shared.proteinChange" default="proteinChange" /></th>
    <th><g:message code="variantTable.columnHeaders.shared.effectOnProtein" default="effectOnProtein" /></th>
<g:if test="${show_sigma}">
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.sigma.source" default="source" /></th>
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.sigma.pValue" default="p-value" /></th>
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.sigma.oddsRatio" default="odds ratio" /></th>
    <th><g:message code="variantTable.columnHeaders.exomeSequencing.caseControl" default="case/control" /></th>
    <th><g:message code="variantTable.columnHeaders.sigma.frequency" default="frequency" /></th>
</g:if>
<g:if test="${show_exseq}">
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.exomeSequencing.pValue" default="p-value" /></th>
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.exomeSequencing.oddsRatio" default="odds ratio" /></th>
    <th><g:message code="variantTable.columnHeaders.exomeSequencing.caseControl" default="case/control" /></th>
    <th><g:message code="variantTable.columnHeaders.exomeSequencing.highestFrequency" default="highest frequency" /></th>
    <th><g:message code="variantTable.columnHeaders.exomeSequencing.popWithHighestFrequency" default="population with highest frequency" /></th>
</g:if>
<g:if test="${show_exchp}">
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.exomeChip.pValue" default="p value" /></th>
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.exomeChip.oddsRatio" default="odds ratio" /></th>
</g:if>
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.shared.pValue" default="p value" /></th>
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.shared.oddsRatio" default="odds ratio" /></th>
</tr>
</thead>
<tbody id="variantTableBody">
</tbody>
</table>