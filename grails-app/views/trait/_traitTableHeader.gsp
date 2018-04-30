<script src="https://unpkg.com/react@15.6.1/dist/react.js"></script>
<script src="https://unpkg.com/react-dom@15.6.1/dist/react-dom.js"></script>
<h1 class="dk-page-title" xmlns="http://www.w3.org/1999/html"><%=phenotypeName%></h1>


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

<div style = "width: 83%; height: 35px; background-color:#fff; border:none; border-radius: 5px; margin:0; font-size: 16px; padding-bottom: 100px;">
    <p class= "dk-footnote" style="width:83%;">Dataset</p>
    <span id="traitTableDescription"></span>
    <select  style = " width:600px; width: 150px; overflow: hidden; text-overflow: ellipsis;" id="manhattanSampleGroupChooser" name="manhattanSampleGroupChooser" onchange="mpgSoftware.manhattanplotTableHeader.callFillClumpVariants(this)">
    </select>

</div>


<div style = "width: 83%; height: 35px; background-color:#fff; border:none; border-radius: 5px; margin:0; font-size: 16px; padding-bottom: 100px;" >
    <p class = "dk-footnote" style="width:83%;">R2 threshold</p>
    <select style = "width:600px; width: 150px; overflow: hidden; text-overflow: ellipsis;" id="rthreshold" name="rthreshold" onchange="mpgSoftware.manhattanplotTableHeader.callFillClumpVariants(this)">
        <option value="0.1000001" >0.1 </option>
        <option value="0.2" >0.2 </option>
        <option value="0.4" >0.4 </option>
        <option value="0.6" >0.6 </option>
        <option value="0.8" >0.8 </option>
        <option value="1" selected="selected"> 1 </option>
    </select>

</div>




<style>
.mychart {width:100% !important; height:740px !important;}
</style>
<div style="text-align: right;">Scroll to zoom. Roll over dots for variant information.</div>
<div id="manhattanPlot1" style="border:solid 1px #999; margin-bottom: 30px; min-width:1000px;"></div>



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
