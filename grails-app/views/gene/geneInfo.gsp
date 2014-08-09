<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>
<script>
    var variant;
    var geneInfoRec = {
        ID: 1,
        CHROM: 2,
        BEG: 3,
        END: 4,
        Function_description: 5,
        _13k_T2D_VAR_TOTAL: 6,
        _13k_T2D_ORIGIN_VAR_TOTALS: 7,
        HS: 8,
        AA: 9,
        EU:10,
        EA:11,
        SA: 12,
        SING: 13,
        RARE: 14,
        LOW_FREQUENCY: 15,
        COMMON: 16,
        TOTAL: 17,
        NS: 18,
        _13k_T2D_lof_NVAR: 19,
        _13k_T2D_lof_MINA_MINU_RET: 20,
        _13k_T2D_lof_METABURDEN: 21,
        _13k_T2D_GWS_TOTAL: 22,
        _13k_T2D_NOM_TOTAL: 23,
        EXCHP_T2D_VAR_TOTALS: 24,
        EXCHP_T2D_GWS_TOTAL: 25,
        EXCHP_T2D_NOM_TOTAL: 26,
        GWS_TRAITS: 27,
        GWAS_T2D_GWS_TOTAL: 28,
        GWAS_T2D_NOM_TOTAL: 29,
        GWAS_T2D_VAR_TOTAL: 30
    };
    function revG(d){
        var v;
        switch(d) {
            case 1:v="ID"; break;
            case 2:v="CHROM";break;
            case 3:v="BEG";break;
            case 4:v="END";break;
            case 5:v="Function_description";break;
            case 6:v="And_13k_T2D_VAR_TOTAL";break;
            case 7:v="_13k_T2D_ORIGIN_VAR_TOTALS";break;
            case 8:v="HS";break;
            case 9:v="AA";break;
            case 10:v="EU";break;
            case 11:v="EA";break;
            case  12:v="SA";break;
            case  13:v="SING";break;
            case  14:v="RARE";break;
            case  15:v="LOW_FREQUENCY";break;
            case  16:v="COMMON";break;
            case  17:v="TOTAL";break;
            case  18:v="NS";break;
            case  19:v="_13k_T2D_lof_NVAR";break;
            case  20:v="_13k_T2D_lof_MINA_MINU_RET";break;
            case  21:v="_13k_T2D_lof_METABURDEN";break;
            case  22:v="_13k_T2D_GWS_TOTAL";break;
            case  23:v="_13k_T2D_NOM_TOTAL";break;
            case  24:v="EXCHP_T2D_VAR_TOTALS";break;
            case  25:v="EXCHP_T2D_GWS_TOTAL";break;
            case  26:v="EXCHP_T2D_NOM_TOTAL";break;
            case  27:v="GWS_TRAITS";break;
            case  28:v="GWAS_T2D_GWS_TOTAL";break;
            case  29:v="GWAS_T2D_NOM_TOTAL";break;
            case  30:v="GWAS_T2D_VAR_TOTAL";break;
            default: v="";
        }
        return v;
    }
    $.ajax({
        cache:false,
        type:"post",
        url:"../geneInfoAjax",
        data:{geneName:'<%=geneName%>'},
        async:true,
        success: function (data) {
            fillTheGeneFields(data) ;
            console.log('Finish processing fillTheGeneFields ')
        }
    });
    function geneFieldOrZero(geneInfo,filedNumber) {
        var retval = 0;
        var fieldName  = revG(filedNumber);
        if ((geneInfo)  &&
            (geneInfo[fieldName])){
            retval =  geneInfo[fieldName];
        }
        return retval;
    }
    function variantsAndAssociationsTitleLine (geneInfo,totalNumberField,description,chromosomeField,beginPositionField,endPositionField,textSpanId,anchorId){
        var currentLine = "There are ";
        var totalNumber =  geneFieldOrZero(geneInfo,totalNumberField);
        if (totalNumber > 0){
            currentLine += '<strong>';
        }
        currentLine += totalNumber+" total variants ";
        if (totalNumber > 0){
            currentLine += '</strong>';
        }
        currentLine += totalNumber+" "+description+" | ";
        $(textSpanId).append (currentLine);
        $(anchorId)[0].href= "/dport/region/regionInfo/chr"+geneFieldOrZero(geneInfo,chromosomeField)+":"+geneFieldOrZero(geneInfo,beginPositionField)+"-"+geneFieldOrZero(geneInfo,endPositionField) ;
    }
    function variantsAndAssociationsContentsLine (geneInfo,totalNumberField,description,chromosomeField,beginPositionField,endPositionField,textSpanId,anchorId){
        var currentLine = "";
        var totalNumber =  geneFieldOrZero(geneInfo,totalNumberField);
        if ((totalNumber > 0)  && (description ==='genome-wide')){
            currentLine += '<strong>';
        }
        currentLine += (totalNumber+"  are associated with type 2 diabetes at or above "+description+" significance ");
        if ((totalNumber > 0)  && (description ==='genome-wide')){
            currentLine += '</strong>';
        }
        currentLine += " | ";
        $(textSpanId).append (currentLine);
        $(anchorId)[0].href= "/dport/region/regionInfo/chr"+geneFieldOrZero(geneInfo,chromosomeField)+":"+geneFieldOrZero(geneInfo,beginPositionField)+"-"+geneFieldOrZero(geneInfo,endPositionField) ;
    }
    function fillTheGeneFields (data)  {
        var rawGeneInfo =  data['geneInfo'];
        var geneInfo = {};
        geneInfo.variationTable =  [] ;
        variantsAndAssociationsTitleLine(rawGeneInfo,geneInfoRec.GWAS_T2D_VAR_TOTAL,'within 500 kb of this gene in GWAS data available on this portal',geneInfoRec.CHROM,geneInfoRec.BEG,geneInfoRec.END,"#totalGwasVariants","#totalGwasVariantAnchor");
        variantsAndAssociationsContentsLine(rawGeneInfo,geneInfoRec.GWAS_T2D_GWS_TOTAL,'genome-wide',geneInfoRec.CHROM,geneInfoRec.BEG,geneInfoRec.END,"#totalGwasVariantst2dgenome","#totalGwasVariantAnchor2dgenome");
        variantsAndAssociationsContentsLine(rawGeneInfo,geneInfoRec.GWAS_T2D_NOM_TOTAL,'nominal',geneInfoRec.CHROM,geneInfoRec.BEG,geneInfoRec.END,"#totalGwasVariantst2dnominal","#totalGwasVariantAnchor2dnominal");

//        fillVariantsAndAssociationsSection (rawGeneInfo);
//        $('#continentalAncestryTable').append(fillAncestryTable()) ;
//        if ((rawGeneInfo) && (rawGeneInfo._13k_T2D_ORIGIN_VAR_TOTALS) ) {
//            $('#continentalAncestryTable').append(fillAncestryTable(rawGeneInfo._13k_T2D_ORIGIN_VAR_TOTALS));
//        }
//        for (var key in rawGeneInfo._13k_T2D_ORIGIN_VAR_TOTALS){
//            var record = rawGeneInfo._13k_T2D_ORIGIN_VAR_TOTALS[key];
//        }
    }
</script>

<div id="main">

    <div class="container" >

        <div class="gene-info-container" >
            <div class="gene-info-view" >

    <h1>
        <em><%=gene_info.ID%></em>
        <a class="page-nav-link" href="#associations">Associations</a>
        <a class="page-nav-link" href="#populations">Populations</a>
        <a class="page-nav-link" href="#biology">Biology</a>
    </h1>



                <g:if test="${(geneName == "C19orf80")||
                        (geneName == "PAM")||
                        (geneName == "SLC30A8")||
                        (geneName == "WFS1")}">
                    <div class="gene-summary">
                        <div class="title">Curated Summary</div>

                        <div id="geneHolderTop" class="top">
                            <script>
                                var contents = "<g:renderGeneSummary geneFile="${geneName}-top"></g:renderGeneSummary>";
                                $('#geneHolderTop').html(contents);
                            </script>

                        </div>

                        <div class="bottom ishidden" id="geneHolderBottom" style="display: none;">
                            <script>
                                // var contents = "$<g:renderGeneSummary geneFile="${geneName}-bottom"></g:renderGeneSummary>";
                                var contents = "<%=renderGeneSummary(geneFile:"${geneName}-bottom")%>";
                                $('#geneHolderBottom').html(contents);
                            </script>

                            %{--<%=gene_info.GENE_SUMMARY_BOTTOM%>--}%
                        </div>
                        <a class="boldlink" id="gene-summary-expand">click to expand</a>
                    </div>
                </g:if>




                <script>
         var geneInfo = {};
         geneInfo.variationTable =  [] ;
         <g:if test="${variationTable}">
             <g:each in="${0..(variationTable.size()-1)}">
             if (variationTable[it]) {
                 geneInfo.variationTable.push({"cohort": "${(variationTable[it]["COHORT"])}",
                     "participants": "${variationTable[it]["NS"]}",
                     "variants": "${variationTable[it]["TOTAL"]}",
                     "common": "${variationTable[it]["COMMON"]}",
                     "lowfrequency": "${variationTable[it]["LOW_FREQUENCY"]}",
                     "rare": "${variationTable[it]["RARE"]}"
                 });
             }
             </g:each>
         </g:if>

    </script>
    <h1>temp</h1>
               <span id="totalGwasVariants"></span><a id="totalGwasVariantAnchor" class="variantlink">view</a>
                <ul>
                    <li><span id="totalGwasVariantst2dgenome"></span><a id="totalGwasVariantAnchor2dgenome" class="variantlink">view</a></li>
                    <li><span id="totalGwasVariantst2dnominal"></span><a id="totalGwasVariantAnchor2dnominal" class="variantlink">view</a></li>
                </ul>
    <p><strong>Uniprot Summary:</strong> <%=gene_info.Function_description%></p>

    <div class="separator"></div>

    <g:render template="variantsAndAssociations" />

    <div class="separator"></div>

    <g:render template="variationAcrossContinents" />

    <div class="separator"></div>

     <g:render template="biologicalHypothesisTesting" />

     <div class="separator"></div>

     <g:render template="findOutMore" />

            </div>
        </div>
    </div>

</div>

</body>
</html>

