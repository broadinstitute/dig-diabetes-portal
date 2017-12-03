<h1><%=phenotypeName%></h1>



<script>
    var mpgSoftware = mpgSoftware || {};

    mpgSoftware.manhattanPlot = function () {

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
                            (data.sampleGroups.length > 0)) {//assume we have data and process it
                            for (var i = 0; i < data.sampleGroups.length; i++) {
                                var sampleGroup = data.sampleGroups[i];
                                $('#manhattanSampleGroupChooser').append(new Option(sampleGroup.sgn, sampleGroup.sg, sampleGroup.default))
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

        var fillClumpVariants = function (phenotypeName, dataset) {
            var loader = $('#rSpinner');
            loader.show();
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'trait',action: 'ajaxClumpData')}",
                data: {phenotype: phenotypeName, dataset: dataset},
                async: false,
                success: function (data) {
                    console.log(data);

                  mpgSoftware.manhattanplotTableHeader.refreshManhattanplotTableView(data);

                },
                error: function (jqXHR, exception) {
                    loader.hide();
                    core.errorReporter(jqXHR, exception);
                }
            }).done(function (data, textStatus, jqXHR) {
                _.forEach(data.children, function (eachKey,val) {
                    console.log(data);
                })

            });

       };
        %{--var unclickClumpCheckbox = function(){--}%
            %{--$("input[type=checkbox]").change(function() {--}%
               %{--// var selectedval = $(this).val();--}%
                %{--if($(this).is(":checked")) {--}%
                    %{--var selectedtext = $(this).next().text();--}%
                    %{--//call clump data and d3 plot--}%
                    %{--mpgSoftware.manhattanPlot.fillClumpVariants('<%=phenotypeKey%>',document.getElementById("manhattanSampleGroupChooser").value);--}%

                %{--}--}%
                %{--else {--}%
                    %{--//clear the clump and call the non-clump data and d3 plot--}%
                    %{--$('#phenotypeTraits').dataTable({"retrieve": true}).fnDestroy();--}%
                    %{--mpgSoftware.regionalTraitAnalysis.fillRegionalTraitAnalysis('<%=phenotypeKey%>',sampleGroup);--}%


                %{--}--}%
            %{--});--}%

        %{--}--}%
//       var unclickClumpCheckbox = function(){
//           $('#clump').change(function() {
//               if(!$(this).is(':checked'))
//                   alert('worked');
//           });
//       }


        return {
            fillSampleGroupDropdown: fillSampleGroupDropdown,
            fillClumpVariants:fillClumpVariants
        }
    }();



    mpgSoftware.pickNewDataSet = function (){
        var sampleGroup = $('#manhattanSampleGroupChooser').val();
        $('#manhattanPlot1').empty();
        $('#traitTableBody').empty();
        $('#phenotypeTraits').DataTable().rows().remove();
        $('#phenotypeTraits').dataTable({"retrieve": true}).fnDestroy();
        mpgSoftware.manhattanplotTableHeader.fillRegionalTraitAnalysis('<%=phenotypeKey%>',sampleGroup);

    }





    $( document ).ready(function() {
        mpgSoftware.manhattanPlot.fillSampleGroupDropdown('<%=phenotypeKey%>');
        console.log("about to fire");
    });

    var callFillClumpVariants = function() {
        //alert("hello world");
        mpgSoftware.manhattanPlot.fillClumpVariants('<%=phenotypeKey%>',document.getElementById("manhattanSampleGroupChooser").value);
    }



</script>


<div class="separator"></div>

<p>

    <g:message code="traitTable.messages.results" />
    <span id="traitTableDescription"></span>:
    <select id="manhattanSampleGroupChooser" name="manhattanSampleGroupChooser" onchange="mpgSoftware.pickNewDataSet(this)">
    </select>

</p>

<div id="manhattanPlot1"></div>


%{--//Ajax call works in this case--}%
%{--<input id="get clump" type="button" value="clickme" onclick="mpgSoftware.manhattanPlot.callFillClumpVariants();" />--}%

%{--//ajax call doesn't work in this case--}%
<input id="get clump" type="button" value="Get clump" onclick="mpgSoftware.manhattanplotTableHeader.callFillClumpVariants();" />


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