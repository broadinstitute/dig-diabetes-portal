

<div id="collapseTwo" class="accordion-body collapse">
    <div class="accordion-inner" id="ancestryInner">

<g:if test="${show_exseq}">



<script>
    var mpgSoftware = mpgSoftware || {};

    mpgSoftware.ancestryTable = (function () {
        var loadAncestryTable = function () {

            var tempKeyGen = function (dataset){
                var retVal = "";
                switch (dataset) {
                    case "ExChip_82k_mdv2": retVal = 'EUchip';  break;
                    case "ExSeq_17k_aa_genes_mdv2": retVal = 'AA';  break;
                    case "ExSeq_17k_ea_genes_mdv2": retVal = 'EA';  break;
                    case "ExSeq_17k_sa_genes_mdv2": retVal = 'SA';  break;
                    case "ExSeq_17k_hs_mdv2": retVal = 'HS';  break;
                    case "ExSeq_17k_eu_mdv2": retVal = 'EU';  break;
                    default: alert(' unrecognized data set = '+dataset+".")
                }
                return retVal;
            }
            var buildDataStructure = function (data) {
                var ethnicitySequence = {},
                        ethnicityChip = {};
                for (var i = 0; i < data.ethnicityInfo.results.length; i++) {
                        var currentDataSet = data.ethnicityInfo.results[i];
                        var key = tempKeyGen(currentDataSet["dataset"]);
                        var oneEthnicity = {};
                        for (var j = 0; j < data.ethnicityInfo.results[i].pVals.length; j++) {
                            switch (j) {
                                case 0:
                                    oneEthnicity ["ns"] = data.ethnicityInfo.results[i].pVals[j].count;
                                    break;
                                case 1:
                                    oneEthnicity ["total"] = data.ethnicityInfo.results[i].pVals[j].count;
                                    break;
                                case 2:
                                    oneEthnicity ["common"] = data.ethnicityInfo.results[i].pVals[j].count;
                                    break;
                                case 3:
                                    oneEthnicity ["lowFrequency"] = data.ethnicityInfo.results[i].pVals[j].count;
                                    break;
                                case 4:
                                    oneEthnicity ["sing"] = data.ethnicityInfo.results[i].pVals[j].count;
                                    oneEthnicity ["rare"] = data.ethnicityInfo.results[i].pVals[j].count;
                                    break;
                                default:
                                    break;
                            }
                        }
                        ethnicitySequence [key] = oneEthnicity;
//                        var currentDataSet = data.ethnicityInfo.results[i];
//                        var key = currentDataSet["dataset"];
//                        var oneEthnicity = {};
//                        for (var j = 0; j < data.ethnicityInfo.results[i].pVals.length; j++) {
//                            switch (j) {
//                                case 0:
//                                    oneEthnicity ["ns"] = data.ethnicityInfo.results[i].pVals[j].count;
//                                    break;
//                                case 1:
//                                    oneEthnicity ["total"] = data.ethnicityInfo.results[i].pVals[j].count;
//                                    break;
//                                case 2:
//                                    oneEthnicity ["common"] = data.ethnicityInfo.results[i].pVals[j].count;
//                                    break;
//                                case 3:
//                                    oneEthnicity ["lowFrequency"] = data.ethnicityInfo.results[i].pVals[j].count;
//                                    break;
//                                case 4:
//                                    oneEthnicity ["sing"] = data.ethnicityInfo.results[i].pVals[j].count;
//                                    oneEthnicity ["rare"] = data.ethnicityInfo.results[i].pVals[j].count;
//                                    break;
//                                default:
//                                    break;
//                            }
//                        }
                        //ethnicityChip["EU"] = oneEthnicity;
                  //  }


                }
                ;
                return {ethnicitySequence: ethnicitySequence,
                    ethnicityChip: ethnicityChip};
            };
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'gene',action: 'geneEthnicityCounts')}",
                data: {geneName: '<%=geneName%>'},
                async: true,
                success: function (data) {

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


                    if ((typeof data !== 'undefined') &&
                            (data)) {
                        if ((data.ethnicityInfo) &&
                                (data.ethnicityInfo.results)) {//assume we have data and process it
                            var holdingStructure = buildDataStructure(data);
                            mpgSoftware.geneInfo.fillVariationAcrossEthnicityTable('<g:createLink controller="variantSearch" action="gene" />',
                                    continentalAncestryText,
                                    holdingStructure.ethnicitySequence,
                                    holdingStructure.ethnicityChip,
                                    '<%=geneName%>');
                        }
                    }
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


    $("#collapseTwo").on("show.bs.collapse", function() {
        mpgSoftware.ancestryTable.loadAncestryTable();
    });

    $('#collapseHowCommonIsVariant').on('hide.bs.collapse', function (e) {
            $("#ancestryInner").html('');
    });


</script>


    <a name="populations"></a>

    <p>
        <g:message code="gene.continentalancestry.subtitle" default="click on a number to view variants"/>
    </p>

    <table id="continentalVariation" class="table table-striped  distinctivetable distinctive">
        <thead>
        <tr>
            <th><g:message code="gene.continentalancestry.title.colhdr.1" default="ancestry"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.2" default="data type"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.3" default="participants"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.4" default="total variants"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.5" default="common"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.6" default="low frequency"/></th>
            <th><g:message code="gene.continentalancestry.title.colhdr.7" default="rare"/></th>
        </tr>
        </thead>
        <tbody id="continentalVariationTableBody">
        </tbody>
        </table>

</g:if>

</div>
</div>
