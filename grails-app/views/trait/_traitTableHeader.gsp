<h1 class="dk-page-title"><%=phenotypeName%></h1>

<style>
.slidecontainer {
    width: 100%;
}

.slider {
    -webkit-appearance: none;
    width: 100%;
    height: 25px;
    background: #d3d3d3;
    outline: none;
    opacity: 0.7;
    -webkit-transition: .2s;
    transition: opacity .2s;
}

.slider:hover {
    opacity: 1;
}

.slider::-webkit-slider-thumb {
    -webkit-appearance: none;
    appearance: none;
    width: 25px;
    height: 25px;
    background: #4CAF50;
    cursor: pointer;
}

.slider::-moz-range-thumb {
    width: 25px;
    height: 25px;
    background: #4CAF50;
    cursor: pointer;
}
</style>

<script>

    
    var drivingVariables = {
        phenotypeName: '<%=phenotypeKey%>',
        r2:0.4,
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

<p class="form-group">

    <g:message code="traitTable.messages.results" />
    <span id="traitTableDescription"></span>:
    <select id="manhattanSampleGroupChooser" name="manhattanSampleGroupChooser" onchange="mpgSoftware.manhattanplotTableHeader.pickNewDataSet(this)">
    </select>

</p>
<style>
.mychart {width:100% !important; height:740px !important;}
</style>
<div style="text-align: right;">Scroll to zoom. Roll over dots for variant information.</div>
<div id="manhattanPlot1" style="border:solid 1px #999; margin-bottom: 30px; min-width:1000px;"></div>


<input id="get clump" type="button" value="Get clump" onclick="mpgSoftware.manhattanplotTableHeader.callFillClumpVariants();" />

<input id="unclump" type="button" value="Not clump" onclick="mpgSoftware.manhattanplotTableHeader.pickNewDataSet(this)" />

%{--slider default value = 1(non-clump data) and anything less than 1 (clump data)--}%
<div class="slidecontainer">
    <input type="range" min="0" max="10" value="0" class="slider" id="myRange">
    <p>Value: <span id="demo"></span></p>
</div>

<script>
    var slider = document.getElementById("myRange");
    var output = document.getElementById("demo");
    output.innerHTML = slider.value;

    slider.onclick = mpgSoftware.manhattanplotTableHeader.callFillClumpVariants();
</script>


<table id="phenotypeTraits" class="table  dk-t2d-general-table basictable table-striped">
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