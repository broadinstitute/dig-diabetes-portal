
<style>
    h1,h2,h3,h4,label{
        font-weight: 300;
    }
</style>


<script>
    var variant;
    var fillVariantStatistics = function (){
        $.ajax({
            cache: false,
            type: "get",
            url: "${createLink(controller:'variant',action: 'variantDescriptiveStatistics')}",
            data: {variantId: '<%=variantToSearch%>'},
            async: true,
            success: function (data) {
                var variantAssociationStrings = {
                    genomeSignificance:'<g:message code="variant.variantAssociations.significance.genomeSignificance" default="GWAS significance" />',
                    locusSignificance:'<g:message code="variant.variantAssociations.significance.locusSignificance" default="locus wide significance" />',
                    nominalSignificance:'<g:message code="variant.variantAssociations.significance.nominalSignificance" default="nominal significance" />',
                    nonSignificance:'<g:message code="variant.variantAssociations.significance.nonSignificance" default="no significance" />',
                    variantPValues:'<g:message code="variant.variantAssociations.variantPValues" default="click here to see a table of P values" />',
                    sourceDiagram:'<g:message code="variant.variantAssociations.source.diagram" default="diagram GWAS" />',
                    sourceDiagramQ:'<g:helpText title="variant.variantAssociations.source.diagramQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.diagramQ.help.text"/>',
                    sourceExomeChip:'<g:message code="variant.variantAssociations.source.exomeChip" default="Exome chip" />',
                    sourceExomeChipQ:'<g:helpText title="variant.variantAssociations.source.exomeChipQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.exomeChipQ.help.text"/>',
                    sourceExomeSequence:'<g:message code="variant.variantAssociations.source.exomeSequence" default="Exome sequence" />',
                    sourceExomeSequenceQ:'<g:helpText title="variant.variantAssociations.source.exomeSequenceQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.exomeSequenceQ.help.text"/>',
                    sourceSigma:'<g:message code="variant.variantAssociations.source.sigma" default="Sigma" />',
                    sourceSigmaQ:'<g:helpText title="variant.variantAssociations.source.sigmaQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.sigmaQ.help.text"/>',
                    associationPValueQ:'<g:helpText title="variant.variantAssociations.pValue.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.pValue.help.text"/>',
                    associationOddsRatioQ:'<g:helpText title="variant.variantAssociations.oddsRatio.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.oddsRatio.help.text"/>'
                };
                var collector = {}
                for (var i = 0 ; i < data.variantInfo.results.length ; i++) {
                    var d = [];
                    for (var j = 0 ; j < data.variantInfo.results[i].pVals.length ; j++ ){
                        var contents={};
                        contents["level"] = data.variantInfo.results[i].pVals[j].level;
                        contents["count"] = data.variantInfo.results[i].pVals[j].count;
                        d.push(contents);
                    }
                    collector["d"+i] = d;
                }
                var inGene = collector["d0"][2].count;
                var closestGene = collector["d0"][3].count;
                var mostdelscore= UTILS.convertStringToNumber(collector["d0"][4].count[0]);
                var varId = collector["d0"][0].count;
                var dbsnpId = collector["d0"][1].count;
                mpgSoftware.variantInfo.setTitlesAndTheLikeFromData(varId,dbsnpId,mostdelscore,inGene,closestGene,  '<%=variantToSearch%>');
                var variantAssociationStatistics = mpgSoftware.variantInfo.variantAssociations;
                variantAssociationStatistics({"IN_GWAS":true,
                        "DBSNP_ID":dbsnpId,
                        "ID":varId,
                        "GWAS_T2D_PVALUE":UTILS.convertStringToNumber(collector["d0"][6].count[0]),
                        "GWAS_T2D_OR":UTILS.convertStringToNumber(collector["d0"][9].count[0]),
                        "EXCHP_T2D_P_value":UTILS.convertStringToNumber(collector["d0"][7].count[0]),
                        "EXCHP_T2D_BETA":UTILS.convertStringToNumber(collector["d0"][10].count[0]),
                        "_13k_T2D_P_EMMAX_FE_IV":UTILS.convertStringToNumber(collector["d0"][5].count[0]),
                        "_13k_T2D_OR_WALD_DOS_FE_IV":UTILS.convertStringToNumber(collector["d0"][8].count[0]),
                        "SIGMA_T2D_P":UTILS.convertStringToNumber(collector["d0"][5].count[0]),
                        "SIGMA_T2D_OR":UTILS.convertStringToNumber(collector["d0"][5].count[0])},
                        ${show_sigma},
                        "<%=variantToSearch%>",
                        "<g:createLink controller='trait' action='traitInfo' />",
                        variantAssociationStrings);

                // KDUXTD-52: set the header text based on the new API call p-values
                var pValueAndKey = UTILS.get_lowest_p_value_from_map({"GWAS": collector["d0"][6].count[0], "exome chip": collector["d0"][7].count[0], "exome sequence": collector["d0"][8].count[0]});
                   $('#variantPValue').append((parseFloat(pValueAndKey[0])).toPrecision(4));
                   $('#variantInfoGeneratingDataSet').append(pValueAndKey[1]);

                // KDUXTD-47: adding call to enable popovers
                $('[data-toggle="popover"]').popover();

            },
           error: function (jqXHR, exception) {
                loading.hide();
                core.errorReporter(jqXHR, exception);
            }
        });

    };
    if (${newApi}){
        fillVariantStatistics();
    }

</script>



<br/>
<div id="VariantsAndAssociationsExist" style="display: block">
    <div class="row clearfix">

        <g:renderSigmaSection>
            <div class="col-md-1">
            </div>
            <div class="col-md-4">
                 <div id="gwasSigmaAssociationStatisticsBox"></div>
            </div>
            <div class="col-md-2"></div>
            <div class="col-md-4">
                <div id="sigmaAssociationStatisticsBox"></div>
            </div>
            <div class="col-md-1"></div>
        </g:renderSigmaSection>
        <g:renderT2dGenesSection>
            <div class="col-md-3">
                <div id="gwasAssociationStatisticsBox"></div>
            </div>
            <div class="col-md-1"></div>
            <div class="col-md-3">
                <div id="exomeChipAssociationStatisticsBox"></div>
            </div>
            <div class="col-md-1"></div>
            <div class="col-md-3">
                <div id="exomeSequenceAssociationStatisticsBox"></div>
            </div>
        </g:renderT2dGenesSection>

    </div>
</div>

<div id="VariantsAndAssociationsNoExist"  style="display: none">
    <h4><g:message code="variant.insufficientdata" default="Insufficient data to draw conclusion"/></h4>
</div>

<br/>

<p>
    <span id="variantInfoAssociationStatisticsLinkToTraitTable"></span>

</p>


