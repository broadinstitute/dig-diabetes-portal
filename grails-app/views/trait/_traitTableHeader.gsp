<h1><%=phenotypeName%></h1>



<script>
    var mpgSoftware = mpgSoftware || {};

    mpgSoftware.manhattanPlot = (function () {

        var fillSampleGroupDropdown = function (phenotype) {
            var loader = $('#rSpinner');
            loader.show();

            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'trait',action: 'ajaxSampleGroupsPerTrait')}",
                data: {phenotype: phenotype},
                async: false,
                success: function (data) {

                    var rowDataStructure = [];
                    if ((typeof data !== 'undefined') &&
                            (data)) {
                        if ((data.sampleGroups) &&
                                (data.sampleGroups.length>0)) {//assume we have data and process it
                            for ( var i = 0 ; i < data.sampleGroups.length ; i++ ){
                                var sampleGroup = data.sampleGroups[i];
                                $('#manhattanSampleGroupChooser').append(new Option(sampleGroup.sgn,sampleGroup.sg,sampleGroup.default))
                            }
                        }
                    }
                     loader.hide();
                },
                error: function (jqXHR, exception) {
                    loader.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });

        };
        return {fillSampleGroupDropdown: fillSampleGroupDropdown}
    }());



    mpgSoftware.pickNewDataSet = function (){
        var sampleGroup = $('#manhattanSampleGroupChooser').val();
        $('#manhattanPlot1').empty();
        $('#traitTableBody').empty();
        $('#phenotypeTraits').DataTable().rows().remove();
        $('#phenotypeTraits').dataTable({"retrieve": true}).fnDestroy();
        mpgSoftware.regionalTraitAnalysis.fillRegionalTraitAnalysis('<%=phenotypeKey%>',sampleGroup);
        %{--mpgSoftware.manhattanPlot.fillSampleGroupDropdown('<%=phenotypeKey%>');--}%
    }


    $( document ).ready(function() {
        mpgSoftware.manhattanPlot.fillSampleGroupDropdown('<%=phenotypeKey%>');
    });

</script>





<div class="separator"></div>

<p>

    <g:message code="traitTable.messages.results" />
    <span id="traitTableDescription"></span>:
    %{--<g:if test="${sampleGroupOwner == 'DIAGRAM'}">--}%
        %{--<a href="http://diagram-consortium.org/downloads.html" class="boldlink"><g:message code="informational.shared.institution.DIAGRAM" />-3</a>--}%
    %{--</g:if>--}%
    %{--<g:elseif test="${sampleGroupOwner == 'MAGIC'}">--}%
        %{--<a href="http://www.magicinvestigators.org/downloads/" class="boldlink"><g:message code="informational.shared.institution.MAGIC" /></a>--}%
    %{--</g:elseif>--}%
    %{--<g:elseif test="${sampleGroupOwner == 'GIANT'}">--}%
        %{--<a href="http://www.broadinstitute.org/collaboration/giant/index.php/GIANT_consortium_data_files#GIANT_Consortium_2010_GWAS_Metadata_is_Available_Here_for_Download"--}%
           %{--class="boldlink"><g:message code="informational.shared.institution.GIANT" /></a>--}%
    %{--</g:elseif>--}%
    %{--<g:elseif test="${sampleGroupOwner == 'GLGC'}">--}%
        %{--<a href="http://www.ncbi.nlm.nih.gov/pubmed/20686565"--}%
           %{--class="boldlink"><g:message code="informational.shared.institution.GLGC" /></a>--}%
    %{--</g:elseif>--}%
    %{--<g:elseif test="${sampleGroupOwner == 'CARDIoGRAM'}">--}%
        %{--<a href="http://www.cardiogramplusc4d.org/downloads/" class="boldlink"><g:message code="informational.shared.institution.CARDIoGRAM" /></a>--}%
    %{--</g:elseif>--}%
    %{--<g:elseif test="${sampleGroupOwner == 'CKDGenConsortium'}">--}%
        %{--<a href="http://www.ncbi.nlm.nih.gov/pubmed/20383146" class="boldlink"><g:message code="informational.shared.institution.CKDGen" /></a>--}%
    %{--</g:elseif>--}%
    %{--<g:elseif test="${sampleGroupOwner == 'PGC'}">--}%
        %{--<a href="https://www.nimhgenetics.org/available_data/data_biosamples/pgc_public.php"--}%
           %{--class="boldlink"><g:message code="informational.shared.institution.PGC" /></a>--}%
    %{--</g:elseif>--}%
    %{--<g:message code="gene.variantassociations.table.rowhdr.gwas" /> <g:message code="gene.variantassociations.table.rowhdr.meta_analyses" /> <g:message code="informational.shared.phrase.consortium" />:--}%

    <select id="manhattanSampleGroupChooser" name="manhattanSampleGroupChooser" onchange="mpgSoftware.pickNewDataSet(this)">
    </select>

</p>

<div id="manhattanPlot1"></div>

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