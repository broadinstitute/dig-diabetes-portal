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
<th colspan="5" class="datatype-header"><g:message code="variantTable.columnHeaders.sigma.title" default="SIGMA" />
    <g:helpText title="variantTable.columnHeaders.sigma.titleQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.sigma.titleQ.help.text"/>
</th>
</g:if>
<g:if test="${show_exseq}">
<th colspan="5" class="datatype-header"><g:message code="variantTable.columnHeaders.exomeSequencing.title" default="exome sequencing" />
<g:helpText title="variantTable.columnHeaders.exomeSequencing.titleQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.exomeSequencing.titleQ.help.text"/>
</th>
</g:if>
<g:if test="${show_exchp}">
<th colspan="2" class="datatype-header"><g:message code="variantTable.columnHeaders.exomeChip.title" default="exome chip" />
<g:helpText title="variantTable.columnHeaders.exomeChip.titleQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.exomeChip.titleQ.help.text"/>
</th>
</g:if>
<th colspan="2" class="datatype-header"><g:message code="variantTable.columnHeaders.diagram.title" default="DIAGRAM" />
<g:helpText title="variantTable.columnHeaders.diagram.titleQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.diagram.titleQ.help.text"/>
</th>
</tr>
<tr>
<g:if test="${show_gene}"><th><g:message code="variantTable.columnHeaders.shared.nearestGene" default="nearest gene" />
<g:helpText title="variantTable.columnHeaders.shared.nearestGeneQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.shared.nearestGeneQ.help.text"/>
</th></g:if>
    <th><g:message code="variantTable.columnHeaders.shared.variant" default="variant" />
    <g:helpText title="variantTable.columnHeaders.shared.variantQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.shared.variantQ.help.text"/>
    </th>
    <th><g:message code="variantTable.columnHeaders.shared.rsid" default="rsid" />
    <g:helpText title="variantTable.columnHeaders.shared.rsidQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.shared.rsidQ.help.text"/>
    </th>
    <th><g:message code="variantTable.columnHeaders.shared.proteinChange" default="proteinChange" />
    <g:helpText title="variantTable.columnHeaders.shared.proteinChangeQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.shared.proteinChangeQ.help.text"/>
    </th>
    <th><g:message code="variantTable.columnHeaders.shared.effectOnProtein" default="effectOnProtein" />
    <g:helpText title="variantTable.columnHeaders.shared.effectOnProteinQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.shared.effectOnProteinQ.help.text"/>
    </th>
<g:if test="${show_sigma}">
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.sigma.source" default="source" />
    <g:helpText title="variantTable.columnHeaders.sigma.sourceQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.sigma.sourceQ.help.text"/>
    </th>
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.sigma.pValue" default="p-value" />
    <g:helpText title="variantTable.columnHeaders.sigma.pValue.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.sigma.pValue.help.text"/>
    </th>
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.sigma.oddsRatio" default="odds ratio" />
    <g:helpText title="variantTable.columnHeaders.sigma.oddsRatioQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.sigma.oddsRatioQ.help.text"/>
    </th>
    <th><g:message code="variantTable.columnHeaders.exomeSequencing.caseControl" default="case/control" />
    <g:helpText title="variantTable.columnHeaders.exomeSequencing.caseControlQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.exomeSequencing.caseControlQ.help.text"/>
    </th>
    <th><g:message code="variantTable.columnHeaders.sigma.frequency" default="frequency" />
    <g:helpText title="variantTable.columnHeaders.sigma.frequencyQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.sigma.frequencyQ.help.text"/>
    </th>
</g:if>
<g:if test="${show_exseq}">
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.exomeSequencing.pValue" default="p-value" />
    <g:helpText title="variantTable.columnHeaders.exomeSequencing.pValueQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.exomeSequencing.pValueQ.help.text"/>
    </th>
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.exomeSequencing.oddsRatio" default="odds ratio" />
    <g:helpText title="variantTable.columnHeaders.exomeSequencing.oddsRatio.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.exomeSequencing.oddsRatio.help.text"/>
    </th>
    <th><g:message code="variantTable.columnHeaders.exomeSequencing.caseControl" default="case/control" />
    <g:helpText title="variantTable.columnHeaders.exomeSequencing.caseControlQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.exomeSequencing.caseControlQ.help.text"/>
    </th>
    <th><g:message code="variantTable.columnHeaders.exomeSequencing.highestFrequency" default="highest frequency" />
    <g:helpText title="variantTable.columnHeaders.exomeSequencing.highestFrequencyQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.exomeSequencing.highestFrequencyQ.help.text"/>
    </th>
    <th><g:message code="variantTable.columnHeaders.exomeSequencing.popWithHighestFrequency" default="population with highest frequency" />
    <g:helpText title="variantTable.columnHeaders.exomeSequencing.popWithHighestFrequencyQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.exomeSequencing.popWithHighestFrequencyQ.help.text"/>
    </th>
</g:if>
<g:if test="${show_exchp}">
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.exomeChip.pValue" default="p value" />
    <g:helpText title="variantTable.columnHeaders.exomeChip.pValueQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.exomeChip.pValueQ.help.text"/>
    </th>
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.exomeChip.oddsRatio" default="odds ratio" />
    <g:helpText title="variantTable.columnHeaders.exomeChip.oddsRatioQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.exomeChip.oddsRatioQ.help.text"/>
    </th>
</g:if>
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.shared.pValue" default="p value" />
    <g:helpText title="variantTable.columnHeaders.shared.pValueQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.shared.pValueQ.help.text"/>
    </th>
    <th style="min-width: 80px;"><g:message code="variantTable.columnHeaders.shared.oddsRatio" default="odds ratio" />
    <g:helpText title="variantTable.columnHeaders.shared.oddsRatioQ.help.header"  qplacer="2px 0 0 6px" placement="top" body="variantTable.columnHeaders.shared.oddsRatioQ.help.text"/>
    </th>
</tr>
</thead>
<tbody id="variantTableBody">
</tbody>
</table>