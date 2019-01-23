<h1 class="dk-page-title"><%=phenotypeName%></h1>



<script>

    var drivingVariables = {
        phenotypeName: '<%=phenotypeKey%>',
        prioritizedGeneInfoAjaxUrl: '${createLink(controller: "trait", action: "prioritizedGeneInfoAjax")}',
        getGeneLevelResultsUrl: '${createLink(controller: "home", action: "getGeneLevelResults")}',
        launchGeneVariantQueryUrl: '${createLink(controller: "variantSearch", action: "findEveryVariantForAGene")}',
        phenotypeDropdownIdentifier:'#phenotypeDropdownIdentifier',
        subphenotypeDropdownIdentifier:'#subphenotypeDropdownIdentifier',
        local:"${locale}",
        copyMsg:'<g:message code="table.buttons.copyText" default="Copy" />',
        printMsg:'<g:message code="table.buttons.printText" default="Print me!" />'
    };
    mpgSoftware.genePrioritization.setMySavedVariables(drivingVariables);

    $( document ).ready(function() {
        mpgSoftware.genePrioritization.fillDropdownsForGenePrioritization();
        //mpgSoftware.genePrioritization.fillRegionalTraitAnalysis('<%=phenotypeKey%>','');
    });


</script>



<div class="separator"></div>

<p class="form-group">

    <g:message code="traitTable.messages.results" />
    <span id="traitTableDescription"></span>:
    <select id="phenotypeDropdownIdentifier" name="manhattanSampleGroupChooser" onchange="mpgSoftware.genePrioritization.pickNewGeneInfo()">
    </select>

    <select id="subphenotypeDropdownIdentifier" name="manhattanSampleGroupChooser" onchange="mpgSoftware.genePrioritization.pickNewGeneInfo()">
    </select>

</p>
<style>
.mychart {width:100% !important; height:740px !important;}
</style>

<g:if test="${g.portalTypeString()?.equals('als')}">
<div style="text-align: right;">Scroll to zoom. Roll over dots for gene information.</div>
    </g:if>

<g:else>
    <div style="text-align: right;">Scroll to zoom. Roll over dots for variant information.</div>
</g:else>

<div id="manhattanPlot1" style="border:solid 1px #999; margin-bottom: 30px; min-width:1000px;"></div>



<input id="get clump" type="button" value="Get clump" onclick="mpgSoftware.manhattanplotTableHeader.callFillClumpVariants();" style="display: none;"/>


<table id="phenotypeTraits" class="table dk-t2d-general-table basictable table-striped">
    <thead>
    <tr>
        <th width="15%"><g:message code="geneTable.columnHeaders.shared.gene" /></th>
        <th width="6%"><g:message code="geneTable.columnHeaders.shared.chromosome" /></th>
        <th width="19%"><g:message code="geneTable.columnHeaders.shared.position" /></th>
        <th width="15%"><g:message code="geneTable.columnHeaders.shared.all_p_val" /></th>
        <th width="15%"><g:message code="geneTable.columnHeaders.shared.oddsRatio" /></th>
        <th width="15%"><g:message code="geneTable.columnHeaders.shared.acu" />
        <g:helpText title="geneTable.columnHeaders.shared.acu.help.header" placement="bottom" body="geneTable.columnHeaders.shared.acu.help.text"/>
        </th>
        <th width="15%"><g:message code="geneTable.columnHeaders.shared.aca" />
        <g:helpText title="geneTable.columnHeaders.shared.aca.help.header" placement="bottom" body="geneTable.columnHeaders.shared.aca.help.text"/>
        </th>
    </tr>
    </thead>
    <tbody id="traitTableBody">
    </tbody>
</table>