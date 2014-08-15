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
        GWAS_T2D_VAR_TOTAL: 30,
        EXCHP_T2D_VAR_TOTALS_EU_TOTAL: 31,
        SIGMA_T2D_VAR_TOTAL: 32,
        SIGMA_T2D_GWS_TOTAL: 33,
        SIGMA_T2D_NOM_TOTAL: 34,
        _13k_T2D_lof_OBSA: 35,
        _13k_T2D_lof_OBSU: 36
    };
    function revG(d){
        var v;
        switch(d) {
            case 1:v="ID"; break;
            case 2:v="CHROM";break;
            case 3:v="BEG";break;
            case 4:v="END";break;
            case 5:v="Function_description";break;
            case 6:v="_13k_T2D_VAR_TOTAL";break;
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
            case  31:v="EXCHP_T2D_VAR_TOTALS.EU.TOTAL";break;
            case  32:v="SIGMA_T2D_VAR_TOTAL";break;
            case  33:v="SIGMA_T2D_GWS_TOTAL";break;
            case  34:v="SIGMA_T2D_NOM_TOTAL";break;
            case  35:v="_13k_T2D_lof_OBSA";break;
            case  36:v="_13k_T2D_lof_OBSU";break;
            default: v="";
        }
        return v;
    }
    var loading = $('#spinner').show();
    $.ajax({
        cache:false,
        type:"post",
        url:"../geneInfoAjax",
        data:{geneName:'<%=geneName%>'},
        async:true,
        success: function (data) {
            fillTheGeneFields(data,
                    ${show_gwas},
                    ${show_exchp},
                    ${show_exseq},
                    ${show_sigma},
                    '<g:createLink controller="region" action="regionInfo" />',
                    '<g:createLink controller="trait" action="regionInfo" />',
                    '<g:createLink controller="variantSearch" action="gene" />') ;
            loading.hide();
        },
        error: function(jqXHR, exception) {
            loading.hide();
            errorReporter(jqXHR, exception) ;
        }
    });
    var  phenotype =  new UTILS.phenotypeListConstructor (decodeURIComponent("${phenotypeList}")) ;
    function expandRegionBegin(geneExtentBeginning) {
        if (geneExtentBeginning)  {
            return Math.max(geneExtentBeginning-500000,0);
        } else {
            return 0;
        }
    }
    function expandRegionEnd(geneExtentEnding) {
        if (geneExtentEnding)  {
            return geneExtentEnding+500000;
        } else {
            return 0;
        }
    }
    // walk into nested fields
    function geneFieldOrZero(geneInfo,filedNumber,defaultValue) {
        var retval = 0;
        var fieldName  = revG(filedNumber);
        if ((geneInfo)  && (fieldName.length>0)) {
            var fieldBreakdown = fieldName.split("."); // step into complex fields
            retval =   geneInfo[fieldBreakdown[0]];
            if ((retval)&&(fieldBreakdown.length>1)){
                for (  var i = 1 ; i < fieldBreakdown.length ; i++ ) {
                    var nextLevelSpec =  fieldBreakdown[i];
                    retval =  retval[nextLevelSpec];
                }
            }
        }
        if (!retval) {    // deal with a null.  Use a zero unless we are given an explicit alternative
           if (typeof defaultValue!=="undefined"){
               retval = defaultValue;
           }  else {
               retval=0;
           }
        }
        return retval;
    }
    function variantsAndAssociationsTitleLine (geneInfo, // Raw info
                                               totalNumberField,  // Which field are we reading
                                               description,  // Special text for each line
                                               chromosomeField,  // Chromosome number, in case we need it for the link
                                               beginPositionField, // Beginning extent, in case we needed for the link
                                               endPositionField, // Ending extent, in case we need it for the link
                                               typeOfSearch, // Is this a region search chip or by gene
                                               dataset,  // exomeseq, exomechip, gwas
                                               significance,
                                               textSpanId, // Span we are modifying
                                               anchorId, // Anchor we are modifying
                                               rootRegionUrl, // Root URL if this is a region search
                                               rootGeneUrl){
        var currentLine = "There are ";
        var totalNumber =  geneFieldOrZero(geneInfo,totalNumberField);
        if (totalNumber > 0){
            currentLine += '<strong>';
        }
        currentLine += (totalNumber+" total variants ");
        if (totalNumber > 0){
            currentLine += '</strong>';
        }
        currentLine += (" "+description+" | ");
        $(textSpanId).append (currentLine);
        if (typeOfSearch === "region")  {
            $(anchorId)[0].href= rootGeneUrl + "Wide/"+ geneFieldOrZero(geneInfo,geneInfoRec.ID)+"?sig="+significance+"&dataset="+dataset +"&region=chr"+geneFieldOrZero(geneInfo,chromosomeField)+":"+expandRegionBegin(geneFieldOrZero(geneInfo,beginPositionField))+"-"+expandRegionEnd(geneFieldOrZero(geneInfo,endPositionField));
        }    else  {
            $(anchorId)[0].href = rootGeneUrl + "Wide/"+ geneFieldOrZero(geneInfo,geneInfoRec.ID)+"?sig="+significance+"&dataset="+dataset ;
        }

    }
    function variantsAndAssociationsContentsLine (geneInfo, // Raw info
                                                  totalNumberField,  // Which field are we reading
                                                  description,  // Special text for each line
                                                  chromosomeField,  // Chromosome number, in case we need it for the link
                                                  beginPositionField, // Beginning extent, in case we needed for the link
                                                  endPositionField, // Ending extent, in case we need it for the link
                                                  typeOfSearch, // gene or region
                                                  dataset,  // exomeseq, exomechip, gwas
                                                  significance,    // anything, gwasSig, nominalSig
                                                  textSpanId, // Span we are modifying
                                                  anchorId, // Anchor we are modifying
                                                  rootRegionUrl, // Root URL if this is a region search
                                                  rootGeneUrl){
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
        if (typeOfSearch === "region") {
            $(anchorId)[0].href = rootGeneUrl + "Wide/" + geneFieldOrZero(geneInfo, geneInfoRec.ID) + "?sig=" + description + "&dataset=" + dataset+"&region=chr"+geneFieldOrZero(geneInfo,chromosomeField)+":"+expandRegionBegin(geneFieldOrZero(geneInfo,beginPositionField))+"-"+expandRegionEnd(geneFieldOrZero(geneInfo,endPositionField));
        } else {
            $(anchorId)[0].href = rootGeneUrl + "Wide/" + geneFieldOrZero(geneInfo, geneInfoRec.ID) + "?sig=" + description + "&dataset=" + dataset;
        }
    }
    function fillVarianceAndAssociations (rawGeneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootRegionUrl, rootGeneUrl,rootVariantUrl){

        if(show_gwas){
            variantsAndAssociationsTitleLine(rawGeneInfo,geneInfoRec.GWAS_T2D_VAR_TOTAL,'within 500 kb of this gene in GWAS data available on this portal',
                    geneInfoRec.CHROM,
                    geneInfoRec.BEG,
                    geneInfoRec.END,
                    "region",
                    "gwas",
                    "everything",
                    "#totalGwasVariants","#totalGwasVariantAnchor",rootRegionUrl, rootVariantUrl);
            variantsAndAssociationsContentsLine(rawGeneInfo,geneInfoRec.GWAS_T2D_GWS_TOTAL,'genome-wide',
                    geneInfoRec.CHROM,
                    geneInfoRec.BEG,
                    geneInfoRec.END,
                    "region",
                    "gwas",
                    "gwasSig",
                    "#totalGwasVariantst2dgenome","#totalGwasVariantAnchor2dgenome",rootRegionUrl, rootVariantUrl);
            variantsAndAssociationsContentsLine(rawGeneInfo,geneInfoRec.GWAS_T2D_NOM_TOTAL,'nominal',
                    geneInfoRec.CHROM,
                    geneInfoRec.BEG,
                    geneInfoRec.END,
                    "region",
                    "gwas",
                    "nominalSig",
                    "#totalGwasVariantst2dnominal","#totalGwasVariantAnchor2dnominal",rootRegionUrl, rootVariantUrl);
        }

        if(show_exchp){
            variantsAndAssociationsTitleLine(rawGeneInfo,geneInfoRec.EXCHP_T2D_VAR_TOTALS_EU_TOTAL,'in exome chip data available on this portal',
                    geneInfoRec.CHROM,
                    geneInfoRec.BEG,
                    geneInfoRec.END,
                    "gene",
                    "exomechip",
                    "everything",
                    "#totalExomeChipVariants",
                    "#totalExomeChipVariantAnchor",rootRegionUrl, rootVariantUrl);
            variantsAndAssociationsContentsLine(rawGeneInfo,geneInfoRec.EXCHP_T2D_GWS_TOTAL,'genome-wide',
                    geneInfoRec.CHROM,
                    geneInfoRec.BEG,
                    geneInfoRec.END,
                    "gene",
                    "exomechip",
                    "gwasSig",
                    "#totalExomeChipVariantst2dgenome",
                    "#totalExomeChipVariantAnchor2dgenome",rootRegionUrl, rootVariantUrl);
            variantsAndAssociationsContentsLine(rawGeneInfo,geneInfoRec.EXCHP_T2D_NOM_TOTAL,'nominal',
                    geneInfoRec.CHROM,
                    geneInfoRec.BEG,
                    geneInfoRec.END,
                    "gene",
                    "exomechip",
                    "nominalSig",
                    "#totalExomeChipVariantst2dnominal",
                    "#totalExomeChipVariantAnchor2dnominal",rootRegionUrl, rootVariantUrl);
        }

        if(show_exseq){
            variantsAndAssociationsTitleLine(rawGeneInfo,geneInfoRec._13k_T2D_VAR_TOTAL,'in exome sequencing data available on this portal',
                    geneInfoRec.CHROM,
                    geneInfoRec.BEG,
                    geneInfoRec.END,
                    "gene",
                    "exomeseq",
                    "everything",
                    "#totalExomeSeqVariants",
                    "#totalExomeSeqVariantAnchor",rootRegionUrl, rootVariantUrl);
            variantsAndAssociationsContentsLine(rawGeneInfo,geneInfoRec._13k_T2D_GWS_TOTAL,'genome-wide',
                    geneInfoRec.CHROM,
                    geneInfoRec.BEG,
                    geneInfoRec.END,
                    "gene",
                    "exomeseq",
                    "gwasSig",
                    "#totalExomeSeqVariantst2dgenome",
                    "#totalExomeSeqVariantAnchor2dgenome",rootRegionUrl, rootVariantUrl);
            variantsAndAssociationsContentsLine(rawGeneInfo,geneInfoRec._13k_T2D_NOM_TOTAL,'nominal',
                    geneInfoRec.CHROM,
                    geneInfoRec.BEG,
                    geneInfoRec.END,
                    "gene",
                    "exomeseq",
                    "nominalSig",
                    "#totalExomeSeqVariantst2dnominal",
                    "#totalExomeSeqVariantAnchor2dnominal",rootRegionUrl, rootVariantUrl);
        }

        if (show_sigma){
            variantsAndAssociationsTitleLine(rawGeneInfo,geneInfoRec.SIGMA_T2D_VAR_TOTAL,'in SIGMA sequencing data available on this portal',
                    geneInfoRec.CHROM,
                    geneInfoRec.BEG,
                    geneInfoRec.END,
                    "gene",
                    "sigma",
                    "everything",
                    "#totalExomeSeqVariants",
                    "#totalExomeSeqVariantAnchor",rootRegionUrl, rootVariantUrl);
            variantsAndAssociationsContentsLine(rawGeneInfo,geneInfoRec.SIGMA_T2D_GWS_TOTAL,'genome-wide',
                    geneInfoRec.CHROM,
                    geneInfoRec.BEG,
                    geneInfoRec.END,
                    "gene",
                    "sigma",
                    "gwasSig",
                    "#totalExomeSeqVariantst2dgenome",
                    "#totalExomeSeqVariantAnchor2dgenome",rootRegionUrl, rootVariantUrl);
            variantsAndAssociationsContentsLine(rawGeneInfo,geneInfoRec.SIGMA_T2D_NOM_TOTAL,'nominal',
                    geneInfoRec.CHROM,
                    geneInfoRec.BEG,
                    geneInfoRec.END,
                    "gene",
                    "sigma",
                    "nominalSig",
                    "#totalExomeSeqVariantst2dnominal",
                    "#totalExomeSeqVariantAnchor2dnominal",rootRegionUrl, rootVariantUrl);
        }

        // show traits
        if(show_gwas){
            var htmlAccumulator  =  "";
            if (rawGeneInfo["GWS_TRAITS"]){
                var traitArray = rawGeneInfo["GWS_TRAITS"];
                if (traitArray.length > 0){
                    htmlAccumulator  +=  ("<strong> "+
                            "<p>Variants in or near this gene have been convincingly associated at genome-wide significance in GWAS meta-analyses with the following traits:</p>"+
                            "<ul>");
                    for ( var i = 0 ; i < traitArray.length ; i++ ) {
                        var traitRepresentation = "";
                        if ((typeof phenotype !== "undefined" ) &&
                                (phenotype.phenotypeMap) &&
                                (phenotype.phenotypeMap [traitArray[i]])){
                            traitRepresentation =  phenotype.phenotypeMap [traitArray[i]];
                        } else {
                            traitRepresentation =  traitArray[i];
                        }
                        htmlAccumulator  += ("<li>"+traitRepresentation+"</li>")
                    }
                    htmlAccumulator  +=  ("</ul>"+
                            "</strong>");
                }
            }  else {
                htmlAccumulator  +=  "<p>Variants in or near this gene have not been convincingly associated with any traits at genome-wide significance in the GWAS meta-analyses included in this portal.</p>"
            }
            $('#gwasTraits').append(htmlAccumulator);
        }

        // fill in trait vis
        $('#linkToVariantTraitCross')[0].href= rootGeneUrl+"/chr"+
                geneFieldOrZero(rawGeneInfo,geneInfoRec.CHROM)+":"+
                expandRegionBegin(geneFieldOrZero(rawGeneInfo,geneInfoRec.BEG))+"-"+
                expandRegionEnd(geneFieldOrZero(rawGeneInfo,geneInfoRec.END)) ;

    }
    function buildAnchorForVariantSearches (displayableContents,geneName, filter,rootVariantUrl){
        var returnValue = "";
        returnValue += ("<a class='boldlink' href='"+ rootVariantUrl+"/"+geneName+"?filter="+filter+"'>"+
                displayableContents+"</a>");
        return  returnValue;
    }
    function fillVariationAcrossEthnicity (rawGeneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootVariantUrl) {
            if  ((rawGeneInfo)&&
                 (rawGeneInfo["_13k_T2D_ORIGIN_VAR_TOTALS"]))  {
                var ethnicityMap = rawGeneInfo["_13k_T2D_ORIGIN_VAR_TOTALS"];
                for (var ethnicityKey in ethnicityMap) {
                    if (ethnicityMap.hasOwnProperty(ethnicityKey)) {
                        var ethnicityRec  = ethnicityMap[ethnicityKey];
                        var sing = (ethnicityRec ["SING"])?(ethnicityRec ["SING"]): 0;
                        var rare = (ethnicityRec ["RARE"])?(ethnicityRec ["RARE"]): 0;
                        var displayableRare =  rare+sing;
                        var lowFrequency = (ethnicityRec ["LOW_FREQUENCY"])?(ethnicityRec ["LOW_FREQUENCY"]): 0;
                        var common = (ethnicityRec ["COMMON"])?(ethnicityRec ["COMMON"]): 0;
                        var total = (ethnicityRec ["TOTAL"])?(ethnicityRec ["TOTAL"]): 0;
                        var ns = (ethnicityRec ["NS"])?(ethnicityRec ["NS"]): 0;
                        $('#continentalVariationTableBody').append ('<tr>'+
                                '<td>' + UTILS.expandEthnicityDesignation (ethnicityKey) + '</td>'+
                                '<td>' + ns + '</td>'+
                                '<td>' + buildAnchorForVariantSearches(total,rawGeneInfo["ID"],'total-'+ethnicityKey,rootVariantUrl) + '</td>'+
                                '<td>' + buildAnchorForVariantSearches(common,rawGeneInfo["ID"],'common-'+ethnicityKey,rootVariantUrl) + '</td>'+
                                '<td>' + buildAnchorForVariantSearches(lowFrequency,rawGeneInfo["ID"],'lowfreq-'+ethnicityKey,rootVariantUrl) + '</td>'+
                                '<td>' + buildAnchorForVariantSearches(displayableRare,rawGeneInfo["ID"],'rare-'+ethnicityKey,rootVariantUrl) + '</td>'+
                                '</tr>');
                    }
                }

                if (rawGeneInfo["EXCHP_T2D_VAR_TOTALS"]) {
                    var excomeChip = rawGeneInfo["EXCHP_T2D_VAR_TOTALS"];
                    if  (excomeChip["EU"] ){
                        var excomeChipEuropean = excomeChip["EU"];
                        if (excomeChipEuropean["NS"]){
                            $('#continentalVariationTableBody').append ('<tr>'+
                                    '<td>European (exome chip)</td>'+
                                    '<td>' + excomeChipEuropean["NS"] + '</td>'+
                                    '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["TOTAL"],rawGeneInfo["ID"],'total-exchp',rootVariantUrl) + '</td>'+
                                    '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["COMMON"],rawGeneInfo["ID"],'common-exchp',rootVariantUrl) + '</td>'+
                                    '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["LOW_FREQUENCY"],rawGeneInfo["ID"],'lowfreq-exchp',rootVariantUrl) + '</td>'+
                                    '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["RARE"],rawGeneInfo["ID"],'rare-exchp',rootVariantUrl) + '</td>'+
                                    '</tr>');

                        }
                    }

                    }
                }
    }
    function fillBiologicalHypothesisTesting (geneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootVariantUrl) {
        var bhtPeopleWithVariantWhoHaveDiabetes  = 0,
                bhtPeopleWithVariantWithoutDiabetes = 0,
                bhtPeopleWithVariant = 0,
                bhtPeopleWithoutVariant = 0,
                arrayOfMinaMinu = [];
        // title line
        $('#bhtLossOfFunctionVariants').append(geneFieldOrZero(geneInfo,geneInfoRec._13k_T2D_lof_NVAR));

        // first subline
        var minaMinu =  geneFieldOrZero(geneInfo,geneInfoRec._13k_T2D_lof_MINA_MINU_RET) ;
        if (minaMinu) {   // we have a  _13k_T2D_lof_MINA_MINU_RET
            arrayOfMinaMinu  = minaMinu.split('/');
            if (arrayOfMinaMinu.length>1) {
                bhtPeopleWithVariantWhoHaveDiabetes = arrayOfMinaMinu[0];
                $('#bhtPeopleWithVariantWhoHaveDiabetes').append(bhtPeopleWithVariantWhoHaveDiabetes);
            }
        }  else {  // we don't
            $('#bhtPeopleWithVariantWhoHaveDiabetes').append(0);
        }
        bhtPeopleWithVariant = geneFieldOrZero(geneInfo,geneInfoRec._13k_T2D_lof_OBSA);
        $('#bhtPeopleWithVariant').append(bhtPeopleWithVariant);
        if (bhtPeopleWithVariant  > 0) {
            var bhtPercentOfPeopleWithVariantWhoHaveDisease =  (100 * (bhtPeopleWithVariantWhoHaveDiabetes / bhtPeopleWithVariant));
            $('#bhtPercentOfPeopleWithVariantWhoHaveDisease').append ( "(" +
                    (bhtPercentOfPeopleWithVariantWhoHaveDisease.toPrecision(2))+"%)");
        }

        // second subline
        if (arrayOfMinaMinu.length>1) {  // we have a  _13k_T2D_lof_MINA_MINU_RET
            bhtPeopleWithVariantWithoutDiabetes = arrayOfMinaMinu[1];
            $('#bhtPeopleWithVariantWithoutDiabetes').append(bhtPeopleWithVariantWithoutDiabetes);
        }  else {  // we don't
            bhtPeopleWithVariantWithoutDiabetes = 0;
            $('#bhtPeopleWithVariantWithoutDiabetes').append(0);
        }
        bhtPeopleWithoutVariant = geneFieldOrZero(geneInfo,geneInfoRec._13k_T2D_lof_OBSU);
        $('#bhtPeopleWithoutVariant').append(bhtPeopleWithoutVariant);
        if (bhtPeopleWithoutVariant  > 0) {
            var bhtPercentOfPeopleWithVariantWithoutDisease =  (100 * (bhtPeopleWithVariantWithoutDiabetes / bhtPeopleWithoutVariant));
            $('#bhtPercentOfPeopleWithVariantWithoutDisease').append (  "(" +
                    (bhtPercentOfPeopleWithVariantWithoutDisease.toPrecision(2)) +"%)");
        }


        var  bhtMetaBurdenForDiabetes  = geneFieldOrZero(geneInfo,geneInfoRec._13k_T2D_lof_METABURDEN);
        if (bhtMetaBurdenForDiabetes  > 0)  {
            $('#bhtMetaBurdenForDiabetes').append("<p>Collectively, these variants' p-value for association with type 2 diabetes is "+
                    (bhtMetaBurdenForDiabetes.toPrecision(3)));
        }
        var linkToVariantsPredictedToTruncate = $('#linkToVariantsPredictedToTruncate') ;
        if (typeof linkToVariantsPredictedToTruncate!== "undefined") {
            linkToVariantsPredictedToTruncate[0].href =  rootVariantUrl+"/"+(geneInfo["ID"])+"?filter=lof";
        }

    }
    function fillUniprotSummary(geneInfo,show_gwas,show_exchp,show_exseq,show_sigma) {
        var funcDescrLine = "";
        if ((geneInfo)&&(geneInfo["Function_description"])){
            funcDescrLine +=  ("<strong>Uniprot Summary:</strong>"+geneInfo['Function_description']);
        } else {
            funcDescrLine += "No uniprot summary available for this gene"
        }

        $('#uniprotSummaryGoesHere').append(funcDescrLine);
    }
    function fillTheGeneFields (data,show_gwas,show_exchp,show_exseq,show_sigma,rootRegionUrl, rootTraitUrl,rootVariantUrl)  {
        var rawGeneInfo =  data['geneInfo'];
        fillUniprotSummary(rawGeneInfo,show_gwas,show_exchp,show_exseq,show_sigma);
        fillVarianceAndAssociations (rawGeneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootRegionUrl, rootTraitUrl,rootVariantUrl);
        fillVariationAcrossEthnicity (rawGeneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootVariantUrl);
        fillBiologicalHypothesisTesting (rawGeneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootVariantUrl);
    }
</script>

<div id="main">

    <div class="container" >

        <div class="gene-info-container" >
            <div class="gene-info-view" >

    <h1>
        <em><%=geneName%></em>
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
                                var contents = '<g:renderGeneSummary geneFile="${geneName}-top"></g:renderGeneSummary>';
                                $('#geneHolderTop').html(contents);
                            </script>

                        </div>

                        <div class="bottom ishidden" id="geneHolderBottom" style="display: none;">
                            <script>
                                var contents = '<g:renderGeneSummary geneFile="${geneName}-bottom"></g:renderGeneSummary>';
                                $('#geneHolderBottom').html(contents);
                                function toggleGeneDescr(){
                                    if ($('#geneHolderBottom').is(':visible'))  {
                                        $('#geneHolderBottom').hide();
                                    }else {
                                        $('#geneHolderBottom').show();
                                    }
                                }
                            </script>


                        </div>
                        <a class="boldlink" id="gene-summary-expand" onclick="toggleGeneDescr()">click to expand</a>
                    </div>
                </g:if>





                <p><span id="uniprotSummaryGoesHere"></span></p>

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

