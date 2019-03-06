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



<!--<div class="separator"></div>-->

<div class="form-group row">

    <!--<h3><g:message code="traitTable.messages.results" /></h3>
    <span id="traitTableDescription"></span>-->

    <div class="col-md-6">
        <label>Dataset: </label><select id="phenotypeDropdownIdentifier" class="form-control" name="manhattanSampleGroupChooser" onchange="mpgSoftware.genePrioritization.pickNewGeneInfo()">
        </select>
    </div>
    <div class="col-md-6">
        <label>Masks: </label><select id="subphenotypeDropdownIdentifier" class="form-control" name="manhattanSampleGroupChooser" onchange="mpgSoftware.genePrioritization.pickNewGeneInfo()">
        </select>
    </div>



</div>

<style>
.mychart {width:100% !important; height:740px !important;}
</style>
<div style="text-align: right;">Scroll to zoom. Roll over dots for variant information.</div>
<div id="manhattanPlot1" style="border:solid 1px #999; margin-bottom: 30px; min-width:1000px;"></div>



<input id="get clump" type="button" value="Get clump" onclick="mpgSoftware.manhattanplotTableHeader.callFillClumpVariants();" style="display: none;"/>


<table id="phenotypeTraits"  class="table dk-t2d-general-table basictable table-striped">
    <thead>
    <tr>
        <th width="15%"><g:message code="geneTable.columnHeaders.shared.gene" /></th>
        <th width="15%"><g:message code="geneTable.columnHeaders.shared.chromosome" /></th>
        <th width="15%"><g:message code="geneTable.columnHeaders.shared.position" /></th>
        <th width="15%"><g:message code="geneTable.columnHeaders.shared.all_p_val" /></th>
        <th width="15%"><g:message code="geneTable.columnHeaders.shared.ploftee" /></th>
        <th width="15%"><g:message code="geneTable.columnHeaders.shared.mina" /></th>
        <th width="15%"><g:message code="geneTable.columnHeaders.shared.minu" /></th>
        <th width="15%"><g:message code="geneTable.columnHeaders.shared.pSkat" /></th>



    </tr>
    </thead>
    <tbody id="traitTableBody">
    </tbody>
</table>