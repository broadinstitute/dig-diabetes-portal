<g:if test="${show_exseq}">



    <g:javascript>
var fillEthnicityTable = function (){
        var buildDataStructure = function (data){
             var ethnicitySequence = {},
             ethnicityChip = {};
             for (var i = 0 ; i < data.ethnicityInfo.results.length ; i++) {
                if (i<5){
                    var currentDataSet = data.ethnicityInfo.results[i];
                    var  key =  currentDataSet["dataset"];
                    var oneEthnicity = {};
                    for (var j = 0 ; j < data.ethnicityInfo.results[i].pVals.length ; j++ ){
                           switch (j){
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
                            default: break;
                           }
                        }
                     currentDataSet [key] = oneEthnicity;
                } else {
                    var currentDataSet = data.ethnicityInfo.results[i];
                    var  key =  currentDataSet["dataset"];
                    var oneEthnicity = {};
                    for (var j = 0 ; j < data.ethnicityInfo.results[i].pVals.length ; j++ ){
                           switch (j){
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
                            default: break;
                           }
                        }
                      ethnicityChip["EU"] = oneEthnicity;
                }


        };
         return {ethnicitySequence:ethnicitySequence,
          ethnicityChip:ethnicityChip};
}
$.ajax({
    cache: false,
    type: "post",
    url: "${createLink(controller:'gene',action: 'geneEthnicityCounts')}",
    data: {geneName: '<%=geneName%>'},
        async: true,
        success: function (data) {


                    var variantsAndAssociationsTableHeaders = {
                hdr1:'<g:message code="gene.variantassociations.table.colhdr.1" default="data type" />',
                hdr2:'<g:message code="gene.variantassociations.table.colhdr.2" default="sample size" />',
                hdr3:'<g:message code="gene.variantassociations.table.colhdr.3" default="total variants" />',
                hdr4:'<g:message code="gene.variantassociations.table.colhdr.4a" default="genome wide" />'+
                        '<g:helpText title="gene.variantassociations.table.colhdr.4.help.header" placement="top" body="gene.variantassociations.table.colhdr.4.help.text" qplacer="2px 0 0 6px"/>'+
                        '<g:message code="gene.variantassociations.table.colhdr.4b" default="genome wide" />',
                hdr5:'<g:message code="gene.variantassociations.table.colhdr.5a" default="locus wide" />'+
                        '<g:helpText title="gene.variantassociations.table.colhdr.5.help.header" placement="top" body="gene.variantassociations.table.colhdr.5.help.text" qplacer="2px 0 0 6px"/>'+
                        '<g:message code="gene.variantassociations.table.colhdr.5b" default="locus wide" />',
                hdr6:'<g:message code="gene.variantassociations.table.colhdr.6a" default="nominal" />'+
                     '<g:helpText title="gene.variantassociations.table.colhdr.6.help.header" placement="top" body="gene.variantassociations.table.colhdr.6.help.text" qplacer="2px 0 0 6px"/>'+
                     '<g:message code="gene.variantassociations.table.colhdr.6b" default="nominal" />'
            };
            var variantsAndAssociationsPhenotypeAssociations = {
                significantAssociations:'<g:message code="gene.variantassociations.significantAssociations" default="variants were associated with"  args="[geneName]"/>',
                noSignificantAssociationsExist:'<g:message code="gene.variantassociations.noSignificantAssociations" default="no significant associations"/>'
            };
            var biologicalHypothesisTesting = {
                question1explanation:'<g:message code="gene.biologicalhypothesis.question1.explanation" default="explanation" args="[geneName]"/>',
                question1insufficient:'<g:message code="gene.biologicalhypothesis.question1.insufficientdata" default="insufficient data"/>',
                question1nominal:'<g:message code="gene.biologicalhypothesis.question1.nominaldifference" default="nominal difference"/>',
                question1significant:'<g:message code="gene.biologicalhypothesis.question1.significantdifference" default="significant difference"/>',
                question1significantQ:'<g:helpText title="gene.biologicalhypothesis.question1.significance.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.biologicalhypothesis.question1.significance.help.text"/>'
            };
            var variantsAndAssociationsRowHelpText ={
                 genomeWide:'<g:message code="gene.variantassociations.table.rowhdr.gwas" default="gwas"/>',
                 genomeWideQ:'<g:helpText title="gene.variantassociations.table.rowhdr.gwas.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.variantassociations.table.rowhdr.gwas.help.text"/>',
                 exomeChip:'<g:message code="gene.variantassociations.table.rowhdr.exomeChip" default="gwas"/>',
                 exomeChipQ:'<g:helpText title="gene.variantassociations.table.rowhdr.exomeChip.help.header"  qplacer="2px 0 0 6px" placement="right" body="gene.variantassociations.table.rowhdr.exomeChip.help.text"/>',
                 sigma:'<g:message code="gene.variantassociations.table.rowhdr.sigma" default="gwas"/>',
                 sigmaQ:'<g:helpText title="gene.variantassociations.table.rowhdr.sigma.help.header"  qplacer="2px 0 0 6px" placement="right" body="gene.variantassociations.table.rowhdr.sigma.help.text"/>',
                 exomeSequence:'<g:message code="gene.variantassociations.table.rowhdr.exomeSequence" default="gwas"/>',
                 exomeSequenceQ:'<g:helpText title="gene.variantassociations.table.rowhdr.exomeSequence.help.header" qplacer="2px 0 0 6px" placement="right"  body="gene.variantassociations.table.rowhdr.exomeSequence.help.text"/>'
            };
            continentalAncestryText = {
                continentalAA:'<g:message code="gene.continentalancestry.title.rowhdr.AA" default="gwas"/>',
                continentalAAQ:'<g:helpText title="gene.continentalancestry.title.rowhdr.AA.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.AA.help.text"/>',
                continentalAAdatatype:'<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>'+
                        '<g:helpText title="gene.continentalancestry.datatype.exomeSequence.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.datatype.exomeSequence.help.text"/>',
                continentalEA:'<g:message code="gene.continentalancestry.title.rowhdr.EA" default="gwas"/>',
                continentalEAQ:'<g:helpText title="gene.continentalancestry.title.rowhdr.EA.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.EA.help.text"/>',
                continentalEAdatatype:'<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>',
                continentalSA:'<g:message code="gene.continentalancestry.title.rowhdr.SA" default="gwas"/>',
                continentalSAQ:'<g:helpText title="gene.continentalancestry.title.rowhdr.SA.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.SA.help.text"/>',
                continentalSAdatatype:'<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>',
                continentalEU:'<g:message code="gene.continentalancestry.title.rowhdr.EU" default="gwas"/>',
                continentalEUQ:'<g:helpText title="gene.continentalancestry.title.rowhdr.EU.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.EU.help.text"/>',
                continentalEUdatatype:'<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>',
                continentalHS:'<g:message code="gene.continentalancestry.title.rowhdr.HS" default="gwas"/>',
                continentalHSQ:'<g:helpText title="gene.continentalancestry.title.rowhdr.HS.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.HS.help.text"/>',
                continentalHSdatatype:'<g:message code="gene.continentalancestry.datatype.exomeSequence" default="exome sequence"/>',
                continentalEUchip:'<g:message code="gene.continentalancestry.title.rowhdr.chipEU" default="gwas"/>',
                continentalEUchipQ:'<g:helpText title="gene.continentalancestry.title.rowhdr.chipEU.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.title.rowhdr.chipEU.help.text"/>',
                continentalEUchipDatatype:'<g:message code="gene.continentalancestry.datatype.exomeChip" default="exome chip"/>'+
                        '<g:helpText title="gene.continentalancestry.datatype.exomeChip.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.continentalancestry.datatype.exomeChip.help.text"/>'

            };


            if ((typeof data !== 'undefined') &&
                (data)){
                    if ((data.geneInfo) &&
                        (data.geneInfo.results)){//assume we have data and process it

                            mpgSoftware.geneInfo.fillTheVariantAndAssociationsTableFromNewApi(data,
        ${show_gwas},
        ${show_exchp},
        ${show_exseq},
        ${show_sigma},
                                '<g:createLink controller="region" action="regionInfo" />',
                                '<g:createLink controller="trait" action="traitSearch" />',
                                '<g:createLink controller="variantSearch" action="gene" />',
                                {variantsAndAssociationsTableHeaders:variantsAndAssociationsTableHeaders,
                                 variantsAndAssociationsPhenotypeAssociations:variantsAndAssociationsPhenotypeAssociations,
                                 biologicalHypothesisTesting:biologicalHypothesisTesting,
                                 variantsAndAssociationsRowHelpText: variantsAndAssociationsRowHelpText,
                                 continentalAncestryText: continentalAncestryText},
                                '9',1,100,
                                collector["d0"][0].count,collector["d0"][1].count,collector["d0"][2].count,collector["d0"][3].count,
                                collector["d0"][0].count,collector["d0"][1].count,collector["d0"][2].count,collector["d0"][3].count,
                                collector["d0"][0].count,collector["d0"][1].count,collector["d0"][2].count,collector["d0"][3].count,
                                collector["d0"][0].count,collector["d0"][1].count,collector["d0"][2].count,collector["d0"][3].count,
                                '<%=geneName%>'
            );


                        }
                }
        },
        error: function (jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception);
        }
    });

};
//fillEthnicityTable ();
    </g:javascript>


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