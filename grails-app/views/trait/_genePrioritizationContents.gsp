<h1 class="dk-page-title"><%=phenotypeName%></h1>



<script>

    var drivingVariables = {
        phenotypeName: '<%=phenotypeKey%>',
        prioritizedGeneInfoAjaxUrl: '${createLink(controller: "trait", action: "prioritizedGeneInfoAjax")}',
        getGeneLevelResultsUrl: '${createLink(controller: "home", action: "getGeneLevelResults")}',
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


<div id="manhattanPlot1"></div>


<input id="get clump" type="button" value="Get clump" onclick="mpgSoftware.manhattanplotTableHeader.callFillClumpVariants();" style="display: none;"/>


<table id="phenotypeTraits" class="table basictable table-striped">
    <thead>
    <tr>
        <th><g:message code="geneTable.columnHeaders.shared.gene" /></th>
        <th><g:message code="geneTable.columnHeaders.shared.all_p_val" /></th>
        <th><g:message code="geneTable.columnHeaders.shared.oddsRatio" /></th>
        <th><g:message code="geneTable.columnHeaders.shared.position" /></th>
        <th><g:message code="geneTable.columnHeaders.shared.acu" /></th>
        <th><g:message code="geneTable.columnHeaders.shared.aca" /></th>
    </tr>
    </thead>
    <tbody id="traitTableBody">
    </tbody>
</table>