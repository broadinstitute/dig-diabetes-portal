
%{--<g:set var="vAndARows" value="${new GspToJavascript(rowInformation as List)}" />--}%
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

<g:render template="variantsAndAssociationsTableChanger"/>

<button id="opener"  class="pull-right btn btn-default">Revise table properties</button>
<table id="variantsAndAssociationsTable" class="table table-striped distinctivetable distinctive">
    <thead id="variantsAndAssociationsHead">
    </thead>
    <tbody id="variantsAndAssociationsTableBody">
    </tbody>
</table>


<g:javascript>
$( document ).ready(function() {
  $(function() {
    $( "#dialog" ).dialog({
      autoOpen: false,
      show: {
        effect: "fade",
        duration: 500
      },
      hide: {
        effect: "fade",
        duration: 500
      },
      width: 560,
      modal: true,
      buttons: {
        Cancel: function() {
          $( this ).dialog( "close" );
        },
        "Rebuild table": function() {
          $('#vandasubmit').click();
          $( this ).dialog( "close" );
        }
      }
    });
  });

var popUpVAndAExtender = function() {
      $( "#dialog" ).dialog( "open" );
    };
$( "#opener" ).click(popUpVAndAExtender);
}
);
var insertVandARow  = function(name, value) {
      var counter = 100;
      $('#vandaRowHolder').add("<label><input type='checkbox' class='checkbox checkbox-primary' name='savedRow"+counter+"' class='form-control' id='savedRow"+counter+"' value='"+name+"^"+value+"^47' checked>"+name+"</label>");
      return false;
 };
//$( "#opener" ).click(popUpVAndAExtender());

var variantsAndAssociationTable = function (){
$.ajax({
    cache: false,
    type: "post",
    url: "${createLink(controller:'gene',action: 'genepValueCounts')}",
    data: {geneName: '<%=geneName%>',
           rowNames:<g:renderRowValues data='${rowInformation}'></g:renderRowValues>,
           colNames:<g:renderColValues data='${columnInformation}'></g:renderColValues>},
        async: true,
        success: function (data) {


                    var variantsAndAssociationsTableHeaders = {
                hdr1:'<g:message code="gene.variantassociations.table.colhdr.1" default="data type"/>',
                hdr2:'<g:message code="gene.variantassociations.table.colhdr.2" default="sample size"/>',
                hdr3:'<g:message code="gene.variantassociations.table.colhdr.3" default="total variants"/>',
                gwasSig:'<g:helpText title="gene.variantassociations.table.colhdr.4.help.header" placement="top"
                                     body="gene.variantassociations.table.colhdr.4.help.text" qplacer="2px 0 0 6px"/>'+
                        '<g:message code="gene.variantassociations.table.colhdr.4b" default="genome wide"/>',
                locusSig:'<g:helpText title="gene.variantassociations.table.colhdr.5.help.header" placement="top"
                                     body="gene.variantassociations.table.colhdr.5.help.text" qplacer="2px 0 0 6px"/>'+
                        '<g:message code="gene.variantassociations.table.colhdr.5b" default="locus wide"/>',
                nominalSig:'<g:helpText title="gene.variantassociations.table.colhdr.6.help.header" placement="top"
                                  body="gene.variantassociations.table.colhdr.6.help.text" qplacer="2px 0 0 6px"/>'+
                     '<g:message code="gene.variantassociations.table.colhdr.6b" default="nominal"/>'
            };
            var variantsAndAssociationsPhenotypeAssociations = {
                significantAssociations:'<g:message code="gene.variantassociations.significantAssociations"
                                                    default="variants were associated with" args="[geneName]"/>',
                noSignificantAssociationsExist:'<g:message code="gene.variantassociations.noSignificantAssociations"
                                                           default="no significant associations"/>'
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

            if ((typeof data !== 'undefined') &&
                (data)){
                    if ((data.geneInfo) &&
                        (data.geneInfo.results)){//assume we have data and process it
                          var collector = [];
                          for (var i = 0 ; i < data.geneInfo.results.length ; i++) {
                               var d = [];
                               for (var j = 0 ; j < data.geneInfo.results[i].pVals.length ; j++ ){
                                  d.push(data.geneInfo.results[i].pVals[j].count);
                               }
                               collector.push(d);
                            }

                            mpgSoftware.geneInfo.fillTheVariantAndAssociationsTableFromNewApi(data,
                                ${show_gwas},
                                ${show_exchp},
                                ${show_exseq},
                                '<g:createLink controller="region" action="regionInfo"/>',
                                '<g:createLink controller="trait" action="traitSearch"/>',
                                '<g:createLink controller="variantSearch" action="gene"/>',
                                {variantsAndAssociationsTableHeaders:variantsAndAssociationsTableHeaders,
                                 variantsAndAssociationsPhenotypeAssociations:variantsAndAssociationsPhenotypeAssociations,
                                 variantsAndAssociationsRowHelpText: variantsAndAssociationsRowHelpText},
                                '${geneChromosome}',${geneExtentBegin},${geneExtentEnd},
                                <g:renderRowMaps data='${rowInformation}'/>,
                                <g:renderColMaps data='${columnInformation}'/>,
                                collector,
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


variantsAndAssociationTable ();



</g:javascript>




<g:if test="${show_gwas}">
    <span id="gwasTraits"></span>
</g:if>

