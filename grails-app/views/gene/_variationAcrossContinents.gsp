

<div id="collapseTwo" class="accordion-body collapse">
    <div class="accordion-inner" id="ancestryInner">

<g:if test="${show_exseq}">



<script>
    var mpgSoftware = mpgSoftware || {};

    mpgSoftware.ancestryTable = (function () {
        var loadAncestryTable = function (chosenGene,dataSetMap) {

            var buildRowDataStructure = function (data) {
                var returnValues = [];
                for (var i = 0; i < data.ethnicityInfo.results.length; i++) {
                        var currentDataSet = data.ethnicityInfo.results[i];
                        var singleRow = {};
                        singleRow["dataset"] = currentDataSet["dataset"];
                        singleRow["technology"] = currentDataSet["technology"];
                        var rowValues = [];
                        for (var j = 0; j < currentDataSet.pVals.length; j++) {
                            rowValues.push( currentDataSet.pVals[j].count );
                        }
                        singleRow["values"] = rowValues;
                        returnValues.push(singleRow);
                }
                ;
                return returnValues;
            };
            var buildColumnDataStructure = function (data) {
                var returnValues = [];
                for (var i = 0; i < data.ethnicityInfo.columns.length; i++) {
                    var currentDataSet = data.ethnicityInfo.columns[i];
                    returnValues.push({"key":i,"lowerValue":currentDataSet["lowerValue"],"higherValue":currentDataSet["higherValue"],
                                       "code":"lowerValue~"+currentDataSet["lowerValue"]+"~higherValue~"+currentDataSet["higherValue"]});
                 }
                ;
                return returnValues;
            };
            var rowNames = [];
            if (typeof dataSetMap !== 'undefined'){
                for ( var i = 0 ; i < dataSetMap.length ; i++ ){
                    rowNames.push(dataSetMap[i].name);
                }
            }
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'gene',action: 'geneEthnicityCounts')}",
                data: {geneName: chosenGene,
                       rowMap:dataSetMap,
                       rowNames:rowNames},
                async: true,
                success: function (data) {
                    if ($.fn.DataTable.isDataTable( '#continentalVariation' )){
                        $('#continentalVariation').dataTable({"bRetrieve":true}).fnDestroy();
                    }

                    var continentalAncestryText = {
                        continentalAA: '<g:message code="gene.continentalancestry.title.rowhdr.AA" default="gwas"/>',
                        continentalAAQ: '<g:helpText title="gene.continentalancestry.title.rowhdr.AA.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.AA.help.text"/>',
                        continentalAAdatatype: '<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>',
                        continentalEA: '<g:message code="gene.continentalancestry.title.rowhdr.EA" default="gwas"/>',
                        continentalEAQ: '<g:helpText title="gene.continentalancestry.title.rowhdr.EA.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.EA.help.text"/>',
                        continentalEAdatatype: '<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>',
                        continentalSA: '<g:message code="gene.continentalancestry.title.rowhdr.SA" default="gwas"/>',
                        continentalSAQ: '<g:helpText title="gene.continentalancestry.title.rowhdr.SA.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.SA.help.text"/>',
                        continentalSAdatatype: '<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>',
                        continentalEU: '<g:message code="gene.continentalancestry.title.rowhdr.EU" default="gwas"/>',
                        continentalEUQ: '<g:helpText title="gene.continentalancestry.title.rowhdr.EU.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.EU.help.text"/>',
                        continentalEUdatatype: '<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>',
                        continentalHS: '<g:message code="gene.continentalancestry.title.rowhdr.HS" default="gwas"/>',
                        continentalHSQ: '<g:helpText title="gene.continentalancestry.title.rowhdr.HS.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.HS.help.text"/>',
                        continentalHSdatatype: '<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>',
                        continentalEUchip: '<g:message code="gene.continentalancestry.title.rowhdr.chipEU" default="gwas"/>',
                        continentalEUchipQ: '<g:helpText title="gene.continentalancestry.title.rowhdr.chipEU.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.chipEU.help.text"/>',
                        continentalEUchipDatatype: '<g:message code="gene.continentalancestry.datatype.exomeChip" default="exome chip"/>'

                    };

                    var rowDataStructure = [];
                    if ((typeof data !== 'undefined') &&
                            (data)) {
                        if ((data.ethnicityInfo) &&
                                (data.ethnicityInfo.results)) {//assume we have data and process it
                            rowDataStructure = buildRowDataStructure(data);
                            mpgSoftware.geneInfo.fillVariationAcrossEthnicityTable('<g:createLink controller="variantSearch" action="gene" />',
                                    continentalAncestryText,
                                    rowDataStructure,
                                    buildColumnDataStructure(data),
                                    "MAFTable",
                                    chosenGene);
                        }
                    }
                    if (typeof rowDataStructure !== 'undefined') {
                        for ( var i = 0 ; i < rowDataStructure.length ; i++ ){
                            jsTreeDataRetriever ('#mafTableRow'+i,"",rowDataStructure[i].dataset);
                        }
                    }
                    var continentalTable = $('#continentalVariation').dataTable({
                        bDestroy: true,
                        bPaginate:false,
                        bInfo : false,
                        bFilter: false,
                        aaSorting: [[ 2, "desc" ]],
                        aoColumnDefs: [{sType: "allAnchor", aTargets: [3,4,5,6] },
                            {"bSortable": false , aTargets: [0] }]
                    });
                    $('[data-toggle="popover"]').popover();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });

        };
        return {loadAncestryTable: loadAncestryTable}
    }());


    // this is a two-part call: first we use the phenotype to get the relevant technologies, and
    //  then we can launch the table refresh
    var retrieveSampleGroupsbyTechAndPhenotype = function(technologies,phenotype){
        var phenotypeName = phenotype;
        $.ajax({
            cache: false,
            type: "post",
            url: "${createLink(controller: 'VariantSearch', action: 'retrieveTopSGsByTechnologyAndPhenotypeAjax')}",
            data: {phenotype:phenotype,
                technologies: technologies},
            async: true,
            success: function (data) {
                if (( data !==  null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.sampleGroupMap !== 'undefined' )  ) {
                    var sampleGroupMap = data.sampleGroupMap;
                    if (typeof sampleGroupMap !== 'undefined'){
                        var dataSetNames =  Object.keys(sampleGroupMap);
                        var dataSetPropertyValues = [];
                        for (var i = 0; i < dataSetNames.length; i++) {
                            if (sampleGroupMap[dataSetNames[i]]) {
                                dataSetPropertyValues.push(sampleGroupMap[dataSetNames[i]]);
                            }
                        }
                        //variantsAndAssociationTable (phenotypeName,dataSetNames,dataSetPropertyValues);
                    }
                }
            },
            error: function (jqXHR, exception) {
                core.errorReporter(jqXHR, exception);
            }
        });
    };

    $("#collapseTwo").on("show.bs.collapse", function() {
        mpgSoftware.ancestryTable.loadAncestryTable('<%=geneName%>');
    });

    $('#collapseHowCommonIsVariant').on('hide.bs.collapse', function (e) {
            $("#ancestryInner").html('');
    });

    function reviseVACRows(){
//        var phenotype = $('#phenotypeTableChooser option:selected').val();
        var clickedBoxes =  $('#continentalVariationTableBody .jstree-clicked');
        var dataSetNames  = [];
        var dataSetMaps  = [];
        for  ( var i = 0 ; i < clickedBoxes.length ; i++ )   {
            var  comboName  =  $(clickedBoxes[i]).attr('id');
            var partsOfCombo =   comboName.split("-");
            var  dataSetWithoutAnchor  =  partsOfCombo[0];
            dataSetNames.push(dataSetWithoutAnchor);
            var  dataSetMap = {"name":dataSetWithoutAnchor,
                "value":dataSetWithoutAnchor,
                "pvalue":partsOfCombo[1],
                "count":partsOfCombo[2].substring(0, partsOfCombo[2].length-7)};
            dataSetMaps.push(dataSetMap);
        }
        //variantsAndAssociationTable (phenotype,dataSetNames,dataSetMaps);

        mpgSoftware.ancestryTable.loadAncestryTable('<%=geneName%>',dataSetMaps);
    }

</script>

    <table id="continentalVariation" class="table table-striped  distinctivetable distinctive" style="border-bottom: 0">
        <thead>
        <tr>
            <th><g:message code="gene.continentalancestry.title.colhdr.1" default="ancestry"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.2" default="data type"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.3" default="sample size"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.4" default="total variants"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.5" default="common"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.6" default="low frequency"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.7" default="rare"/></th>
        </tr>
        </thead>
        <tbody id="continentalVariationTableBody">
        </tbody>
        </table>
    <div class="row clearfix">

        <div class="col-md-2">
            <button id="reviser"  class="btn btn-primary pull-left" onclick="reviseVACRows()">
                <g:message code="gene.variantassociations.change.rows" default="Revise rows"/>
            </button>
        </div>

        <div class="col-md-8">

        </div>
        <div class="col-md-2">

        </div>
    </div>

</g:if>

</div>
</div>
