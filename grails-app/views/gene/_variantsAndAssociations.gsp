<a name="associations"></a>

%{--<h2><strong>Variants and associations</strong></h2>--}%

<h3>
    %{--Explore variants within 100kb of <em>${geneName}</em>--}%
    <g:message code="gene.variantassociations.mainDirective" default="Explore" args="[geneName]"/>
</h3>
<p></p>
<p>
    %{--Click on a number below to generate a table of variants associated with type 2 diabetes in the following categories:--}%
    <g:message code="gene.variantassociations.subDirective" default="Click on a number below to generate a table of variants associated with type 2 diabetes in the following categories:"/></p>
<br/>


<table id="variantsAndAssociationsTable" class="table table-striped distinctivetable distinctive">
    <thead id="variantsAndAssociationsHead">
    </thead>
    <tbody id="variantsAndAssociationsTableBody">
    </tbody>
</table>


<g:javascript>
var variantsAndAssociationTable = function (){
$.ajax({
    cache: false,
    type: "post",
    url: "${createLink(controller:'gene',action: 'genepValueCounts')}",
    data: {geneName: '<%=geneName%>'},
        async: true,
        success: function (data) {


                    var variantsAndAssociationsTableHeaders = {
                hdr1:'<g:message code="gene.variantassociations.table.colhdr.1" default="data type"/>',
                hdr2:'<g:message code="gene.variantassociations.table.colhdr.2" default="sample size"/>',
                hdr3:'<g:message code="gene.variantassociations.table.colhdr.3" default="total variants"/>',
                hdr4:'<g:message code="gene.variantassociations.table.colhdr.4a" default="genome wide"/>'+
                        '<g:helpText title="gene.variantassociations.table.colhdr.4.help.header" placement="top"
                                     body="gene.variantassociations.table.colhdr.4.help.text" qplacer="2px 0 0 6px"/>'+
                        '<g:message code="gene.variantassociations.table.colhdr.4b" default="genome wide"/>',
                hdr5:'<g:message code="gene.variantassociations.table.colhdr.5a" default="locus wide"/>'+
                        '<g:helpText title="gene.variantassociations.table.colhdr.5.help.header" placement="top"
                                     body="gene.variantassociations.table.colhdr.5.help.text" qplacer="2px 0 0 6px"/>'+
                        '<g:message code="gene.variantassociations.table.colhdr.5b" default="locus wide"/>',
                hdr6:'<g:message code="gene.variantassociations.table.colhdr.6a" default="nominal"/>'+
                     '<g:helpText title="gene.variantassociations.table.colhdr.6.help.header" placement="top"
                                  body="gene.variantassociations.table.colhdr.6.help.text" qplacer="2px 0 0 6px"/>'+
                     '<g:message code="gene.variantassociations.table.colhdr.6b" default="nominal"/>'
            };
            var variantsAndAssociationsPhenotypeAssociations = {
                significantAssociations:'<g:message code="gene.variantassociations.significantAssociations"
                                                    default="variants were associated with" args="[geneName]"/>',
                noSignificantAssociationsExist:'<g:message code="gene.variantassociations.noSignificantAssociations"
                                                           default="no significant associations"/>'
            };
            var biologicalHypothesisTesting = {
                question1explanation:'<g:message code="gene.biologicalhypothesis.question1.explanation"
                                                 default="explanation" args="[geneName]"/>',
                question1insufficient:'<g:message code="gene.biologicalhypothesis.question1.insufficientdata"
                                                  default="insufficient data"/>',
                question1nominal:'<g:message code="gene.biologicalhypothesis.question1.nominaldifference"
                                             default="nominal difference"/>',
                question1significant:'<g:message code="gene.biologicalhypothesis.question1.significantdifference"
                                                 default="significant difference"/>',
                question1significantQ:'<g:helpText title="gene.biologicalhypothesis.question1.significance.help.header"
                                                   qplacer="2px 0 0 6px" placement="right"
                                                   body="gene.biologicalhypothesis.question1.significance.help.text"/>'
            };
            var variantsAndAssociationsRowHelpText ={
                 genomeWide:'<g:message code="gene.variantassociations.table.rowhdr.gwas" default="gwas"/>',
                 genomeWideQ:'<g:helpText title="gene.variantassociations.table.rowhdr.gwas.help.header"
                                          qplacer="2px 0 0 6px" placement="right"
                                          body="gene.variantassociations.table.rowhdr.gwas.help.text"/>',
                 exomeChip:'<g:message code="gene.variantassociations.table.rowhdr.exomeChip" default="gwas"/>',
                 exomeChipQ:'<g:helpText title="gene.variantassociations.table.rowhdr.exomeChip.help.header"
                                         qplacer="2px 0 0 6px" placement="right"
                                         body="gene.variantassociations.table.rowhdr.exomeChip.help.text"/>',
                 sigma:'<g:message code="gene.variantassociations.table.rowhdr.sigma" default="gwas"/>',
                 sigmaQ:'<g:helpText title="gene.variantassociations.table.rowhdr.sigma.help.header"
                                     qplacer="2px 0 0 6px" placement="right"
                                     body="gene.variantassociations.table.rowhdr.sigma.help.text"/>',
                 exomeSequence:'<g:message code="gene.variantassociations.table.rowhdr.exomeSequence" default="gwas"/>',
                 exomeSequenceQ:'<g:helpText title="gene.variantassociations.table.rowhdr.exomeSequence.help.header"
                                             qplacer="2px 0 0 6px" placement="right"
                                             body="gene.variantassociations.table.rowhdr.exomeSequence.help.text"/>'
            };
            continentalAncestryText = {
                continentalAA:'<g:message code="gene.continentalancestry.title.rowhdr.AA" default="gwas"/>',
                continentalAAQ:'<g:helpText title="gene.continentalancestry.title.rowhdr.AA.help.header"
                                            qplacer="2px 0 0 6px" placement="right"
                                            body="gene.continentalancestry.title.rowhdr.AA.help.text"/>',
                continentalAAdatatype:'<g:message code="gene.continentalancestry.datatype.exomeSequence"
                                                  default="exome sequence"/>'+
                        '<g:helpText title="gene.continentalancestry.datatype.exomeSequence.help.header"
                                     qplacer="2px 0 0 6px" placement="right"
                                     body="gene.continentalancestry.datatype.exomeSequence.help.text"/>',
                continentalEA:'<g:message code="gene.continentalancestry.title.rowhdr.EA" default="gwas"/>',
                continentalEAQ:'<g:helpText title="gene.continentalancestry.title.rowhdr.EA.help.header"
                                            qplacer="2px 0 0 6px" placement="right"
                                            body="gene.continentalancestry.title.rowhdr.EA.help.text"/>',
                continentalEAdatatype:'<g:message code="gene.continentalancestry.datatype.exomeSequence"
                                                  default="exome sequence"/>',
                continentalSA:'<g:message code="gene.continentalancestry.title.rowhdr.SA" default="gwas"/>',
                continentalSAQ:'<g:helpText title="gene.continentalancestry.title.rowhdr.SA.help.header"
                                            qplacer="2px 0 0 6px" placement="right"
                                            body="gene.continentalancestry.title.rowhdr.SA.help.text"/>',
                continentalSAdatatype:'<g:message code="gene.continentalancestry.datatype.exomeSequence"
                                                  default="exome sequence"/>',
                continentalEU:'<g:message code="gene.continentalancestry.title.rowhdr.EU" default="gwas"/>',
                continentalEUQ:'<g:helpText title="gene.continentalancestry.title.rowhdr.EU.help.header"
                                            qplacer="2px 0 0 6px" placement="right"
                                            body="gene.continentalancestry.title.rowhdr.EU.help.text"/>',
                continentalEUdatatype:'<g:message code="gene.continentalancestry.datatype.exomeSequence"
                                                  default="exome sequence"/>',
                continentalHS:'<g:message code="gene.continentalancestry.title.rowhdr.HS" default="gwas"/>',
                continentalHSQ:'<g:helpText title="gene.continentalancestry.title.rowhdr.HS.help.header"
                                            qplacer="2px 0 0 6px" placement="right"
                                            body="gene.continentalancestry.title.rowhdr.HS.help.text"/>',
                continentalHSdatatype:'<g:message code="gene.continentalancestry.datatype.exomeSequence"
                                                  default="exome sequence"/>',
                continentalEUchip:'<g:message code="gene.continentalancestry.title.rowhdr.chipEU" default="gwas"/>',
                continentalEUchipQ:'<g:helpText title="gene.continentalancestry.title.rowhdr.chipEU.help.header"
                                                qplacer="2px 0 0 6px" placement="right"
                                                body="gene.continentalancestry.title.rowhdr.chipEU.help.text"/>',
                continentalEUchipDatatype:'<g:message code="gene.continentalancestry.datatype.exomeChip"
                                                      default="exome chip"/>'+
                        '<g:helpText title="gene.continentalancestry.datatype.exomeChip.help.header"
                                     qplacer="2px 0 0 6px" placement="right"
                                     body="gene.continentalancestry.datatype.exomeChip.help.text"/>'

            };


            if ((typeof data !== 'undefined') &&
                (data)){
                    if ((data.geneInfo) &&
                        (data.geneInfo.results)){//assume we have data and process it
                          var collector = {}
                          for (var i = 0 ; i < data.geneInfo.results.length ; i++) {
                               var d = [];
                               for (var j = 0 ; j < data.geneInfo.results[i].pVals.length ; j++ ){
                                  var contents={};
                                  contents["level"] = data.geneInfo.results[i].pVals[j].level;
                                  contents["count"] = data.geneInfo.results[i].pVals[j].count;
                                  d.push(contents);
                               }
                               collector["d"+i] = d;
                            }

                            mpgSoftware.geneInfo.fillTheVariantAndAssociationsTableFromNewApi(data,
                                ${show_gwas},
                                ${show_exchp},
                                ${show_exseq},
                                ${show_sigma},
                                '<g:createLink controller="region" action="regionInfo"/>',
                                '<g:createLink controller="trait" action="traitSearch"/>',
                                '<g:createLink controller="variantSearch" action="gene"/>',
                                {variantsAndAssociationsTableHeaders:variantsAndAssociationsTableHeaders,
                                 variantsAndAssociationsPhenotypeAssociations:variantsAndAssociationsPhenotypeAssociations,
                                 biologicalHypothesisTesting:biologicalHypothesisTesting,
                                 variantsAndAssociationsRowHelpText: variantsAndAssociationsRowHelpText,
                                 continentalAncestryText: continentalAncestryText},
                                '${geneChromosome}',${geneExtentBegin},${geneExtentEnd},
                                collector["d0"][0].count,collector["d0"][1].count,collector["d0"][2].count,collector["d0"][3].count,
                                collector["d1"][0].count,collector["d1"][1].count,collector["d1"][2].count,collector["d1"][3].count,
                                collector["d2"][0].count,collector["d2"][1].count,collector["d2"][2].count,collector["d2"][3].count,
                                collector["d0"][0].count,collector["d0"][1].count,collector["d0"][2].count,collector["d0"][3].count,
                                '<%=geneName%>'
                            );

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
if (${newApi}){
variantsAndAssociationTable ();
}
</g:javascript>




<g:if test="${show_gwas}">
    <span id="gwasTraits"></span>
</g:if>

