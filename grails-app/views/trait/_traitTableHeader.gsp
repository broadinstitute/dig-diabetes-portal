<h1><%=phenotypeName%></h1>



<script>

    
    var drivingVariables = {
        phenotypeName: '<%=phenotypeKey%>',
        ajaxClumpDataUrl: '${createLink(controller: "trait", action: "ajaxClumpData")}',
        ajaxSampleGroupsPerTraitUrl: '${createLink(controller: "trait", action: "ajaxSampleGroupsPerTrait")}',
        phenotypeAjaxUrl: '${createLink(controller: "trait", action: "phenotypeAjax")}',
        variantInfoUrl: '${createLink(controller: "variantInfo", action: "variantInfo")}',
        requestedSignificance:'<%=requestedSignificance%>',
        local:"${locale}",
        copyMsg:'<g:message code="table.buttons.copyText" default="Copy" />',
        printMsg:'<g:message code="table.buttons.printText" default="Print me!" />'
    };
    mpgSoftware.manhattanplotTableHeader.setMySavedVariables(drivingVariables);

    $( document ).ready(function() {

        mpgSoftware.manhattanplotTableHeader.fillSampleGroupDropdown('<%=phenotypeKey%>');
        mpgSoftware.manhattanplotTableHeader.fillRegionalTraitAnalysis('<%=phenotypeKey%>','');
    });


</script>



<div class="separator"></div>

<p>

    <g:message code="traitTable.messages.results" />
    <span id="traitTableDescription"></span>:
    <select id="manhattanSampleGroupChooser" name="manhattanSampleGroupChooser" onchange="mpgSoftware.manhattanplotTableHeader.pickNewDataSet(this)">
    </select>

</p>


<div id="manhattanPlot1"></div>


<input id="get clump" type="button" value="Get clump" onclick="mpgSoftware.manhattanplotTableHeader.callFillClumpVariants();" style="display: none;"/>


<table id="phenotypeTraits" class="table basictable table-striped">
    <thead>
    <tr>
        <th><g:message code="variantTable.columnHeaders.shared.rsid" /></th>
        <th><g:message code="variantTable.columnHeaders.shared.nearestGene" /></th>
        <th><g:message code="variantTable.columnHeaders.exomeChip.pValue" /></th>
        <th id="effectTypeHeader"></th>
        <th><g:message code="variantTable.columnHeaders.shared.maf" /></th>
        <th><g:message code="variantTable.columnHeaders.shared.all_p_val" /></th>
    </tr>
    </thead>
    <tbody id="traitTableBody">
    </tbody>
</table>
%{--<% if (variants.length == 0) { print('<p><em>No variants found</em></p>') } %>--}%